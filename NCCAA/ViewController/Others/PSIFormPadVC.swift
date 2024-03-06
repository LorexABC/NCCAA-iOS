//
//  PSIFormPadVC.swift
//  NCCAA
//
//  Created by Apple on 20/07/22.
//

import UIKit

class PSIFormPadVC: UIViewController {
    
    // MARK: - Variable
    var isFromVC = "CDQExam"
    var arrUniversities:[EditProfileFieldsResponse]?
    var intExamId:Int?
    var arrYear:[String] = []
    let arrGender = ["Male","Female"]
    var intUniversityId = 0
    var selectedTextfield:UITextField?
    var myPickerView : UIPickerView!
    var picker:UIDatePicker?
    let arrState = ["AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
    
    let arrMenu = ["Announcements","Important Info/Dates","Student Clinical Competencies","Certification Exam","State Licensing Info","View CAA Certificate","CDQ Exam","CME Submissions","Blog","History","Edit Profile","Contact NCCAA"]

    
    let arrMenuIcons = ["Doorbell","Calendar","Upload to Cloud","Document","Rubber Stamp yellow","Diploma","Document_blue","Upload","News","Clock","Settings","Customer Support"]
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableMenu: UITableView!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtDob: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtLname: UITextField!
    @IBOutlet weak var txtMname: UITextField!
    @IBOutlet weak var txtFname: UITextField!
    @IBOutlet weak var txtUserId: UITextField!
    @IBOutlet weak var txtYearGraduate: UITextField!
    @IBOutlet weak var txtSchool: UITextField!
    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        userAPI()
        setDatePicker()
        personalUserAPI()
    }

    func setupUI() {
        lblName.text = "Hello, \(Helper.shared.userName)!"
        let year = Calendar.current.component(.year, from: Date())

        for i in 1970...year {
            arrYear.append("\(i)")
        }
        
        if Helper.shared.userType == "student" {
            
            txtSchool.isUserInteractionEnabled = false
            txtYearGraduate.isUserInteractionEnabled = false
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
        txtDob.inputView = picker
        picker?.backgroundColor = UIColor.white
        picker?.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        picker?.datePickerMode = .date
        picker?.maximumDate = Date()
        
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
    }
    @objc func onClickDoneButton() {
        self.view.endEditing(true)
    }
    @objc func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let strDate = dateFormatter.string(from: picker!.date)
        txtDob?.text = strDate
    }
    func pickUp(textField : UITextField) {
        
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

        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    @objc func doneClick() {
        selectedTextfield?.resignFirstResponder()
    }
    
    
    
    // MARK: - Webservice
    func personalUserAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallPersonalUser(url: URLs.personal, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            self.txtYearGraduate.text = "\(response.graduationYear ?? 0)"
            self.getUniversitiesAPI(universityId: response.universityId ?? 0)
            
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    func getUniversitiesAPI(universityId:Int) {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallEditProfileFields(url: URLs.universities, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            self.arrUniversities = response
            
            if universityId == 0 {
                self.txtSchool.text = ""
            } else {
                
                if let index = self.arrUniversities?.firstIndex(where: { $0.id == universityId }) {
                    
                    self.txtSchool.text = self.arrUniversities?[index].name
                    self.intUniversityId = self.arrUniversities?[index].id ?? 0
                }
            }
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    
    func psiFillAPI() {
        
        Helper.shared.showHUD()
        
        let date = Helper.shared.changeStringDateFormat(date: txtDob.text!, toFormat: "yyyy-MM-dd", fromFormat: "MM/dd/yyyy")

        var params = [
            "firstName": txtFname.text!,
            "middleName": txtMname.text ?? "",
            "lastName": txtLname.text!,
            "email": txtEmail.text!,
            "dateOfBirth": date,
            "phone": txtPhone.text!,
            "address": txtAddress.text!,
            "city": txtCity.text!,
            "state": txtState.text!,
            "zipCode": txtZip.text!,
            "graduationYear": Int(txtYearGraduate.text ?? "")!,
            "universityId": intUniversityId] as [String : Any]
        
        if txtGender.text == "Male" {
            params["gender"] = "male"
        } else {
            params["gender"] = "female"
        }
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]

        NetworkManager.shared.webserviceCallFillPSI(url: "\(URLs.exams)/\(intExamId ?? 0)/psi", parameters: params, headers:headers) { (response) in

            //if response.ResponseCode == 200 {

            //print(response)
            
            if let err = response["error"] {
                
                Toast.show(message: err as? String ?? "", controller: self)
            } else {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "CreditCardPadVC") as! CreditCardPadVC
                obj.intReceiptId = response["receiptId"] as? Int
                obj.isFromVC = self.isFromVC
                self.navigationController?.pushViewController(obj, animated: true)
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
            
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    // MARK: - IBAction
    @IBAction func btnSubmit(_ sender: Any) {
        
        if txtEmail.text == "" || txtFname.text == "" || txtLname.text == "" || txtDob.text == "" || txtGender.text == "" || txtPhone.text == "" || txtAddress.text == "" || txtCity.text == "" || txtState.text == "" || txtZip.text == "" || txtSchool.text == "" || txtYearGraduate.text == "" {
            Toast.show(message: Message.fillReqFields, controller: self)
            return
        }
        
        if !(txtEmail.text?.isValidEmail() ?? false) {
            Toast.show(message: Message.validEmail, controller: self)
            return
        }
//        if !(txtPhone.text?.isValidContact() ?? false) {
//            Toast.show(message: Message.validPhone, controller: self)
//            return
//        }
        psiFillAPI()
        
    }

    @IBAction func btnNotification(_ sender: Any) {
        
        let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
        let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navAnnouncement") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = obj
    }
}
extension PSIFormPadVC:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrMenu.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
extension PSIFormPadVC:UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if selectedTextfield == txtYearGraduate {
            
            return arrYear.count
        }
        if selectedTextfield == txtSchool {
            
            return arrUniversities?.count ?? 0
        }
        if selectedTextfield == txtGender {
            
            return arrGender.count
        }
        if selectedTextfield == txtState {
            
            return arrState.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if selectedTextfield == txtYearGraduate {
            
           return arrYear[row]
        }
        if selectedTextfield == txtSchool {
            
            return arrUniversities?[row].name
        }
        if selectedTextfield == txtGender {
            
            return arrGender[row]
        }
        if selectedTextfield == txtState {
            
            return arrState[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if selectedTextfield == txtYearGraduate {
            
            selectedTextfield?.text = arrYear[row]
        }
        if selectedTextfield == txtSchool {
            
            selectedTextfield?.text = arrUniversities?[row].name
            intUniversityId = arrUniversities?[row].id ?? 0
        }
        if selectedTextfield == txtGender {
            
            selectedTextfield?.text = arrGender[row]
        }
        if selectedTextfield == txtState {
            
            selectedTextfield?.text = arrState[row]
        }
    }
    
}
extension PSIFormPadVC:UITextFieldDelegate {
    
    //MARK:- TextFiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextfield = textField
        
        self.pickUp(textField: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
