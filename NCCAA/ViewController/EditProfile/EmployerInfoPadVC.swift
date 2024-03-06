//
//  EmployerInfoPadVC.swift
//  NCCAA
//
//  Created by Apple on 19/07/22.
//

import UIKit

class EmployerInfoPadVC: UIViewController, RetirePlans, SelectAnesthesia {
    
    
    // MARK: - Variable
    var arrRetirePlans:[EditProfileFieldsResponse]?
    var arrSubRetirePlans:[[String:Any]]?
    var arrPracticeTypes1:[EditProfileFieldsResponse]?
    var arrPracticeTypes2:[EditProfileFieldsResponse]?
    var arrBenefits:[EditProfileFieldsResponse]?
    var arrSpecialties:[EditProfileFieldsResponse]?
    var arrAnesthesiology:[EditProfileFieldsResponse]?
    var selectedTextfield:UITextField?
    var myPickerView : UIPickerView!
    var picker:UIDatePicker?
    var isRetirePlansEdited = false
    var arrSelectedRetirePlans:[[String:Any]] = []
    var arrDefaultRetirePlans:[[String:Any]]?
    var arrSelectedAnesthesiaAAA:[String] = []
    var arrSelectedAnesthesiaASA:[String] = []
    
    let arrState = ["AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
    let arrEmpStatus = ["Full-time", "Part-time","PRN", "Locum tenens", "Retired", "Not currently employed as a CAN"]
    let arrEmpStatusID = ["full-time", "part-time","prn", "locum-tenens", "retired", "not-employed"]
    let arrPayReason = ["Any time","After cumulative hours","Do not receive","Not eligible"]
    let arrPayReasonID = ["any-time","after-cumulative","not-receive","not-eligible"]
    let arrWorkSchedule = ["Consistent shift","Variable shifts","Set start time each day with variable end time","Call","Other"]
    let arrWorkScheduleID = ["consistent-shift","variable-shifts","fixed-start-variable-end","call","other"]
    let arrWorkingHours = ["Less than 20","20-30","30-40","Greater than 40"]
    let arrWorkingHoursID = ["less-20","20-30","30-40","greater-40"]
    var arrActivityHours:[String] = []
    let arrTeaching = ["AA Students","Healthcare Learners"]
    let arrTeachingID = ["aa-students","healthcare-learners"]
    let arrBool = ["Yes","No"]
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var txtDate1stEmp: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtEmpStatus: UITextField!
    @IBOutlet weak var txtEmpName: UITextField!
    @IBOutlet weak var txtEmpAddress: UITextField!
    @IBOutlet weak var txtEmpSuite: UITextField!
    @IBOutlet weak var txtEmpCity: UITextField!
    @IBOutlet weak var txtEmpState: UITextField!
    @IBOutlet weak var txtEmpZip: UITextField!
    @IBOutlet weak var txtEmpPracticeSetting1: UITextField!
    @IBOutlet weak var txtEmpPracticeSetting2: UITextField!
    @IBOutlet weak var txtEmpPracticeSetting1Other: UITextField!
    @IBOutlet weak var txtEmpPracticeSetting2Other: UITextField!
    @IBOutlet weak var txtCompOffered: UITextField!
    @IBOutlet weak var txtOTPay: UITextField!
    @IBOutlet weak var txtOTPayReason: UITextField!
    @IBOutlet weak var txtWeekWorkSchedule: UITextField!
    @IBOutlet weak var txtWeekWorkScheduleOther: UITextField!
    @IBOutlet weak var txtWorkingHours: UITextField!
    @IBOutlet weak var txtActivityHours: UITextField!
    @IBOutlet weak var txtEmpBenefit: UITextField!
    @IBOutlet weak var txtEmpBenefitOther: UITextField!
    @IBOutlet weak var txtRetireDate: UITextField!
    @IBOutlet weak var txtRetireSetup1: UITextField!
    @IBOutlet weak var txtRetireSetup2: UITextField!
    @IBOutlet weak var txtLangSpoken: UITextField!
    @IBOutlet weak var txtLanguageToPatient: UITextField!
    @IBOutlet weak var txtTeaching: UITextField!
    @IBOutlet weak var txtSpecialties: UITextField!
    @IBOutlet weak var txtSpecialtiesOther: UITextField!
    @IBOutlet weak var txtAcademyASS: UITextField!
    @IBOutlet weak var txtSocietyASA: UITextField!
    @IBOutlet weak var viewRetireSetup2: UIView!
    @IBOutlet weak var txtviewRetireSetup2: UITextView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        getRetirePlansAPI()
        getPracticeTypesAPI()
        getSpecialtiesAPI()
        getAnesthesiologyAPI()
        getBenefitsAPI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.employerInfoAPI()
        }
        setDatePicker()
        
