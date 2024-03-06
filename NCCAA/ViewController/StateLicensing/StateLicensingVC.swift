//
//  StateLicensingVC.swift
//  NCCAA
//
//  Created by Apple on 12/07/22.
//

import UIKit

class StateLicensingVC: UIViewController {
    
    // MARK: - Variable
    var selectedTextfield:UITextField?
    var myPickerView : UIPickerView!
    var picker:UIDatePicker?
    var arrVOC = ["State Medical Board" , "Employer" , "Personal Usage"]
    var arrVOCID = ["medical-board", "employer", "personal"]
    let arrState = ["AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
    
    // MARK: - IBOutlet
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtFname: UITextField!
    @IBOutlet weak var txtLname: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtDob: UITextField!
    @IBOutlet weak var txtVoc: UITextField!
    @IBOutlet weak var txtSpecialist: UITextField!
    @IBOutlet weak var txtBoardEmail: UITextField!
    @IBOutlet weak var txtBoardConfirmEmail: UITextField!
    @IBOutlet weak var txtEmpName: UITextField!
    @IBOutlet weak var txtEmpContact: UITextField!
    @IBOutlet weak var txtEmpEmail: UITextField!
    @IBOutlet weak var txtCAAEmail: UITextField!
    @IBOutlet weak var txtUserId: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        userAPI()
        setDatePicker()
    }
    
    
    // MARK: - Function
    
