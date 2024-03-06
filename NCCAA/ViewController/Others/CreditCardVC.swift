//
//  CreditCardVC.swift
//  NCCAA
//
//  Created by Apple on 21/07/22.
//

import UIKit

class CreditCardVC: UIViewController {
    
    // MARK: - Variable
    var intReceiptId:Int?
    var isFromVC = "CDQExam"
    var picker:UIDatePicker?
    
    // MARK: - IBOutlet
    @IBOutlet weak var txtSecurityCode: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtExp: UITextField!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var btnPay: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getReceiptsAPI()
        //setDatePicker()
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
        txtExp.inputView = picker
        picker?.backgroundColor = UIColor.white
        picker?.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        picker?.datePickerMode = .date
        picker?.minimumDate = Date()
        
        //Write toolbar code for done button
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onClickDoneButton))
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        txtExp.inputAccessoryView = toolBar
    }
    @objc func onClickDoneButton() {
        self.view.endEditing(true)
    }
    @objc func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let strDate = dateFormatter.string(from: picker!.date)
        txtExp?.text = strDate
    }
    
    
    // MARK: - Webservice
    func getReceiptsAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallCommonGetMethod(url: "\(URLs.receipts)\(intReceiptId!)", headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            if let _ = response["status"] {
                
                Toast.show(message: response["message"] as! String, controller: self)
            } else {
                
                self.lblAmount.text = "\(response["dueAmount"] ?? 0)".currencyFormatting()
                self.btnPay.setTitle("Pay \(self.lblAmount.text ?? "")", for: .normal)
            }
            
            
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    func paymentAPI() {
        
        Helper.shared.showHUD()
        
        let date = Helper.shared.changeStringDateFormat(date: txtExp.text!, toFormat: "yy-MM", fromFormat: "MM/yy")
        

        let params = [
            "name": txtName.text!,
            "cardNumber": (txtNumber.text!).replacingOccurrences(of: " ", with: ""),
            "expireDate": date,
            "securityCode": txtSecurityCode.text!,
            "zipCode": txtZip.text!] as [String : Any]
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]

        NetworkManager.shared.webserviceCallPayment(url: "\(URLs.receipts)\(intReceiptId!)/payment", parameters: params, headers:headers) { (response) in

            //if response.ResponseCode == 200 {

            //print(response)
            
            if let err = response["error"] {
                
                Toast.show(message: err as? String ?? "", controller: self)
            } else {
                Toast.show(message: "success", controller: self)
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "ReceiptVC") as! ReceiptVC
                obj.intReceiptId = self.intReceiptId
                obj.isFromVC = self.isFromVC
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
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnPay(_ sender: Any) {
        
        if txtNumber.text == "" || txtName.text == "" || txtExp.text == "" || txtSecurityCode.text == "" || txtZip.text == "" {
            Toast.show(message: Message.fillReqFields, controller: self)
            return
        }
        
        paymentAPI()
    }
}
extension CreditCardVC:UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtNumber
        {
            guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
            
            if currentText.count<20 {
                textField.text = currentText.grouping(every: 4, with: " ")
                return false
            } else {
                return false
            }
            
        }
        
        if textField == txtSecurityCode {
            let maxLength = 4
                let currentString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)

                return newString.count <= maxLength
        }
        if textField == txtExp {
            
            if range.length > 0 {
                  return true
                }
                if string == "" {
                  return false
                }
                if range.location > 4 {
                  return false
                }
                var originalText = textField.text
                let replacementText = string.replacingOccurrences(of: " ", with: "")

                //Verify entered text is a numeric value
                if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: replacementText)) {
                  return false
                }

                //Put / after 2 digit
                if range.location == 2 {
                  originalText?.append("/")
                  textField.text = originalText
                }
                return true
        }
        return true
    }
    
}
