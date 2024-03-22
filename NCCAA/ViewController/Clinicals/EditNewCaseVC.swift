//
//  EditNewCaseVC.swift
//  NCCAA
//
//  Created by Apple on 07/09/22.
//

import UIKit

class EditNewCaseVC: UIViewController {
    
    // MARK: - Variable
    var delegate:ShowToast?
    var time = Date()
    var myPickerView : UIPickerView!
    var selectedTextfield:UITextField?
    var selectedStartingTime = String()
    var selectedEndingTime = String()
    var dictCaseDetails:[String:Any]?
    var arrCategories:[[String : Any]]?
    var isASA = "no"
    var picker:UIDatePicker?
    var arrCatID:[Int] = []
    var arrClassification = ["ASA 1", "ASA 2", "ASA 3", "ASA 4", "ASA 5", "ASA 6"]
    
    // MARK: - IBOutlet
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtview: UITextView!
    @IBOutlet weak var sctClassification: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setDatePicker()
    }
    

    // MARK: - Function

    
    func setupUI() {
        
        arrCategories = dictCaseDetails?["category"] as? [[String : Any]]
        
        var str = ""
        for i in 0..<(arrCategories?.count ?? 0) {
            
            arrCatID.append(arrCategories?[i]["id"] as! Int)
            str += "\(arrCategories?[i]["name"] as! String)\n"
        }
        txtview.text = str
        if let date = dictCaseDetails?["date"] as? String {
            txtDate.text = Helper.shared.changeStringDateFormat(date: date, toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
        } else {
            txtDate.text = ""
        }
        
        txtAge.text = "\(dictCaseDetails?["age"] ?? 0)"
        txtTitle.text = dictCaseDetails?["title"] as? String
        selectedStartingTime = dictCaseDetails?["start_time"] as? String ?? ""
        selectedEndingTime = dictCaseDetails?["end_time"] as? String ?? ""
        
        if dictCaseDetails?["asa"] as? String == "yes" {
            btnSwitch.isOn = true
        } else {
            btnSwitch.isOn = false
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm:ss"

        let date1 = dateFormatter.date(from: selectedStartingTime)
        let date2 = dateFormatter.date(from: selectedEndingTime)

        startTimePicker.date = date1!
        endTimePicker.date = date2!
    }
    
    func pickUp(textField : UITextField, text:String){
        
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
        let labelButton = UIBarButtonItem(title: text.maxLength(length: 35), style: .plain, target: nil, action: nil)

        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([labelButton,spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    @objc func doneClick() {
        selectedTextfield?.resignFirstResponder()
    }
    
    func setDatePicker() {
        
        //Write Date picker code
        picker = UIDatePicker()
        if #available(iOS 13.4, *) {
            picker?.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        txtDate.inputView = picker
        picker?.backgroundColor = UIColor.white
        picker?.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        picker?.datePickerMode = .date
        
        //Write toolbar code for done button
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onClickDoneButton))
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        txtDate.inputAccessoryView = toolBar
    }
    @objc func onClickDoneButton() {
        self.view.endEditing(true)
    }
    @objc func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let strDate = dateFormatter.string(from: picker!.date)
        txtDate?.text = strDate
    }
    
    func labelTabbed() {
        let customView = Bundle.main.loadNibNamed("CategoryDetailsView", owner: self)?.first as! CategoryDetailsView
        
        customView.lblTitle.text = "Emergent (ASA Class E)"
        customView.htmlText = "<p><b>Emergent (ASA Class E)</b></p>\n<p>The addition of “E” to the ASAPS (e.g., ASA 2E) denotes an emergency surgical procedure. The ASA defines an emergency as existing “when the delay in treatment of the patient would lead to a significant increase in the threat to life or body part.” You are required to have a minimum of (30) cases in Emergent Class E. Once the minimums have been met, the student may engage in any Emergent Class E Classes to reach the (30) case minimum for this main category. You may only select one sub-skill in this category per case. You may also select the “Other” sub-skill if a case is Emergent Class E but does not fit into any other sub-skill category.</p>\n<p>(source: www.statpearls.com)</p>\n<br>\n\n<p>The ASA defines an emergency as existing “when the delay in treatment of the patient would lead to a significant increase in the threat to life or body part.” For this category, the candidate may select this case if there is an urgency/emergency to provide immediate care and there is limited time for planning, assessment of the patient and set-up for the case.  You are required to have a minimum of (30) cases in the Emergent ASA Class. </p>"
        customView.setContentInWebview()
        customView.frame = view.bounds
        view.addSubview(customView)
    }
    
    // MARK: - Webservice
    func editCaseAPI() {
        
        Helper.shared.showHUD()

        let date = Helper.shared.changeStringDateFormat(date: txtDate.text!, toFormat: "yyyy-MM-dd", fromFormat: "MM/dd/yyyy")
        
        let params = ["title":txtTitle.text!,
                      "date":date,
                      "start_time":selectedStartingTime,
                      "end_time":selectedEndingTime,
                      "age":txtAge.text!,
                      "asa":isASA,
                      "categorie_id":arrCatID] as [String : Any]
        

        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]

        NetworkManager.shared.webserviceCallEditCase(url: "\(URLs.cases)/\(dictCaseDetails?["id"] ?? 0)", parameters: params, headers:headers) { (response) in

            //if response.ResponseCode == 200 {

            self.arrCategories = response.data?["category"] as? [[String : Any]]
            
            self.delegate?.showToastMessage(message: "You have successfully saved your CME")
            self.navigationController?.popViewController(animated: true)
            
            //print(response)

            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    func deleteCaseAPI() {
        
        Helper.shared.showHUD()


        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]

        NetworkManager.shared.webserviceCallDeleteCase(url: "\(URLs.cases)/\(dictCaseDetails?["id"] ?? 0)", headers:headers) { (response) in

            //if response.ResponseCode == 200 {

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                // Put your code which should be executed with a delay here
                self.navigationController?.popViewController(animated: true)
            }
            Toast.show(message: "Success".uppercased(), controller: self)
            //print(response)

            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    // MARK: - IBAction
    @IBAction func btnCategories(_ sender: Any) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "PatientCategoriesVC") as! PatientCategoriesVC
        obj.delegate = self
        obj.isFromEditCase = true
        obj.arrEditCat = arrCategories
        obj.classification = selectedTextfield?.text as? String ?? ""
        obj.asa = btnSwitch.isOn
        obj.patientAge = txtAge?.text as? String ?? ""
        navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func startTimeAction(_ sender: Any) {
        time = startTimePicker.date
        selectedStartingTime = time.formattedTime()
        print("Selected Starting Time: \(selectedStartingTime)")
    }
    
    @IBAction func endTimeAction(_ sender: Any) {
        time = endTimePicker.date
        selectedEndingTime = time.formattedTime()
        print("Selected Ending Time: \(selectedEndingTime)")
    }
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSwitch(_ sender: UISwitch) {
        
        if (sender.isOn){
            isASA = "yes"
            self.labelTabbed()
        }
        else{
            isASA = "no"
        }
    }
    
    @IBAction func btnSave(_ sender: Any) {
        
        if txtTitle.text == "" || txtAge.text == "" || txtDate.text == "" || arrCatID.count == 0  {
            
            Toast.show(message: "Please fill all the fields", controller: self)
            return
        }
        editCaseAPI()
    }
    
    
    @IBAction func btnDelete(_ sender: Any) {
        deleteCaseAPI()
    }
}
extension EditNewCaseVC: CategoriesCustomDelegate {
    func sendCategories(arr: [Int], name:[String]) {
        
        arrCatID = arr
        
        var str = ""
        for i in 0..<name.count {
            
            str += "\(name[i])\n"
        }
        txtview.text = str
    }
}

extension EditNewCaseVC:UITextFieldDelegate {
    
    //MARK:- TextFiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        selectedTextfield = textField
        
        self.pickUp(textField: textField, text: textField.placeholder ?? "")
    }
}

extension EditNewCaseVC:UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrClassification.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 44));
        label.font = UIFont(name: "SFProDisplay-Regular", size: 17.0)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        label.text = arrClassification[row]
        label.sizeToFit()
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTextfield?.text = arrClassification[row]
    }
}
