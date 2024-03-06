//
//  PatientCategoriesVC.swift
//  NCCAA
//
//  Created by Apple on 07/09/22.
//

import UIKit

protocol CategoriesCustomDelegate {
    
    func sendCategories(arr:[Int], name:[String])
    
}

class PatientCategoriesVC: UIViewController {
    
    // MARK: - Variable
    let refreshControl = UIRefreshControl()
    var arrCat:[CategoryData]?
    var arrFilteredCat:[CategoryData]?
    var arrSectionFlag:[Int] = []
    var arrFlag:[[Int]] = []
    var isFromEditCase = false
    var arrEditCat:[[String:Any]]?
    var delegate:CategoriesCustomDelegate!
    
    // MARK: - IBOutlet
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        initialRefresh()
    }
    
    
    // MARK: - Function
    
    func setupUI() {
        table.sectionHeaderHeight = UITableView.automaticDimension
        table.estimatedSectionHeaderHeight = 30
        table.estimatedRowHeight = 50
        table.rowHeight = UITableView.automaticDimension

        if #available(iOS 15.0, *){
            self.table.sectionHeaderTopPadding = 0.0
        }
        
        table.register(UINib(nibName: "CategoriesHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CategoriesHeaderView")
        
        //
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        table.addSubview(refreshControl)
    }
    func initialRefresh() {
        
        getCategoriesAPI()
    }
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        
        initialRefresh()
        refreshControl.endRefreshing()
    }
    // MARK: - Webservice
    func getCategoriesAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallCategories(url: URLs.categories, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            self.arrCat = response.data
            self.arrFilteredCat = self.arrCat
            self.arrFlag.removeAll()
            self.arrSectionFlag.removeAll()

            if self.isFromEditCase {
                
                for i in 0..<(self.arrFilteredCat?.count ?? 0) {
                    
                    if let index = self.arrEditCat?.firstIndex(where: { $0["id"] as? Int == self.arrFilteredCat?[i].id }) {
                        self.arrSectionFlag.append(self.arrEditCat?[index]["id"] as! Int)
                    } else {
                        self.arrSectionFlag.append(0)
                    }
                    
                    var arrTemp:[Int] = []
                    for j in 0..<(self.arrFilteredCat?[i].sub_category?.count ?? 0) {
                        
                        if let index = self.arrEditCat?.firstIndex(where: { $0["id"] as? Int == self.arrFilteredCat?[i].sub_category?[j]["id"] as? Int }) {
                            arrTemp.append(self.arrEditCat?[index]["id"] as! Int)
                        } else {
                            arrTemp.append(0)
                        }
                        
                    }
                    self.arrFlag.append(arrTemp)
                }
                
            } else {
                
                for i in 0..<(self.arrFilteredCat?.count ?? 0) {
                    
                    self.arrSectionFlag.append(0)
                    var arrTemp:[Int] = []
                    for _ in 0..<(self.arrFilteredCat?[i].sub_category?.count ?? 0) {
                        
                        arrTemp.append(0)
                    }
                    self.arrFlag.append(arrTemp)
                }
            }
            
            self.table.reloadData()
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    // MARK: - IBAction
    @IBAction func btnInfo(_ sender: Any) {
    }
    
    @IBAction func btnCompleted(_ sender: Any) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SkillsStatusVC") as! SkillsStatusVC
        obj.isCompletedSelected = true
        obj.modalPresentationStyle = .overCurrentContext
        obj.modalTransitionStyle = .crossDissolve
        present(obj, animated: true, completion: nil)
    }
    @IBAction func btnRemaining(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SkillsStatusVC") as! SkillsStatusVC
        obj.isCompletedSelected = false
        obj.modalPresentationStyle = .overCurrentContext
        obj.modalTransitionStyle = .crossDissolve
        present(obj, animated: true, completion: nil)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveCategories(_ sender: Any) {
        
        print("CatArr: \(arrSectionFlag)")
        print("SubCatArr: \(arrFlag)")
        
        var arr:[Int] = []
        
        for i in 0..<arrSectionFlag.count {
            
            if arrSectionFlag[i] != 0 {
                arr.append(arrSectionFlag[i])
            }
            
        }
        
        for j in 0..<arrFlag.count {
            
            for k in 0..<arrFlag[j].count {
                
                if arrFlag[j][k] != 0 {
                    arr.append(arrFlag[j][k])
                }
            }
        }
        
        print(arr)
        
        
        
        
        //
        var arrName:[String] = []
        for i in 0..<arr.count {
            if let index = arrFilteredCat?.firstIndex{$0.id == arr[i]} {
                
                arrName.append(arrFilteredCat?[index].name ?? "")
            }
        }
        print(arrName)

        var arrNameSubCat:[String] = []
        for j in 0..<arr.count {
            
            for k in 0..<(arrFilteredCat?.count ?? 0) {
                
                let arr6 = arrFilteredCat?[k].sub_category
                
                for m in 0..<(arr6?.count ?? 0) {
                    
                    if let index = arr6?.firstIndex{$0["id"] as! Int == arr[j]} {
                        
                        arrNameSubCat.append(arr6?[index]["name"] as? String ?? "")
                    }
                }
            }
        }
        
        
        print(arrNameSubCat)
        
        var arrFinal:[String] = []
        for i in arrNameSubCat{
            if !arrFinal.contains(i){
                arrFinal.append(i)
            }
        }
        
        let finalArr = arrName + arrFinal
        //
        
        delegate.sendCategories(arr: arr, name: finalArr)
        navigationController?.popViewController(animated: true)
    }
    @objc func btnCheckboxHeader(sender:UIButton) {
        
        if arrSectionFlag[sender.tag] == 0 {
            arrSectionFlag[sender.tag] = arrFilteredCat?[sender.tag].id ?? 0
        } else {
            arrSectionFlag[sender.tag] = 0
        }
        table.reloadData()
    }
    
    @objc func btnCheckboxSubCategory(sender:UIButton) {
        
        let cell = sender.superview?.superview as? SubCategoriesCell
        let indexPath = table.indexPath(for: cell!)!
        
        if arrFilteredCat?[indexPath.section].select_multiple == false {
            
            if arrFlag[indexPath.section][indexPath.row] == 0 {
                let arr = arrFlag[indexPath.section]
                
                for i in 0..<arr.count {
                    
                    if arr[i] != 0 {
                        Toast.show(message: "You can't select multiple sub categories", controller: self)
                        return
                    }
                }
            }
            
        }
        
        
        if arrFlag[indexPath.section][indexPath.row] == 0 {
            arrFlag[indexPath.section][indexPath.row] = (arrFilteredCat?[indexPath.section].sub_category?[indexPath.row]["id"] ?? 0) as! Int
        } else {
            arrFlag[indexPath.section][indexPath.row] = 0
        }
        table.reloadData()
    }
    
    @objc func btnTapSubCategory(sender:UIButton) {
        
        let cell = sender.superview?.superview as? SubCategoriesCell
        let indexPath = table.indexPath(for: cell!)!
        
        openCategoryDetailsView(name: arrFilteredCat?[indexPath.section].sub_category?[indexPath.row]["name"] as? String ?? "", desc: arrFilteredCat?[indexPath.section].sub_category?[indexPath.row]["description"] as? String ?? "")
    }
    @objc func btnTapHeader(sender:UIButton) {
        
        openCategoryDetailsView(name: self.arrFilteredCat?[sender.tag].name ?? "", desc: self.arrFilteredCat?[sender.tag].description ?? "")
    }
    
    func openCategoryDetailsView(name:String, desc:String) {
        
        let customView = Bundle.main.loadNibNamed("CategoryDetailsView", owner: self)?.first as! CategoryDetailsView
        
        customView.lblTitle.text = name
        customView.htmlText = desc
        customView.setContentInWebview()
        
        customView.frame = view.bounds
        view.addSubview(customView)
    }
}
extension PatientCategoriesVC:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return arrFilteredCat?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFilteredCat?[section].sub_category?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoriesCell") as! SubCategoriesCell
        cell.lblTitle.text = arrFilteredCat?[indexPath.section].sub_category?[indexPath.row]["name"] as? String
        cell.lblTotal.text = "\(arrFilteredCat?[indexPath.section].sub_category?[indexPath.row]["target"] ?? 0)"
        cell.lblCompleted.text = "\(arrFilteredCat?[indexPath.section].sub_category?[indexPath.row]["fill"] ?? 0)"
        
        if arrFlag[indexPath.section][indexPath.row] == 0 {
            cell.imgTick.image = UIImage(named: "unTick")
        } else {
            cell.imgTick.image = UIImage(named: "tick")
        }
        
        cell.btnTick.tag = indexPath.row
        cell.btnTick.addTarget(self, action: #selector(btnCheckboxSubCategory(sender:)), for: .touchUpInside)
        
        cell.btnTap.tag = indexPath.row
        cell.btnTap.addTarget(self, action: #selector(btnTapSubCategory(sender:)), for: .touchUpInside)
        
        //
        if arrFilteredCat?[indexPath.section].sub_category?[indexPath.row]["display_target"] as? Bool == true {
            cell.lblTotal.isHidden = false
        } else {
            cell.lblTotal.isHidden = true
        }
        
        if arrFilteredCat?[indexPath.section].sub_category?[indexPath.row]["display_completed"] as? Bool == true {
            cell.lblCompleted.isHidden = false
        } else {
            cell.lblCompleted.isHidden = true
        }
        
        if arrFilteredCat?[indexPath.section].sub_category?[indexPath.row]["display_target"] as? Bool == false || arrFilteredCat?[indexPath.section].sub_category?[indexPath.row]["display_completed"] as? Bool == false {
            cell.lblSign.isHidden = true
        } else {
            cell.lblSign.isHidden = false
        }
        
        
        //
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CategoriesHeaderView") as! CategoriesHeaderView
        
        headerView.lblCategory.text = arrFilteredCat?[section].name
        headerView.lblTotal.text = "\(arrFilteredCat?[section].target ?? 0)"
        headerView.lblCompleted.text = "\(arrFilteredCat?[section].fill ?? 0)"
        
        headerView.btnCheckbox.tag = section
        headerView.btnCheckbox.addTarget(self, action: #selector(btnCheckboxHeader(sender:)), for: .touchUpInside)
        
        
        if arrSectionFlag[section] == 0 {
            headerView.imgTick.image = UIImage(named: "unTick")
        } else {
            headerView.imgTick.image = UIImage(named: "tick")
        }
        
        headerView.btnTapHeader.tag = section
        headerView.btnTapHeader.addTarget(self, action: #selector(btnTapHeader(sender:)), for: .touchUpInside)
        
        
        if arrFilteredCat?[section].is_selectable == true {
            headerView.widthImgTick.constant = 30
        } else {
            headerView.widthImgTick.constant = 0
        }
        if arrFilteredCat?[section].display_target == true {
            headerView.lblTotal.isHidden = false
        } else {
            headerView.lblTotal.isHidden = true
        }
        if arrFilteredCat?[section].display_completed == true {
            headerView.lblCompleted.isHidden = false
        } else {
            headerView.lblCompleted.isHidden = true
        }
        
        return headerView
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 80
//    }
    
}
extension PatientCategoriesVC:UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text != "" {
            arrFilteredCat = arrCat?.filter({($0.name?.localizedCaseInsensitiveContains(textField.text!))!})
        } else {
            arrFilteredCat = arrCat
        }
        
        self.arrFlag.removeAll()
        self.arrSectionFlag.removeAll()
        
        for i in 0..<(self.arrFilteredCat?.count ?? 0) {
            
            self.arrSectionFlag.append(0)
            var arrTemp:[Int] = []
            for _ in 0..<(self.arrFilteredCat?[i].sub_category?.count ?? 0) {
                
                arrTemp.append(0)
            }
            self.arrFlag.append(arrTemp)
        }
        table.reloadData()
        
        print("CatArr: \(arrSectionFlag)")
        print("SubCatArr: \(arrFlag)")
    }
}
