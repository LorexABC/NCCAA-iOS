//
//  WebviewVC.swift
//  NCCAA
//
//  Created by Apple on 30/09/22.
//

import UIKit
import WebKit

class WebviewVC: UIViewController {
    
    // MARK: - Variable
    var strUrl = ""
    
    // MARK: - IBOutlet
    @IBOutlet weak var webview: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupUI()
        
    }
    
    
    // MARK: - Function
    
    func setupUI() {
        
        if strUrl == "" {
            
            return
        }
        webview.navigationDelegate = self
        
        let url = URL (string: strUrl)
        let requestObj = URLRequest(url: url!)
        webview.load(requestObj)
        
    }
    
    
    
    
    // MARK: - Webservice
    
    // MARK: - IBAction
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
extension WebviewVC:WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        Helper.shared.showHUD()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        Helper.shared.hideHUD()
    }
}
