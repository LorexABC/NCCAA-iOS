//
//  ReceiptVC.swift
//  NCCAA
//
//  Created by Apple on 21/07/22.
//

import UIKit

class ReceiptVC: UIViewController {
    
    // MARK: - Variable
    var intReceiptId:Int?
    var isFromVC = "CDQExam"
    var strCenterUrl = ""
    var strReceiptTitle = "June 2022 Cert Exam"
    
    // MARK: - IBOutlet
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAmountPaid: UILabel!
    @IBOutlet weak var lblPaidOn: UILabel!
    @IBOutlet weak var lblAmountDue: UILabel!
    @IBOutlet weak var lblLast4: UILabel!
    @IBOutlet weak var btnReturn: UIButton!
    @IBOutlet weak var lblReceptTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getReceiptsAPI()
        //getExamsAPI()
        setupUI()
    }
    

    // MARK: - Function
    func setupUI() {
        
        lblReceptTitle.text = strReceiptTitle
    }
    
    
    // MARK: - Webservice
    func getReceiptsAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallCommonGetMethod(url: "\(URLs.receipts)\(intReceiptId!)", headers:headers) { (response) in
            
            if let _ = response["status"] {
                
                Toast.show(message: response["message"] as! String, controller: self)
            } else {
                
                self.lblName.text = response["name"] as? String
                self.lblAmountPaid.text = "\(response["paidAmount"] ?? 0)".currencyFormatting()
                
                //
                if let date = response["paidDate"] as? String {
                    self.lblPaidOn.text = Helper.shared.changeStringDateFormat(date: date, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
                } else {
                    self.lblPaidOn.text = ""
                }
                //
                self.lblAmountDue.text = "\(response["dueAmount"] ?? 0)".currencyFormatting()
                self.lblLast4.text = response["lastFourDigits"] as? String
                
                //
                var strTitle = ""
                if response["dateStart"] as? String != "" {
                    
                    let arr = (response["dateStart"] as? String)?.components(separatedBy: "-")
                    
                    if arr?.count != 0 {
                        
                        let month = Helper.shared.getMonthFromNumber(month: (arr?[1])!)
                        
                        strTitle = "\(month) \(arr?[2] ?? "")"
                    }
                    
                }
                if response["dateEnd"] as? String != "" {
                    
                    let arr = (response["dateEnd"] as? String)?.components(separatedBy: "-")
                    
                    if arr?.count != 0 {
                        strTitle = "\(strTitle)-\(arr?[2] ?? ""), \(arr?[0] ?? "") \((response["type"] as? String) ?? "") Exam"
                    }
                    
                }
                self.lblReceptTitle.text = strTitle
            }
         
            Helper.shared.hideHUD()
        }
    }
//    func getExamsAPI() {
//
//        Helper.shared.showHUD()
//
//        let headers = ["Accept":"application/json",
//                       "Authorization":"Bearer \(Helper.shared.access_token)"]
//
//        NetworkManager.shared.webserviceCallGetExams(url: URLs.exams, headers:headers) { (response) in
//
//            //if response.ResponseCode == 200 {
//
//            //print(response)
//
//            let index = response.firstIndex{$0["receiptId"] as? Int == self.intReceiptId!}
//            if index != nil {
//                self.strCenterUrl = response[index!]["testingCenterUrl"] as? String ?? ""
//            }
//
//            //            } else {
//            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
//            //            }
//            Helper.shared.hideHUD()
//        }
//    }
    // MARK: - IBAction
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnDone(_ sender: Any) {
//        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//        let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navMain") as! UINavigationController
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = obj
        
        if isFromVC == "CDQExam" {
            self.performSegue(withIdentifier: "unwindCDQ", sender: self)
        }
        if isFromVC == "ImportantDatesInfo" {
            self.performSegue(withIdentifier: "unwindImpDates", sender: self)
        }
        if isFromVC == "Certification" {
            self.performSegue(withIdentifier: "unwindCert", sender: self)
        }
        if isFromVC == "History" {
            self.performSegue(withIdentifier: "unwindHistory", sender: self)
        }
        if isFromVC == "CME" {
            self.performSegue(withIdentifier: "unwindCME", sender: self)
        }
    }
    
    @IBAction func btnReturn(_ sender: Any) {
        
//        let obj = self.storyboard?.instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
//        obj.strUrl = strCenterUrl
//        self.navigationController?.pushViewController(obj, animated: true)
    }
}
