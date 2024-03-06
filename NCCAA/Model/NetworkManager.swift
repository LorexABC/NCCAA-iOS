//
//  NetworkManager.swift
//  Snagpay
//
//  Created by Apple on 01/03/21.
//

import UIKit
import AlamofireObjectMapper
import Alamofire

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    
    func webserviceCallCommon(url:String, parameters:[String:Any], headers:HTTPHeaders, completion:@escaping (CommonResponse)->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseObject { (response: DataResponse<CommonResponse>) in
                
                print("URL:\(url) PARAM:\(parameters)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value!)
                } else {
                    
                }
            }
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    func webserviceCallCommonPostMethod(url:String, parameters:[String:Any], headers:HTTPHeaders, completion:@escaping ([String:Any])->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                
                print("URL:\(url) PARAM:\(parameters)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value! as! [String : Any])
                } else {
                    
                }
            }
            
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    func webserviceCallCommonGetMethod(url:String, headers:HTTPHeaders, completion:@escaping ([String:Any])->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                
                print("URL:\(url)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value! as! [String : Any])
                } else {
                    
                }
            }
            
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    func webserviceCallEditCase(url:String, parameters:[String:Any], headers:HTTPHeaders, completion:@escaping (CommonResponse)->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .patch, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseObject { (response: DataResponse<CommonResponse>) in
                
                print("URL:\(url) PARAM:\(parameters)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value!)
                } else {
                    
                }
            }
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    func webserviceCallDeleteCase(url:String, headers:HTTPHeaders, completion:@escaping (CommonResponse)->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .delete, encoding: URLEncoding.default, headers: headers).responseObject { (response: DataResponse<CommonResponse>) in
                
                print("URL:\(url)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value!)
                } else {
                    
                }
            }
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    func webserviceCallLogin(url:String, parameters:[String:Any], headers:HTTPHeaders, completion:@escaping (LoginResponse)->()) {

        if Reachability.isConnectedToNetwork(){

            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseObject { (response: DataResponse<LoginResponse>) in

                print("URL:\(url) PARAM:\(parameters)")
                print(response.result.value as Any)
                if let _ = response.result.value {

                    completion(response.result.value!)
                } else {

                }
            }
        }else{
            print("Internet Connection not Available!")
        }

    }
    func webserviceCallBlogs(url:String, headers:HTTPHeaders, completion:@escaping ([BlogResponse])->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseArray { (response: DataResponse<[BlogResponse]>) in
                
                print("URL:\(url)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value!)
                } else {
                    
                }
            }
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    
    func webserviceCallAnnouncements(url:String, headers:HTTPHeaders, completion:@escaping ([AnnouncementResponse])->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseArray { (response: DataResponse<[AnnouncementResponse]>) in
                
                print("URL:\(url)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value!)
                } else {
                    
                }
            }
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    
    func webserviceCallEditProfileFields(url:String, headers:HTTPHeaders, completion:@escaping ([EditProfileFieldsResponse])->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseArray { (response: DataResponse<[EditProfileFieldsResponse]>) in
                
                print("URL:\(url)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value!)
                } else {
                    
                }
            }
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    func webserviceCallPersonalUser(url:String, headers:HTTPHeaders, completion:@escaping (PersonalUserResponse)->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseObject { (response: DataResponse<PersonalUserResponse>) in
                
                print("URL:\(url)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value!)
                } else {
                    
                }
            }
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    func webserviceCallEmployerInfo(url:String, headers:HTTPHeaders, completion:@escaping (EmployerInfoResponse)->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseObject { (response: DataResponse<EmployerInfoResponse>) in
                
                print("URL:\(url)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value!)
                } else {
                    
                }
            }
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    func webserviceCallUpdateEmployerInfo(url:String, parameters:[String:Any], headers:HTTPHeaders, completion:@escaping ([String:Any])->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                
                print("URL:\(url) PARAM:\(parameters)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value! as! [String : Any])
                } else {
                    
                }
            }
            
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    
    func webserviceCallCases(url:String, headers:HTTPHeaders, completion:@escaping (CasesResponse)->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseObject { (response: DataResponse<CasesResponse>) in
                
                print("URL:\(url)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value!)
                } else {
                    
                }
            }
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    func webserviceCallCategories(url:String, headers:HTTPHeaders, completion:@escaping (CategoriesResponse)->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseObject { (response: DataResponse<CategoriesResponse>) in
                
                print("URL:\(url)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value!)
                } else {
                    
                }
            }
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    
    func webserviceCallUpdatePersonalInfo(url:String, parameters:[String:Any], headers:HTTPHeaders, completion:@escaping ([String:Any])->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                
                print("URL:\(url) PARAM:\(parameters)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value! as! [String : Any])
                } else {
                    
                }
            }
            
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    
    func webserviceCallStateLicensing(url:String, parameters:[String:Any], headers:HTTPHeaders, completion:@escaping ([String:Any])->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                
                print("URL:\(url) PARAM:\(parameters)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value! as! [String : Any])
                } else {
                    
                }
            }
            
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    func webserviceCallGetExams(url:String, headers:HTTPHeaders, completion:@escaping ([[String:Any]])->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                
                print("URL:\(url)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value! as! [[String : Any]])
                } else {
                    
                }
            }
            
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    func webserviceCallGetHistory(url:String, headers:HTTPHeaders, completion:@escaping ([[String:Any]])->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                
                print("URL:\(url)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value! as! [[String : Any]])
                } else {
                    
                }
            }
            
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    func webserviceCallGetCMECycles(url:String, headers:HTTPHeaders, completion:@escaping ([[String:Any]])->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                
                print("URL:\(url)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value! as! [[String : Any]])
                } else {
                    
                }
            }
            
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    func webserviceCallAddDocument(url:String, parameters:[String:String], docData:Data, fileName:String, headers:HTTPHeaders, completion:@escaping ([String:Any])->()){
        

        if Reachability.isConnectedToNetwork() {

            Alamofire.upload(multipartFormData: { multipartFormData in
                    //loop this "multipartFormData" and make the key as array data
                    multipartFormData.append(docData, withName: "file",fileName: fileName, mimeType: "image/jpg")
                    
                    for (key, value) in parameters {
                        multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                        } //Optional for extra parameters
                },
            to:url,headers: headers)
            { (result) in
                switch result {
                case .success(let upload, _, _):

                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })

                    upload.responseJSON { response in
                        print(response.result.value)
                        if let _ = response.result.value {
                            
                            completion(response.result.value as! [String : Any])
                        } else {
                            
                        }
                    }

                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        } else{
            print("Internet Connection not Available!")
        }
        
    }
    func webserviceCallCreateCMECycle(url:String, parameters:[String:Any], headers:HTTPHeaders, completion:@escaping ([String:Any])->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                
                print("URL:\(url) PARAM:\(parameters)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value! as! [String : Any])
                } else {
                    
                }
            }
            
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    func webserviceCallUpdateCMECycle(url:String, parameters:[String:Any], headers:HTTPHeaders, completion:@escaping ([String:Any])->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                
                print("URL:\(url) PARAM:\(parameters)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value! as! [String : Any])
                } else {
                    
                }
            }
            
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    func webserviceCallDeleteCMECycle(url:String, headers:HTTPHeaders, completion:@escaping ([String:Any])->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .delete, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                
                print("URL:\(url)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value! as! [String : Any])
                } else {
                    
                }
            }
            
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    func webserviceCallContactUs(url:String, parameters:[String:Any], headers:HTTPHeaders, completion:@escaping ([String:Any])->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                
                print("URL:\(url) PARAM:\(parameters)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value! as! [String : Any])
                } else {
                    
                }
            }
            
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    func webserviceCallFillPSI(url:String, parameters:[String:Any], headers:HTTPHeaders, completion:@escaping ([String:Any])->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                
                print("URL:\(url) PARAM:\(parameters)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value! as! [String : Any])
                } else {
                    
                }
            }
            
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    func webserviceCallPayment(url:String, parameters:[String:Any], headers:HTTPHeaders, completion:@escaping ([String:Any])->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                
                print("URL:\(url) PARAM:\(parameters)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value! as! [String : Any])
                } else {
                    
                }
            }
            
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    func webserviceCallGetUploadedFile(url:String, headers:HTTPHeaders, completion:@escaping ([String:Any])->()) {
        
        if Reachability.isConnectedToNetwork(){
            
            Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                
                print("URL:\(url)")
                print(response.result.value as Any)
                if let _ = response.result.value {
                    
                    completion(response.result.value! as! [String : Any])
                } else {
                    
                }
            }
            
        }else{
            print("Internet Connection not Available!")
        }
        
    }
    func webserviceCallAddExcelDocument(url:String, parameters:[String:String], docData:Data, fileName:String, headers:HTTPHeaders, completion:@escaping ([String:Any])->()){
        

        if Reachability.isConnectedToNetwork() {

            Alamofire.upload(multipartFormData: { multipartFormData in
                    //loop this "multipartFormData" and make the key as array data
                    multipartFormData.append(docData, withName: "file",fileName: fileName, mimeType: "application/vnd.ms-excel")
                    
                    for (key, value) in parameters {
                        multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                        } //Optional for extra parameters
                },
            to:url,headers: headers)
            { (result) in
                switch result {
                case .success(let upload, _, _):

                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })

                    upload.responseJSON { response in
                        print(response.result.value)
                        if let _ = response.result.value {
                            
                            completion(response.result.value as! [String : Any])
                        } else {
                            
                        }
                    }

                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        } else{
            print("Internet Connection not Available!")
        }
        
    }
}
