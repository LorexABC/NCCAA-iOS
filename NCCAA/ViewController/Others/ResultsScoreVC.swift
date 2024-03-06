//
//  ResultsScoreVC.swift
//  NCCAA
//
//  Created by Apple on 21/07/22.
//

import UIKit

class ResultsScoreVC: UIViewController {
    
    // MARK: - Variable
    let refreshControl = UIRefreshControl()
    var intExamId:Int?
    var arrResults:[[String:Any]]?
    
    // MARK: - IBOutlet
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var heightCollview: NSLayoutConstraint!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var lblExam: UILabel!
    @IBOutlet weak var lblExmResut: UILabel!
    @IBOutlet weak var lblYourResult: UILabel!
    @IBOutlet weak var lblMinPassing: UILabel!
    @IBOutlet weak var lblYourScore: UILabel!
    @IBOutlet weak var lblMaxScore: UILabel!
    @IBOutlet weak var lblCorrect: UILabel!
    @IBOutlet weak var lblNationalCorrect: UILabel!
    @IBOutlet weak var lblNationalPercentageCorrect: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialRefresh()
        setupUI()
    }
    

    // MARK: - Function
    func setupUI() {
        
        //
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        scrollview.addSubview(refreshControl)
    }
    func initialRefresh() {
        
        getResultsAPI()
    }
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        
        initialRefresh()
        refreshControl.endRefreshing()
    }
    override func viewWillLayoutSubviews() {
        
        DispatchQueue.main.async {
            super.updateViewConstraints()
            self.heightCollview?.constant = self.collView.contentSize.height
        }
        
    }
    
    // MARK: - Webservice
    func getResultsAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallCommonGetMethod(url: "\(URLs.exams)/\(intExamId!)/result", headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            if let err = response["error"] {
                
                Toast.show(message: err as? String ?? "", controller: self)
            } else {
                self.lblExam.text = response["name"] as? String
                self.lblExmResut.text = response["result"] as? String
                self.lblYourResult.text = "\(response["score"] as? Int ?? 0)%"
                self.lblMinPassing.text = "\(response["minimumPassing"] as? Int ?? 0)%"
                
                self.lblYourScore.text = "\((response["grandTotal"] as? [String:Any])?["score"] as? Int ?? 0)"
                self.lblMaxScore.text = "\((response["grandTotal"] as? [String:Any])?["maximumScore"] as? Int ?? 0)"
                self.lblCorrect.text = "\((response["grandTotal"] as? [String:Any])?["percentageCorrect"] as? Int ?? 0)%"
                self.lblNationalCorrect.text = "\((response["grandTotal"] as? [String:Any])?["nationalCorrect"] as? Int ?? 0)"
                self.lblNationalPercentageCorrect.text = "\((response["grandTotal"] as? [String:Any])?["nationalPercentageCorrect"] as? Int ?? 0)%"
                
                self.arrResults = response["individualScores"] as? [[String : Any]]
                self.collView.reloadData()
            }
            
            
            //print(response)
            
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    
    
    // MARK: - IBAction
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
extension ResultsScoreVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultsCell", for: indexPath) as! ResultsCell
        
        cell.lblName.text = "\(arrResults?[indexPath.row]["name"] as? String ?? "")"
        cell.lblYourScore.text = "\(arrResults?[indexPath.row]["score"] as? Int ?? 0)"
        cell.lblMaxScore.text = "\(arrResults?[indexPath.row]["maximumScore"] as? Int ?? 0)"
        cell.lblPercentCorrect.text = "\(arrResults?[indexPath.row]["percentageCorrect"] as? Int ?? 0)%"
        cell.lblNationalCorrect.text = "\(arrResults?[indexPath.row]["nationalCorrect"] as? Int ?? 0)"
        cell.lblNationalPercentageCorrect.text = "\(arrResults?[indexPath.row]["nationalPercentageCorrect"] as? Int ?? 0)%"
        
        
        if (arrResults?.count ?? 0) > 2 {
            
            if indexPath.row == 0 {
                cell.contentView.viewWithTag(101)?.isHidden = true
                cell.contentView.viewWithTag(102)?.isHidden = false
            } else if indexPath.row == ((arrResults?.count ?? 0)-1) {
                cell.contentView.viewWithTag(101)?.isHidden = false
                cell.contentView.viewWithTag(102)?.isHidden = true
            } else {
                cell.contentView.viewWithTag(101)?.isHidden = false
                cell.contentView.viewWithTag(102)?.isHidden = false
            }
        } else {
            if indexPath.row % 2 != 0 {
                cell.contentView.viewWithTag(101)?.isHidden = false
                cell.contentView.viewWithTag(102)?.isHidden = true
            } else {
                cell.contentView.viewWithTag(101)?.isHidden = true
                cell.contentView.viewWithTag(102)?.isHidden = false
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 200)
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
}
