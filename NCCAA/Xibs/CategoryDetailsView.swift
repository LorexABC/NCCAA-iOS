//
//  CategoryDetailsView.swift
//  NCCAA
//
//  Created by Apple on 21/03/23.
//

import UIKit
import WebKit

class CategoryDetailsView: UIView, WKNavigationDelegate {

    var htmlText = ""
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightBgView: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
    }
    
    func setContentInWebview() {
        
        webview.navigationDelegate = self
        
        let htmlStart = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"></HEAD><BODY>"
        let htmlEnd = "</BODY></HTML>"
        let htmlString = "\(htmlStart)\(htmlText)\(htmlEnd)"
        
        webview.loadHTMLString(htmlString, baseURL: nil)
        
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        //webView.scrollView.isScrollEnabled = false
        webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
            self.heightConstraint?.constant = height as! CGFloat
            
            //
            
            if self.heightConstraint?.constant ?? 0 < 300 {
                self.heightBgView.constant = (self.heightConstraint?.constant ?? 0) + 90
            } else {
                self.heightBgView.constant = 300 + 90
            }
            
        })
        
        
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.removeFromSuperview()
    }
    

}
