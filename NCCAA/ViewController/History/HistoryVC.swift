//
//  HistoryVC.swift
//  NCCAA
//
//  Created by Apple on 18/07/22.
//

import UIKit

class HistoryVC: UIViewController {

    
    // MARK: - Variable
    let refreshControl = UIRefreshControl()
    var arrHistory:[[String:Any]]?
    
    // MARK: - IBOutlet
    @IBOutlet weak var collview: UICollectionView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        initialRefresh()
    }
    

    // MARK: - Function
    
    func setupUI() {
        
        //
        collview.alwaysBounceVertical = true
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        collview.addSubview(refreshControl)
    }
    func initialRefresh() {
        
        getHistoryAPI()
    }
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        
        initialRefresh()
        refreshControl.endRefreshing()
    }
    // MARK: - Webservice
    
    func getHistoryAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallGetHistory(url: "\(URLs.history)", headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
             
            self.arrHistory = response
            
            DispatchQueue.main.async {
                self.collview.reloadData()
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
    @IBAction func btnLogout(_ sender: Any) {
        
        Helper.shared.logoutFromApp(vc: self)
    }
    @IBAction func unwindToHistoryVC(segue: UIStoryboardSegue) {}
    
    @objc func btnView(sender:UIButton) {
        
        if let id = arrHistory?[sender.tag]["examId"] {
            
            if arrHistory?[sender.tag]["results"] as? String == "WAITING ON RESULTS" {
                Toast.show(message: "Result status is Waiting", controller: self)
            } else {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "ResultsScoreVC") as! ResultsScoreVC
                obj.intExamId = id as? Int
                self.navigationController?.pushViewController(obj, animated: true)
            }
            
        } else if let id = arrHistory?[sender.tag]["receiptId"] {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ReceiptVC") as! ReceiptVC
            obj.intReceiptId = id as? Int
            obj.isFromVC = "History"
            if arrHistory?[sender.tag]["type"] as? String == "cme" {
                obj.strReceiptTitle = "CME Payment"
            }
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
    

}
extension HistoryVC:UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrHistory?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if arrHistory?[indexPath.row]["type"] as? String == "result" {
            
            if arrHistory?[indexPath.row]["examType"] as? String == "cdq" {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CDQExamSmallCell", for: indexPath) as! CDQExamSmallCell
                //
                if let date = arrHistory?[indexPath.row]["date"] as? String {
                    cell.lblDate.text = Helper.shared.changeStringDateFormat(date: date, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
                } else {
                    cell.lblDate.text = ""
                }
                //
                cell.lblResults.text = (arrHistory?[indexPath.row]["results"] as? String)?.uppercased()
                
                cell.btnView.tag = indexPath.row
                cell.btnView.addTarget(self, action: #selector(btnView(sender:)), for: .touchUpInside)
                return cell
            } else if arrHistory?[indexPath.row]["examType"] as? String == "cert" {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CertificationExamSmallCell", for: indexPath) as! CertificationExamSmallCell
                if let date = arrHistory?[indexPath.row]["date"] as? String {
                    cell.lblDate.text = Helper.shared.changeStringDateFormat(date: date, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
                } else {
                    cell.lblDate.text = ""
                }
                cell.lblResults.text = (arrHistory?[indexPath.row]["results"] as? String)?.uppercased()
                cell.btnView.tag = indexPath.row
                cell.btnView.addTarget(self, action: #selector(btnView(sender:)), for: .touchUpInside)
                return cell
            }
        } else if arrHistory?[indexPath.row]["type"] as? String == "cdq" {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CDQExamCell", for: indexPath) as! CDQExamCell
            
            var strTitle = ""
            if arrHistory?[indexPath.row]["examDateStart"] as? String != "" {
                
                let arr = (arrHistory?[indexPath.row]["examDateStart"] as? String)?.components(separatedBy: "-")
                
                if arr?.count != 0 {
                    
                    let month = Helper.shared.getMonthFromNumber(month: (arr?[1])!)
                    
                    strTitle = "\(month) \(arr?[2] ?? "")"
                }
                
            }
            if arrHistory?[indexPath.row]["examDateEnd"] as? String != "" {
                
                let arr = (arrHistory?[indexPath.row]["examDateEnd"] as? String)?.components(separatedBy: "-")
                
                if arr?.count != 0 {
                    strTitle = "\(strTitle)-\(arr?[2] ?? ""), \(arr?[0] ?? "")"
                }
                
            }
            cell.lblExmDate.text = strTitle
            
            let arr = (arrHistory?[indexPath.row]["paidDate"] as? String)?.components(separatedBy: "T")
            var date = ""
            var time = ""
            
            
            if arr?.count != 0 {
                
                if let _ = arr?[0] {
                    date = Helper.shared.changeStringDateFormat(date: arr?[0] ?? "", toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
                } else {
                    date = ""
                }
                let arr2 = arr?[1].components(separatedBy: "-")
                
                if arr2?.count != 0 {
                    
                    time = arr2?[0] ?? ""
                }
            }
            
            cell.lblDatePaid.text = "\(date) (\(time))"
            
            let amount = "\(arrHistory?[indexPath.row]["paidAmount"] as? Int ?? 0)".convertDoubleToCurrency()
            
            cell.lblAmountPaid.text = amount
            cell.lblPaymentPeriod.text = (arrHistory?[indexPath.row]["paymentPeriod"] as? String)?.uppercased()
            cell.lblAttempt.text = "\(arrHistory?[indexPath.row]["attemptNumber"] as? Int ?? 0)"
            cell.btnView.tag = indexPath.row
            cell.btnView.addTarget(self, action: #selector(btnView(sender:)), for: .touchUpInside)
            return cell
        } else if arrHistory?[indexPath.row]["type"] as? String == "cme" {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CMESubmissionCycleCell", for: indexPath) as! CMESubmissionCycleCell
            
            cell.lblCycle.text = "\(arrHistory?[indexPath.row]["cycle"] as? Int ?? 0)"
            if let date = arrHistory?[indexPath.row]["dueDate"] as? String {
                cell.lblDueDate.text = Helper.shared.changeStringDateFormat(date: date, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
            } else {
                cell.lblDueDate.text = ""
            }
            
            let arr = (arrHistory?[indexPath.row]["paidDate"] as? String)?.components(separatedBy: "T")
            var date = ""
            var time = ""
            
            
            if arr?.count != 0 {
                
                if let _ = arr?[0] {
                    date = Helper.shared.changeStringDateFormat(date: arr?[0] ?? "", toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
                } else {
                    date = ""
                }
                let arr2 = arr?[1].components(separatedBy: "-")
                
                if arr2?.count != 0 {
                    
                    time = arr2?[0] ?? ""
                }
            }
            
            cell.lblDatePaid.text = "\(date) (\(time))"
            
            let amount = "\(arrHistory?[indexPath.row]["paidAmount"] as? Int ?? 0)".convertDoubleToCurrency()
            
            cell.lblAmountPaid.text = amount
            cell.lblPaymentPeriod.text = (arrHistory?[indexPath.row]["paymentPeriod"] as? String)?.uppercased()
            cell.btnView.tag = indexPath.row
            cell.btnView.addTarget(self, action: #selector(btnView(sender:)), for: .touchUpInside)
            return cell
        } else if arrHistory?[indexPath.row]["type"] as? String == "cert" {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CerificationExamCell", for: indexPath) as! CerificationExamCell
            var strTitle = ""
            if arrHistory?[indexPath.row]["examDateStart"] as? String != "" {
                
                let arr = (arrHistory?[indexPath.row]["examDateStart"] as? String)?.components(separatedBy: "-")
                
                if arr?.count != 0 {
                    
                    let month = Helper.shared.getMonthFromNumber(month: (arr?[1])!)
                    
                    strTitle = "\(month) \(arr?[2] ?? "")"
                }
                
            }
            if arrHistory?[indexPath.row]["examDateEnd"] as? String != "" {
                
                let arr = (arrHistory?[indexPath.row]["examDateEnd"] as? String)?.components(separatedBy: "-")
                
                if arr?.count != 0 {
                    strTitle = "\(strTitle)-\(arr?[2] ?? ""), \(arr?[0] ?? "")"
                }
                
            }
            cell.lblExmDate.text = strTitle
            
            let arr = (arrHistory?[indexPath.row]["paidDate"] as? String)?.components(separatedBy: "T")
            var date = ""
            var time = ""
            
            
            if arr?.count != 0 {
                
                if let _ = arr?[0] {
                    date = Helper.shared.changeStringDateFormat(date: arr?[0] ?? "", toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
                } else {
                    date = ""
                }
                let arr2 = arr?[1].components(separatedBy: "-")
                
                if arr2?.count != 0 {
                    
                    time = arr2?[0] ?? ""
                }
            }
            
            cell.lblDatePaid.text = "\(date) (\(time))"
            
            let amount = "\(arrHistory?[indexPath.row]["paidAmount"] as? Int ?? 0)".convertDoubleToCurrency()
            
            cell.lblAmountPaid.text = amount
            cell.lblPaymentPeriod.text = (arrHistory?[indexPath.row]["paymentPeriod"] as? String)?.uppercased()
            cell.lblAttempt.text = "\(arrHistory?[indexPath.row]["attemptNumber"] as? Int ?? 0)"
            cell.lblUniversity.text = arrHistory?[indexPath.row]["universityName"] as? String
            cell.lblUniCode.text = arrHistory?[indexPath.row]["universityCode"] as? String
            cell.btnView.tag = indexPath.row
            cell.btnView.addTarget(self, action: #selector(btnView(sender:)), for: .touchUpInside)
            return cell
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if arrHistory?[indexPath.row]["type"] as? String == "cdq" {
            
            if Helper.shared.userType == "caa" {
                return CGSize(width: collectionView.frame.width, height: 233)
            } else {
                return CGSize(width: 0, height: 0)
            }
            
        } else if arrHistory?[indexPath.row]["type"] as? String == "cme" {
            
            if Helper.shared.userType == "caa" {
                return CGSize(width: collectionView.frame.width, height: 233)
            }  else {
                return CGSize(width: 0, height: 0)
            }
            
        } else if arrHistory?[indexPath.row]["type"] as? String == "result" {
            
            if arrHistory?[indexPath.row]["examType"] as? String == "cdq" {
                if Helper.shared.userType == "caa" {
                    return CGSize(width: collectionView.frame.width, height: 156)
                } else {
                    return CGSize(width: 0, height: 0)
                }
                
            } else if arrHistory?[indexPath.row]["examType"] as? String == "cert" {
                
                if Helper.shared.userType == "caa" {
                    return CGSize(width: 0, height: 0)
                } else {
                    return CGSize(width: collectionView.frame.width, height: 156)
                }
            }
        } else if arrHistory?[indexPath.row]["type"] as? String == "cert" {
            if Helper.shared.userType == "caa" {
                return CGSize(width: 0, height: 0)
            }  else {
                return CGSize(width: collectionView.frame.width, height: 306)
            }
            
        }
        return CGSize(width: 0, height: 0)
    }
    
    
    
    
    
}


