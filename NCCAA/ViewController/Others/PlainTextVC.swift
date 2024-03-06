//
//  PlainTextVC.swift
//  NCCAA
//
//  Created by Apple on 21/10/22.
//

import UIKit

class PlainTextVC: UIViewController {

    var strHeader = ""
    
    @IBOutlet weak var lblTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblTitle.text = strHeader
    }
    

    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
