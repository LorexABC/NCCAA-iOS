//
//  OtpVerificationVC.swift
//  NCCAA
//
//  Created by Apple on 05/09/22.
//

import UIKit
import SkyFloatingLabelTextField

class OtpVerificationVC: UIViewController {
    
    // MARK: - Variable
    var params:[String:String]?
    var count = 30
    var timer:Timer!
    
    // MARK: - IBOutlet
    @IBOutlet weak var txtFirst: UITextField!
    @IBOutlet weak var txtSecond: UITextField!
    @IBOutlet weak var txtThird: UITextField!
    @IBOutlet weak var txtFourth: UITextField!
    @IBOutlet weak var txtFifth: UITextField!
    @IBOutlet weak var txtSixth: UITextField!
    @IBOutlet weak var btnRequestNewCode: UIButton!
    @IBOutlet weak var lblResendCode: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    

    // MARK: - Function
    
    func setupUI() {
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        lblResendCode.isHidden = false
        
        txtFirst.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtSecond.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtThird.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtFourth.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtFifth.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtSixth.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func update() {
        print(count)
        if(count > 1) {
            count -= 1
            lblResendCode.text = "Request a new code in \(count)s..."
        } else {
            lblResendCode.text = "Request a new code in 30s..."
            timer.invalidate()
            timer = nil
            btnRequestNewCode.isHidden = false
            lblResendCode.isHidden = true
        }
    }
    // MARK: - Webservice
    func resendOtpAPI() {
        
        Helper.shared.showHUD()

        let headers = ["Accept":"application/json",
                       "Content-Type":"application/x-www-form-urlencoded"]

        NetworkManager.shared.webserviceCallCommonPostMethod(url: URLs.otp_resend, parameters: params!, headers:headers) { (response) in

            //if response.ResponseCode == 200 {

            //print(response)

            if response["status"] as? Bool == true {
                
                Toast.show(message: response["message"] as! String, controller: self)
                
            } else {
                Toast.show(message: response["message"] as! String, controller: self)
            }
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    func forgotPasswordAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Content-Type":"application/x-www-form-urlencoded"]

        NetworkManager.shared.webserviceCallCommonPostMethod(url: URLs.forgot_password, parameters: params!, headers:headers) { (response) in

            //if response.ResponseCode == 200 {

            //print(response)


            if response["status"] as? Bool == true {
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "CreatePasswordVC") as! CreatePasswordVC
                obj.params = self.params
                self.navigationController?.pushViewController(obj, animated: true)
            } else {
                Toast.show(message: "Otp doesn't match", controller: self)
            }
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    
    // MARK: - IBAction
    @IBAction func btnResend(_ sender: Any) {
        
        btnRequestNewCode.isHidden = true
        lblResendCode.isHidden = false
        count = 30
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        resendOtpAPI()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
extension OtpVerificationVC:UITextFieldDelegate {
    
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case txtFirst:
                txtSecond.becomeFirstResponder()
            case txtSecond:
                txtThird.becomeFirstResponder()
            case txtThird:
                txtFourth.becomeFirstResponder()
            case txtFourth:
                txtFifth.becomeFirstResponder()
            case txtFifth:
                txtSixth.becomeFirstResponder()
            case txtSixth:
                txtSixth.resignFirstResponder()
                
                if txtFirst.text != "" && txtSecond.text != "" && txtThird.text != "" && txtFourth.text != "" && txtFifth.text != "" && txtSixth.text != "" {
                    
                    if self.timer != nil {
                        self.timer.invalidate()
                        self.timer = nil
                    }
                    
                    
                    let enteredOtp = "\(txtFirst.text ?? "")\(txtSecond.text ?? "")\(txtThird.text ?? "")\(txtFourth.text ?? "")\(txtFifth.text ?? "")\(txtSixth.text ?? "")"
                    
                    params?["token"] = enteredOtp
                    forgotPasswordAPI()
                }
                
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case txtFirst:
                txtFirst.becomeFirstResponder()
            case txtSecond:
                txtFirst.becomeFirstResponder()
            case txtThird:
                txtSecond.becomeFirstResponder()
            case txtFourth:
                txtThird.becomeFirstResponder()
            case txtFifth:
                txtFourth.becomeFirstResponder()
            case txtSixth:
                txtFifth.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    

}

