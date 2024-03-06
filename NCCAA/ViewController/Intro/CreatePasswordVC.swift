//
//  CreatePasswordVC.swift
//  NCCAA
//
//  Created by Apple on 05/09/22.
//

import UIKit
import SkyFloatingLabelTextField

class CreatePasswordVC: UIViewController {
    
    // MARK: - Variable
    var isShowPassword = false
    var params:[String:String]?
    
    // MARK: - IBOutlet
    @IBOutlet weak var txtNewPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtConfPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var btnEye: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    

    // MARK: - Function
    
    func setupUI() {
        
        txtNewPassword.isSecureTextEntry = true
        txtConfPassword.isSecureTextEntry = true
    }
    
    
    // MARK: - Webservice
    func changePasswordAPI() {
        
        Helper.shared.showHUD()

        let headers = ["Accept":"application/json",
                       "Content-Type":"application/x-www-form-urlencoded"]

        NetworkManager.shared.webserviceCallCommonPostMethod(url: URLs.otp_change_password, parameters: params!, headers:headers) { (response) in

            //if response.ResponseCode == 200 {

            //print(response)

            if response["status"] as? Bool == true {
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "PasswordResetSuccessVC") as! PasswordResetSuccessVC
                self.navigationController?.pushViewController(obj, animated: true)
                
            }
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    
    // MARK: - IBAction
    @IBAction func btnCreatePassword(_ sender: Any) {
        
        if txtNewPassword.text == "" || txtConfPassword.text == "" {
            return
        }
        if txtNewPassword.text != txtConfPassword.text {
            Toast.show(message: Message.passwordMismatch, controller: self)
            return
        }
        params?["password"] = txtNewPassword.text
        changePasswordAPI()
        
    }
    
    @IBAction func btnHideShowPassword(_ sender: Any) {
        
        isShowPassword = !isShowPassword
        
        if isShowPassword {
            txtNewPassword.isSecureTextEntry = false
            txtConfPassword.isSecureTextEntry = false
            //btnEye.setTitleColor(Color.ThemeColor, for: .normal)
            btnEye.setImage(UIImage(named: "visible"), for: .normal)
        } else {
            txtNewPassword.isSecureTextEntry = true
            txtConfPassword.isSecureTextEntry = true
            //btnEye.setTitleColor(Color.grayDefault, for: .normal)
            btnEye.setImage(UIImage(named: "invisible"), for: .normal)
            
        }
    }
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
