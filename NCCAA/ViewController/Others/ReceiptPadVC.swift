//
//  ReceiptPadVC.swift
//  NCCAA
//
//  Created by Apple on 21/07/22.
//

import UIKit

class ReceiptPadVC: UIViewController {
    
    // MARK: - Variable
    var isFromVC = "CDQExam"
    var intReceiptId:Int?
    var strCenterUrl = ""
    var strReceiptTitle = "June 2022 Cert Exam"
    let arrMenu = ["Announcements","Important Info/Dates","Student Clinical Competencies","Certification Exam","State Licensing Info","View CAA Certificate","CDQ Exam","CME Submissions","Blog","History","Edit Profile","Contact NCCAA"]
    
    
    let arrMenuIcons = ["Doorbell","Calendar","Upload to Cloud","Document","Rubber Stamp yellow","Diploma","Document_blue","Upload","News","Clock","Settings","Customer Support"]
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableMenu: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAmountPaid: UILabel!
    @IBOutlet weak var lblPaidOn: UILabel!
    @IBOutlet weak var lblAmountDue: UILabel!
    @IBOutlet weak var lblLast4: UILabel!
    @IBOutlet weak var btnReturn: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblReceiptTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getReceiptsAPI()
        //getExamsAPI()
        setupUI()
    }
    
    
    // MARK: - Function
    func setupUI() {
        
        lblUserName.text = "Hello, \(Helper.shared.userName)!"
        lblReceiptTitle.text = strReceiptTitle
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
                self.lblReceiptTitle.text = strTitle
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
    @IBAction func btnDone(_ sender: Any) {
//        let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
//        let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navAnnouncement") as! UINavigationController
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = obj
        
        if isFromVC == "CDQExam" {
            let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
            let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navCDQ") as! UINavigationController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = obj
        }
        if isFromVC == "ImportantDatesInfo" {
            
            let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
            let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navInfoDates") as! UINavigationController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = obj
        }
        if isFromVC == "Certification" {
            let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
            let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navCertification") as! UINavigationController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = obj
        }
        if isFromVC == "History" {
            let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
            let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navHistory") as! UINavigationController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = obj
        }
        if isFromVC == "CME" {
            let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
            let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navCME") as! UINavigationController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = obj
        }
    }
    
    @IBAction func btnReturn(_ sender: Any) {
        
        //        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
        //        obj.strUrl = strCenterUrl
        //        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        
        let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
        let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navAnnouncement") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = obj
    }
}
extension ReceiptPadVC:UITableViewDataSource, UITableViewDelegate {
    
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
        if isFromVC == "ImportantDatesInfo" {
            if indexPath.row == 1 {
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
