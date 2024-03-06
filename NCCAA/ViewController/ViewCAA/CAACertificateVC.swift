//
//  CAACertificateVC.swift
//  NCCAA
//
//  Created by Apple on 13/07/22.
//

import UIKit
import WebKit

class CAACertificateVC: UIViewController {

    // MARK: - Variable
    var strPdfUrl:String?
    
    // MARK: - IBOutlet
    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewCaaCertificateAPI()
    }
    

    // MARK: - Function
    
    func savePdf(urlString:String) {
        
        let fileName = "\(Int.random(in: 1..<100000))"
        DispatchQueue.main.async {
            let url = URL(string: urlString)
            let pdfData = try? Data.init(contentsOf: url!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "NCCAA_\(fileName).pdf"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            do {
                try pdfData?.write(to: actualPath, options: .atomic)
                print("pdf successfully saved!")
                Toast.show(message: "Successfully saved!", controller: self)
                //file is downloaded in app data container, I can find file from x code > devices > MyApp > download Container >This container has the file
            } catch {
                print("Pdf could not be saved")
                Toast.show(message: "could not be saved", controller: self)
            }
        }
    }
    
    // MARK: - Webservice
    func viewCaaCertificateAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallCommonGetMethod(url: URLs.certificate_pdf, headers:headers) { (response) in
            
            if response["ResponseCode"] as? Int == 200 {
                
                self.strPdfUrl = (response["data"] as? [String:Any])?["url"] as? String
                self.webView.load(NSURLRequest(url: NSURL(string: self.strPdfUrl ?? "")! as URL) as URLRequest)

            } else {
                
                Toast.show(message: response["ResponseMsg"] as! String, controller: self)
            }
         
            Helper.shared.hideHUD()
        }
    }
    
    // MARK: - IBAction
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnDownloadCert(_ sender: Any) {
        
        if strPdfUrl == nil{
            return
        }
        savePdf(urlString: strPdfUrl ?? "")
    }
    @IBAction func btnLogout(_ sender: Any) {
        
        Helper.shared.logoutFromApp(vc: self)
    }
}
