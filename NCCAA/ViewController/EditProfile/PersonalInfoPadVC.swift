//
//  PersonalInfoPadVC.swift
//  NCCAA
//
//  Created by Apple on 19/07/22.
//

import UIKit

class PersonalInfoPadVC: UIViewController {
    
    // MARK: - Variable
    var arrUniversities:[EditProfileFieldsResponse]?
    var myPickerView : UIPickerView!
    var picker:UIDatePicker?
    var selectedTextfield:UITextField?
    let arrTitle = ["Mr.","Ms.","Miss","Mrs."]
    let arrSuffix = ["Sr.","Jr.","I", "II", "III"]
    let arrGender = ["Male","Female"]
    let arrGenderID = ["male","female"]
    let arrRace = ["Alaska Native", "American Indian","Asia", "Black or Aftian American", "Latino or Hispanic", "Middle Easter", "Native Hawaiian", "Pacific Islander", "White or Caucasian", "Other","Prefer Not To Answer"]
    let arrRaceID = ["alaska-native", "american-indian","asian", "black-aftian-american", "latino-hispanic", "middle-eastern", "native-hawaiian", "pacific-islander", "white-caucasian", "other","no-answer"]
    let arrEthnicity = ["African-American", "American","Dutch","English", "French", "German", "rst", "Italian", "Mexican", "Norwegian","Polish", "Scottish", "Swedish", "Other"]
    let arrEthnicityID = ["african-american", "american","dutch","english", "french", "german", "irish", "italian", "mexican", "norwegian","polish", "scottish", "swedish", "other"]
    let arrMaritalStatus = ["Single","Married","Seperated","Divorced","Widowed"]
    let arrMaritalStatusID = ["single","married","seperated","divorced","widowed"]
    let arrState = ["AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
    
    var isEditPage = false
    
    let arrMenu = ["Announcements","Important Info/Dates","Student Clinical Competencies","Certification Exam","State Licensing Info","View CAA Certificate","CDQ Exam","CME Submissions","Blog","History","Edit Profile","Contact NCCAA"]
    //    let arrMenuIcons = ["Frame 52","Frame 52 (1)","Group 35","award","Rubber Stamp","archive-book","teacher","Frame 52 (2)","Frame 52 (3)","Frame 52 (4)","user-edit","Support"]
    
    let arrMenuIcons = ["Doorbell","Calendar","Upload to Cloud","Document","Rubber Stamp yellow","Diploma","Document_blue","Upload","News","Clock","Settings","Customer Support"]
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableMenu: UITableView!
    @IBOutlet weak var containerview: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var txtUserId: UITextField!
    @IBOutlet weak var txtSelectRole: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtSelectTitle: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtMiddleName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtSuffix: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtDob: UITextField!
    @IBOutlet weak var txtRace: UITextField!
    @IBOutlet weak var txtEthnicity: UITextField!
    @IBOutlet weak var txtOtherEthnicity: UITextField!
    @IBOutlet weak var txtMaritalStatus: UITextField!
    @IBOutlet weak var txtCellPhone: UITextField!
    @IBOutlet weak var txtOtherPhone: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtAlma: UITextField!
    @IBOutlet weak var txtAutoAlma: UITextField!
    @IBOutlet weak var txtClass: UITextField!
    @IBOutlet weak var txtGraduationDate: UITextField!
    @IBOutlet weak var txtDegree: UITextField!
    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getUniversitiesAPI()
        userAPI()
        setDatePicker()
        lblName.text = "Hello, \(Helper.shared.userName)!"
    }
    
    
    // MARK: - Function
    func setDatePicker() {
        
        //Write Date picker code
        picker = UIDatePicker()
        if #available(iOS 13.4, *) {
            picker?.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        txtDob.inputView = picker
        txtGraduationDate.inputView = picker
        picker?.backgroundColor = UIColor.white
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
        txtDob.inputAccessoryView = toolBar
        txtGraduationDate.inputAccessoryView = toolBar
    }
    
