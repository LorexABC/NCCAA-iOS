//
//  SkillsStatusVC.swift
//  NCCAA
//
//  Created by Apple on 07/09/22.
//

import UIKit

class SkillsStatusVC: UIViewController {
    
    // MARK: - Variable
    var arrCat:[CategoryData] = []
    var isCompletedSelected = true
    
    // MARK: - IBOutlet
    @IBOutlet weak var btnRemaining: UIButton!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var btnComleted: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        getCategoriesAPI()
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
        
        if isCompletedSelected {
            btnComleted.sendActions(for: .touchUpInside)

        } else {
            btnRemaining.sendActions(for: .touchUpInside)

        }
    }
    
    
    
    
    // MARK: - Webservice
    func getCategoriesAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallCategories(url: URLs.categories, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            
            //
           
            self.arrCat = response.data ?? []
            
            
            
            //
            self.table.reloadData()
            
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    // MARK: - IBAction
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func btnCompleted(_ sender: UIButton) {
        
        isCompletedSelected = true
        self.table.reloadData()
        sender.backgroundColor = #colorLiteral(red: 0, green: 0.2784313725, blue: 0.8588235294, alpha: 1)
        btnRemaining.backgroundColor = #colorLiteral(red: 0.8556032181, green: 0.9156377316, blue: 0.961797297, alpha: 1)
    }
    @IBAction func btnRemaining(_ sender: UIButton) {
        
        isCompletedSelected = false
        self.table.reloadData()
        sender.backgroundColor = #colorLiteral(red: 0, green: 0.2784313725, blue: 0.8588235294, alpha: 1)
        btnComleted.backgroundColor = #colorLiteral(red: 0.8556032181, green: 0.9156377316, blue: 0.961797297, alpha: 1)
    }
    @objc func btnTapHeader(sender:UIButton) {
        
        openCategoryDetailsView(name: arrCat[sender.tag].name ?? "", desc: arrCat[sender.tag].description ?? "")
    }
    
    @objc func btnTapSubCategory(sender:UIButton) {
        
        let cell = sender.superview?.superview as? SubCategoriesCell
        let indexPath = table.indexPath(for: cell!)!
        
        openCategoryDetailsView(name: arrCat[indexPath.section].sub_category?[indexPath.row]["name"] as? String ?? "", desc: arrCat[indexPath.section].sub_category?[indexPath.row]["description"] as? String ?? "")
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

extension SkillsStatusVC:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return arrCat.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrCat[section].sub_category?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoriesCell") as! SubCategoriesCell
        
        if isCompletedSelected {
            cell.lblTitle.text = arrCat[indexPath.section].sub_category?[indexPath.row]["name"] as? String
            cell.lblTotal.text = "\(arrCat[indexPath.section].sub_category?[indexPath.row]["target"] ?? 0)"
            cell.lblCompleted.text = "\(arrCat[indexPath.section].sub_category?[indexPath.row]["fill"] ?? 0)"
        } else {
            cell.lblTitle.text = arrCat[indexPath.section].sub_category?[indexPath.row]["name"] as? String
            cell.lblTotal.text = "\(arrCat[indexPath.section].sub_category?[indexPath.row]["target"] ?? 0)"
            
            let remain = (arrCat[indexPath.section].sub_category?[indexPath.row]["target"] as? Int ?? 0)-(arrCat[indexPath.section].sub_category?[indexPath.row]["fill"] as? Int ?? 0)
            
            cell.lblCompleted.text = "\(remain)"
        }
        cell.btnTap.tag = indexPath.row
        cell.btnTap.addTarget(self, action: #selector(btnTapSubCategory(sender:)), for: .touchUpInside)
        
        //
        if arrCat[indexPath.section].sub_category?[indexPath.row]["display_target"] as? Bool == true {
            cell.lblTotal.isHidden = false
        } else {
            cell.lblTotal.isHidden = true
        }
        
        if arrCat[indexPath.section].sub_category?[indexPath.row]["display_completed"] as? Bool == true {
            cell.lblCompleted.isHidden = false
        } else {
            cell.lblCompleted.isHidden = true
        }
        
        if arrCat[indexPath.section].sub_category?[indexPath.row]["display_target"] as? Bool == false || arrCat[indexPath.section].sub_category?[indexPath.row]["display_completed"] as? Bool == false {
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
        
        if isCompletedSelected {
            headerView.lblCategory.text = arrCat[section].name
            headerView.lblTotal.text = "\(arrCat[section].target ?? 0)"
            headerView.lblCompleted.text = "\(arrCat[section].fill ?? 0)"
        } else {
            
            headerView.lblCategory.text = arrCat[section].name
            headerView.lblTotal.text = "\(arrCat[section].target ?? 0)"
            
            let remain = (arrCat[section].target ?? 0)-(arrCat[section].fill ?? 0)
            
            headerView.lblCompleted.text = "\(remain)"
        }
        headerView.btnTapHeader.tag = section
        headerView.btnTapHeader.addTarget(self, action: #selector(btnTapHeader(sender:)), for: .touchUpInside)
        
        if arrCat[section].is_selectable == true {
            headerView.widthImgTick.constant = 30
        } else {
            headerView.widthImgTick.constant = 0
        }
        if arrCat[section].display_target == true {
            headerView.lblTotal.isHidden = false
        } else {
            headerView.lblTotal.isHidden = true
        }
        if arrCat[section].display_completed == true {
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
