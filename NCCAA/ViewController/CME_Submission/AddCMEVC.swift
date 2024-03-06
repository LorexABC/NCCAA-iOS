//
//  AddCMEVC.swift
//  NCCAA
//
//  Created by Apple on 21/07/22.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

protocol ShowToast {
    
    func showToastMessage(message:String)
}
class AddCMEVC: UIViewController {
    
    // MARK: - Variable
    var delegate:ShowToast?
    let arrProvider = ["AMA","ACCME","AAPA","AHA","FAACT"]
    let arrProviderId = ["ama","accme","aapa","aha","faact"]
    var myPickerView : UIPickerView!
    var selectedTextfield:UITextField?
    var strProviderId = ""
    var strHours = "anesthesia"
    var intUploadId = 0
    var isFirstCheckbox = false
    var isSecondCheckbox = false
    var strYear = ""
    var isEdit = false
    var dictEdit:[String:Any]?
    
    // MARK: - IBOutlet
    @IBOutlet weak var lblAddCME: UILabel!
    @IBOutlet weak var txtCardNo: UITextField!
    @IBOutlet weak var txtDocName: UITextField!
    @IBOutlet weak var imgRadioAnesthesia: UIImageView!
    @IBOutlet weak var imgRadioOther: UIImageView!
    @IBOutlet weak var txtEnterHours: UITextField!
    @IBOutlet weak var btnChooseFile: UIButton!
    @IBOutlet weak var txtProvider: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if strYear == "" {
            strYear = "\(Calendar.current.component(.year, from: Date()))"
        }
        
