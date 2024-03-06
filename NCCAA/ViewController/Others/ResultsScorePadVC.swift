//
//  ResultsScorePadVC.swift
//  NCCAA
//
//  Created by Apple on 21/07/22.
//

import UIKit

class ResultsScorePadVC: UIViewController {
    
    // MARK: - Variable
    let refreshControl = UIRefreshControl()
    var isFromVC = "CDQExam"
    var intExamId:Int?
    var arrResults:[[String:Any]]?
    let arr = ["Principals of Anesthesia","Cardiovascular"]
    let arrMenu = ["Announcements","Important Info/Dates","Student Clinical Competencies","Certification Exam","State Licensing Info","View CAA Certificate","CDQ Exam","CME Submissions","Blog","History","Edit Profile","Contact NCCAA"]
//    let arrMenuIcons = ["Frame 52","Frame 52 (1)","Group 35","award","Rubber Stamp","archive-book","teacher","Frame 52 (2)","Frame 52 (3)","Frame 52 (4)","user-edit","Support"]
    
    let arrMenuIcons = ["Doorbell","Calendar","Upload to Cloud","Document","Rubber Stamp yellow","Diploma","Document_blue","Upload","News","Clock","Settings","Customer Support"]
    
    // MARK: - IBOutlet
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var heightCollview: NSLayoutConstraint!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var tableMenu: UITableView!
    @IBOutlet weak var lblExam: UILabel!
    @IBOutlet weak var lblExmResut: UILabel!
    @IBOutlet weak var lblYourResult: UILabel!
    @IBOutlet weak var lblMinPassing: UILabel!
    @IBOutlet weak var lblYourScore: UILabel!
    @IBOutlet weak var lblMaxScore: UILabel!
    @IBOutlet weak var lblCorrect: UILabel!
    @IBOutlet weak var lblNationalCorrect: UILabel!
    @IBOutlet weak var lblNationalPercentageCorrect: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialRefresh()
        setupUI()
        
    }
    

    // MARK: - Function
    func setupUI() {
        
        lblName.text = "Hello, \(Helper.shared.userName)!"
        
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
        super.updateViewConstraints()
        self.heightCollview?.constant = self.collView.contentSize.height
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
    
    @IBAction func btnNotification(_ sender: Any) {
        
        let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
        let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navAnnouncement") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = obj
    }
}
extension ResultsScorePadVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
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
extension ResultsScorePadVC:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrMenu.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
        cell.lblTitle.text = arrMenu[indexPath.row]
        cell.img.image = UIImage(named: arrMenuIcons[indexPath.row])
        
        if isFromVC == "CDQExam" {
            if indexPath.row == 6 {
                cell.viewWithTag(101)?.backgroundColor = #colorLiteral(red: 0.3019607843, green: 0.5215686275, blue: 0.9411764706, alpha: 1)
                cell.lblTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                cell.viewWithTag(101)?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.lblTitle.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
        if isFromVC == "History" {
            if indexPath.row == 9 {
                cell.viewWithTag(101)?.backgroundColor = #colorLiteral(red: 0.3019607843, green: 0.5215686275, blue: 0.9411764706, alpha: 1)
                cell.lblTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                cell.viewWithTag(101)?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.lblTitle.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
        if isFromVC == "Certification" {
            if indexPath.row == 3 {
                cell.viewWithTag(101)?.backgroundColor = #colorLiteral(red: 0.3019607843, green: 0.5215686275, blue: 0.9411764706, alpha: 1)
                cell.lblTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                cell.viewWithTag(101)?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.lblTitle.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tableMenu {
            
            if indexPath.row == 0 {
                
                let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navAnnouncement") as! UINavigationController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = obj
            }
            if indexPath.row == 1 {
                
                let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navInfoDates") as! UINavigationController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = obj
            }
            if indexPath.row == 2 {
                
                if Helper.shared.userType == "student" {
                    let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                    let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navClinicals") as! UINavigationController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = obj
                } else {
                    Toast.show(message: Message.caaModuleUnavailable, controller: self)
                }
            }
            if indexPath.row == 3 {
                
                if Helper.shared.userType == "student" {
                    let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                    let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navCertification") as! UINavigationController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = obj
                } else {
                    Toast.show(message: Message.certificationModuleUnavailable, controller: self)
                }
            }
            if indexPath.row == 4 {
                
                if Helper.shared.userType == "caa" {
                    let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                    let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navStateLicensing") as! UINavigationController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = obj
                } else {
                    Toast.show(message: Message.studentModuleUnavailable, controller: self)
                }
            }
            if indexPath.row == 5 {
                
                if Helper.shared.userType == "caa" {
                    let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                    let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navCAA") as! UINavigationController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = obj
                } else {
                    Toast.show(message: Message.studentModuleUnavailable, controller: self)
                }
            }
            if indexPath.row == 6 {
                
                if Helper.shared.userType == "caa" {
                    let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                    let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navCDQ") as! UINavigationController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = obj
                } else {
                    Toast.show(message: Message.studentModuleUnavailable, controller: self)
                }
            }
            if indexPath.row == 7 {
                
                if Helper.shared.userType == "caa" {
                    let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                    let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navCME") as! UINavigationController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = obj
                } else {
                    Toast.show(message: Message.studentModuleUnavailable, controller: self)
                }
            }
            if indexPath.row == 8 {
                
                let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navBlog") as! UINavigationController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = obj
            }
            if indexPath.row == 9 {
                
                let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navHistory") as! UINavigationController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = obj
            }
            if indexPath.row == 10 {
                
                let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navProfile") as! UINavigationController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = obj
            }
            if indexPath.row == 11 {
                
                let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navContact") as! UINavigationController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = obj
            }
        }
    }
}
