//
//  PSIMandatoryDataNextVC.swift
//  NCCAA
//
//  Created by Apple on 05/09/22.
//

import UIKit

class PSIMandatoryDataNextVC: UIViewController {
    
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
            navigationController?.pushViewController(obj, animated: true)
        }
       
    }
    
}
