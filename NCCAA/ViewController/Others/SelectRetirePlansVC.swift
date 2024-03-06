//
//  SelectRetirePlansVC.swift
//  NCCAA
//
//  Created by Apple on 19/10/22.
//

import UIKit

protocol RetirePlans {
    
    func sendRetirePlans(arr:[[String:Any]], str:String)
}

class SelectRetirePlansVC: UIViewController {

    var delegate:RetirePlans!
    var arrSubRetirePlans:[[String:Any]]?
    var arrFlag:[String] = []
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    

    func setupUI() {
        
        view.isOpaque = false
        view.backgroundColor = .clear
        
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 50
        
        for _ in 0..<(arrSubRetirePlans?.count ?? 0) {
            
            arrFlag.append("")
        }
        
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        
        self.view.endEditing(true)
        
        print(arrFlag)
        var str = ""
        
        var arr:[[String:String]] = []
        
        for i in 0..<(arrSubRetirePlans?.count ?? 0) {
            
            var dict:[String:String] = [:]
            
            dict["code"] = arrSubRetirePlans?[i]["code"] as? String
            dict["name"] = arrSubRetirePlans?[i]["name"] as? String
            dict["value"] = arrFlag[i]
            
            arr.append(dict)
            
            str += "\(dict["name"] ?? "")-\(arrFlag[i])\n"
        }
        
        
        delegate.sendRetirePlans(arr: arr, str: str)
        self.dismiss(animated: true)
    }
    
}
extension SelectRetirePlansVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSubRetirePlans?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RetirePlanCell") as! RetirePlanCell
        cell.lblTitle.text = arrSubRetirePlans?[indexPath.row]["name"] as? String
        cell.txtAmount.text = arrFlag[indexPath.row]
        cell.txtAmount.tag = indexPath.row
        cell.txtAmount.delegate = self
        return cell
        
    }
    
    
}
extension SelectRetirePlansVC:UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        arrFlag[textField.tag] = textField.text ?? ""
        table.reloadData()
    }
}
