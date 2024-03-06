//
//  LoginVC.swift
//  NCCAA
//
//  Created by Apple on 05/09/22.
//

import UIKit
import SkyFloatingLabelTextField

class LoginVC: UIViewController {
    
    // MARK: - Variable
    var isShowPassword = false
    
    // MARK: - IBOutlet
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    

    // MARK: - Function
    
    func setupUI() {
        
        
        
        txtPassword.isSecureTextEntry = true
    }
    
    // MARK: - Webservice
    func loginAPI() {
        
        //Helper.shared.showHUD()
        
        let params = ["username":txtEmail.text!,
                      "password": txtPassword.text!,
                      "client_id": "nccaa",
                      "grant_type": "password"]
        
        let headers = ["Accept":"application/json"]
        
        NetworkManager.shared.webserviceCallLogin(url: URLs.login, parameters: params, headers:headers) { (response) in
            
            if let err = response.error {
                
                Toast.show(message: err , controller: self)
            } else {
                Helper.shared.access_token = response.access_token ?? ""
                
                UserDefaults.standard.set(response.access_token ?? "", forKey: "access_token")
                UserDefaults.standard.set(true, forKey: "isLogin")
                UserDefaults.standard.synchronize()
                
                self.personalUserAPI()
                
            }
            
            
//            if response.ResponseCode == 200 {
//
//                //print(response)
//
//                let dict = response.access_token
//
//
//            } else {
//                Toast.show(message: response.ResponseMsg ?? "", controller: self)
//            }
            //Helper.shared.hideHUD()
        }
    }
    
    func userInfoAPI(universityId:Int) {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallPersonalUser(url: URLs.user_info, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            Helper.shared.userType = response.status!
            Helper.shared.userName = response.firstName!
            
            if response.isAppLocked == "1" {
                //
                UserDefaults.standard.set("", forKey: "access_token")
                UserDefaults.standard.set(false, forKey: "isLogin")
                UserDefaults.standard.synchronize()
                
                //
                let alert = UIAlertController(title: "", message: "We are sorry. Both the website and app are under going maintenance. Check back soon. Thanks you!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if response.psiFilled == true {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    
                    let obj = UIStoryboard(name: "MainiPad", bundle: nil).instantiateViewController(withIdentifier: "navAnnouncement") as! UINavigationController
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate

                    // If this scene's self.window is nil then set a new UIWindow object to it.
                    appDelegate.window = appDelegate.window ?? UIWindow()
                    
                    // Set this scene's window's background color.
                    appDelegate.window!.backgroundColor = UIColor.red
                    
                    // Create a ViewController object and set it as the scene's window's root view controller.
                    appDelegate.window!.rootViewController = obj
                    
                    // Make this scene's window be visible.
                    appDelegate.window!.makeKeyAndVisible()
                    
                } else {
                    let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    self.navigationController?.pushViewController(obj, animated: true)
                }
            } else {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "PsiMandotryDataVC") as! PsiMandotryDataVC
                obj.dict = ["graduationDate":response.graduationDate ?? "",
                            "universityId":universityId]
                self.navigationController?.pushViewController(obj, animated: true)
            }
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    func personalUserAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallPersonalUser(url: URLs.personal, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            self.userInfoAPI(universityId:response.universityId ?? 0)
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    // MARK: - IBAction
    @IBAction func btnLogin(_ sender: Any) {
        
        if txtEmail.text == "" || txtPassword.text == "" {
            
            return
        }
        
        loginAPI()
    }
    
    @IBAction func btnHideShowPassword(_ sender: Any) {
        isShowPassword = !isShowPassword
        
        if isShowPassword {
            txtPassword.isSecureTextEntry = false
            btnEye.setImage(UIImage(named: "visible"), for: .normal)
        } else {
            txtPassword.isSecureTextEntry = true
            btnEye.setImage(UIImage(named: "invisible"), for: .normal)
        }
        
    }

    @IBAction func btnForgotPassword(_ sender: Any) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnNotice(_ sender: Any) {
        self.performSegue(withIdentifier: "segueNotice", sender: self)
    }
    @IBAction func btnPrivacy(_ sender: Any) {
        self.performSegue(withIdentifier: "seguePrivacy", sender: self)
    }
    @IBAction func btnCondition(_ sender: Any) {
        self.performSegue(withIdentifier: "segueCondition", sender: self)
    }
    
    @IBAction func unwindToLoginVC(segue: UIStoryboardSegue) {
    }
}
