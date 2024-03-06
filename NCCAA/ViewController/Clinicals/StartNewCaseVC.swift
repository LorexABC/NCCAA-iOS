//
//  StartNewCaseVC.swift
//  NCCAA
//
//  Created by Apple on 07/09/22.
//

import UIKit



class StartNewCaseVC: UIViewController {
    
    // MARK: - Variable
    var delegate:ShowToast?
    var time = Date()
    var selectedStartingTime = String()
    var selectedEndingTime = String()
    var isASA = "no"
    var picker:UIDatePicker?
    var arrCat:[Int] = []
    
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
        
        time = startTimePicker.date
        selectedStartingTime = time.formattedTime()
        
        time = endTimePicker.date
        selectedEndingTime = time.formattedTime()
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
    func addCaseAPI() {
        
        Helper.shared.showHUD()
        
        let date = Helper.shared.changeStringDateFormat(date: txtDate.text!, toFormat: "yyyy-MM-dd", fromFormat: "MM/dd/yyyy")

        let params = ["title":txtTitle.text!,
                      "date":date,
                      "start_time":selectedStartingTime,
                      "end_time":selectedEndingTime,
                      "age":txtAge.text!,
                      "asa":isASA,
                      "categorie_id":arrCat] as [String : Any]
        

        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]

        NetworkManager.shared.webserviceCallCommon(url: URLs.cases, parameters: params, headers:headers) { (response) in

            //if response.ResponseCode == 200 {

            //print(response)

            self.delegate?.showToastMessage(message: "You have successfully saved your CME")
            
            self.navigationController?.popViewController(animated: true)
            

            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
        
        
        
    }
    
    // MARK: - IBAction
    @IBAction func ntmSubmit(_ sender: Any) {
        
        if txtTitle.text == "" || txtAge.text == "" || txtDate.text == "" || arrCat.count == 0  {
            
            Toast.show(message: "Please fill all the fields", controller: self)
            return
        }
        addCaseAPI()
    }
    @IBAction func btnCategories(_ sender: Any) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "PatientCategoriesVC") as! PatientCategoriesVC
        obj.delegate = self
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
            print("on")
            isASA = "yes"
        }
        else{
            print("off")
            isASA = "no"
        }
    }
    
}
extension StartNewCaseVC: CategoriesCustomDelegate {
    func sendCategories(arr: [Int], name:[String]) {
        
        arrCat = arr
        
        var str = ""
        for i in 0..<name.count {
            
            str += "\(name[i])\n"
        }
        txtview.text = str
    }
}
