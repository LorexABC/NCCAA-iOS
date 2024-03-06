//
//  BlogDetailsVC.swift
//  NCCAA
//
//  Created by Apple on 22/07/22.
//

import UIKit
import WebKit

class BlogDetailsVC: UIViewController, WKNavigationDelegate {
    
    // MARK: - Variable
    var dict:BlogResponse? = nil
    
    // MARK: - IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupUI()
        
    }
    
    
    // MARK: - Function
    
    func setupUI() {
        
        webview.navigationDelegate = self
        
        let htmlStart = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"><style>img {max-width:100%;}</style></HEAD><BODY>"
        let htmlEnd = "</BODY></HTML>"
        let htmlString = "\(htmlStart)\(dict?.htmlContent ?? "")\(htmlEnd)"
        
        webview.loadHTMLString(htmlString, baseURL: nil)
        
        lblDate.text = dict?.date
        lblTitle.text = dict?.subject
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        //webView.scrollView.isScrollEnabled = false
        webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
            
            if height != nil {
                self.heightConstraint?.constant = height as! CGFloat
            }
            
        })
        
    }
    //Open Tapped Link in Safari
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            if let url = navigationAction.request.url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        // Call this completion handler compulsary
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    // MARK: - Webservice
    
    // MARK: - IBAction
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
