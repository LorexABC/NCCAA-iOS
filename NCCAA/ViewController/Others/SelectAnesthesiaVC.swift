//
//  SelectAnesthesiaVC.swift
//  NCCAA
//
//  Created by Apple on 19/10/22.
//

import UIKit

protocol SelectAnesthesia {
    
    func sendAnesthesia(arr:[String], type:String)
}

class SelectAnesthesiaVC: UIViewController {
    
    var delegate:SelectAnesthesia!
    var arrAnesthesiology:[EditProfileFieldsResponse]?
    var arrFlag:[Int] = []
    var type = ""
    
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
        
        for _ in 0..<(arrAnesthesiology?.count ?? 0) {
            
            arrFlag.append(0)
        }
        
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        
        self.view.endEditing(true)
        
        print(arrFlag)
        
        var arr:[String] = []
        
        for i in 0..<arrFlag.count {
            
            if arrFlag[i] == 1 {
                
                arr.append(arrAnesthesiology?[i].code ?? "")
            }
        }
        
        
        delegate.sendAnesthesia(arr: arr, type: type)
        self.dismiss(animated: true)
    }
    
    @objc func btnCheckbox(sender:UIButton) {
        
        if arrFlag[sender.tag] == 0 {
            arrFlag[sender.tag] = 1
        } else {
            arrFlag[sender.tag] = 0
        }
        
        table.reloadData()
    }
    
}
extension SelectAnesthesiaVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAnesthesiology?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectAnesthesiaCell") as! SelectAnesthesiaCell
        cell.lblTitle.text = arrAnesthesiology?[indexPath.row].name
        cell.btnCheckbox.tag = indexPath.row
        cell.btnCheckbox.addTarget(self, action: #selector(btnCheckbox(sender:)), for: .touchUpInside)
        
        if arrFlag[indexPath.row] == 1 {
            cell.btnCheckbox.setImage(UIImage(named: "check-box"), for: .normal)
        } else {
            cell.btnCheckbox.setImage(UIImage(named: "Shape"), for: .normal)
        }
        return cell
        
    }
    
    
}
