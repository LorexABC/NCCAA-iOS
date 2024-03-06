//
//  ForgotPasswordVC.swift
//  NCCAA
//
//  Created by Apple on 05/09/22.
//

import UIKit
import SkyFloatingLabelTextField

class ForgotPasswordVC: UIViewController {
    
    // MARK: - Variable
    var isEmail = true
    @IBOutlet weak var lblTop: UILabel!
    
    // MARK: - IBOutlet
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtviewBottom: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    

    // MARK: - Function
    
    func setupUI() {
        
        
    }
    
    
    // MARK: - Webservice
    func forgotPasswordAPI(params:[String:String]) {
        
        Helper.shared.showHUD()

        let headers = ["Accept":"application/json",
                       "Content-Type":"application/x-www-form-urlencoded"]

        NetworkManager.shared.webserviceCallCommonPostMethod(url: URLs.forgot_password, parameters: params, headers:headers) { (response) in

            //if response.ResponseCode == 200 {

            //print(response)


            if response["status"] as? Bool == true {
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "EmailConfirmationVC") as! EmailConfirmationVC
                obj.isEmail = self.isEmail
                obj.params = params
                self.navigationController?.pushViewController(obj, animated: true)
            } else {
                Toast.show(message: response["message"] as! String, controller: self)
            }
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    
    // MARK: - IBAction
    @IBAction func btnRecoverWithPhone(_ sender: UIButton) {
        
        if sender.tag == 0 {
            sender.setTitle("Recover with email instead", for: .normal)
            txtEmail.text = nil
            txtEmail.placeholder = "Phone"
            txtEmail.selectedTitle = "Phone"
            sender.tag = 1
            isEmail = false
            lblTop.attributedText = NSMutableAttributedString(string:"\("Enter your registered phone number below to receive password reset instruction.")")
            txtviewBottom.text = "Note: To initiate a password reset, users can enter the phone number associated with their Edit Profile in the member area. Our system will then send a password reset code to the email address linked to their account."
        } else {
            sender.setTitle("Recover with phone number instead", for: .normal)
            txtEmail.text = nil
            txtEmail.placeholder = "Email"
            txtEmail.selectedTitle = "Email"
            sender.tag = 0
            isEmail = true
            lblTop.attributedText = NSMutableAttributedString(string:"\("Enter your registered email below to receive password reset instruction.")")
            txtviewBottom.text = "Note: Some email servers may not forward our password reset code email. The email we send should appear as follows:\n\nSubject: Password Reset Code\n\nHello,\nYou have requested a password reset from NCCAA. Please use the following code to reset your password:\n\nCode:     _ _ _ _\n\nThank you,\nNCCAA"
        }
        
    }
    @IBAction func btnContinue(_ sender: Any) {
        
        if txtEmail.text == "" {
            return
        }
        if isEmail {
            
            if !(txtEmail.text?.isValidEmail() ?? false) {
                
                Toast.show(message: Message.validEmail, controller: self)
                return
            }
            
            let params = ["email":txtEmail.text!]
            
            forgotPasswordAPI(params: params)
        } else {
            
            let newString = txtEmail.text?.replacingOccurrences(of: "-", with: "")
            
//            if !(newString?.isValidContact() ?? false) {
//
//                Toast.show(message: Message.validPhone, controller: self)
//                return
//            }
            if newString?.isStringContainsAlphabets() ?? true {
                
                Toast.show(message: Message.validPhone, controller: self)
                return
            }
            let params = ["mobile":newString!]
            
            forgotPasswordAPI(params: params)
        }
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
