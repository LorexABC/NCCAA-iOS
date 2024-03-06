//
//  EmailConfirmationVC.swift
//  NCCAA
//
//  Created by Apple on 05/09/22.
//

import UIKit
import SkyFloatingLabelTextField

class EmailConfirmationVC: UIViewController {
    
    // MARK: - Variable
    var isEmail = true
    var params:[String:String]?
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    

    // MARK: - Function
    
    func setupUI() {
        
        if isEmail {
            
            lblTitle.text = "Check your email"
            lblSubtitle.attributedText = NSMutableAttributedString(string:"\("We have sent a password recovery instruction to your email.")")
        } else {
            lblTitle.text = "Check your phone"
            lblSubtitle.attributedText = NSMutableAttributedString(string:"\("We have sent a password recovery instruction to your phone number.")")
        }
    }
    
    
    // MARK: - Webservice
    
    // MARK: - IBAction
    @IBAction func btnContinue(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "OtpVerificationVC") as! OtpVerificationVC
        obj.params = params
        navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
