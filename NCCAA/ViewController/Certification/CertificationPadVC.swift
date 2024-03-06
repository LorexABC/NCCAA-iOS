//
//  CertificationPadVC.swift
//  NCCAA
//
//  Created by Apple on 12/07/22.
//

import UIKit

class CertificationPadVC: UIViewController {
    
    
    // MARK: - Variable
    var isRegisterCertExam = false
    var isPsiFilled = false
    var isReceiptPaid = false
    var isBookingMade = false
    var isResultsAvailable = false
    var intExamId:Int = 0
    var dictExam:[String:Any]?
    let arrMenu = ["Announcements","Important Info/Dates","Student Clinical Competencies","Certification Exam","State Licensing Info","View CAA Certificate","CDQ Exam","CME Submissions","Blog","History","Edit Profile","Contact NCCAA"]

    let arrMenuIcons = ["Doorbell","Calendar","Upload to Cloud","Document","Rubber Stamp yellow","Diploma","Document_blue","Upload","News","Clock","Settings","Customer Support"]
    let refreshControl = UIRefreshControl()
    
    // MARK: - IBOutlet
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var tableMenu: UITableView!
    @IBOutlet weak var btnResults: UIButton!
    @IBOutlet weak var lblExamTitle: UILabel!
    @IBOutlet weak var lblExmRegistration: UILabel!
    @IBOutlet weak var lblExmLate: UILabel!
    @IBOutlet weak var lblProgram: UILabel!
    @IBOutlet weak var lblCertDueDate: UILabel!
    @IBOutlet weak var lblAttempt: UILabel!
    @IBOutlet weak var lblTestingCentre: UILabel!
    @IBOutlet weak var lblResults: UILabel!
    @IBOutlet weak var lblHistory: UILabel!
    @IBOutlet weak var btnRegisterCetExam: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnBookTestingCentre: UIButton!
    @IBOutlet weak var viewRetakeBg: UIView!
    @IBOutlet weak var lblRetakeNo: UILabel!
    @IBOutlet weak var lblRetakeDesc: UILabel!
    @IBOutlet weak var lblRetakeFee: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        initialRefresh()
    }

    // MARK: - Function
    func setupUI() {
        
        lblName.text = "Hello, \(Helper.shared.userName)!"
        
        //
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        scrollview.addSubview(refreshControl)
    }
    func initialRefresh() {
        userAPI()
        getExamsAPI()
    }
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        
        initialRefresh()
        refreshControl.endRefreshing()
    }
    // MARK: - Webservice
    func getExamsAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallGetExams(url: URLs.exams, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            let dict = response[0]
            self.dictExam = dict
            self.intExamId = dict["id"] as! Int
            
            if let date1 = dict["registrationStart"] as? String {
                let lateStart = Helper.shared.changeStringDateFormat(date: date1, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
                
                if let date2 = dict["registrationEnd"] as? String {
                    
                    let lateEnd = Helper.shared.changeStringDateFormat(date: date2, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
                    
                    self.lblExmRegistration.text = "\(lateStart)-\(lateEnd)"
                }
                
            } else {
                self.lblExmRegistration.text = ""
            }
            
            
            
            if let date1 = dict["lateStart"] as? String {
                let lateStart = Helper.shared.changeStringDateFormat(date: date1, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
                
                if let date2 = dict["lateEnd"] as? String {
                    
                    let lateEnd = Helper.shared.changeStringDateFormat(date: date2, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
                    
                    self.lblExmLate.text = "\(lateStart)-\(lateEnd)"
                }
                
            } else {
                self.lblExmLate.text = ""
            }
            
            self.lblAttempt.text = "\(dict["attemptNumber"] ?? 0)"
            self.lblHistory.text = "\((dict["attemptNumber"] as? Int ?? 0).ordinal) Attempt"
            
            //
            if dict["attemptNumber"] as? Int ?? 0 > 1 {
                
                self.viewRetakeBg.isHidden = false
                self.lblRetakeNo.text =  "Retake #\((dict["attemptNumber"] as? Int ?? 0) - 1) (\(dict["examsRemaining"] as? Int ?? 0) Exams Remaining)"
                let retake_fees = "\(dict["retakeFee"] as? Int ?? 0)".currencyFormatting()
                self.lblRetakeFee.text = "Retake fee:\n\(retake_fees)"
                
                let startDate = Helper.shared.changeStringDateFormat(date: (dict["dateStart"] as? String)!, toFormat: "MMM dd, yyyy", fromFormat: "yyyy-MM-dd")
                let mainString = "There are a total of five retakes allowed to pass the Certification exam\n\nYou are required to take the next Certification exam on \(startDate)\n\nSelect the Pay Now button to register for your next exam. After completing the PSI form and making payment, the Testing Center button below will activate enabling you to schedule your exam location."
                
                let range = (mainString as NSString).range(of: startDate)
                
                let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
                mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
                
                self.lblRetakeDesc.attributedText = mutableAttributedString
                
                DispatchQueue.main.async {
                    self.viewRetakeBg.dropShadow()
                }
            } else {
                self.viewRetakeBg.isHidden = true
            }
            
            //
            var strTitle = ""
            if dict["dateStart"] as? String != "" {
                
                let arr = (dict["dateStart"] as? String)?.components(separatedBy: "-")
                
                if arr?.count != 0 {
                    
                    let month = Helper.shared.getMonthFromNumber(month: (arr?[1])!)
                    
                    strTitle = "\(month) \(arr?[2] ?? "")"
                }
                
            }
            if dict["dateEnd"] as? String != "" {
                
                let arr = (dict["dateEnd"] as? String)?.components(separatedBy: "-")
                
                if arr?.count != 0 {
                    strTitle = "\(strTitle)-\(arr?[2] ?? ""), \(arr?[0] ?? "") Cert Exam"
                }
                
            }
            self.lblExamTitle.text = strTitle
            
            
            if dict["bookingMade"] as? Bool == true {
                self.lblTestingCentre.text = "Booked"
            } else {
                self.lblTestingCentre.text = "Not Booked"
            }
            if dict["resultsAvailable"] as? Bool == true {
                self.lblResults.text = "Available"
                self.btnResults.setTitle("Results (available)", for: .normal)
                self.btnResults.backgroundColor = UIColor(named: "AppBlue")
            } else {
                self.lblResults.text = "Not Available"
                self.btnResults.setTitle("Results (not available)", for: .normal)
                self.btnResults.backgroundColor = UIColor(named: "AppLightGray")
            }
            
            self.isPsiFilled = (dict["psiFilled"] as? Bool)!
            self.isReceiptPaid = (dict["receiptPaid"] as? Bool)!
            self.isBookingMade = (dict["bookingMade"] as? Bool)!
            self.isResultsAvailable = (dict["resultsAvailable"] as? Bool)!
            
            if dict["registrationIsAvailable"] as? Bool == true {
                self.isRegisterCertExam = true
                self.btnRegisterCetExam.backgroundColor = UIColor(named: "AppBlue")
            } else {
                self.isRegisterCertExam = false
                self.btnRegisterCetExam.backgroundColor = UIColor(named: "AppLightGray")
            }
            
            if let receiptPaid = dict["receiptPaid"] as? Bool {
                
                if receiptPaid == true {
                    self.btnBookTestingCentre.backgroundColor = UIColor(named: "AppBlue")
                    
                    if let bookingMade = dict["bookingMade"] as? Bool {
                        
                        if bookingMade == true {
                            self.btnBookTestingCentre.setTitle("View Details", for: .normal)
                            if dict["resultsAvailable"] as? Bool == true {
                                self.btnBookTestingCentre.backgroundColor = UIColor(named: "AppLightGray")
                            } else {
                                if (dict["bookingStatus"] as? String == "EXAM_COMPLETED") ||  (dict["bookingStatus"] as? String == "ABSENT") {
                                    self.btnBookTestingCentre.backgroundColor = UIColor(named: "AppLightGray")
                                } else {
                                    self.btnBookTestingCentre.backgroundColor = UIColor(named: "AppBlue")
                                }
                            }
                        }
                        
                    }
                } else {
                    self.btnBookTestingCentre.backgroundColor = UIColor(named: "AppLightGray")
                }
            }
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    func userAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallPersonalUser(url: URLs.user_info, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            if let _ = response.program {
                self.lblProgram.text = response.program
            } else {
                self.lblProgram.text = "N/A"
            }
            
            if let date = response.certificationDueDate {
                self.lblCertDueDate.text = Helper.shared.changeStringDateFormat(date: date, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
            } else {
                self.lblCertDueDate.text = "N/A"
            }
            
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    
    // MARK: - IBAction

    
    @IBAction func btnRegisterCertExam(_ sender: Any) {
        
        if isRegisterCertExam == false {
            Toast.show(message: "Registration isn't availbale", controller: self)
            return
        }
        
        if isPsiFilled == false {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "PSIFormPadVC") as! PSIFormPadVC
            obj.intExamId = intExamId
            obj.isFromVC = "Certification"
            navigationController?.pushViewController(obj, animated: true)
        } else {
            
            if isReceiptPaid == false {
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "CreditCardPadVC") as! CreditCardPadVC
                obj.intReceiptId = dictExam?["receiptId"] as? Int
                obj.isFromVC = "Certification"
                self.navigationController?.pushViewController(obj, animated: true)
            } else {
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "ReceiptPadVC") as! ReceiptPadVC
                obj.intReceiptId = dictExam?["receiptId"] as? Int
                obj.isFromVC = "Certification"
                self.navigationController?.pushViewController(obj, animated: true)
            }
        }
        
        
    }
    
    @IBAction func btnResults(_ sender: Any) {
        
        if isResultsAvailable {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ResultsScorePadVC") as! ResultsScorePadVC
            obj.intExamId = dictExam?["id"] as? Int
            obj.isFromVC = "Certification"
            self.navigationController?.pushViewController(obj, animated: true)
        } else {
            
            Toast.show(message: "Scores and results are not yet available", controller: self)
        }
    }
    @IBAction func btnBookingCentre(_ sender: Any) {
        
        if isReceiptPaid == true {
            
            if isBookingMade == true {
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "TestingCenerPadVC") as! TestingCenerPadVC
                obj.intExamId = dictExam?["id"] as? Int
                obj.strCentreUrl = dictExam?["testingCenterUrl"] as? String
                self.navigationController?.pushViewController(obj, animated: true)
            } else {
                
                if let _ = dictExam?["testingCenterUrl"] {
                    
                    let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
                    obj.strUrl = dictExam?["testingCenterUrl"] as? String ?? ""
                    self.navigationController?.pushViewController(obj, animated: true)
                }
                
            }
        } else {
            Toast.show(message: "Booking is not available until registration and payment has been made during the registration periods", controller: self)
        }
    }
    @IBAction func btnNotification(_ sender: Any) {
        
        let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
        let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navAnnouncement") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = obj
    }
    @IBAction func btnMoreInfo(_ sender: Any) {
        
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlainTextVC") as! PlainTextVC
        obj.strHeader = "Certification Exam"
        navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnCertInfo(_ sender: Any) {
        
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlainTextVC") as! PlainTextVC
        obj.strHeader = "Certification Info/Handbook"
        navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnLogout(_ sender: Any) {
        
        Helper.shared.logoutFromApp(vc: self)
    }
}
extension CertificationPadVC:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrMenu.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
        cell.lblTitle.text = arrMenu[indexPath.row]
        cell.img.image = UIImage(named: arrMenuIcons[indexPath.row])
        
        
        if indexPath.row == 3 {
            cell.viewWithTag(101)?.backgroundColor = #colorLiteral(red: 0.3019607843, green: 0.5215686275, blue: 0.9411764706, alpha: 1)
            cell.lblTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            cell.viewWithTag(101)?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.lblTitle.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
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
