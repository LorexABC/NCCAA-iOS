//
//  CMESubmissionPadVC.swift
//  NCCAA
//
//  Created by Apple on 14/07/22.
//

import UIKit

class CMESubmissionPadVC: UIViewController {
    
    // MARK: - Variable
    let refreshControl = UIRefreshControl()
    var arrCyclesYear:[[String:Any]]?
    var arrHistory:[[String:Any]]?
    var myPickerView : UIPickerView = UIPickerView()
    var selectedTextfield:UITextField?
    var intSelectedPickerRow:Int?
    var selectedYear:Int?
    
    let arrMenu = ["Announcements","Important Info/Dates","Student Clinical Competencies","Certification Exam","State Licensing Info","View CAA Certificate","CDQ Exam","CME Submissions","Blog","History","Edit Profile","Contact NCCAA"]

    let arrMenuIcons = ["Doorbell","Calendar","Upload to Cloud","Document","Rubber Stamp yellow","Diploma","Document_blue","Upload","News","Clock","Settings","Customer Support"]
    
    // MARK: - IBOutlet
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var lblCME_history: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var heightCollview: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableMenu: UITableView!
    @IBOutlet weak var lblLabelAnesthesiaCredits: UILabel!
    @IBOutlet weak var lblLabelCreditStillNeeded: UILabel!
    @IBOutlet weak var lblLabelCreditsCompleted: UILabel!
    @IBOutlet weak var lblLabelCreditNeeded: UILabel!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var txtSelectCycle: UITextField!
    @IBOutlet weak var lblCreditNeeded: UILabel!
    @IBOutlet weak var lblCreditsCompleted: UILabel!
    @IBOutlet weak var lblCreditStillNeeded: UILabel!
    @IBOutlet weak var lblAneshthesiaCreditsNeeded: UILabel!
    @IBOutlet weak var btnAddCME: UIButton!
    @IBOutlet weak var btnPayNow: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnAddCMETop: UIButton!
    
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
        
        lblName.text = "Hello, \(Helper.shared.userName)!"
        
