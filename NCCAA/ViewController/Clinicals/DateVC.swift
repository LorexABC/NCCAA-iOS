//
//  DateVC.swift
//  NCCAA
//
//  Created by Apple on 07/09/22.
//

import UIKit

class DateVC: UIViewController {
    
    // MARK: - Variable
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
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

    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePickerAction(_ sender: Any) {
        
    }
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        
    }
}