    func setupUI() {
        
        self.view.viewWithTag(101)?.isHidden = true
        self.view.viewWithTag(102)?.isHidden = true
        self.view.viewWithTag(103)?.isHidden = true
        self.view.viewWithTag(104)?.isHidden = true
        self.view.viewWithTag(105)?.isHidden = true
        self.view.viewWithTag(106)?.isHidden = true
        self.view.viewWithTag(107)?.isHidden = true
        self.view.viewWithTag(108)?.isHidden = true
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
    
    func pickUp(textField : UITextField){
        
        // UIPickerView
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.backgroundColor = UIColor.white
        textField.inputView = self.myPickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    @objc func doneClick() {
        selectedTextfield?.resignFirstResponder()
    }
    @objc func cancelClick() {
        selectedTextfield?.resignFirstResponder()
    }
    
    // MARK: - Webservice
    func stateLicensingAPI(params:[String:Any]) {
        
        Helper.shared.showHUD()
        
        let date = Helper.shared.changeStringDateFormat(date: txtDob.text!, toFormat: "yyyy-MM-dd", fromFormat: "MM/dd/yyyy")
        
        var param:[String:Any] = [:]
        param["firstName"] = txtFname.text!
        param["lastName"] = txtLname.text!
        param["email"] = txtEmail.text!
        param["dateOfBirth"] = date
        
        
        let parameters = param.merging(params) { $1 }
        
        print(parameters)

        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]

        NetworkManager.shared.webserviceCallStateLicensing(url: URLs.licensing, parameters: parameters, headers:headers) { (response) in

            //if response.ResponseCode == 200 {

            //print(response)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.navigationController?.popViewController(animated: true)
            }
            if let _  = response["receiptId"] {

                Toast.show(message: "Your message has been sent to NCCAA. Thank You", controller: self)
            } else {
                Toast.show(message: "This message could not be sent\nEither try again or send NCCAA an email shown below", controller: self)
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
    @IBAction func btnMoreInfo(_ sender: Any) {
        
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlainTextVC") as! PlainTextVC
        obj.strHeader = "CDQ Exam"
        navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnSubmit(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if txtFname.text == "" || txtLname.text == "" || txtEmail.text == "" || txtDob.text == "" || txtVoc.text == "" {
            Toast.show(message: Message.fillReqFields, controller: self)
            return
        }
        if !(txtEmail.text?.isValidEmail() ?? false) {
            
            Toast.show(message: Message.validEmail, controller: self)
            return
        }
        
        var params:[String:Any] = [:]
        
        if txtVoc.text == "State Medical Board" {
            
            if txtBoardEmail.text == "" || txtBoardConfirmEmail.text == "" || txtState.text == "" || txtSpecialist.text == "" {
                
                Toast.show(message: Message.fillReqFields, controller: self)
                return
            }
            if !(txtBoardEmail.text?.isValidEmail() ?? false) {
                
                Toast.show(message: Message.validEmail, controller: self)
                return
            }
            if txtBoardEmail.text != txtBoardConfirmEmail.text {
                
                Toast.show(message: Message.emailMismatch, controller: self)
                return
            }
            
            params["vocRecipient"] = "medical-board"
            params["recipientEmail"] = txtBoardEmail.text!
            params["credentialingSpecialist"] = txtSpecialist.text!
            params["state"] = txtState.text!
        }
        if txtVoc.text == "Employer" {
            
            if txtEmpName.text == "" || txtEmpEmail.text == "" || txtEmpContact.text == "" {
                
                Toast.show(message: Message.fillReqFields, controller: self)
                return
            }
            if !(txtEmpEmail.text?.isValidEmail() ?? false) {
                
                Toast.show(message: Message.validEmail, controller: self)
                return
            }
            params["vocRecipient"] = "employer"
            params["recipientEmail"] = txtEmpEmail.text!
            params["employerName"] = txtEmpName.text!
            params["employerContact"] = txtEmpContact.text!
        }
        if txtVoc.text == "Personal Usage" {
            if txtCAAEmail.text == "" {
                
                Toast.show(message: Message.fillReqFields, controller: self)
                return
            }
            if !(txtCAAEmail.text?.isValidEmail() ?? false) {
                
                Toast.show(message: Message.validEmail, controller: self)
                return
            }
            params["vocRecipient"] = "personal"
            params["recipientEmail"] = txtCAAEmail.text!
        }
        
        
        stateLicensingAPI(params: params)
    }
    @IBAction func btnLogout(_ sender: Any) {
        
        Helper.shared.logoutFromApp(vc: self)
    }
}
extension StateLicensingVC:UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if selectedTextfield == txtState {
            return arrState.count
        }
        return arrVOC.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectedTextfield == txtState {
            return arrState[row]
        }
        return arrVOC[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if selectedTextfield == txtState {
            
            selectedTextfield?.text = arrState[row]
        } else {
            selectedTextfield?.text = arrVOC[row]
            
            if row == 0 {
                self.view.viewWithTag(101)?.isHidden = false
                self.view.viewWithTag(102)?.isHidden = false
                self.view.viewWithTag(103)?.isHidden = false
                self.view.viewWithTag(104)?.isHidden = false
                self.view.viewWithTag(105)?.isHidden = true
                self.view.viewWithTag(106)?.isHidden = true
                self.view.viewWithTag(107)?.isHidden = true
                self.view.viewWithTag(108)?.isHidden = true
            } else if row == 1 {
                self.view.viewWithTag(101)?.isHidden = true
                self.view.viewWithTag(102)?.isHidden = true
                self.view.viewWithTag(103)?.isHidden = true
                self.view.viewWithTag(104)?.isHidden = true
                self.view.viewWithTag(105)?.isHidden = false
                self.view.viewWithTag(106)?.isHidden = false
                self.view.viewWithTag(107)?.isHidden = false
                self.view.viewWithTag(108)?.isHidden = true
            } else if row == 2 {
                self.view.viewWithTag(101)?.isHidden = true
                self.view.viewWithTag(102)?.isHidden = true
                self.view.viewWithTag(103)?.isHidden = true
                self.view.viewWithTag(104)?.isHidden = true
                self.view.viewWithTag(105)?.isHidden = true
                self.view.viewWithTag(106)?.isHidden = true
                self.view.viewWithTag(107)?.isHidden = true
                self.view.viewWithTag(108)?.isHidden = false
            }
        }
        
    }
    
}
extension StateLicensingVC:UITextFieldDelegate {
    
    //MARK:- TextFiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextfield = textField
        self.pickUp(textField: textField)
        
        self.myPickerView.selectRow(0, inComponent: 0, animated: true)
        self.pickerView(self.myPickerView, didSelectRow: 0, inComponent: 0)
    }
}
