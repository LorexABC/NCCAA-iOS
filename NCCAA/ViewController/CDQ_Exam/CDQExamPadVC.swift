//
//  CDQExamPadVC.swift
//  NCCAA
//
//  Created by Apple on 13/07/22.
//

import UIKit

class CDQExamPadVC: UIViewController {
    
    
    // MARK: - Variable
    let refreshControl = UIRefreshControl()
    var arrExams:[[String:Any]]?
    let arr4 = ["Register for the February Exam","Register for the June Exam"]
    let arrMenu = ["Announcements","Important Info/Dates","Student Clinical Competencies","Certification Exam","State Licensing Info","View CAA Certificate","CDQ Exam","CME Submissions","Blog","History","Edit Profile","Contact NCCAA"]
//    let arrMenuIcons = ["Frame 52","Frame 52 (1)","Group 35","award","Rubber Stamp","archive-book","teacher","Frame 52 (2)","Frame 52 (3)","Frame 52 (4)","user-edit","Support"]
    let arrMenuIcons = ["Doorbell","Calendar","Upload to Cloud","Document","Rubber Stamp yellow","Diploma","Document_blue","Upload","News","Clock","Settings","Customer Support"]
    var intSelectedExam = 0
    
    // MARK: - IBOutlet
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var tableMenu: UITableView!
    @IBOutlet weak var collview: UICollectionView!
    @IBOutlet weak var lblProgram: UILabel!
    @IBOutlet weak var lblCertDueDate: UILabel!
    @IBOutlet weak var lblAttempt: UILabel!
    @IBOutlet weak var lblTestingCentre: UILabel!
    @IBOutlet weak var lblResults: UILabel!
    @IBOutlet weak var lblHistory: UILabel!
    @IBOutlet weak var tableBookCentre: UITableView!
    @IBOutlet weak var heightTableBookCentre: NSLayoutConstraint!
    @IBOutlet weak var heightTableResults: NSLayoutConstraint!
    @IBOutlet weak var tableResults: UITableView!
    @IBOutlet weak var lblName: UILabel!
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
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        
        DispatchQueue.main.async {
            
            self.heightTableBookCentre?.constant = self.tableBookCentre.contentSize.height
            self.heightTableResults?.constant = self.tableResults.contentSize.height
        }
        
    }
    
    func setupUI() {
        lblName.text = "Hello, \(Helper.shared.userName)!"
        tableBookCentre.estimatedRowHeight = 20
        tableBookCentre.rowHeight = UITableView.automaticDimension
        tableResults.estimatedRowHeight = 20
        tableResults.rowHeight = UITableView.automaticDimension
        
        //
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        scrollview.addSubview(refreshControl)
    }
    func initialRefresh() {
        
        getExamsAPI()
        userAPI()
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
            
            self.arrExams = response
            
            
            if response.count > 0 {
                let index = response.firstIndex{$0["receiptPaid"] as? Bool == true}
                
                if let _ = index {
                    self.intSelectedExam = index!
                    let dict = response[index!]
                    
                    self.lblAttempt.text = "\(dict["attemptNumber"] ?? 0)"
                    self.lblHistory.text = "\((dict["attemptNumber"] as? Int ?? 0).ordinal) Attempt"
                    
                    //
                    if dict["attemptNumber"] as? Int ?? 0 > 1 {
                        
                        self.viewRetakeBg.isHidden = false
                        self.lblRetakeNo.text =  "Retake #\((dict["attemptNumber"] as? Int ?? 0) - 1) (\(dict["examsRemaining"] as? Int ?? 0) Exams Remaining)"
                        let retake_fees = "\(dict["retakeFee"] as? Int ?? 0)".currencyFormatting()
                        self.lblRetakeFee.text = "Retake fee:\n\(retake_fees)"
                        
                        let startDate = Helper.shared.changeStringDateFormat(date: (dict["dateStart"] as? String)!, toFormat: "MMM dd, yyyy", fromFormat: "yyyy-MM-dd")
                        let mainString = "There are a total of two retakes allowed to pass the CDQ exam\n\nYou are required to take the next CDQ exam on \(startDate)\n\nSelect the Pay Now button to register for your next exam. After completing the PSI form and making payment, the Testing Center button below will activate approx. 3 months prior to the next available exam date, enabling you to schedule your exam location."
                        
                        
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
                    if dict["bookingMade"] as? Bool == true {
                        self.lblTestingCentre.text = "Booked"
                    } else {
                        self.lblTestingCentre.text = "Not Booked"
                    }
                    if dict["resultsAvailable"] as? Bool == true {
                        self.lblResults.text = "Available"
                    } else {
                        self.lblResults.text = "Not Available"
                    }
                } else {
                    self.intSelectedExam = 0
                    let dict = response[0]
                    
                    self.lblAttempt.text = "\(dict["attemptNumber"] ?? 0)"
                    self.lblHistory.text = "\((dict["attemptNumber"] as? Int ?? 0).ordinal) Attempt"
                    
                    //
                    if dict["attemptNumber"] as? Int ?? 0 > 1 {
                        
                        self.viewRetakeBg.isHidden = false
                        self.lblRetakeNo.text =  "Retake #\((dict["attemptNumber"] as? Int ?? 0) - 1) (\(dict["examsRemaining"] as? Int ?? 0) Exams Remaining)"
                        let retake_fees = "\(dict["retakeFee"] as? Int ?? 0)".currencyFormatting()
                        self.lblRetakeFee.text = "Retake fee:\n\(retake_fees)"
                        
                        let startDate = Helper.shared.changeStringDateFormat(date: (dict["dateStart"] as? String)!, toFormat: "MMM dd, yyyy", fromFormat: "yyyy-MM-dd")
                        let mainString = "There are a total of two retakes allowed to pass the CDQ exam\n\nYou are required to take the next CDQ exam on \(startDate)\n\nSelect the Pay Now button to register for your next exam. After completing the PSI form and making payment, the Testing Center button below will activate approx. 3 months prior to the next available exam date, enabling you to schedule your exam location."
                        
                        
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
                    if dict["bookingMade"] as? Bool == true {
                        self.lblTestingCentre.text = "Booked"
                    } else {
                        self.lblTestingCentre.text = "Not Booked"
                    }
                    if dict["resultsAvailable"] as? Bool == true {
                        self.lblResults.text = "Available"
                    } else {
                        self.lblResults.text = "Not Available"
                    }
                }
            }
            
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            
            self.collview.reloadData()
            self.tableBookCentre.reloadData()
            self.tableResults.reloadData()
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
            
            if let _ = response.cdqDueDate {
                self.lblCertDueDate.text = Helper.shared.changeStringDateFormat(date: response.cdqDueDate ?? "", toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
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
    @IBAction func btnNotification(_ sender: Any) {
        
        let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
        let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navAnnouncement") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = obj
    }
    @IBAction func btnMoreInfo(_ sender: Any) {
        
//        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlainTextVC") as! PlainTextVC
//        obj.strHeader = "CDQ Exam"
//        navigationController?.pushViewController(obj, animated: true)
        
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
        obj.strUrl = "https://www.nccaatest.org/NCCAAHandbooksandPolicies.pdf"
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnLogout(_ sender: Any) {
        
        Helper.shared.logoutFromApp(vc: self)
    }
    @objc func btnRegisterForExam(sender:UIButton) {
        
        if arrExams?[sender.tag]["registrationIsAvailable"] as? Bool == false {
            Toast.show(message: "Registration isn't availbale", controller: self)
            return
        }
        
        if arrExams?[sender.tag]["psiFilled"] as? Bool == false {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "PSIFormPadVC") as! PSIFormPadVC
            obj.intExamId = arrExams?[sender.tag]["id"] as? Int
            navigationController?.pushViewController(obj, animated: true)
        } else {
            
            if arrExams?[sender.tag]["receiptPaid"] as? Bool == false {
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "CreditCardPadVC") as! CreditCardPadVC
                obj.intReceiptId = arrExams?[sender.tag]["receiptId"] as? Int
                self.navigationController?.pushViewController(obj, animated: true)
            } else {
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "ReceiptPadVC") as! ReceiptPadVC
                obj.intReceiptId = arrExams?[sender.tag]["receiptId"] as? Int
                self.navigationController?.pushViewController(obj, animated: true)
            }
        }
    }
    
    @objc func btnBookTestingCenter(sender:UIButton) {
        
        if let receiptPaid = arrExams?[sender.tag]["receiptPaid"] as? Bool {
            
            if receiptPaid == true {
                if arrExams?[sender.tag]["bookingMade"] as? Bool == true {
                    
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "TestingCenerPadVC") as! TestingCenerPadVC
                    obj.intExamId = arrExams?[sender.tag]["id"] as? Int
                    obj.strCentreUrl = arrExams?[sender.tag]["testingCenterUrl"] as? String
                    self.navigationController?.pushViewController(obj, animated: true)
                } else {
                    
                    if let _ = arrExams?[sender.tag]["testingCenterUrl"] {
                        
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
                        obj.strUrl = arrExams?[sender.tag]["testingCenterUrl"] as? String ?? ""
                        self.navigationController?.pushViewController(obj, animated: true)
                    }
                }
            } else {
                Toast.show(message: "Booking is not available until registration and payment has been made during the registration periods", controller: self)
            }
        }
        
    }
    @objc func btnResultsScores(sender:UIButton) {
        
        if arrExams?[sender.tag]["resultsAvailable"] as? Bool == true {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ResultsScorePadVC") as! ResultsScorePadVC
            obj.intExamId = arrExams?[sender.tag]["id"] as? Int
            self.navigationController?.pushViewController(obj, animated: true)
        } else {
            
            Toast.show(message: "Scores and results are not yet available", controller: self)
        }
    }
}
extension CDQExamPadVC:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tableMenu {
            return arrMenu.count
        } else {
            
            return arrExams?.count ?? 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableMenu {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
            cell.lblTitle.text = arrMenu[indexPath.row]
            cell.img.image = UIImage(named: arrMenuIcons[indexPath.row])
            
            
            if indexPath.row == 6 {
                cell.viewWithTag(101)?.backgroundColor = #colorLiteral(red: 0.3019607843, green: 0.5215686275, blue: 0.9411764706, alpha: 1)
                cell.lblTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                cell.viewWithTag(101)?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.lblTitle.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            return cell
        } else if tableView == tableBookCentre {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as! ButtonCell
            cell.btn.tag = indexPath.row
            cell.btn.addTarget(self, action: #selector(btnBookTestingCenter(sender:)), for: .touchUpInside)
            if let receiptPaid = arrExams?[indexPath.row]["receiptPaid"] as? Bool {
                
                if receiptPaid == true {
                    cell.btn.backgroundColor = UIColor(named: "AppBlue")
                    
                    if let bookingMade = arrExams?[indexPath.row]["bookingMade"] as? Bool {
                        
                        if bookingMade == true {
                            cell.btn.setTitle("View Details", for: .normal)
                            if arrExams?[indexPath.row]["resultsAvailable"] as? Bool == true {
                                cell.btn.backgroundColor = UIColor(named: "AppLightGray")
                            } else {
                                
                                if (arrExams?[indexPath.row]["bookingStatus"] as? String == "EXAM_COMPLETED") ||  (arrExams?[indexPath.row]["bookingStatus"] as? String == "ABSENT") {
                                    cell.btn.backgroundColor = UIColor(named: "AppLightGray")
                                } else {
                                    cell.btn.backgroundColor = UIColor(named: "AppBlue")
                                }
                            }
                        }
                        
                    }
                } else {
                    cell.btn.backgroundColor = UIColor(named: "AppLightGray")
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as! ButtonCell
            
            if arrExams?[indexPath.row]["resultsAvailable"] as? Bool == true {
                cell.btn.setTitle("Results (available)", for: .normal)
                cell.btn.backgroundColor = UIColor(named: "AppBlue")
            } else {
                cell.btn.setTitle("Results (not available)", for: .normal)
                cell.btn.backgroundColor = UIColor(named: "AppLightGray")
            }
            cell.btn.tag = indexPath.row
            cell.btn.addTarget(self, action: #selector(btnResultsScores(sender:)), for: .touchUpInside)
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == tableMenu {
            return UITableView.automaticDimension
        } else if tableView == tableBookCentre {
            
            if indexPath.row == intSelectedExam {
                return UITableView.automaticDimension
            } else {
                return 0
            }
        } else {
            if indexPath.row == intSelectedExam {
                return UITableView.automaticDimension
            } else {
                return 0
            }
        }
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
extension CDQExamPadVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrExams?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImportantDate2CollectionViewCell", for: indexPath) as! ImportantDate2CollectionViewCell
        if let date1 = arrExams?[indexPath.row]["registrationStart"] as? String {
            let lateStart = Helper.shared.changeStringDateFormat(date: date1, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
            
            if let date2 = arrExams?[indexPath.row]["registrationEnd"] as? String {
                
                let lateEnd = Helper.shared.changeStringDateFormat(date: date2, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
                
                cell.lblRegistration.text = "\(lateStart)-\(lateEnd)"
            }
            
        } else {
            cell.lblRegistration.text = ""
        }
        
        if let date1 = arrExams?[indexPath.row]["lateStart"] as? String {
            let lateStart = Helper.shared.changeStringDateFormat(date: date1, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
            
            if let date2 = arrExams?[indexPath.row]["lateEnd"] as? String {
                
                let lateEnd = Helper.shared.changeStringDateFormat(date: date2, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
                
                cell.lblLate.text = "\(lateStart)-\(lateEnd)"
            }
            
        } else {
            cell.lblLate.text = ""
        }
        
        
        var strTitle = ""
        if arrExams?[indexPath.row]["dateStart"] as? String != "" {
            
            let arr = (arrExams?[indexPath.row]["dateStart"] as? String)?.components(separatedBy: "-")
            
            if arr?.count != 0 {
                
                let month = Helper.shared.getMonthFromNumber(month: (arr?[1])!)
                cell.btnSubmit.setTitle("Register for the \(month) Exam", for: .normal)
                
                strTitle = "\(month) \(arr?[2] ?? "")"
            }
            
        }
        if arrExams?[indexPath.row]["dateEnd"] as? String != "" {
            
            let arr = (arrExams?[indexPath.row]["dateEnd"] as? String)?.components(separatedBy: "-")
            
            if arr?.count != 0 {
                strTitle = "\(strTitle)-\(arr?[2] ?? ""),\(arr?[0] ?? "") CDQ Exam"
            }
            
        }
        cell.lblTitle.text = strTitle
        
        if arrExams?[indexPath.row]["registrationIsAvailable"] as? Bool == true {
            cell.btnSubmit.backgroundColor = UIColor(named: "AppBlue")
        } else {
            cell.btnSubmit.backgroundColor = UIColor(named: "AppLightGray")
        }
        
        cell.btnSubmit.tag = indexPath.row
        cell.btnSubmit.addTarget(self, action: #selector(btnRegisterForExam(sender:)), for: .touchUpInside)
        
        
        if indexPath.row % 2 != 0 {
            cell.contentView.viewWithTag(101)?.isHidden = false
            cell.contentView.viewWithTag(102)?.isHidden = true
        } else {
            cell.contentView.viewWithTag(101)?.isHidden = true
            cell.contentView.viewWithTag(102)?.isHidden = false
        }
        
        if ((arrExams?.count ?? 0)-1) == indexPath.row {
            cell.contentView.viewWithTag(102)?.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 350, height: 213)
    }
    
    
}
