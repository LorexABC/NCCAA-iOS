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
    var selectedStartingTime = String()
    var selectedEndingTime = String()
    var dictCaseDetails:[String:Any]?
    var arrCategories:[[String : Any]]?
    var isASA = "no"
    var picker:UIDatePicker?
    var arrCatID:[Int] = []
    
    // MARK: - IBOutlet
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtview: UITextView!
    
    
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
