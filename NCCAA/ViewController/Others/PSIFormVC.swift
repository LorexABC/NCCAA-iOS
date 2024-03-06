//
//  PSIFormVC.swift
//  NCCAA
//
//  Created by Apple on 20/07/22.
//

import UIKit

class PSIFormVC: UIViewController {
    
    // MARK: - Variable
    var isFromVC = "CDQExam"
    var arrUniversities:[EditProfileFieldsResponse]?
    var arrYear:[String] = []
    let arrGender = ["Male","Female"]
    var intUniversityId = 0
    var selectedTextfield:UITextField?
    var myPickerView : UIPickerView!
    var intExamId:Int?
    var picker:UIDatePicker?
    let arrState = ["AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
    
    // MARK: - IBOutlet
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        userAPI()
        setDatePicker()
        personalUserAPI()
    }
    

    // MARK: - Function
    
    func setupUI() {
        
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
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "CreditCardVC") as! CreditCardVC
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
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
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

}
extension PSIFormVC:UIPickerViewDataSource, UIPickerViewDelegate {
    
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
extension PSIFormVC:UITextFieldDelegate {
    
    //MARK:- TextFiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextfield = textField
        
        self.pickUp(textField: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
