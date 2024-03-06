//
//  BlogVC.swift
//  NCCAA
//
//  Created by Apple on 16/07/22.
//

import UIKit

class BlogVC: UIViewController {
    
    // MARK: - Variable
    var arrBlogs:[BlogResponse]?
    let refreshControl = UIRefreshControl()
    
    // MARK: - IBOutlet
    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        initialRefresh()
    }
    
    
    // MARK: - Function
    func setupUI() {
        
        table.estimatedRowHeight = 20
        table.rowHeight = UITableView.automaticDimension
        
        //
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        table.addSubview(refreshControl)
    }
    func initialRefresh() {
        
        blogsAPI()
    }
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        
        initialRefresh()
        refreshControl.endRefreshing()
    }
    // MARK: - Webservice
    
    func blogsAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallBlogs(url: URLs.blogs, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
                
                //print(response)
                
                self.arrBlogs = response
                self.table.reloadData()
                
//            } else {
//                Toast.show(message: response.ResponseMsg ?? "", controller: self)
//            }
            Helper.shared.hideHUD()
        }
    }
    
    // MARK: - IBAction
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnLogout(_ sender: Any) {
        
        Helper.shared.logoutFromApp(vc: self)
    }
}
extension BlogVC:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrBlogs?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlogCell") as! BlogCell
        cell.lblTitle.text = arrBlogs?[indexPath.row].subject ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "BlogDetailsVC") as! BlogDetailsVC
        obj.dict = arrBlogs?[indexPath.row]
        navigationController?.pushViewController(obj, animated: true)
    }
    
}
