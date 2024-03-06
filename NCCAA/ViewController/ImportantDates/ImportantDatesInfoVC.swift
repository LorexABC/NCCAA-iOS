//
//  ImportantDatesInfoVC.swift
//  NCCAA
//
//  Created by Apple on 08/07/22.
//

import UIKit

class ImportantDatesInfoVC: UIViewController {
    
    // MARK: - Variable
    var arrCycle:[[String:Any]] = []
    var arrExams:[[String:Any]]?
    let refreshControl = UIRefreshControl()
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var lblDescBottom: UILabel!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblCertificateNo: UILabel!
    @IBOutlet weak var lblCertifiedThrough: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    @IBOutlet weak var lblCMEDueDate: UILabel!
    @IBOutlet weak var lblCDQDueDate: UILabel!
    @IBOutlet weak var lblYear1: UILabel!
    @IBOutlet weak var lblGradDate: UILabel!
    @IBOutlet weak var lblCertDueDate: UILabel!
    @IBOutlet weak var lblClinicalsCompleted: UILabel!
    @IBOutlet weak var lblScienceExmDate: UILabel!
    @IBOutlet weak var lblProgram: UILabel!
    @IBOutlet weak var btnClinicals: UIButton!
    
    
    
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
            self.tableHeight?.constant = self.table.contentSize.height
        }
    }
    
    func setupUI() {
        
        viewBg.dropShadow()
        table.estimatedRowHeight = 20
        table.rowHeight = UITableView.automaticDimension
        
        lblDescBottom.attributedText = "<p style=\"text-align:left\"><strong>1st 4 Years of CAA</strong></p><p style=\"text-align:left\">During the initial 4-year period, CAAs must submit 50 hours of CME documents and pay $295 every 2 years.</p><p style=\"text-align:left\">In the 4th year, CAAs must take the first CDQ Exam, paying $1,300, and submit their 2nd CME submission, paying $295.</p><p style=\"text-align:left\">If the CDQ Exam is passed, the subsequent exam will take place 10 years after the pass date. For instance, if a CAA passes the CDQ exam in 2024, the next exam will be scheduled for 2034.</p><p style=\"text-align:left\">In addition to the CDQ Exam, CAAs must submit CMEs every two years until retirement.</p>".convertToAttributedString(fontStyle: "SFProDisplay-Regular", fontWeight: "Regular", fontSize: "17")
        
        //
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        scrollview.addSubview(refreshControl)
    }
    func initialRefresh() {
        
        if Helper.shared.userType == "caa" {
            getCMECyclesAPI()
        }
        userAPI()
        getExamsAPI()
    }
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        
        initialRefresh()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Webservice
    func userAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallPersonalUser(url: URLs.user_info, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            if let _ = response.account {
                self.lblAccount.text = response.account?.uppercased()
            } else {
                self.lblAccount.text = "N/A"
            }
            
            if let _ = response.status {
                self.lblStatus.text = response.status?.uppercased()
            } else {
                self.lblStatus.text = "N/A"
            }
            
            
            
            if let _ = response.certificateNumber {
                self.lblCertificateNo.text = "\(response.certificateNumber ?? 0)"
            } else {
                self.lblCertificateNo.text = "N/A"
            }
            
            
            if let _ = response.certifiedThrough {
                self.lblCertifiedThrough.text = Helper.shared.changeStringDateFormat(date: response.certifiedThrough ?? "", toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
            } else {
                self.lblCertifiedThrough.text = "N/A"
            }
            
            if let _ = response.designation {
                self.lblDesignation.text = response.designation
            } else {
                self.lblDesignation.text = "N/A"
            }
            
            
            if let _ = response.cmeDueDate {
                self.lblCMEDueDate.text = Helper.shared.changeStringDateFormat(date: response.cmeDueDate ?? "", toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
            } else {
                self.lblCMEDueDate.text = "N/A"
            }
            if let _ = response.cdqDueDate {
                self.lblCDQDueDate.text = Helper.shared.changeStringDateFormat(date: response.cdqDueDate ?? "", toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
            } else {
                self.lblCDQDueDate.text = "N/A"
            }
            if let _ = response.graduationDate {
                self.lblGradDate.text = Helper.shared.changeStringDateFormat(date: response.graduationDate ?? "", toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
            } else {
                self.lblGradDate.text = ""
            }
            
            if let _ = response.firstYear {
                self.lblYear1.text = "\(response.firstYear ?? 0)"
            } else {
                self.lblYear1.text = "N/A"
            }
            
            if let _ = response.certificationDueDate {
                self.lblCertDueDate.text = Helper.shared.changeStringDateFormat(date: response.certificationDueDate ?? "", toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
            } else {
                self.lblCertDueDate.text = "N/A"
            }
            
            if let _ = response.clinicalsCompleted {
                self.lblClinicalsCompleted.text = response.clinicalsCompleted
            } else {
                self.lblClinicalsCompleted.text = "Unavailable"//"Not Completed"
                if Helper.shared.userType == "caa" {
                    self.btnClinicals.isUserInteractionEnabled = false
                }
            }
            
            if let _ = response.scienceExamDueDate {
                self.lblScienceExmDate.text = Helper.shared.changeStringDateFormat(date: response.scienceExamDueDate ?? "", toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
            } else {
                self.lblScienceExmDate.text = "N/A"
            }
            
            if let _ = response.program {
                self.lblProgram.text = response.program
            } else {
                self.lblProgram.text = "N/A"
            }
            
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    func getCMECyclesAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallGetExams(url: URLs.cmeCycles, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            self.arrCycle.removeAll()
            if response.count > 0 {
                
                for i in 0..<response.count {
                    
                    if response[i]["isCurrent"] as? Bool == true {
                        
                        self.arrCycle.append(response[i])
                    }
                }
            }
            self.table.reloadData()
            
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }

    func getExamsAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallGetExams(url: URLs.exams, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            self.arrExams = response
            self.table.reloadData()
            
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
    
    @IBAction func btnClinicals(_ sender: Any) {
        
//        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ClinicalCompetenciesVC") as! ClinicalCompetenciesVC
//        navigationController?.pushViewController(obj, animated: true)
        Toast.show(message: "This module will not be available until 2024.", controller: self)
    }
    
    @IBAction func btnCME(_ sender: Any) {
        if Helper.shared.userType == "student" {
            Toast.show(message: Message.studentModuleUnavailable, controller: self)
            return
        }
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "CMESubmissionVC") as! CMESubmissionVC
        navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnCDQ(_ sender: Any) {
        if Helper.shared.userType == "student" {
            Toast.show(message: Message.studentModuleUnavailable, controller: self)
            return
        }
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "CDQExamVC") as! CDQExamVC
        navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnCertDueDate(_ sender: Any) {
        
        if Helper.shared.userType == "caa" {
            Toast.show(message: Message.caaModuleUnavailable, controller: self)
            return
        }
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "CertificationVC") as! CertificationVC
        navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnLogout(_ sender: Any) {
        
        Helper.shared.logoutFromApp(vc: self)
    }
    @objc func btnUplodCME(sender:UIButton) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "AddCMEVC") as! AddCMEVC
        obj.strYear = "\(arrCycle[sender.tag]["cycle"] ?? 0)"
        navigationController?.pushViewController(obj, animated: true)
    }
    @objc func btnRegisterForExam(sender:UIButton) {
        
        if arrExams?[sender.tag]["registrationIsAvailable"] as? Bool == false {
            Toast.show(message: "Registration isn't availbale", controller: self)
            return
        }
        
        if arrExams?[sender.tag]["psiFilled"] as? Bool == false {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "PSIFormVC") as! PSIFormVC
            obj.intExamId = arrExams?[sender.tag]["id"] as? Int
            obj.isFromVC = "ImportantDatesInfo"
            navigationController?.pushViewController(obj, animated: true)
        } else {
            
            if arrExams?[sender.tag]["receiptPaid"] as? Bool == false {
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "CreditCardVC") as! CreditCardVC
                obj.intReceiptId = arrExams?[sender.tag]["receiptId"] as? Int
                obj.isFromVC = "ImportantDatesInfo"
                self.navigationController?.pushViewController(obj, animated: true)
            } else {
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "ReceiptVC") as! ReceiptVC
                obj.intReceiptId = arrExams?[sender.tag]["receiptId"] as? Int
                obj.isFromVC = "ImportantDatesInfo"
                self.navigationController?.pushViewController(obj, animated: true)
            }
        }
    }
    
    @IBAction func unwindToImpDatesInfoVC(segue: UIStoryboardSegue) {}
}

extension ImportantDatesInfoVC:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
                return 1
        } else {
            return arrExams?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImportantDate1Cell") as! ImportantDate1Cell
            
            if arrCycle.count > 0 {
                
                let date = Helper.shared.changeStringDateFormat(date: (arrCycle[indexPath.row]["deadline"])! as! String, toFormat: "MMMM dd, yyyy", fromFormat: "yyyy-MM-dd")
                cell.lblExamTitle.text = "\(date), CME Due Date"
                
                if let date = arrCycle[indexPath.row]["deadline"] as? String {
                    cell.lblExmDeadline.text = Helper.shared.changeStringDateFormat(date: date, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
                } else {
                    cell.lblExmDeadline.text = ""
                }
                
                if let date1 = arrCycle[indexPath.row]["lateStart"] as? String {
                    let lateStart = Helper.shared.changeStringDateFormat(date: date1, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
                    
                    if let date2 = arrCycle[indexPath.row]["lateEnd"] as? String {
                        
                        let lateEnd = Helper.shared.changeStringDateFormat(date: date2, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
                        
                        cell.lblExmLate.text = "\(lateStart)-\(lateEnd)"
                    }
                    
                } else {
                    cell.lblExmLate.text = ""
                }
                
            }
            
            
            cell.btnUploadCME.tag = indexPath.row
            cell.btnUploadCME.addTarget(self, action: #selector(btnUplodCME(sender:)), for: .touchUpInside)
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImportantDate2Cell") as! ImportantDate2Cell
            
            
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
                    strTitle = "\(strTitle)-\(arr?[2] ?? ""), \(arr?[0] ?? "") \((arrExams?[indexPath.row]["type"] as? String)?.uppercased() ?? "") Exam"
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
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            if Helper.shared.userType != "caa" {
                return 1
            }
        }
        return UITableView.automaticDimension
    }
}


