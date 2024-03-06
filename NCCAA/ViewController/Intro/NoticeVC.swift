//
//  NoticeVC.swift
//  NCCAA
//
//  Created by Apple on 05/09/22.
//

import UIKit

class NoticeVC: UIViewController {
    
    @IBOutlet weak var txtview: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //setStatusBarStyle()
        //conditionTextView.scrollRangeToVisible(NSMakeRange(0, 0))
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        txtview.contentOffset = .zero
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