        setupUI()
    }
    
    
    // MARK: - Function
    
    func setupUI() {
        
        for i in 1...100 {
            arrActivityHours.append("\(i)")
        }
    }
    
    func sendRetirePlans(arr: [[String : Any]], str:String) {
        
        isRetirePlansEdited = true
        
        //print(arr)
        
        var subArr:[[String : Any]] = []
        
        for i in 0..<arr.count {
            
            var subDict:[String:String] = [:]
            
            subDict["fieldCode"] = arr[i]["code"] as? String
            subDict["value"] = arr[i]["value"] as? String
            
            subArr.append(subDict)
        }
        
        var dict:[String:Any] = [:]
        
        dict["code"] = txtRetireSetup1.accessibilityLabel
        dict["fieldValues"] = subArr
        
        arrSelectedRetirePlans.append(dict)
        
        print(arrSelectedRetirePlans)
        txtviewRetireSetup2.text = str
    }
    
    func sendAnesthesia(arr: [String], type:String) {
        
        var str1 = ""
        for i in 0..<arr.count {
            
            if let index = self.arrAnesthesiology?.firstIndex(where: { $0.code == arr[i] }) {
                
                str1 += "\(self.arrAnesthesiology?[index].name ?? ""),"
            }
        }
        
        if type == "AAA" {
            self.txtAcademyASS.text = String(str1.dropLast())
            self.arrSelectedAnesthesiaAAA = arr
        }
        if type == "ASA" {
            self.txtSocietyASA.text = String(str1.dropLast())
            self.arrSelectedAnesthesiaASA = arr
        }
        
    }
    
    func setDatePicker() {
        
        //Write Date picker code
        picker = UIDatePicker()
        if #available(iOS 13.4, *) {
            picker?.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        txtRetireDate.inputView = picker
        txtDate1stEmp.inputView = picker
        picker?.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        picker?.datePickerMode = .date
        
        //Write toolbar code for done button
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onClickDoneButton))
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        txtRetireDate.inputAccessoryView = toolBar
        txtDate1stEmp.inputAccessoryView = toolBar
    }
    
    @objc func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy" //Change your date formate
        let strDate = dateFormatter.string(from: picker!.date)
        selectedTextfield?.text = strDate
    }
    
    //Toolbar done button function
    @objc func onClickDoneButton() {
        self.view.endEditing(true)
    }
    func pickUp(textField : UITextField, text:String){
        
        
        view.viewWithTag(1001)?.removeFromSuperview()
        view.viewWithTag(1002)?.removeFromSuperview()
        // UIPickerView
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        myPickerView.tag = 1001
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.backgroundColor = UIColor.white
        textField.inputView = self.myPickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.tag = 1002
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let labelButton = UIBarButtonItem(title: text.maxLength(length: 35), style: .plain, target: nil, action: nil)

        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([labelButton,spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    @objc func doneClick() {
        selectedTextfield?.resignFirstResponder()
    }
    
    
    
    // MARK: - Webservice
    func employerInfoAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallEmployerInfo(url: URLs.employer_info, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            if let date = response.firstEmployment {
                self.txtDate1stEmp.text = Helper.shared.changeStringDateFormat(date: date, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
            } else {
                self.txtDate1stEmp.text = ""
            }
            
            if let index = self.arrEmpStatusID.firstIndex(where: { $0 == response.employerStatus }) {
                self.txtEmpStatus.text = self.arrEmpStatus[index]
                
                if self.txtEmpStatus.text == "Not currently employed as a CAN" {
                    
                    self.txtActivityHours.text = ""
                    self.txtActivityHours.isUserInteractionEnabled = false
                } else {
                    
                    if let dict = response.workingHoursDistribution?[0] as? [String:Any] {
                        
                        if let hours = dict["hours"] as? Int {
                            self.txtActivityHours.text = "\(hours)"
                        }
                        
                    }
                    
                    self.txtActivityHours.isUserInteractionEnabled = true
                }
            }
            
            if response.statesEligible?.count != 0 {
                self.txtState.text = response.statesEligible?[0]
            }
            
            self.txtEmpName.text = response.name
            self.txtEmpAddress.text = response.address
            self.txtEmpSuite.text = response.aptOrSuite
            self.txtEmpCity.text = response.city
            self.txtEmpState.text = response.state
            self.txtEmpZip.text = response.zipCode
            
            
            if response.practiceTypeCodesGroup1?.count != 0 {
                
                if let index = self.arrPracticeTypes1?.firstIndex(where: { $0.code == response.practiceTypeCodesGroup1?[0] }) {
                    self.txtEmpPracticeSetting1.text = self.arrPracticeTypes1?[index].name
                }
            }
            self.txtEmpPracticeSetting1Other.text = response.group1Other
            
            if response.practiceTypeCodesGroup2?.count != 0 {
                
                if let index = self.arrPracticeTypes2?.firstIndex(where: { $0.code == response.practiceTypeCodesGroup2?[0] }) {
                    self.txtEmpPracticeSetting2.text = self.arrPracticeTypes2?[index].name
                }
            }
            self.txtEmpPracticeSetting2Other.text = response.group2Other
            
            self.txtCompOffered.text = response.compensation
            
            if response.overtime == true {
                self.txtOTPay.text = "Yes"
            } else {
                self.txtOTPay.text = "No"
            }
            
            
            if let index = self.arrPayReasonID.firstIndex(where: { $0 == response.overtimeReceived }) {
                self.txtOTPayReason.text = self.arrPayReason[index]
            }
            if let index = self.arrWorkScheduleID.firstIndex(where: { $0 == response.workSchedule }) {
                self.txtWeekWorkSchedule.text = self.arrWorkSchedule[index]
            }
            self.txtWeekWorkScheduleOther.text = response.workScheduleOther
            
            if let index = self.arrWorkingHoursID.firstIndex(where: { $0 == response.workingHours }) {
                self.txtWorkingHours.text = self.arrWorkingHours[index]
            }
            
            if response.employerBenefits?.count != 0 {
                
                if let index = self.arrBenefits?.firstIndex(where: { $0.code == response.employerBenefits?[0] }) {
                    self.txtEmpBenefit.text = self.arrBenefits?[index].name
                }
            }
            
            self.txtEmpBenefitOther.text = response.employerBenefitOther
            
            if let date = response.retirementDate {
                self.txtRetireDate.text = Helper.shared.changeStringDateFormat(date: date, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
            } else {
                self.txtRetireDate.text = ""
            }
            
            
            //
            
            //DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                if response.retirementPlan?.count != 0 {
                    
                    self.arrDefaultRetirePlans = response.retirementPlan
                    if let index = self.arrRetirePlans?.firstIndex(where: { $0.code == response.retirementPlan?[0]["code"] as? String }) {
                        self.txtRetireSetup1.text = self.arrRetirePlans?[index].name
                        self.txtRetireSetup1.accessibilityLabel = response.retirementPlan?[0]["code"] as? String
                        
                        var str = ""
                        self.arrSubRetirePlans = self.arrRetirePlans?[index].fields
                        
                        for i in 0..<(self.arrSubRetirePlans?.count ?? 0) {
                            
                            str += "\(self.arrSubRetirePlans?[i]["name"] as? String ?? "")-\n"
                        }
                        self.txtviewRetireSetup2.text = str
                        
                    }
                    
                    self.viewRetireSetup2.isHidden = false
                    
                }
            //}
            
            
            //
            
            
            self.txtLangSpoken.text = "\(response.languagesSpoken ?? 0)"
            
            if response.useOtherLanguages == true {
                self.txtLanguageToPatient.text = "Yes"
            } else {
                self.txtLanguageToPatient.text = "No"
            }
            
            if response.teaches?.count != 0 {
                
                if let index = self.arrTeachingID.firstIndex(where: { $0 == response.teaches?[0] }) {
                    self.txtTeaching.text = self.arrTeaching[index]
                }
            }
            if response.specialties?.count != 0 {
                
                if let index = self.arrSpecialties?.firstIndex(where: { $0.code == response.specialties?[0] }) {
                    self.txtSpecialties.text = self.arrSpecialties?[index].name
                }
            }
            self.txtSpecialtiesOther.text = response.specialtyOther
            
            if response.belongsToAsaGroups?.count != 0 {
                self.txtAcademyASS.text = response.belongsToAsaGroups?[0]
            }
            if response.belongsToAsaGroups?.count != 0 {
                self.txtSocietyASA.text = response.belongsToAsaGroups?[0]
            }
            
           //
            //DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                self.arrSelectedAnesthesiaAAA = response.belongsToAaaaGroups ?? []
                var str1 = ""
                for i in 0..<(response.belongsToAaaaGroups?.count ?? 0) {
                    
                    if let index = self.arrAnesthesiology?.firstIndex(where: { $0.code == response.belongsToAaaaGroups?[i] }) {
                        
                        str1 += "\(self.arrAnesthesiology?[index].name ?? ""),"
                    }
                }
                self.txtAcademyASS.text = String(str1.dropLast())
                
                self.arrSelectedAnesthesiaASA = response.belongsToAsaGroups ?? []
                var str2 = ""
                for i in 0..<(response.belongsToAsaGroups?.count ?? 0) {
                    
                    if let index = self.arrAnesthesiology?.firstIndex(where: { $0.code == response.belongsToAsaGroups?[i] }) {
                        
                        str2 += "\(self.arrAnesthesiology?[index].name ?? ""),"
                    }
                }
                self.txtSocietyASA.text = String(str2.dropLast())
            //}
            
           
            
            //
            Helper.shared.hideHUD()
        }
    }
    
    func getRetirePlansAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallEditProfileFields(url: URLs.retirementPlans, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            self.arrRetirePlans = response
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    
    func getPracticeTypesAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallEditProfileFields(url: URLs.practiceTypes, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            //self.arrPracticeTypes = response
            self.arrPracticeTypes1 = response.filter {$0.group == 1}
            self.arrPracticeTypes2 = response.filter {$0.group == 2}
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    
    func getBenefitsAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallEditProfileFields(url: URLs.employerBenefits, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            self.arrBenefits = response
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    
    func getSpecialtiesAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallEditProfileFields(url: URLs.specialties, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            self.arrSpecialties = response
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    func getAnesthesiologyAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallEditProfileFields(url: URLs.anesthesiologyGroups, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            self.arrAnesthesiology = response
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    
    func updateEmployerInfoAPI(params:[String:Any]) {
        
        Helper.shared.showHUD()
        

        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]

        NetworkManager.shared.webserviceCallUpdateEmployerInfo(url: URLs.employer_info, parameters: params, headers:headers) { (response) in

            //if response.ResponseCode == 200 {

            //print(response)


            if response["status"] as? String == "success" {
                
                Toast.show(message: response["status"] as? String ?? "", controller: self)
            }
            if let err = response["error"] {
                
                Toast.show(message: err as? String ?? "", controller: self)
            }

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
    
    @IBAction func btnSubmit(_ sender: Any) {
        
        self.view.endEditing(true)
        
        let obj = self.parent as? PersonalInfoPadVC
        obj?.isEditPage = false
        
        if txtState.text == "" {
            Toast.show(message: "Please select States", controller: self)
            return
        }
        if txtEmpName.text == "" {
            Toast.show(message: "Please enter Employer name", controller: self)
            return
        }
        if txtEmpPracticeSetting1.text == "" {
            Toast.show(message: "Select employer type of practise #1", controller: self)
            return
        }
        if txtEmpPracticeSetting2.text == "" {
            Toast.show(message: "Select employer type of practise #2", controller: self)
            return
        }
        if txtWorkingHours.text == "" {
            Toast.show(message: "Enter working hours", controller: self)
            return
        }
        if txtActivityHours.text == "" {
            
            if txtEmpStatus.text != "Not currently employed as a CAN" {
                Toast.show(message: "Enter hours per week", controller: self)
                return
            }
        }
        if txtOTPay.text == "" {
            Toast.show(message: "Select receive overtime pay", controller: self)
            return
        }
        if txtEmpBenefit.text == "" {
            Toast.show(message: "Select employer benefits", controller: self)
            return
        }
        if txtRetireSetup1.text == "" {
            Toast.show(message: "Select retirement plan setup 1", controller: self)
            return
        }
        if txtviewRetireSetup2.text == "" {
            Toast.show(message: "Select retirement plan setup 2", controller: self)
            return
        }
        if txtLangSpoken.text == "" {
            Toast.show(message: "Enter number of languages spoken", controller: self)
            return
        }
        if txtLanguageToPatient.text == "" {
            Toast.show(message: "Select communication languages", controller: self)
            return
        }
        if txtTeaching.text == "" {
            Toast.show(message: "Select teaching", controller: self)
            return
        }
        if txtSpecialties.text == "" {
            Toast.show(message: "Select surgical specialities", controller: self)
            return
        }
        if txtAcademyASS.text == "" {
            Toast.show(message: "Select academy of anesthesiologist", controller: self)
            return
        }
        if txtSocietyASA.text == "" {
            Toast.show(message: "Select society of anesthesiologist", controller: self)
            return
        }
        var dict:[String:Any] = [:]
        
        if txtDate1stEmp.text != "" {
            dict["firstEmployment"] = Helper.shared.changeStringDateFormat(date: txtDate1stEmp.text!, toFormat: "yyyy-MM-dd", fromFormat: "MM/dd/yyyy")
        }
         
        if txtEmpStatus.text != "" {
            if let index = self.arrEmpStatus.firstIndex(where: { $0 == txtEmpStatus.text }) {
                
                dict["employerStatus"] = arrEmpStatusID[index]
            }
        }
        
        
        dict["statesEligible"] = [txtState.text ?? ""]
        dict["name"] = txtEmpName.text
        dict["address"] = txtEmpAddress.text
        dict["aptOrSuite"] = txtEmpSuite.text
        dict["city"] = txtEmpCity.text
        
        if txtEmpState.text != "" {
            dict["state"] = txtEmpState.text
        }
        if txtEmpZip.text != "" {
            dict["zipCode"] = txtEmpZip.text
        }
        
        
        
        if let index = self.arrPracticeTypes1?.firstIndex(where: { $0.name == txtEmpPracticeSetting1.text }) {
            
            dict["practiceTypeCodesGroup1"] = [self.arrPracticeTypes1?[index].code ?? ""]
        }
        dict["group1Other"] = txtEmpPracticeSetting1Other.text ?? ""
        
        if let index = self.arrPracticeTypes2?.firstIndex(where: { $0.name == txtEmpPracticeSetting2.text }) {
            
            dict["practiceTypeCodesGroup2"] = [self.arrPracticeTypes2?[index].code ?? ""]
        }
        dict["group2Other"] = txtEmpPracticeSetting2Other.text ?? ""
        
        if txtCompOffered.text != "" {
            dict["compensation"] = txtCompOffered.text ?? ""
        }
        
        if txtOTPay.text != "" {
            if txtOTPay.text == "Yes" {
                dict["overtime"] = true
            } else {
                dict["overtime"] = false
            }
        }
        
        if txtOTPayReason.text != "" {
            if let index = self.arrPayReason.firstIndex(where: { $0 == txtOTPayReason.text }) {
                
                dict["overtimeReceived"] = arrPayReasonID[index]
            }
        }
        
        if txtWeekWorkSchedule.text != "" {
            if let index = self.arrWorkSchedule.firstIndex(where: { $0 == txtWeekWorkSchedule.text }) {
                
                dict["workSchedule"] = arrWorkScheduleID[index]
            }
            dict["workScheduleOther"] = txtWeekWorkScheduleOther.text ?? ""
        }
        
        
        if let index = self.arrWorkingHours.firstIndex(where: { $0 == txtWorkingHours.text }) {
            
            dict["workingHours"] = arrWorkingHoursID[index]
        }
        
            
        dict["workingHoursDistribution"] = [["code":"direct",
                                                 "hours":Int(txtActivityHours.text ?? "0") ?? 0]]
        
        if let index = self.arrBenefits?.firstIndex(where: { $0.name == txtEmpBenefit.text }) {
            
            dict["employerBenefits"] = [self.arrBenefits?[index].code ?? ""]
        }
        dict["employerBenefitOther"] = txtEmpBenefitOther.text ?? ""
        
        if txtRetireDate.text != "" {
            dict["retirementDate"] = Helper.shared.changeStringDateFormat(date: txtRetireDate.text!, toFormat: "yyyy-MM-dd", fromFormat: "MM/dd/yyyy")
        }
        
        
        if isRetirePlansEdited {
            
            //retirementPlan value = arrSelectedRetirePlans
            dict["retirementPlan"] = arrSelectedRetirePlans
        } else {
            
            //retirementPlan value = arrDefaultRetirePlans
            dict["retirementPlan"] = arrDefaultRetirePlans
        }
        
        dict["languagesSpoken"] = Int(txtLangSpoken.text ?? "0")
        
        
        if txtLanguageToPatient.text == "Yes" {
            dict["useOtherLanguages"] = true
        } else {
            dict["useOtherLanguages"] = false
        }
        
        if let index = self.arrTeaching.firstIndex(where: { $0 == txtTeaching.text }) {
            
            dict["teaches"] = [arrTeachingID[index]]
        }
        
        if let index = self.arrSpecialties?.firstIndex(where: { $0.name == txtSpecialties.text }) {
            
            dict["specialties"] = [self.arrSpecialties?[index].code ?? ""]
        }
        dict["specialtyOther"] = txtSpecialtiesOther.text ?? ""
        
        
            
        dict["belongsToAaaaGroups"] = arrSelectedAnesthesiaAAA
        dict["belongsToAsaGroups"] = arrSelectedAnesthesiaASA
        
        print(dict)
        
        updateEmployerInfoAPI(params: dict)
        
    }
    
    @IBAction func btnRetirePlanSetup(_ sender: Any) {
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectRetirePlansVC") as! SelectRetirePlansVC
        obj.modalPresentationStyle = .overCurrentContext
        obj.delegate = self
        obj.arrSubRetirePlans = arrSubRetirePlans
        self.present(obj, animated: true, completion: nil)
    }
    
    @IBAction func btnAAA(_ sender: Any) {
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectAnesthesiaVC") as! SelectAnesthesiaVC
        obj.modalPresentationStyle = .overCurrentContext
        obj.delegate = self
        obj.arrAnesthesiology = arrAnesthesiology
        obj.type = "AAA"
        self.present(obj, animated: true, completion: nil)
    }
    @IBAction func btnASA(_ sender: Any) {
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectAnesthesiaVC") as! SelectAnesthesiaVC
        obj.modalPresentationStyle = .overCurrentContext
        obj.delegate = self
        obj.arrAnesthesiology = arrAnesthesiology
        obj.type = "ASA"
        self.present(obj, animated: true, completion: nil)
    }
    
}

extension EmployerInfoPadVC:UITextFieldDelegate {
    
    //MARK:- TextFiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextfield = textField
        let obj = self.parent as? PersonalInfoPadVC
        obj?.isEditPage = true
        
        if textField == txtRetireDate || textField == txtDate1stEmp || textField == txtEmpName || textField == txtEmpAddress || textField == txtEmpCity || textField == txtEmpZip || textField == txtEmpSuite || textField == txtCompOffered  {
            return
        }
        self.pickUp(textField: textField, text: textField.placeholder ?? "")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtEmpName || textField == txtEmpAddress || textField == txtEmpCity || textField == txtEmpZip || textField == txtEmpSuite || textField == txtCompOffered  {
            return true
        }
        return false
    }
}
extension EmployerInfoPadVC:UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if selectedTextfield == txtEmpStatus {
            
            return arrEmpStatus.count
        }
        if selectedTextfield == txtState {
            
            return arrState.count
        }
        if selectedTextfield == txtEmpState {
            
            return arrState.count
        }
        if selectedTextfield == txtEmpPracticeSetting1 {
            
            return arrPracticeTypes1?.count ?? 0
        }
        if selectedTextfield == txtEmpPracticeSetting2 {
            
            return arrPracticeTypes2?.count ?? 0
        }
        if selectedTextfield == txtOTPay {
            
            return arrBool.count
        }
        if selectedTextfield == txtOTPayReason {
            
            return arrPayReason.count
        }
        if selectedTextfield == txtWeekWorkSchedule {
            
            return arrWorkSchedule.count
        }
        if selectedTextfield == txtWorkingHours {
            
            return arrWorkingHours.count
        }
        if selectedTextfield == txtActivityHours {
            
            return arrActivityHours.count
        }
        if selectedTextfield == txtEmpBenefit {
            
            return arrBenefits?.count ?? 0
        }
        if selectedTextfield == txtRetireSetup1 {
            
            return arrRetirePlans?.count ?? 0
        }
        if selectedTextfield == txtRetireSetup2 {
            
            return arrSubRetirePlans?.count ?? 0
        }
        if selectedTextfield == txtLanguageToPatient {
            
            return arrBool.count
        }
        if selectedTextfield == txtTeaching {
            
            return arrTeaching.count
        }
        if selectedTextfield == txtSpecialties {
            
            return arrSpecialties?.count ?? 0
        }
        if selectedTextfield == txtAcademyASS {
            
            return arrAnesthesiology?.count ?? 0
        }
        if selectedTextfield == txtSocietyASA {
            
            return arrAnesthesiology?.count ?? 0
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 44));
        label.font = UIFont(name: "SFProDisplay-Regular", size: 17.0)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        if selectedTextfield == txtEmpStatus {
            
            label.text = arrEmpStatus[row]
        }
        if selectedTextfield == txtState {
            
            label.text = arrState[row]
        }
        if selectedTextfield == txtEmpState {
            
            label.text = arrState[row]
        }
        if selectedTextfield == txtEmpPracticeSetting1 {
            
            label.text = arrPracticeTypes1?[row].name
        }
        if selectedTextfield == txtEmpPracticeSetting2 {
            
            label.text = arrPracticeTypes2?[row].name
        }
        if selectedTextfield == txtOTPay {
            
            label.text = arrBool[row]
        }
        if selectedTextfield == txtOTPayReason {
            
            label.text = arrPayReason[row]
        }
        if selectedTextfield == txtWeekWorkSchedule {
            
            label.text = arrWorkSchedule[row]
        }
        if selectedTextfield == txtWorkingHours {
            
            label.text = arrWorkingHours[row]
        }
        if selectedTextfield == txtActivityHours {
            
            label.text = arrActivityHours[row]
        }
        if selectedTextfield == txtEmpBenefit {
            
            label.text = arrBenefits?[row].name
        }
        if selectedTextfield == txtRetireSetup1 {
            
            label.text = arrRetirePlans?[row].name
        }
        if selectedTextfield == txtRetireSetup2 {
            
            label.text = arrSubRetirePlans?[row]["name"] as? String
        }
        if selectedTextfield == txtLanguageToPatient {
            
            label.text = arrBool[row]
        }
        if selectedTextfield == txtTeaching {
            
            label.text = arrTeaching[row]
        }
        if selectedTextfield == txtSpecialties {
            
            label.text = arrSpecialties?[row].name
        }
        if selectedTextfield == txtAcademyASS {
            
            label.text = arrAnesthesiology?[row].name
        }
        if selectedTextfield == txtSocietyASA {
            
            label.text = arrAnesthesiology?[row].name
        }
        label.sizeToFit()
        return label
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if selectedTextfield == txtEmpStatus {
            
            selectedTextfield?.text =  arrEmpStatus[row]
            
            if arrEmpStatus[row] == "Not currently employed as a CAN" {
                
                txtActivityHours.text = ""
                txtActivityHours.isUserInteractionEnabled = false
            } else {
                txtActivityHours.isUserInteractionEnabled = true
            }
        }
        if selectedTextfield == txtState {
            
            selectedTextfield?.text =  arrState[row]
        }
        if selectedTextfield == txtEmpState {
            
            selectedTextfield?.text =  arrState[row]
        }
        if selectedTextfield == txtEmpPracticeSetting1 {
            
            selectedTextfield?.text =  arrPracticeTypes1?[row].name
            
            txtEmpPracticeSetting1Other.text = ""
            if arrPracticeTypes1?[row].name == "Other" {
                
                view.viewWithTag(9001)?.isHidden = false
            } else {
                view.viewWithTag(9001)?.isHidden = true
            }
        }
        if selectedTextfield == txtEmpPracticeSetting2 {
            
            selectedTextfield?.text =  arrPracticeTypes2?[row].name
            
            txtEmpPracticeSetting2Other.text = ""
            if arrPracticeTypes2?[row].name == "Other" {
                
                view.viewWithTag(9002)?.isHidden = false
            } else {
                view.viewWithTag(9002)?.isHidden = true
            }
        }
        if selectedTextfield == txtOTPay {
            
            selectedTextfield?.text =  arrBool[row]
        }
        if selectedTextfield == txtOTPayReason {
            
            selectedTextfield?.text =  arrPayReason[row]
        }
        if selectedTextfield == txtWeekWorkSchedule {
            
            selectedTextfield?.text =  arrWorkSchedule[row]
            
            txtWeekWorkScheduleOther.text = ""
            if arrWorkSchedule[row] == "Other" {
                
                view.viewWithTag(9003)?.isHidden = false
            } else {
                view.viewWithTag(9003)?.isHidden = true
            }
        }
        if selectedTextfield == txtWorkingHours {
            
            selectedTextfield?.text =  arrWorkingHours[row]
        }
        if selectedTextfield == txtActivityHours {
            
            selectedTextfield?.text =  arrActivityHours[row]
        }
        if selectedTextfield == txtEmpBenefit {
            
            selectedTextfield?.text =  arrBenefits?[row].name
            
            txtEmpBenefitOther.text = ""
            if arrBenefits?[row].name == "Other" {
                
                view.viewWithTag(9004)?.isHidden = false
            } else {
                view.viewWithTag(9004)?.isHidden = true
            }
        }
        if selectedTextfield == txtRetireSetup1 {
            
            selectedTextfield?.text =  arrRetirePlans?[row].name
            selectedTextfield?.accessibilityLabel = arrRetirePlans?[row].code
            viewRetireSetup2.isHidden = false
            txtRetireSetup2.text = ""
            arrSubRetirePlans = arrRetirePlans?[row].fields
            
            //
            txtviewRetireSetup2.text = ""
            var str = ""
            if arrSubRetirePlans?.count ?? 0 > 0 {
                
                for i in 0..<(arrSubRetirePlans?.count ?? 0) {
                    str += "\(arrSubRetirePlans?[i]["name"] as? String ?? "")-\n"
                    
                }
                self.txtviewRetireSetup2.text = str
            }
            //
        }
        if selectedTextfield == txtRetireSetup2 {
            
            selectedTextfield?.text =  arrSubRetirePlans?[row]["name"] as? String
        }
        if selectedTextfield == txtLanguageToPatient {
            
            selectedTextfield?.text =  arrBool[row]
        }
        if selectedTextfield == txtTeaching {
            
            selectedTextfield?.text =  arrTeaching[row]
        }
        if selectedTextfield == txtSpecialties {
            
            selectedTextfield?.text =  arrSpecialties?[row].name
            
            txtSpecialtiesOther.text = ""
            if arrSpecialties?[row].name == "Other" {
                
                view.viewWithTag(9005)?.isHidden = false
            } else {
                view.viewWithTag(9005)?.isHidden = true
            }
        }
        if selectedTextfield == txtAcademyASS {
            
            selectedTextfield?.text =  arrAnesthesiology?[row].name
        }
        if selectedTextfield == txtSocietyASA {
            
            selectedTextfield?.text =  arrAnesthesiology?[row].name
        }
    }
    
}