        if isEdit {
            lblAddCME.text = "Edit CME"
            
            intUploadId = dictEdit?["uploadId"] as! Int
            strProviderId = dictEdit?["cmeProvider"] as! String
            
            let index = arrProviderId.firstIndex(of: strProviderId)
            txtProvider.text = arrProvider[index!]
            
            if dictEdit?["type"] as! String == "anesthesia" {
                strHours = "anesthesia"
                imgRadioAnesthesia.image = UIImage(named: "radio_filled")
                imgRadioOther.image = UIImage(named: "radio")
            } else {
                strHours = "other"
                imgRadioAnesthesia.image = UIImage(named: "radio")
                imgRadioOther.image = UIImage(named: "radio_filled")
            }
            
            txtDocName.text = dictEdit?["name"] as? String
            txtEnterHours.text = "\((dictEdit?["hours"] as? Double ?? 0).rounded(toPlaces: 2))"
            
        }
        
    }
    

    // MARK: - Function
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Document", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.uploadDocument()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
            case .pad:
            actionSheet.popoverPresentationController?.sourceView = btnChooseFile
            actionSheet.popoverPresentationController?.sourceRect = btnChooseFile.bounds
            actionSheet.popoverPresentationController?.permittedArrowDirections = .up
            default:
                break
            }
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func uploadDocument() {
        
        var documentPicker: UIDocumentPickerViewController!
        if #available(iOS 14, *) {
            // iOS 14 & later
            let supportedTypes: [UTType] = [UTType.image, UTType.pdf, UTType.init(filenameExtension: "doc")!,UTType.init(filenameExtension: "docx")!,UTType.init(filenameExtension: "xls")!,UTType.init(filenameExtension: "xlsx")!,UTType.init(filenameExtension: "ppt")!]
            documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        } else {
            // iOS 13 or older code
            let supportedTypes: [String] = [kUTTypeImage as String,kUTTypePDF as String]
            documentPicker = UIDocumentPickerViewController(documentTypes: supportedTypes, in: .import)
        }
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true)
    }
    
    func camera()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerController.SourceType.camera
        
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func photoLibrary()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
    }
    func pickUp(textField : UITextField) {
        
        view.viewWithTag(1001)?.removeFromSuperview()
        view.viewWithTag(1002)?.removeFromSuperview()
        // UIPickerView
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        myPickerView.tag = 1001
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.backgroundColor = UIColor.white
        textField.inputView = self.myPickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.tag = 1002
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))

        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }

    @objc func doneClick() {
        selectedTextfield?.resignFirstResponder()
    }
    
    // MARK: - Webservice
    func addCMECyclesAPI() {
        
        Helper.shared.showHUD()
        
        let params = [
            "name": txtDocName.text!,
            "hours": Float(txtEnterHours.text!)!,
            "cmeProvider": strProviderId,
            "type": strHours,
            "uploadId": intUploadId] as [String : Any]
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallCreateCMECycle(url: "\(URLs.cmeCycles)/\(strYear)/entries", parameters: params, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            if let _ = response["error"] as? String {
                
                Toast.show(message: response["error"] as! String, controller: self)
            }
            if let _ = response["entryId"] {
                
                self.delegate?.showToastMessage(message: "You have successfully saved your CME info")
                
                self.navigationController?.popViewController(animated: true)
            }
            
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    func editCMECyclesAPI() {
        
        Helper.shared.showHUD()
        
        let params = [
            "name": txtDocName.text!,
            "hours": Float(txtEnterHours.text!)!,
            "cmeProvider": strProviderId,
            "type": strHours,
            "uploadId": intUploadId] as [String : Any]
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallUpdateCMECycle(url: "\(URLs.cmeCycles)/\(strYear)/entries/\(dictEdit?["id"] ?? 0)", parameters: params, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            if let _ = response["error"] as? String {
                
                Toast.show(message: response["error"] as! String, controller: self)
            }
            if let _ = response["status"] {
                
                self.delegate?.showToastMessage(message: "You have successfully saved your CME info")
                
                self.navigationController?.popViewController(animated: true)
            }
            
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    func addDocumentAPI(docData:Data, fileName:String) {
        
        Helper.shared.showHUD()
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallAddDocument(url: URLs.uploadFile, parameters: [:], docData: docData, fileName: fileName, headers:headers) { (response) in
            
            if let id = response["uploadId"] {
                self.intUploadId = id as! Int
            }
            Helper.shared.hideHUD()
        }
    }
    // MARK: - IBAction
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnChooseFile(_ sender: Any) {
        showActionSheet()
    }
    
    @IBAction func btnHours(_ sender: UIButton) {
        
        if sender.tag == 101 {
            strHours = "anesthesia"
            imgRadioAnesthesia.image = UIImage(named: "radio_filled")
            imgRadioOther.image = UIImage(named: "radio")
        } else {
            strHours = "other"
            imgRadioAnesthesia.image = UIImage(named: "radio")
            imgRadioOther.image = UIImage(named: "radio_filled")
        }
    }
    
    @IBAction func btnFirstCheckbox(_ sender: UIButton) {
        
        if sender.tag == 0 {
            isFirstCheckbox = true
            sender.tag = 1
            sender.setImage(UIImage(named: "check-box"), for: .normal)
        } else {
            isFirstCheckbox = false
            sender.tag = 0
            sender.setImage(UIImage(named: "shape"), for: .normal)
        }
    }
    
    
    @IBAction func btnSecondCheckbox(_ sender: UIButton) {
        if sender.tag == 0 {
            isSecondCheckbox = true
            sender.tag = 1
            sender.setImage(UIImage(named: "check-box"), for: .normal)
        } else {
            isSecondCheckbox = false
            sender.tag = 0
            sender.setImage(UIImage(named: "shape"), for: .normal)
        }
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        
        if intUploadId == 0 {
            Toast.show(message: "Please choose from file/Take Photo", controller: self)
            return
        }
        if txtDocName.text == "" || txtProvider.text == "" ||  txtEnterHours.text == "" {
            Toast.show(message: Message.fillReqFields, controller: self)
            return
        }
        if isFirstCheckbox == false || isSecondCheckbox == false {
            Toast.show(message: "Please check both boxes", controller: self)
            return
        }
        
        if isEdit {
            editCMECyclesAPI()
        } else {
            addCMECyclesAPI()
        }
        
    }
    @IBAction func btnMoreInfo(_ sender: Any) {
        
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlainTextVC") as! PlainTextVC
        obj.strHeader = "Add CME"
        navigationController?.pushViewController(obj, animated: true)
    }
}

extension AddCMEVC:UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if selectedTextfield == txtProvider {
            
            return arrProvider.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if selectedTextfield == txtProvider {
            
           return arrProvider[row]
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if selectedTextfield == txtProvider {
            
            selectedTextfield?.text = arrProvider[row]
            strProviderId = arrProviderId[row]
        }
        
    }
    
}
extension AddCMEVC:UITextFieldDelegate {
    
    //MARK:- TextFiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextfield = textField
        
        self.pickUp(textField: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
extension AddCMEVC:UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)?.fixOrientation()
        
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            
            let documentData = (selectedImage?.jpegData(compressionQuality: 0.6)!)!
            self.addDocumentAPI(docData: documentData, fileName: url.lastPathComponent)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}
extension AddCMEVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        for url in urls {
            
            // Start accessing a security-scoped resource.
            guard url.startAccessingSecurityScopedResource() else {
                // Handle the failure here.
                return
            }
            
            do {
                let data = try Data.init(contentsOf: url)
                // You will have data of the selected file
                self.addDocumentAPI(docData: data, fileName: url.lastPathComponent)
            }
            catch {
                print(error.localizedDescription)
            }
            
            // Make sure you release the security-scoped resource when you finish.
            defer { url.stopAccessingSecurityScopedResource() }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
