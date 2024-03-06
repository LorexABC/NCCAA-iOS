//
//  SplashVC.swift
//  NCCAA
//
//  Created by Apple on 05/09/22.
//

import UIKit
import LocalAuthentication

class SplashVC: UIViewController {

    // MARK: - Variable
    
    
    // MARK: - IBOutlet
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        if Helper.shared.isLocalAuthDone == false {
            //authenticationWithTouchID()
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            if UserDefaults.standard.value(forKey: "isLogin") != nil && UserDefaults.standard.value(forKey: "isLogin") as! Bool == true {
                
                Helper.shared.access_token = (UserDefaults.standard.value(forKey: "access_token") as? String)!
                
                self.personalUserAPI()
            } else {
                self.navigateToLoginScreen()
            }
        }
    }

    // MARK: - Function
    
    func setupUI() {
        
        
    }
    
    func navigateToLoginScreen() {
        
        self.performSegue(withIdentifier: "segueloginScreen", sender: nil)
    }
    
    
    // MARK: - Webservice
    func userInfoAPI(universityId:Int) {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallPersonalUser(url: URLs.user_info, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            Helper.shared.userType = response.status!
            Helper.shared.userName = response.firstName!
            
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

}
extension SplashVC {
    
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"

        var authError: NSError?
        let reasonString = "To access the secure data"

        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    
                    //TODO: User authenticated successfully, take appropriate action
                    print("Success")
                    Helper.shared.isLocalAuthDone = true
                } else {
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    guard let error = evaluateError else {
                        return
                    }
                    
                    print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                    
                    //close app
                    DispatchQueue.main.async {
                        
                        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
                        //Comment if you want to minimise app
                        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (timer) in
                            exit(0)
                        }
                    }
                    
                    
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                }
            }
        } else {
            
            guard let error = authError else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
        }
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
                case LAError.biometryNotAvailable.rawValue:
                    message = "Authentication could not start because the device does not support biometric authentication."
                
                case LAError.biometryLockout.rawValue:
                    message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
                case LAError.biometryNotEnrolled.rawValue:
                    message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
                default:
                    message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
                case LAError.touchIDLockout.rawValue:
                    message = "Too many failed attempts."
                
                case LAError.touchIDNotAvailable.rawValue:
                    message = "TouchID is not available on the device"
                
                case LAError.touchIDNotEnrolled.rawValue:
                    message = "TouchID is not enrolled on the device"
                
                default:
                    message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"

        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
}
