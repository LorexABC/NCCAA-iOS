//
//  PersonalInformationVC.swift
//  NCCAA
//
//  Created by Apple on 05/09/22.
//

import UIKit
import SkyFloatingLabelTextField

class PersonalInformationVC: UIViewController {
    
    // MARK: - Variable
    var dict:[String:Any]?
    let arrGender = ["Male","Female"]
    var picker:UIDatePicker?
    var selectedTextfield:UITextField?
    var myPickerView : UIPickerView!
    
    // MARK: - IBOutlet
    @IBOutlet weak var txtMiddleName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFname: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLname: SkyFloatingLabelTextField!
    @IBOutlet weak var txtDob: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPhone: SkyFloatingLabelTextField!
    @IBOutlet weak var txtGender: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setDatePicker()
    }
    

    // MARK: - Function
    
    func setupUI() {
        
        
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
    
    // MARK: - IBAction
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinue(_ sender: Any) {
        
        if txtFname.text == "" || txtLname.text == "" || txtGender.text == "" || txtDob.text == "" || txtPhone.text == "" {
            
            Toast.show(message: Message.fillReqFields, controller: self)
            return
        }
//        if !(txtPhone.text?.isValidContact() ?? false) {
//            
//            Toast.show(message: Message.validPhone, controller: self)
//            return
//        }
        
        if txtPhone.text?.isStringContainsAlphabets() ?? true {
            
            Toast.show(message: Message.validPhone, controller: self)
            return
        }
        
        let date = Helper.shared.changeStringDateFormat(date: txtDob.text!, toFormat: "yyyy-MM-dd", fromFormat: "MM/dd/yyyy")
        
        dict?["firstName"] = txtFname.text
        dict?["middleName"] = txtMiddleName.text ?? ""
        dict?["lastName"] = txtLname.text
        dict?["dateOfBirth"] = date
        dict?["phone"] = txtPhone.text
        
        if txtGender.text == "Male" {
            dict?["gender"] = "male"
        } else {
            dict?["gender"] = "female"
        }
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "AddressVC") as! AddressVC
        obj.dict = dict
        navigationController?.pushViewController(obj, animated: false)
    }
}
extension PersonalInformationVC:UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        if selectedTextfield == txtGender {
            
            return arrGender.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if selectedTextfield == txtGender {
            
           return arrGender[row]
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if selectedTextfield == txtGender {
            
            selectedTextfield?.text = arrGender[row]
        }
        
    }
    
}
extension PersonalInformationVC:UITextFieldDelegate {
    
    //MARK:- TextFiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextfield = textField
        
        self.pickUp(textField: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
