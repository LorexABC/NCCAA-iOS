//
//  PasswordResetSuccessVC.swift
//  NCCAA
//
//  Created by Apple on 05/09/22.
//

import UIKit
import SkyFloatingLabelTextField

class PasswordResetSuccessVC: UIViewController {
    
    // MARK: - Variable
    
    // MARK: - IBOutlet
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    

    // MARK: - Function
    
    func setupUI() {
        
        
    }
    
    
    // MARK: - Webservice
    
    // MARK: - IBAction
    @IBAction func btnContinue(_ sender: Any) {
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
