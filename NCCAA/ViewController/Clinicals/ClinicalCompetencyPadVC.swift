//
//  ClinicalCompetencyPadVC.swift
//  NCCAA
//
//  Created by Apple on 07/09/22.
//

import UIKit
import MobileCoreServices

class ClinicalCompetencyPadVC: UIViewController {
    
    // MARK: - Variable
    let refreshControl = UIRefreshControl()
    let arrMenu = ["Announcements","Important Info/Dates","Student Clinical Competencies","Certification Exam","State Licensing Info","View CAA Certificate","CDQ Exam","CME Submissions","Blog","History","Edit Profile","Contact NCCAA"]
//    let arrMenuIcons = ["Frame 52","Frame 52 (1)","Group 35","award","Rubber Stamp","archive-book","teacher","Frame 52 (2)","Frame 52 (3)","Frame 52 (4)","user-edit","Support"]
    let arrMenuIcons = ["Doorbell","Calendar","Upload to Cloud","Document","Rubber Stamp yellow","Diploma","Document_blue","Upload","News","Clock","Settings","Customer Support"]
    
    var arrCases:[[String:Any]]?
    var arrFilteredCases:[[String:Any]]?
    var isComleted = false
    var iscanCompleteClinicals = false
    
    // MARK: - IBOutlet
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var searchBgView: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var tableMenu: UITableView!
    @IBOutlet weak var lblCompleteTotalHours: UILabel!
    @IBOutlet weak var lblTotalHours: UILabel!
    @IBOutlet weak var lblCompletedCases: UILabel!
    @IBOutlet weak var lblTotalCases: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnCompleted: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        initialRefresh()
    }

    
    // MARK: - Function
    
    func setupUI() {
        
        //
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        table.addSubview(refreshControl)
    }
    func initialRefresh() {
        
        lblName.text = "Hello, \(Helper.shared.userName)!"
        txtSearch.text = ""
        getCasesAPI()
        getClinicalAPI()
    }
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        
        initialRefresh()
        refreshControl.endRefreshing()
    }
    func savePdf(urlString:String) {
        
        let fileName = "\(Int.random(in: 1..<100000))"
        DispatchQueue.main.async {
            let url = URL(string: urlString)
            let pdfData = try? Data.init(contentsOf: url!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "NCCAA_\(fileName).xlsx"
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
    func getCasesAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallCases(url: URLs.cases, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            self.arrCases = response.data
            self.arrFilteredCases = self.arrCases
            self.table.reloadData()
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    func getClinicalAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallCommonGetMethod(url: URLs.get_clinical, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            self.lblCompleteTotalHours.text = "\(response["hoursCompleted"] ?? 0)"
            self.lblTotalHours.text = "/\(response["hoursTarget"] ?? 0)"
            self.lblCompletedCases.text = "\(response["casesCompleted"] ?? 0)"
            self.lblTotalCases.text = "/\(response["casesTarget"] ?? 0)"
            self.isComleted = response["completed"] as? Bool ?? false
            self.iscanCompleteClinicals = response["canCompleteClinicals"] as? Bool ?? false
            
            if self.isComleted == false {
                 
                self.btnCompleted.setTitle("Not Completed", for: .normal)
                self.btnCompleted.backgroundColor = UIColor(named: "AppLightGray")
            } else {
                self.btnCompleted.setTitle("Completed", for: .normal)
                self.btnCompleted.backgroundColor = UIColor(named: "AppBlue")
            }
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    
    func clinicalCompleteAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallCommonPostMethod(url: URLs.clinical_complete, parameters: [:], headers:headers) { (response) in
            
            if response["status"] as? Bool == true {
                self.getClinicalAPI()
            }
            if let err = response["error"] {
                
                Toast.show(message: err as? String ?? "", controller: self)
            }
                
            Helper.shared.hideHUD()
        }
    }
    
    func addExcelDocumentAPI(docData:Data, fileName:String) {
        
        Helper.shared.showHUD()
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallAddExcelDocument(url: URLs.cases_import, parameters: [:], docData: docData, fileName: fileName, headers:headers) { (response) in
            
            if response["ResponseCode"] as? Int == 200 {
                Toast.show(message: response["ResponseMsg"] as? String ?? "", controller: self)
            } else {
                Toast.show(message: response["ResponseMsg"] as? String ?? "", controller: self)
            }
            Helper.shared.hideHUD()
        }
    }
    func exportExcelAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallCommonGetMethod(url: URLs.cases_export, headers:headers) { (response) in
            
            if response["ResponseCode"] as? Int == 200 {
                
                print(response)
                self.savePdf(urlString: ((response["data"] as? [String:Any])?["url"] as? String ?? ""))
            } else {
                Toast.show(message: response["ResponseMsg"] as? String ?? "", controller: self)
            }
            Helper.shared.hideHUD()
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func btnImportExcel(_ sender: Any) {
        
        let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeSpreadsheet]
            let importMenu = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)

            if #available(iOS 11.0, *) {
                importMenu.allowsMultipleSelection = true
            }

            importMenu.delegate = self
            importMenu.modalPresentationStyle = .formSheet

            present(importMenu, animated: true)
    }
    
    @IBAction func btnExcelBackup(_ sender: Any) {
        exportExcelAPI()
    }
    @IBAction func btnAddCase(_ sender: Any) {
        
        if self.isComleted == true {
            Toast.show(message: "Not eligible", controller: self)
            return
        }
        
        if Helper.shared.userType == "student" {
            let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartNewCaseVC") as! StartNewCaseVC
            obj.delegate = self
            navigationController?.pushViewController(obj, animated: true)
        } else {
            Toast.show(message: Message.caaModuleUnavailable, controller: self)
        }
    }
    @IBAction func btnCompleted(_ sender: Any) {
        
        if self.iscanCompleteClinicals == true {
            
            clinicalCompleteAPI()
        } else {
            
            Toast.show(message: "Not eligible", controller: self)
        }
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        
        let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
        let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navAnnouncement") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = obj
    }
    @IBAction func btnLogout(_ sender: Any) {
        
        Helper.shared.logoutFromApp(vc: self)
    }
    @objc func btnEdit(sender:UIButton) {
        
        if self.isComleted == true {
            Toast.show(message: "Not eligible", controller: self)
            return
        }
        
        if Helper.shared.userType == "student" {
            let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditNewCaseVC") as! EditNewCaseVC
            obj.dictCaseDetails = arrFilteredCases?[sender.tag]
            obj.delegate = self
            navigationController?.pushViewController(obj, animated: true)
        } else {
            Toast.show(message: Message.caaModuleUnavailable, controller: self)
        }
        
    }
    
}
extension ClinicalCompetencyPadVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == table {
            if arrFilteredCases?.count == 0 {
                table.isHidden = true
            } else {
                table.isHidden = false
            }
            return arrFilteredCases?.count ?? 0
        } else {
            return arrMenu.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == table {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClinicalCompetenciesCell") as! ClinicalCompetenciesCell
            if let date = arrFilteredCases?[indexPath.row]["date"] as? String {
                cell.lblDate.text = Helper.shared.changeStringDateFormat(date: date, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
            } else {
                cell.lblDate.text = ""
            }
            cell.lblCaseDetail.text = arrFilteredCases?[indexPath.row]["title"] as? String
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(btnEdit(sender:)), for: .touchUpInside)
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
            cell.lblTitle.text = arrMenu[indexPath.row]
            cell.img.image = UIImage(named: arrMenuIcons[indexPath.row])
            
            if indexPath.row > 2 {
                cell.lblTitle.textColor = UIColor.lightGray
            } else {
                cell.lblTitle.textColor = UIColor.black
            }
            
            if indexPath.row == 2 {
                cell.viewWithTag(101)?.backgroundColor = #colorLiteral(red: 0.3019607843, green: 0.5215686275, blue: 0.9411764706, alpha: 1)
                cell.lblTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                cell.viewWithTag(101)?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.lblTitle.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tableMenu {
            
            if indexPath.row == 0 {
                
                let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navAnnouncement") as! UINavigationController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = obj
            }
            if indexPath.row == 1 {
                
                let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navInfoDates") as! UINavigationController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = obj
            }
            
            if indexPath.row == 3 {
                
                if Helper.shared.userType == "student" {
                    let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                    let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navCertification") as! UINavigationController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = obj
                } else {
                    Toast.show(message: Message.certificationModuleUnavailable, controller: self)
                }
            }
            if indexPath.row == 4 {
                
                if Helper.shared.userType == "caa" {
                    let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                    let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navStateLicensing") as! UINavigationController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = obj
                } else {
                    Toast.show(message: Message.studentModuleUnavailable, controller: self)
                }
            }
            if indexPath.row == 5 {
                
                if Helper.shared.userType == "caa" {
                    let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                    let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navCAA") as! UINavigationController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = obj
                } else {
                    Toast.show(message: Message.studentModuleUnavailable, controller: self)
                }
            }
            if indexPath.row == 6 {
                
                if Helper.shared.userType == "caa" {
                    let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                    let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navCDQ") as! UINavigationController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = obj
                } else {
                    Toast.show(message: Message.studentModuleUnavailable, controller: self)
                }
            }
            if indexPath.row == 7 {
                
                if Helper.shared.userType == "caa" {
                    let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                    let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navCME") as! UINavigationController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = obj
                } else {
                    Toast.show(message: Message.studentModuleUnavailable, controller: self)
                }
            }
            if indexPath.row == 8 {
                
                let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navBlog") as! UINavigationController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = obj
            }
            if indexPath.row == 9 {
                
                let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navHistory") as! UINavigationController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = obj
            }
            if indexPath.row == 10 {
                
                let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navProfile") as! UINavigationController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = obj
            }
            if indexPath.row == 11 {
                
                let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navContact") as! UINavigationController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = obj
            }
        }
    }
    
    
}
extension ClinicalCompetencyPadVC:UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text != "" {
            arrFilteredCases = arrCases?.filter({(($0["title"] as! String).localizedCaseInsensitiveContains(textField.text!)) || ($0["age"] as? Int == Int(textField.text!)) || ($0["category"] as? [[String:Any]] ?? [])!.contains(where: { (($0["name"] as! String).localizedCaseInsensitiveContains(textField.text!))})})
        } else {
            arrFilteredCases = arrCases
        }
        table.reloadData()
        
    }
}
extension ClinicalCompetencyPadVC: ShowToast {
    func showToastMessage(message: String) {
        
        Toast.show(message: message, controller: self)
    }
}
extension ClinicalCompetencyPadVC: UIDocumentPickerDelegate, UINavigationControllerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        
        let file = urls[0]
        do{
            let fileData = try Data.init(contentsOf: file.absoluteURL)
            
//            selectedFileData["filename"] = file.lastPathComponent
//            selectedFileData["data"] = fileData.base64EncodedString(options: .lineLength64Characters)
            
            print(file.lastPathComponent)
            print(fileData.base64EncodedString(options: .lineLength64Characters))
            addExcelDocumentAPI(docData: fileData, fileName: file.lastPathComponent)
            
        }catch{
            print("contents could not be loaded")
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
