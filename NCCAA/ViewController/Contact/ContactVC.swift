//
//  ContactVC.swift
//  NCCAA
//
//  Created by Apple on 19/07/22.
//

import UIKit
import MessageUI

class ContactVC: UIViewController {
    
    // MARK: - Variable
    var email = ""
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var lblDesignation: UILabel!
    @IBOutlet weak var lblAddress2: UILabel!
    @IBOutlet weak var lblAddress1: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var txtview: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getContactInfoAPI()
    }
    

    // MARK: - Function
    
    
    
    // MARK: - Webservice
    func getContactInfoAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallCommonGetMethod(url: URLs.get_contact_info, headers:headers) { (response) in
            
        
            if let err = response["error"] {
                
                Toast.show(message: err as? String ?? "", controller: self)
            } else {
                
                if let name1 = (response["person"] as? [String])?[0] {
                    self.lblName.text = name1
                }
                if let name2 = (response["person"] as? [String])?[1] {
                    self.lblDesignation.text = name2
                }
                if let name3 = (response["person"] as? [String])?[2] {
                    self.lblAddress1.text = name3
                }
                if let name4 = (response["person"] as? [String])?[3] {
                    self.lblAddress2.text = name4
                }
                
                self.lblPhone.text = response["phone"] as? String
                self.email = response["email"] as? String ?? ""
            }
            
            
            Helper.shared.hideHUD()
        }
    }
    func contactUsAPI() {
        
        Helper.shared.showHUD()
        
        let params:[String:String] = ["question":txtview.text]
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallContactUs(url: URLs.contact_us, parameters: params, headers:headers) { (response) in
            
            if response["status"] as? String == "success" {
                self.txtview.text = ""
                Toast.show(message: "Success", controller: self)
            }
            if let err = response["error"] {
                
                Toast.show(message: err as? String ?? "", controller: self)
            }
                
            Helper.shared.hideHUD()
        }
    }
    
    // MARK: - IBAction
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnEmail(_ sender: Any) {
        
        if email == "" {
            Toast.show(message: "Email is not available!", controller: self)
            return
        }
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
        let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self

            // Configure the fields of the interface.
            composeVC.setToRecipients([email])
            composeVC.setSubject("")
            composeVC.setMessageBody("", isHTML: false)

            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
    }
    
    @IBAction func btnSend(_ sender: Any) {
        
        if txtview.text == "" {
            return
        }
        contactUsAPI()
    }
    @IBAction func btnLogout(_ sender: Any) {
        
        Helper.shared.logoutFromApp(vc: self)
    }
}

extension ContactVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        self.dismiss(animated: true, completion: nil)
    }
    
}
