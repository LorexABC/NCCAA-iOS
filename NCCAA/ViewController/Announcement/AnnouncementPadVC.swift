//
//  AnnouncementPadVC.swift
//  NCCAA
//
//  Created by Apple on 11/07/22.
//

import UIKit

class AnnouncementPadVC: UIViewController {

    // MARK: - Variable
    let refreshControl = UIRefreshControl()
    let arrMenu = ["Announcements","Important Info/Dates","Student Clinical Competencies","Certification Exam","State Licensing Info","View CAA Certificate","CDQ Exam","CME Submissions","Blog","History","Edit Profile","Contact NCCAA"]
//    let arrMenuIcons = ["Frame 52","Frame 52 (1)","Group 35","award","Rubber Stamp","archive-book","teacher","Frame 52 (2)","Frame 52 (3)","Frame 52 (4)","user-edit","Support"]
    let arrMenuIcons = ["Doorbell","Calendar","Upload to Cloud","Document","Rubber Stamp yellow","Diploma","Document_blue","Upload","News","Clock","Settings","Customer Support"]
    var arrAnnouncements:[AnnouncementResponse]?
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableMenu: UITableView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        initialRefresh()
        
    }
    
    
    // MARK: - Function
    func setupUI() {
        lblName.text = "Hello, \(Helper.shared.userName)!"
        table.estimatedRowHeight = 20
        table.rowHeight = UITableView.automaticDimension
        
        //
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        table.addSubview(refreshControl)
    }
    
    func initialRefresh() {
        Helper.shared.showHUD()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.announcementAPI()
        }
        userInfoAPI()
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
    func userInfoAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallPersonalUser(url: URLs.user_info, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            Helper.shared.userType = response.status!
            Helper.shared.userName = response.firstName!
            self.lblName.text = "Hello, \(Helper.shared.userName)!"
            
            if response.isAppLocked == "1" {
            
                
                let alert = UIAlertController(title: "", message: "We are sorry. Both the website and app are under going maintenance. Check back soon. Thanks you!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
                    
                    //
                    UserDefaults.standard.set("", forKey: "access_token")
                    UserDefaults.standard.set(false, forKey: "isLogin")
                    UserDefaults.standard.synchronize()
                    
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        let obj = UIStoryboard(name: "IntroiPad", bundle: nil).instantiateViewController(withIdentifier: "navIntroiPad") as! UINavigationController
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = obj
                    } else {
                        let obj = UIStoryboard(name: "Intro", bundle: nil).instantiateViewController(withIdentifier: "navIntro") as! UINavigationController
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = obj
                    }
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
            //            } else {
            //                Toast.show(message: response.ResponseMsg ?? "", controller: self)
            //            }
            Helper.shared.hideHUD()
        }
    }
    // MARK: - IBAction
    @IBAction func btnNotification(_ sender: Any) {
        
        let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
        let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navAnnouncement") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = obj
    }
    @IBAction func btnLogout(_ sender: Any) {
        
        Helper.shared.logoutFromApp(vc: self)
    }
    
}
extension AnnouncementPadVC:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == table {
            return arrAnnouncements?.count ?? 0
        } else {
            return arrMenu.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == table {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementCell") as! AnnouncementCell
            cell.lblTitle.text = arrAnnouncements?[indexPath.row].subject ?? ""
            cell.lblDesc.text = arrAnnouncements?[indexPath.row].text ?? ""
            let date = Helper.shared.changeStringDateFormat(date: arrAnnouncements?[indexPath.row].date ?? "", toFormat: "MM/dd/yyyy", fromFormat: "yyyy-MM-dd")
            cell.lblDate.text = date
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
            cell.lblTitle.text = arrMenu[indexPath.row]
            cell.img.image = UIImage(named: arrMenuIcons[indexPath.row])
            
            if indexPath.row > 2 {
                cell.lblTitle.textColor = UIColor.lightGray
            } else {
                cell.lblTitle.textColor = UIColor.black
            }
            
            if indexPath.row == 0 {
                cell.viewWithTag(101)?.backgroundColor = #colorLiteral(red: 0.3019607843, green: 0.5215686275, blue: 0.9411764706, alpha: 1)
                cell.lblTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                cell.viewWithTag(101)?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.lblTitle.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tableMenu {
            
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
            if indexPath.row == 7 {
                
                if Helper.shared.userType == "caa" {
                    let mainStoryBoard = UIStoryboard(name: "MainiPad", bundle: nil)
                    let obj = mainStoryBoard.instantiateViewController(withIdentifier: "navCME") as! UINavigationController
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

