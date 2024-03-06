//
//  CreditCardPadVC.swift
//  NCCAA
//
//  Created by Apple on 21/07/22.
//

import UIKit

class CreditCardPadVC: UIViewController {
    
    // MARK: - Variable
    var isFromVC = "CDQExam"
    var intReceiptId:Int?
    var picker:UIDatePicker?
    let arrMenu = ["Announcements","Important Info/Dates","Student Clinical Competencies","Certification Exam","State Licensing Info","View CAA Certificate","CDQ Exam","CME Submissions","Blog","History","Edit Profile","Contact NCCAA"]

    
    let arrMenuIcons = ["Doorbell","Calendar","Upload to Cloud","Document","Rubber Stamp yellow","Diploma","Document_blue","Upload","News","Clock","Settings","Customer Support"]
    // MARK: - IBOutlet
    @IBOutlet weak var tableMenu: UITableView!
    @IBOutlet weak var txtSecurityCode: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtExp: UITextField!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getReceiptsAPI()
        //setDatePicker()
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
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "ReceiptPadVC") as! ReceiptPadVC
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
    @IBAction func btnPay(_ sender: Any) {
        
        if txtNumber.text == "" || txtName.text == "" || txtExp.text == "" || txtSecurityCode.text == "" || txtZip.text == "" {
            Toast.show(message: Message.fillReqFields, controller: self)
            return
        }
        
        paymentAPI()
    }
    @IBAction func btnNotification(_ sender: Any) {
        
        let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
        let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navAnnouncement") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = obj
    }

}
extension CreditCardPadVC:UITableViewDataSource, UITableViewDelegate {
    
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
extension CreditCardPadVC:UITextFieldDelegate {
    
    
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
        
        //////////////////
        
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
    
    func expDateValidation(dateStr:String) {
        
        let currentYear = Calendar.current.component(.year, from: Date()) % 100   // This will give you current year (i.e. if 2019 then it will be 19)
        let currentMonth = Calendar.current.component(.month, from: Date()) // This will give you current month (i.e if June then it will be 6)
        
        let enteredYear = Int(dateStr.suffix(2)) ?? 0 // get last two digit from entered string as year
        let enteredMonth = Int(dateStr.prefix(2)) ?? 0 // get first two digit from entered string as month
        print(dateStr) // This is MM/YY Entered by user
        
        if enteredYear > currentYear {
            if (1 ... 12).contains(enteredMonth) {
                print("Entered Date Is Right")
            } else {
                print("Entered Date Is Wrong")
            }
        } else if currentYear == enteredYear {
            if enteredMonth >= currentMonth {
                if (1 ... 12).contains(enteredMonth) {
                    print("Entered Date Is Right")
                } else {
                    print("Entered Date Is Wrong")
                }
            } else {
                print("Entered Date Is Wrong")
            }
        } else {
            print("Entered Date Is Wrong")
        }
        
    }
}
