//
//  HomeVC.swift
//  NCCAA
//
//  Created by Apple on 11/07/22.
//

import UIKit


class HomeVC: UIViewController {

    // MARK: - Variable
    let arrTitle = ["Announcements","Important Info/Dates","Student Clinical Competencies","Certification Exam","State Licensing Info","View CAA Certificate","CDQ Exam","CME Submissions","Blog","History","Edit Profile","Contact NCCAA"]
    let arrImg = ["Doorbell","Calendar","Upload to Cloud","Document","Rubber Stamp yellow","Diploma","Document_blue","Upload","News","Clock","Settings","Customer Support"]
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var collview: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        userInfoAPI()
    }
    

    // MARK: - Function
    func setupUI() {
        
        lblName.text = "Hello, \(Helper.shared.userName)!"
    }
    // MARK: - Webservice
    func userInfoAPI() {
        
        Helper.shared.showHUD()
        
        let headers = ["Accept":"application/json",
                       "Authorization":"Bearer \(Helper.shared.access_token)"]
        
        NetworkManager.shared.webserviceCallPersonalUser(url: URLs.user_info, headers:headers) { (response) in
            
            //if response.ResponseCode == 200 {
            
            //print(response)
            
            Helper.shared.userType = response.status!
            Helper.shared.userName = response.firstName!
            self.lblName.text = "Hello, \(Helper.shared.userName.capitalizingFirstLetter())!"
            
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
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "AnnouncementsVC") as! AnnouncementsVC
        navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnLogout(_ sender: Any) {
        
        Helper.shared.logoutFromApp(vc: self)
    }
    
    
    
    
}
extension HomeVC:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.img.image = UIImage(named: arrImg[indexPath.row])
        cell.lblTitle.text = arrTitle[indexPath.row]
        
        DispatchQueue.main.async {
            cell.viewBg.dropShadow()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "AnnouncementsVC") as! AnnouncementsVC
            navigationController?.pushViewController(obj, animated: true)
        }
        if indexPath.row == 1 {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ImportantDatesInfoVC") as! ImportantDatesInfoVC
            navigationController?.pushViewController(obj, animated: true)
        }
        if indexPath.row == 2 {
            
            if Helper.shared.userType == "student" {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "ClinicalCompetenciesVC") as! ClinicalCompetenciesVC
                navigationController?.pushViewController(obj, animated: true)
                
                // Toast.show(message: "This module will not be available until 2024.", controller: self)
            } else {
                Toast.show(message: Message.caaModuleUnavailable, controller: self)
            }
            
        }
        if indexPath.row == 3 {
            
            if Helper.shared.userType == "student" {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "CertificationVC") as! CertificationVC
                navigationController?.pushViewController(obj, animated: true)
            } else {
                Toast.show(message: Message.certificationModuleUnavailable, controller: self)
            }
            
        }
        if indexPath.row == 4 {
            
            if Helper.shared.userType == "caa" {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "StateLicensingVC") as! StateLicensingVC
                navigationController?.pushViewController(obj, animated: true)
            } else {
                Toast.show(message: Message.studentModuleUnavailable, controller: self)
            }
            
        }
        if indexPath.row == 5 {
            
            if Helper.shared.userType == "caa" {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "CAACertificateVC") as! CAACertificateVC
                navigationController?.pushViewController(obj, animated: true)
            } else {
                Toast.show(message: Message.studentModuleUnavailable, controller: self)
            }
            
        }
        if indexPath.row == 6 {
            if Helper.shared.userType == "caa" {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "CDQExamVC") as! CDQExamVC
                navigationController?.pushViewController(obj, animated: true)
            } else {
                Toast.show(message: Message.studentModuleUnavailable, controller: self)
            }
        }
        if indexPath.row == 7 {
            
            if Helper.shared.userType == "caa" {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "CMESubmissionVC") as! CMESubmissionVC
                navigationController?.pushViewController(obj, animated: true)
            } else {
                Toast.show(message: Message.studentModuleUnavailable, controller: self)
            }
        }
        if indexPath.row == 8 {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "BlogVC") as! BlogVC
            navigationController?.pushViewController(obj, animated: true)
        }
        if indexPath.row == 9 {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
            navigationController?.pushViewController(obj, animated: true)
        }
        if indexPath.row == 10 {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "PersonalInfoVC") as! PersonalInfoVC
            navigationController?.pushViewController(obj, animated: true)
        }
        if indexPath.row == 11 {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ContactVC") as! ContactVC
            navigationController?.pushViewController(obj, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.width/2)-4, height: 130)
    }
}

