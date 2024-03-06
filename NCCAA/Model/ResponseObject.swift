//
//  ResponseObject.swift
//  Snagpay
//
//  Created by Apple on 01/03/21.
//

import UIKit
import ObjectMapper

class CommonResponse: Mappable {
    
    var ResponseMsg:String?
    var ResponseCode:Int?
    var data:[String:Any]?
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        ResponseMsg <- map["ResponseMsg"]
        ResponseCode <- map["ResponseCode"]
        data <- map["data"]
    }
    
}
class LoginResponse: Mappable {
    
    var access_token:String?
    var error:String?
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        access_token <- map["access_token"]
        error <- map["error"]
    }
    
}
class BlogResponse: Mappable {
    
    var id:String?
    var date:String?
    var subject:String?
    var htmlContent:String?
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        id <- map["id"]
        date <- map["date"]
        subject <- map["subject"]
        htmlContent <- map["htmlContent"]
    }
    
}
class AnnouncementResponse: Mappable {
    
    var id:String?
    var date:String?
    var subject:String?
    var text:String?
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        id <- map["id"]
        date <- map["date"]
        subject <- map["subject"]
        text <- map["text"]
    }
    
}

class EditProfileFieldsResponse: Mappable {
    
    var id:Int?
    var group:Int?
    var name:String?
    var code:String?
    var type:String?
    var fields:[[String:Any]]?
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        id <- map["id"]
        group <- map["group"]
        name <- map["name"]
        code <- map["code"]
        type <- map["type"]
        fields <- map["fields"]
    }
    
}
class PersonalUserResponse: Mappable {
    
    var id:Int?
    var universityId:Int?
    var degree:String?
    var title:String?
    var suffix:String?
    var gender:String?
    var dateOfBirth:String?
    var race:String?
    var ethnicity:String?
    var otherEthnicity:String?
    var maritalStatus:String?
    var phone:String?
    var address:String?
    var otherPhone:String?
    var city:String?
    var state:String?
    var zipCode:String?
    var firstName:String?
    var middleName:String?
    var lastName:String?
    var email:String?
    var status:String?
    var graduationDate:String?
    var firstYear:Int?
    var program:String?
    var psiFilled:Bool?
    var certificationDueDate:String?
    var cdqDueDate:String?
    var graduationYear:Int?
    var account:String?
    var certificateNumber:Int?
    var certifiedThrough:String?
    var designation:String?
    var cmeDueDate:String?
    var clinicalsCompleted:String?
    var scienceExamDueDate:String?
    var isAppLocked:String?
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        id <- map["id"]
        universityId <- map["universityId"]
        degree <- map["degree"]
        title <- map["title"]
        suffix <- map["suffix"]
        gender <- map["gender"]
        dateOfBirth <- map["dateOfBirth"]
        race <- map["race"]
        ethnicity <- map["ethnicity"]
        otherEthnicity <- map["otherEthnicity"]
        maritalStatus <- map["maritalStatus"]
        phone <- map["phone"]
        address <- map["address"]
        otherPhone <- map["otherPhone"]
        city <- map["city"]
        state <- map["state"]
        zipCode <- map["zipCode"]
        firstName <- map["firstName"]
        middleName <- map["middleName"]
        lastName <- map["lastName"]
        email <- map["email"]
        status <- map["status"]
        graduationDate <- map["graduationDate"]
        firstYear <- map["firstYear"]
        program <- map["program"]
        psiFilled <- map["psiFilled"]
        certificationDueDate <- map["certificationDueDate"]
        cdqDueDate <- map["cdqDueDate"]
        graduationYear <- map["graduationYear"]
        account <- map["account"]
        certificateNumber <- map["certificateNumber"]
        certifiedThrough <- map["certifiedThrough"]
        designation <- map["designation"]
        cmeDueDate <- map["cmeDueDate"]
        clinicalsCompleted <- map["clinicalsCompleted"]
        scienceExamDueDate <- map["scienceExamDueDate"]
        isAppLocked <- map["isAppLocked"]
    }
    
}


class EmployerInfoResponse: Mappable {
    
    var firstEmployment:String?
    var employerStatus:String?
    var statesEligible:[String]?
    var name:String?
    var address:String?
    var aptOrSuite:String?
    var city:String?
    var state:String?
    var zipCode:String?
    var practiceTypeCodesGroup1:[String]?
    var group1Other:String?
    var practiceTypeCodesGroup2:[String]?
    var group2Other:String?
    var compensation:String?
    var overtime:Bool?
    var overtimeReceived:String?
    var workSchedule:String?
    var workScheduleOther:String?
    var workingHours:String?
    var workingHoursDistribution:[Any]?
    var employerBenefits:[String]?
    var employerBenefitOther:String?
    var retirementDate:String?
    var retirementPlan:[[String:Any]]?
    var languagesSpoken:Int?
    var useOtherLanguages:Bool?
    var teaches:[String]?
    var specialties:[String]?
    var specialtyOther:String?
    var belongsToAaaaGroups:[String]?
    var belongsToAsaGroups:[String]?
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        firstEmployment <- map["firstEmployment"]
        employerStatus <- map["employerStatus"]
        statesEligible <- map["statesEligible"]
        name <- map["name"]
        address <- map["address"]
        aptOrSuite <- map["aptOrSuite"]
        city <- map["city"]
        state <- map["state"]
        zipCode <- map["zipCode"]
        practiceTypeCodesGroup1 <- map["practiceTypeCodesGroup1"]
        group1Other <- map["group1Other"]
        practiceTypeCodesGroup2 <- map["practiceTypeCodesGroup2"]
        group2Other <- map["group2Other"]
        compensation <- map["compensation"]
        overtime <- map["overtime"]
        overtimeReceived <- map["overtimeReceived"]
        workSchedule <- map["workSchedule"]
        workScheduleOther <- map["workScheduleOther"]
        workingHours <- map["workingHours"]
        workingHoursDistribution <- map["workingHoursDistribution"]
        employerBenefits <- map["employerBenefits"]
        employerBenefitOther <- map["employerBenefitOther"]
        retirementDate <- map["retirementDate"]
        retirementPlan <- map["retirementPlan"]
        languagesSpoken <- map["languagesSpoken"]
        useOtherLanguages <- map["useOtherLanguages"]
        teaches <- map["teaches"]
        specialties <- map["specialties"]
        specialtyOther <- map["specialtyOther"]
        belongsToAaaaGroups <- map["belongsToAaaaGroups"]
        belongsToAsaGroups <- map["belongsToAsaGroups"]
    }
    
}
class CasesResponse: Mappable {
    
    var data:[[String:Any]]?
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        data <- map["data"]
        
    }
    
}
class CategoriesResponse: Mappable {
    
    var data:[CategoryData]?
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        data <- map["data"]
        
    }
    
}
