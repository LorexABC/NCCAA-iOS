//
//  CaaInfoVC.swift
//  NCCAA
//
//  Created by Apple on 05/09/22.
//

import UIKit
import SkyFloatingLabelTextField

class CaaInfoVC: UIViewController {
    
    // MARK: - Variable
    var dict:[String:Any]?
    var arrUniversities:[EditProfileFieldsResponse]?
    var arrYear = ["2018","2019","2020","2021","2022"]
    var intUniversityId = 0
    var selectedTextfield:UITextField?
    var myPickerView : UIPickerView!
    
    // MARK: - IBOutlet
    @IBOutlet weak var txtYearGraduate: SkyFloatingLabelTextField!
    @IBOutlet weak var txtSchool: SkyFloatingLabelTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        getUniversitiesAPI()
    }
    

    // MARK: - Function
    
    func setupUI() {
        
        if (dict?["graduationDate"] as? String) == "" {
            txtYearGraduate.text = ""
        } else {
            
            let arr = (dict?["graduationDate"] as? String)?.components(separatedBy: "-")
            txtYearGraduate.text = arr?[0]
        }
        
        if Helper.shared.userType == "student" {
            
            txtSchool.isUserInteractionEnabled = false
            txtYearGraduate.isUserInteractionEnabled = false
        }
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
    func getUniversitiesAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallEditProfileFields(url: URLs.universities, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            self.arrUniversities = response
            
            if (self.dict?["universityId"] as? Int) == 0 {
                self.txtSchool.text = ""
            } else {
                
                if let index = self.arrUniversities?.firstIndex(where: { $0.id == (self.dict?["universityId"] as? Int) }) {
                    
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

        let params = [
            "firstName": dict?["firstName"] as! String,
            "middleName": dict?["middleName"] as! String,
            "lastName": dict?["lastName"] as! String,
            "gender": dict?["gender"] as! String,
            "dateOfBirth": dict?["dateOfBirth"] as! String,
            "phone": dict?["phone"] as! String,
            "address": dict?["address"] as! String,
            "city": dict?["city"] as! String,
            "state": dict?["state"] as! String,
            "country": dict?["country"] as! String,
            "zipCode": dict?["zipCode"] as! String,
            "graduationYear": Int(txtYearGraduate.text ?? "")!,
            "universityId": intUniversityId] as [String : Any]
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]

        NetworkManager.shared.webserviceCallFillPSI(url: URLs.psi_fill, parameters: params, headers:headers) { (response) in

            //if response.ResponseCode == 200 {

            //print(response)
            
            if let err = response["error"] {
                
                Toast.show(message: err as? String ?? "", controller: self)
            } else {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "PSIMandatoryDataNextVC") as! PSIMandatoryDataNextVC
                self.navigationController?.pushViewController(obj, animated: true)
            }

            
            
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    
    // MARK: - IBAction
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnContinue(_ sender: Any) {
        
        if txtSchool.text == "" || txtYearGraduate.text == "" {
            Toast.show(message: Message.fillReqFields, controller: self)
            return
        }
        psiFillAPI()
        
    }
}
extension CaaInfoVC:UIPickerViewDataSource, UIPickerViewDelegate {
    
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
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if selectedTextfield == txtYearGraduate {
            
           return arrYear[row]
        }
        if selectedTextfield == txtSchool {
            
            return arrUniversities?[row].name
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
    }
    
}
extension CaaInfoVC:UITextFieldDelegate {
    
    //MARK:- TextFiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextfield = textField
        
        self.pickUp(textField: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