    @objc func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
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
    func getUniversitiesAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallEditProfileFields(url: URLs.universities, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            self.arrUniversities = response
            self.personalUserAPI()
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    func personalUserAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallPersonalUser(url: URLs.personal, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            self.txtSelectTitle.text = response.title
            self.txtSuffix.text = response.suffix
            
            if let index = self.arrGenderID.firstIndex(where: { $0 == response.gender }) {
                self.txtGender.text = self.arrGender[index]
            }
            
            if let date = response.dateOfBirth {
                self.txtDob.text = Helper.shared.changeStringDateFormat(date: date, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
            } else {
                self.txtDob.text = ""
            }
            
            if let index = self.arrRaceID.firstIndex(where: { $0 == response.race }) {
                self.txtRace.text = self.arrRace[index]
            }
            if let index = self.arrEthnicityID.firstIndex(where: { $0 == response.ethnicity }) {
                self.txtEthnicity.text = self.arrEthnicity[index]
            }
            
            self.txtOtherEthnicity.text = response.otherEthnicity
            if let index = self.arrMaritalStatusID.firstIndex(where: { $0 == response.maritalStatus }) {
                self.txtMaritalStatus.text = self.arrMaritalStatus[index]
            }
            
            self.txtCellPhone.text = response.phone
            self.txtOtherPhone.text = response.otherPhone
            self.txtCity.text = response.city
            self.txtState.text = response.state
            self.txtStreet.text = response.address
            self.txtZip.text = response.zipCode
            
            
            if let index = self.arrUniversities?.firstIndex(where: { $0.id == response.universityId }) {
                
                self.txtAlma.text = self.arrUniversities?[index].name
                self.txtAutoAlma.text = self.arrUniversities?[index].code
            }
            
            if Helper.shared.userType == "student" {
                self.txtAlma.isUserInteractionEnabled = false
                self.txtAutoAlma.isUserInteractionEnabled = false
                self.txtDegree.isUserInteractionEnabled = false
            } else {
                self.txtAlma.isUserInteractionEnabled = true
                self.txtAutoAlma.isUserInteractionEnabled = true
                self.txtDegree.isUserInteractionEnabled = true
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
            self.txtUserId.text = "ID \(response.id ?? 0)"
            self.txtFirstName.text = response.firstName?.capitalizingFirstLetter()
            self.txtMiddleName.text = response.middleName?.capitalizingFirstLetter()
            self.txtLastName.text = response.lastName?.capitalizingFirstLetter()
            self.txtEmail.text = response.email
            self.txtSelectRole.text = response.status?.uppercased()
            self.txtDegree.text = response.designation
            
            if let date = response.graduationDate {
                self.txtGraduationDate.text = Helper.shared.changeStringDateFormat(date: date, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
            } else {
                self.txtGraduationDate.text = ""
            }
            
            self.txtClass.text = "\(response.firstYear ?? 0)"
            if Helper.shared.userType == "caa" {
                
                if self.txtClass.text == "0" {
                    self.txtClass.isUserInteractionEnabled = true
                } else {
                    self.txtClass.isUserInteractionEnabled = false
                }
                
            } else {
                self.txtClass.isUserInteractionEnabled = false
            }
            
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    
    func updatePersoalInfoAPI(params:[String:Any]) {
        
        Helper.shared.showHUD()
        
        let date = Helper.shared.changeStringDateFormat(date: txtDob.text!, toFormat: "yyyy-MM-dd", fromFormat: "MM/dd/yyyy")
        
        var parameters = [
            "gender": params["genderID"]!,
            "dateOfBirth": date,
            "otherEthnicity": txtOtherEthnicity.text!,
            "phone": txtCellPhone.text!,
            "otherPhone": txtOtherPhone.text!,
            "address": txtStreet.text!,
            "city": txtCity.text!] as [String : Any]
        
        if txtSelectTitle.text != "" {
            parameters["title"] = txtSelectTitle.text!
        }
        if txtSuffix.text != "" {
            parameters["suffix"] = txtSuffix.text!
        }
        if params["raceID"] as! String != "" {
            parameters["race"] = params["raceID"]!
        }
        if params["ethnicityID"] as! String != "" {
            parameters["ethnicity"] = params["ethnicityID"]!
        }
        if params["maritalStatusID"] as! String != "" {
            parameters["maritalStatus"] = params["maritalStatusID"]!
        }
        if txtState.text != "" {
            parameters["state"] = txtState.text!
        }
        if txtZip.text != "" {
            parameters["zipCode"] = txtZip.text!
        }
        if params["universityID"] as! Int != 0 {
            parameters["universityId"] = params["universityID"]!
        }
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallUpdatePersonalInfo(url: URLs.personal, parameters: parameters, headers:headers) { (response) in
            
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
    func updateUserInfoAPI() {
        
        Helper.shared.showHUD()
        
        let params = [
            "firstName": txtFirstName.text!,
            "middleName": txtMiddleName.text!,
            "lastName": txtLastName.text!,
            "email": txtEmail.text!] as [String : Any]
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallUpdatePersonalInfo(url: URLs.user_info, parameters: params, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            if response["status"] as? String == "success" {
                
                Toast.show(message: response["status"] as? String ?? "", controller: self)
            }
            if let err = response["error"] {
                
                Toast.show(message: err as? String ?? "", controller: self)
            }
            //print(response)
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    func deleteAccountAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallCommonPostMethod(url: URLs.delete_Account, parameters: [:], headers:headers) { (response) in
            
            if response["message"] as? String == "Deleted" {
                
                UserDefaults.standard.set("", forKey: "access_token")
                UserDefaults.standard.set(false, forKey: "isLogin")
                UserDefaults.standard.synchronize()
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    let obj = UIStoryboard(name: "IntroiPad", bundle: nil).instantiateViewController(withIdentifier: "navIntroiPad") as! UINavigationController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = obj
                } else {
                    let obj = UIStoryboard(name: "Intro", bundle: nil).instantiateViewController(withIdentifier: "navIntro") as! UINavigationController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = obj
                }
            }
            if let err = response["error"] {
                
                Toast.show(message: err as? String ?? "", controller: self)
            }
                
            Helper.shared.hideHUD()
        }
    }
    // MARK: - IBAction
    @IBAction func btnPersonalInfo(_ sender: Any) {
        
        scrollview.isHidden = false
        containerview.isHidden = true
        
        view.viewWithTag(5001)?.backgroundColor = #colorLiteral(red: 0.3682953119, green: 0.6056789756, blue: 0.9541431069, alpha: 1)
        (view.viewWithTag(5002) as! UILabel).textColor = #colorLiteral(red: 0.3682953119, green: 0.6056789756, blue: 0.9541431069, alpha: 1)
        view.viewWithTag(5003)?.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6509803922, blue: 0.7215686275, alpha: 1)
        (view.viewWithTag(5004) as! UILabel).textColor = #colorLiteral(red: 0.6039215686, green: 0.6509803922, blue: 0.7215686275, alpha: 1)
    }
    
    @IBAction func btnEmployerInfo(_ sender: Any) {
        
        scrollview.isHidden = true
        containerview.isHidden = false
        
        view.viewWithTag(5001)?.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6509803922, blue: 0.7215686275, alpha: 1)
        (view.viewWithTag(5002) as! UILabel).textColor = #colorLiteral(red: 0.6039215686, green: 0.6509803922, blue: 0.7215686275, alpha: 1)
        view.viewWithTag(5003)?.backgroundColor = #colorLiteral(red: 0.3682953119, green: 0.6056789756, blue: 0.9541431069, alpha: 1)
        (view.viewWithTag(5004) as! UILabel).textColor = #colorLiteral(red: 0.3682953119, green: 0.6056789756, blue: 0.9541431069, alpha: 1)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        self.view.endEditing(true)
        isEditPage = false
        if txtEmail.text == "" {
            
            Toast.show(message: "Please enter Email", controller: self)
            return
        } else {
            if !(txtEmail.text?.isValidEmail() ?? false) {
                Toast.show(message: Message.validEmail, controller: self)
                return
            }
        }
        if txtFirstName.text == "" {
            Toast.show(message: "Please enter First name", controller: self)
            return
        }
        if txtLastName.text == "" {
            Toast.show(message: "Please enter Last name", controller: self)
            return
        }
        if txtGender.text == "" {
            Toast.show(message: "Please select Gender", controller: self)
            return
        }
        if txtDob.text == "" {
            Toast.show(message: "Please select Date of birth", controller: self)
            return
        }
        if txtCellPhone.text == "" {
            Toast.show(message: "Please enter cell phone", controller: self)
            return
        } else {
//            if !(txtCellPhone.text?.isValidContact() ?? false) {
//                Toast.show(message: Message.validPhone, controller: self)
//                return
//            }
        }
        if txtOtherPhone.text == "" {
            Toast.show(message: "Please enter other cell phone", controller: self)
            return
        } else {
//            if !(txtOtherPhone.text?.isValidContact() ?? false) {
//                Toast.show(message: Message.validPhone, controller: self)
//                return
//            }
        }
        
        if txtZip.text != "" {
            if txtZip.text?.count != 5 {
                Toast.show(message: Message.validZip, controller: self)
                return
            }
        }
        
        var genderID:String = ""
        var raceID:String = ""
        var ethnicityID:String = ""
        var maritalStatusID:String = ""
        var universityID:Int = 0
        
        
        if let index = self.arrGender.firstIndex(where: { $0 == txtGender.text }) {
            genderID = self.arrGenderID[index]
        }
        
        if txtRace.text != "" {
            if let index = self.arrRace.firstIndex(where: { $0 == txtRace.text }) {
                raceID = self.arrRaceID[index]
            }
        }
        if txtEthnicity.text != "" {
            if let index = self.arrEthnicity.firstIndex(where: { $0 == txtEthnicity.text }) {
                ethnicityID = self.arrEthnicityID[index]
            }
        }
        if txtMaritalStatus.text != "" {
            if let index = self.arrMaritalStatus.firstIndex(where: { $0 == txtMaritalStatus.text }) {
                maritalStatusID = self.arrMaritalStatusID[index]
            }
        }
        if txtAlma.text != "" {
            if let index = self.arrUniversities?.firstIndex(where: { $0.name == txtAlma.text }) {
                universityID = self.arrUniversities?[index].id ?? 0
            }
        }
        
        let params = ["genderID":genderID,
                      "raceID":raceID,
                      "ethnicityID":ethnicityID,
                      "maritalStatusID":maritalStatusID,
                      "universityID":universityID] as [String : Any]
        
        updatePersoalInfoAPI(params: params as [String : Any])
        
        
        updateUserInfoAPI()
        
    }
    @IBAction func btnNotification(_ sender: Any) {
        
        let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
        let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navAnnouncement") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = obj
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        
        let alert = UIAlertController(title: "Are you sure you want to delete account?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
            
            self.deleteAccountAPI()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func btnLogout(_ sender: Any) {
        
        Helper.shared.logoutFromApp(vc: self)
    }
}
extension PersonalInfoPadVC:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrMenu.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
        cell.lblTitle.text = arrMenu[indexPath.row]
        cell.img.image = UIImage(named: arrMenuIcons[indexPath.row])
        
        
        if indexPath.row == 10 {
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
            
            if isEditPage {
                
                let alert = UIAlertController(title: "Warning!", message: "You have made changes to this page without saving.", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "YES! SAVE ALL CHANGES", style: .default, handler: { action in
                    
                })
                alert.addAction(ok)
                let cancel = UIAlertAction(title: "NO", style: .default, handler: { action in
                    
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
                    if indexPath.row == 11 {
                        
                        let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                        let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navContact") as! UINavigationController
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = obj
                    }
                })
                alert.addAction(cancel)
                DispatchQueue.main.async(execute: {
                    self.present(alert, animated: true)
                })
            } else {
                
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
                if indexPath.row == 11 {
                    
                    let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                    let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navContact") as! UINavigationController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = obj
                }
            }
            
        }
    }
}

extension PersonalInfoPadVC:UITextFieldDelegate {
    
    //MARK:- TextFiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextfield = textField
        
        isEditPage = true
        if textField == txtDob || textField == txtGraduationDate || textField == txtSelectRole || textField == txtEmail || textField == txtFirstName || textField == txtMiddleName || textField == txtLastName || textField == txtOtherEthnicity || textField == txtCellPhone || textField == txtOtherPhone || textField == txtStreet || textField == txtCity || textField == txtZip || textField == txtAutoAlma || textField == txtClass {
            return
        }
        self.pickUp(textField: textField, text: textField.placeholder ?? "")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtEmail || textField == txtFirstName || textField == txtMiddleName || textField == txtLastName || textField == txtOtherEthnicity || textField == txtCellPhone || textField == txtOtherPhone || textField == txtStreet || textField == txtCity || textField == txtZip || textField == txtClass {
            return true
        }
        return false
    }
}
extension PersonalInfoPadVC:UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if selectedTextfield == txtSelectTitle {
            
            return arrTitle.count
        }
        if selectedTextfield == txtSuffix {
            
            return arrSuffix.count
        }
        if selectedTextfield == txtGender {
            
            return arrGender.count
        }
        if selectedTextfield == txtRace {
            
            return arrRace.count
        }
        if selectedTextfield == txtEthnicity {
            
            return arrEthnicity.count
        }
        if selectedTextfield == txtMaritalStatus {
            
            return arrMaritalStatus.count
        }
        if selectedTextfield == txtState {
            
            return arrState.count
        }
        if selectedTextfield == txtAlma {
            
            return arrUniversities?.count ?? 0
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 44));
        label.font = UIFont(name: "SFProDisplay-Regular", size: 17.0)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        if selectedTextfield == txtSelectTitle {
            
            label.text = arrTitle[row]
        }
        if selectedTextfield == txtSuffix {
            
            label.text = arrSuffix[row]
        }
        if selectedTextfield == txtGender {
            
            label.text = arrGender[row]
        }
        if selectedTextfield == txtRace {
            
            label.text = arrRace[row]
        }
        if selectedTextfield == txtEthnicity {
            
            label.text = arrEthnicity[row]
        }
        if selectedTextfield == txtMaritalStatus {
            
            label.text = arrMaritalStatus[row]
        }
        if selectedTextfield == txtState {
            
            label.text = arrState[row]
        }
        if selectedTextfield == txtAlma {
            
            label.text = arrUniversities?[row].name
        }
        label.sizeToFit()
        return label
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if selectedTextfield == txtSelectTitle {
            
            selectedTextfield?.text = arrTitle[row]
        }
        if selectedTextfield == txtSuffix {
            
            selectedTextfield?.text = arrSuffix[row]
        }
        if selectedTextfield == txtGender {
            
            selectedTextfield?.text = arrGender[row]
        }
        if selectedTextfield == txtRace {
            
            selectedTextfield?.text = arrRace[row]
        }
        if selectedTextfield == txtEthnicity {
            
            selectedTextfield?.text = arrEthnicity[row]
        }
        if selectedTextfield == txtMaritalStatus {
            
            selectedTextfield?.text = arrMaritalStatus[row]
        }
        if selectedTextfield == txtState {
            
            selectedTextfield?.text = arrState[row]
        }
        if selectedTextfield == txtAlma {
            
            selectedTextfield?.text = arrUniversities?[row].name
            txtAutoAlma.text = arrUniversities?[row].code
        }
    }
    
}
