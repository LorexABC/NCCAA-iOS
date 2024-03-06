//
//  TestingCentreVC.swift
//  NCCAA
//
//  Created by Apple on 20/07/22.
//

import UIKit

class TestingCentreVC: UIViewController {
    
    // MARK: - Variable
    var intExamId:Int?
    var strCentreUrl:String?
    
    // MARK: - IBOutlet
    @IBOutlet weak var txtCenterType: UITextField!
    @IBOutlet weak var txtview: UITextView!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        getBookingInfoAPI()
    }
    

    // MARK: - Function
    
    func setupUI() {
        
        txtview.text = "Address"
        txtview.textColor = UIColor.lightGray
        self.adjustContentSize(tv: txtview)
    }
    
    
    
    // MARK: - Webservice
    func getBookingInfoAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallCommonGetMethod(url: "\(URLs.exams)/\(intExamId!)/booking", headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            let arr = (response["dateTime"] as? String)?.components(separatedBy: "T")
            
            if arr?.count != 0 {
                
                
                if let date = arr?[0] {
                    self.txtDate.text = Helper.shared.changeStringDateFormat(date: date, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
                } else {
                    self.txtDate.text = ""
                }
                
                let arr2 = arr?[1].components(separatedBy: "-")
                
                if arr2?.count != 0 {
                    
                    self.txtTime.text = arr2?[0]
                }
            }
            
            self.txtCenterType.text = response["type"] as? String
            self.txtLocation.text = response["locationName"] as? String
            self.txtview.text = response["address"] as? String
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    
    
    // MARK: - IBAction
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSubmit(_ sender: Any) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
        obj.strUrl = strCentreUrl ?? ""
        self.navigationController?.pushViewController(obj, animated: true)
    }
}
extension TestingCentreVC:UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Address"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func adjustContentSize(tv: UITextView){
        let deadSpace = tv.bounds.size.height - tv.contentSize.height
        let inset = max(0, deadSpace/2.0)
        tv.contentInset = UIEdgeInsets(top: inset, left: tv.contentInset.left, bottom: inset, right: tv.contentInset.right)
    }

    func textViewDidChange(_ textView: UITextView) {
        self.adjustContentSize(tv: textView)
    }
}
