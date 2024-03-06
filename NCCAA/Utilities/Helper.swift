//
//  Helper.swift
//  TheWord
//
//  Created by Apple on 19/02/22.
//

import UIKit
import SVProgressHUD

class Helper: NSObject {

    
    static let shared = Helper()
    
    var access_token = ""
    var userType = ""
    var userName = ""
    var isLocalAuthDone = false
    
    var dictBlog:BlogResponse? = nil
    
    func showHUD() {
        
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundLayerColor(UIColor.black.withAlphaComponent(0.5))
    }
    func hideHUD() {
        
        SVProgressHUD.dismiss()
    }
    
    func logoutFromApp(vc:UIViewController) {
        
        let alert = UIAlertController(title: "Are you sure you want to logout?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { action in
            
            UserDefaults.standard.set("", forKey: "access_token")
            UserDefaults.standard.set(false, forKey: "isLogin")
            UserDefaults.standard.synchronize()
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                let obj = UIStoryboard(name: "IntroiPad", bundle: nil).instantiateViewController(withIdentifier: "navIntroiPad") as! UINavigationController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = obj
            } else {
                let obj = UIStoryboard(name: "Intro", bundle: nil).instantiateViewController(withIdentifier: "navIntro") as! UINavigationController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = obj
            }
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        vc.present(alert, animated: true, completion: nil)
    }
    
    func getMonthFromNumber(month:String) -> String {
        
        let monthNumber = Int(month)!
        let fmt = DateFormatter()
        fmt.dateFormat = "MM"
        return fmt.monthSymbols[monthNumber - 1]
    }
    
    func changeStringDateFormat(date:String, toFormat:String, fromFormat:String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = toFormat
        let resultString = dateFormatter.string(from: date!)
        return resultString
    }
}
