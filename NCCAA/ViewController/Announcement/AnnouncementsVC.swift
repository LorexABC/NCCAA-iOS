//
//  AnnouncementsVC.swift
//  NCCAA
//
//  Created by Apple on 08/07/22.
//

import UIKit

class AnnouncementsVC: UIViewController {
    
    // MARK: - Variable
    var arrAnnouncements:[AnnouncementResponse]?
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
        
        announcementAPI()
    }
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        
        initialRefresh()
        refreshControl.endRefreshing()
    }
    // MARK: - Webservice
    func announcementAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallAnnouncements(url: URLs.announcements, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
                
                //print(response)
                
                self.arrAnnouncements = response
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
extension AnnouncementsVC:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrAnnouncements?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementCell") as! AnnouncementCell
        cell.lblTitle.text = arrAnnouncements?[indexPath.row].subject ?? ""
        cell.lblDesc.text = arrAnnouncements?[indexPath.row].text ?? ""
        
        let date = Helper.shared.changeStringDateFormat(date: arrAnnouncements?[indexPath.row].date ?? "", toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
        cell.lblDate.text = date
        return cell
    }
    
}

