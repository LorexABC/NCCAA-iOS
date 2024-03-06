//
//  PsiMandotryDataVC.swift
//  NCCAA
//
//  Created by Apple on 05/09/22.
//

import UIKit

class PsiMandotryDataVC: UIViewController {
    
    // MARK: - Variable
    var dict:[String:Any]?
    
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
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "PersonalInformationVC") as! PersonalInformationVC
        obj.dict = dict
        navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