        //
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        scrollview.addSubview(refreshControl)
    }
    func initialRefresh() {
        
        getCMECyclesAPI()
        if txtSelectCycle?.text != "" {
            getCMECyclesByYearAPI(strYear: "\(selectedYear ?? 0)")
        }
    }
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        
        initialRefresh()
        refreshControl.endRefreshing()
    }
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.heightCollview?.constant = self.collectionView.contentSize.height
        }
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
    func getCMECyclesAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallGetExams(url: URLs.cmeCycles, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            self.arrCyclesYear = response
            self.myPickerView.reloadAllComponents()
            
            if response.count > 0 {
                
                self.selectedTextfield = self.txtSelectCycle
                
                self.myPickerView.selectRow(0, inComponent: 0, animated: true)
                self.pickerView(self.myPickerView, didSelectRow: 0, inComponent: 0)
                
            }
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    
    func getCMECyclesByYearAPI(strYear:String) {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallGetExams(url: "\(URLs.cmeCycles)/\(strYear)/entries", headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            self.arrHistory = response
            self.collectionView.reloadData()
            
            
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    func deleteCMECyclesAPI(id:Int) {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallDeleteCMECycle(url: "\(URLs.cmeCycles)/\(selectedYear!)/entries/\(id)", headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            if let _ = response["error"] as? String {
                
                Toast.show(message: response["error"] as! String, controller: self)
            }
            if let _ = response["status"] {
                
                Toast.show(message: "Success", controller: self)
                self.getCMECyclesByYearAPI(strYear: "\(self.selectedYear ?? 0)")
            }
            
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    func getDocumentAPI(uploadId:Int) {
        
        Helper.shared.showHUD()
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallGetUploadedFile(url: "\(URLs.uploadFile)/\(uploadId)/metadata", headers:headers) { (response) in
            
            if let url = response["url"] as? String {
                let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
                obj.strUrl = url
                self.navigationController?.pushViewController(obj, animated: true)
            }
            Helper.shared.hideHUD()
        }
    }
    // MARK: - IBAction
    @IBAction func btnAddCME(_ sender: Any) {
        
        if arrCyclesYear?[intSelectedPickerRow ?? 0]["isCurrent"] as? Bool == true {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "AddCMEPadVC") as! AddCMEPadVC
            obj.strYear = "\(selectedYear ?? 0)"
            obj.delegate = self
            navigationController?.pushViewController(obj, animated: true)
        } else {
            Toast.show(message: "Not allowed to add", controller: self)
        }
    }
    @IBAction func btnPayNow(_ sender: Any) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "CreditCardPadVC") as! CreditCardPadVC
        obj.intReceiptId = arrCyclesYear?[intSelectedPickerRow ?? 0]["receiptId"] as? Int
        obj.isFromVC = "CME"
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnNotification(_ sender: Any) {
        
        let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
        let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navAnnouncement") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = obj
    }
    @IBAction func btnMoreInfo(_ sender: Any) {
        
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlainTextVC") as! PlainTextVC
        obj.strHeader = "View CME Submission"
        navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnLogout(_ sender: Any) {
        
        Helper.shared.logoutFromApp(vc: self)
    }
    @objc func btnEdit(sender:UIButton) {
        
        let obj = UIStoryboard(name: "MainiPad", bundle: nil).instantiateViewController(withIdentifier: "AddCMEPadVC") as! AddCMEPadVC
        obj.strYear = "\(selectedYear ?? 0)"
        obj.isEdit = true
        obj.dictEdit = arrHistory?[sender.tag]
        obj.delegate = self
        navigationController?.pushViewController(obj, animated: true)
    }
    @objc func btnDelete(sender:UIButton) {
        
        let alert = UIAlertController(title: "Are you sure you want to delete this CME submission?", message: "", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.deleteCMECyclesAPI(id:(self.arrHistory?[sender.tag]["id"])! as! Int)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    @objc func btnView(sender:UIButton) {
        
        getDocumentAPI(uploadId: (arrHistory?[sender.tag]["uploadId"] as! Int))
    }
}
extension CMESubmissionPadVC:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrMenu.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
        cell.lblTitle.text = arrMenu[indexPath.row]
        cell.img.image = UIImage(named: arrMenuIcons[indexPath.row])
        
        
        if indexPath.row == 7 {
            cell.viewWithTag(101)?.backgroundColor = #colorLiteral(red: 0.3019607843, green: 0.5215686275, blue: 0.9411764706, alpha: 1)
            cell.lblTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            cell.viewWithTag(101)?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.lblTitle.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        return cell
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
            if indexPath.row == 2 {
                
                if Helper.shared.userType == "student" {
                    let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                    let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navClinicals") as! UINavigationController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = obj
                } else {
                    Toast.show(message: Message.caaModuleUnavailable, controller: self)
                }
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
extension CMESubmissionPadVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrHistory?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CMESubmissionCell", for: indexPath) as! CMESubmissionCell
        
        if (arrHistory?.count ?? 0) > 2 {
            
            if indexPath.row == 0 {
                cell.contentView.viewWithTag(101)?.isHidden = true
                cell.contentView.viewWithTag(102)?.isHidden = false
            } else if indexPath.row == ((arrHistory?.count ?? 0)-1) {
                cell.contentView.viewWithTag(101)?.isHidden = false
                cell.contentView.viewWithTag(102)?.isHidden = true
            } else {
                cell.contentView.viewWithTag(101)?.isHidden = false
                cell.contentView.viewWithTag(102)?.isHidden = false
            }
        } else {
            if indexPath.row % 2 != 0 {
                cell.contentView.viewWithTag(101)?.isHidden = false
                cell.contentView.viewWithTag(102)?.isHidden = true
            } else {
                cell.contentView.viewWithTag(101)?.isHidden = true
                cell.contentView.viewWithTag(102)?.isHidden = false
            }
        }
        
        cell.lblDesc.text = arrHistory?[indexPath.row]["name"] as? String
        cell.lblDate.text = "Date not available"
        cell.lblCredits.text = "\((arrHistory?[indexPath.row]["hours"] as? Double ?? 0).rounded(toPlaces: 2))"
        cell.lblType.text = (arrHistory?[indexPath.row]["type"] as? String)?.capitalizingFirstLetter()
        
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(btnEdit(sender:)), for: .touchUpInside)
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(btnDelete(sender:)), for: .touchUpInside)
        cell.btnView.tag = indexPath.row
        cell.btnView.addTarget(self, action: #selector(btnView(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 200)
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
}
extension CMESubmissionPadVC:UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if selectedTextfield == txtSelectCycle {
            
            return arrCyclesYear?.count ?? 0
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if selectedTextfield == txtSelectCycle {
            
            let yr = (arrCyclesYear?[row]["cycle"] as? Int) ?? 0
            
            
           return "\(yr-2)-\(arrCyclesYear?[row]["cycle"] ?? 0)"
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if selectedTextfield == txtSelectCycle {
            
            intSelectedPickerRow = row
            //
            selectedYear = (arrCyclesYear?[row]["cycle"] as? Int) ?? 0
            
            selectedTextfield?.text = "\(selectedYear!-2)-\(arrCyclesYear?[row]["cycle"] ?? 0)"
            
            lblTitle.text = "Credits This Cycle (\(selectedYear!-2)-\(arrCyclesYear?[row]["cycle"] ?? 0))"
            lblLabelCreditNeeded.text = "Credit needed for this cycle (\(selectedYear!-2)-\(arrCyclesYear?[row]["cycle"] ?? 0))"
            lblCME_history.text = "CME History (\(selectedYear!-2)-\(arrCyclesYear?[row]["cycle"] ?? 0))"
            //
            
            if let _ = arrCyclesYear?[row]["creditsNeeded"] as? Double {
                lblCreditNeeded.text = "\((arrCyclesYear?[row]["creditsNeeded"] as? Double ?? 0).rounded(toPlaces: 2))"
            }
            else {
                lblCreditNeeded.text = "\(arrCyclesYear?[row]["creditsNeeded"] ?? 0)"
            }
            if let _ = arrCyclesYear?[row]["creditsCompleted"] as? Double {
                lblCreditsCompleted.text = "\((arrCyclesYear?[row]["creditsCompleted"] as? Double ?? 0).rounded(toPlaces: 2))"
            }
            else {
                lblCreditsCompleted.text = "\(arrCyclesYear?[row]["creditsCompleted"] ?? 0)"
            }
            if let _ = arrCyclesYear?[row]["creditsLeft"] as? Double {
                lblCreditStillNeeded.text = "\((arrCyclesYear?[row]["creditsLeft"] as? Double ?? 0).rounded(toPlaces: 2))"
            } else {
                
                lblCreditStillNeeded.text = "\(arrCyclesYear?[row]["creditsLeft"] ?? 0)"
            }
            if let _ = arrCyclesYear?[row]["anesthesiaCreditsLeft"] as? Double {
                lblAneshthesiaCreditsNeeded.text = "\((arrCyclesYear?[row]["anesthesiaCreditsLeft"] as? Double ?? 0).rounded(toPlaces: 2))"
            } else {
                lblAneshthesiaCreditsNeeded.text = "\(arrCyclesYear?[row]["anesthesiaCreditsLeft"] ?? 0)"
            }
            if arrCyclesYear?[row]["isCurrent"] as? Bool == true {
                viewBg.backgroundColor = #colorLiteral(red: 0.8556032181, green: 0.9156377316, blue: 0.961797297, alpha: 1)
                lblLabelCreditsCompleted.textColor = #colorLiteral(red: 0.1411764706, green: 0.2666666667, blue: 0.6, alpha: 1)
                lblLabelCreditNeeded.textColor = #colorLiteral(red: 0.1411764706, green: 0.2666666667, blue: 0.6, alpha: 1)
                lblLabelCreditStillNeeded.textColor = #colorLiteral(red: 0.1411764706, green: 0.2666666667, blue: 0.6, alpha: 1)
                lblLabelAnesthesiaCredits.textColor = #colorLiteral(red: 0.1411764706, green: 0.2666666667, blue: 0.6, alpha: 1)
                lblCreditsCompleted.textColor = #colorLiteral(red: 0.1411764706, green: 0.2666666667, blue: 0.6, alpha: 1)
                lblCreditNeeded.textColor = #colorLiteral(red: 0.1411764706, green: 0.2666666667, blue: 0.6, alpha: 1)
                lblCreditStillNeeded.textColor = #colorLiteral(red: 0.1411764706, green: 0.2666666667, blue: 0.6, alpha: 1)
                lblAneshthesiaCreditsNeeded.textColor = #colorLiteral(red: 0.1411764706, green: 0.2666666667, blue: 0.6, alpha: 1)
            } else {
                viewBg.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9294117647, blue: 0.8705882353, alpha: 1)
                lblLabelCreditsCompleted.textColor = #colorLiteral(red: 0.4156862745, green: 0.1607843137, blue: 0.0862745098, alpha: 1)
                lblLabelCreditNeeded.textColor = #colorLiteral(red: 0.4156862745, green: 0.1607843137, blue: 0.0862745098, alpha: 1)
                lblLabelCreditStillNeeded.textColor = #colorLiteral(red: 0.4156862745, green: 0.1607843137, blue: 0.0862745098, alpha: 1)
                lblLabelAnesthesiaCredits.textColor = #colorLiteral(red: 0.4156862745, green: 0.1607843137, blue: 0.0862745098, alpha: 1)
                lblCreditsCompleted.textColor = #colorLiteral(red: 0.4156862745, green: 0.1607843137, blue: 0.0862745098, alpha: 1)
                lblCreditNeeded.textColor = #colorLiteral(red: 0.4156862745, green: 0.1607843137, blue: 0.0862745098, alpha: 1)
                lblCreditStillNeeded.textColor = #colorLiteral(red: 0.4156862745, green: 0.1607843137, blue: 0.0862745098, alpha: 1)
                lblAneshthesiaCreditsNeeded.textColor = #colorLiteral(red: 0.4156862745, green: 0.1607843137, blue: 0.0862745098, alpha: 1)
            }
            
            
            if Double(lblCreditsCompleted.text!)! >= Double(lblCreditNeeded.text!)! {
                btnPayNow.isHidden = false
            } else {
                btnPayNow.isHidden = true
            }
            
            if arrCyclesYear?[row]["receiptId"] as? Int ?? 0 > 0 {
                btnPayNow.setTitle("Pay Now", for: .normal)
            } else {
                
                if arrCyclesYear?[row]["receiptPaid"] as? Bool == true {
                    btnAddCME.isHidden = true
                    btnAddCMETop.isHidden = true
                    btnPayNow.setTitle("Paid", for: .normal)
                } else {
                    btnAddCME.isHidden = false
                    btnAddCMETop.isHidden = false
                    btnPayNow.setTitle("Pay Now", for: .normal)
                }
            }
            
            
            self.selectedTextfield?.resignFirstResponder()
            getCMECyclesByYearAPI(strYear: "\(selectedYear ?? 0)")
        }
        
    }
    
}
extension CMESubmissionPadVC:UITextFieldDelegate {
    
    //MARK:- TextFiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextfield = textField
        
        self.pickUp(textField: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
extension CMESubmissionPadVC: ShowToast {
    func showToastMessage(message: String) {
        
        Toast.show(message: message, controller: self)
    }
}
