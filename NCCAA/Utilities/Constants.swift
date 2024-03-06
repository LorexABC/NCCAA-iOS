//
//  Constants.swift
//
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit



struct URLs {
    static let baseurl = "https://nccaatest1.globaltechkyllc.com/api/"
    
    static let login = baseurl + "auth/login"
    static let blogs = baseurl + "blogs"
    static let announcements = baseurl + "announcements"
    static let practiceTypes = baseurl + "practiceTypes"
    static let employerBenefits = baseurl + "employerBenefits"
    static let retirementPlans = baseurl + "retirementPlans"
    static let specialties = baseurl + "specialties"
    static let anesthesiologyGroups = baseurl + "anesthesiologyGroups"
    static let universities = baseurl + "universities"
    static let personal = baseurl + "users/me/personal"
    static let user_info = baseurl + "users/me"
    static let employer_info = baseurl + "users/me/employer"
    static let categories = baseurl + "categories"
    static let cases = baseurl + "cases"
    static let forgot_password = baseurl + "auth/forgot-password"
    static let otp_resend = baseurl + "auth/otp-resend"
    static let otp_change_password = baseurl + "auth/otp-change-password"
    static let get_clinical = baseurl + "clinical"
    static let clinical_complete = baseurl + "clinical/complete"
    static let psi_fill = baseurl + "users/me/psi"
    static let licensing = baseurl + "users/me/licensing"
    static let cmeCycles = baseurl + "users/me/cmeCycles"
    static let exams = baseurl + "users/me/exams"
    static let uploadFile = baseurl + "users/me/uploads"
    static let receipts = baseurl + "receipts/"
    static let history = baseurl + "history"
    static let get_contact_info = baseurl + "contact/data"
    static let contact_us = baseurl + "contact/question"
    static let delete_Account = baseurl + "auth/delete"
    static let cases_import = baseurl + "cases/import"
    static let cases_export = baseurl + "cases/export"
    static let certificate_pdf = baseurl + "users/me/certificate/pdf"
}

struct Message {
    
    static let fillReqFields = "Please fill required fields"
    static let validEmail = "Please enter valid email"
    static let validPhone = "Please enter valid phone number"
    static let validZip = "Please enter valid Zip code"
    static let passwordMismatch = "Both passwords should be same"
    static let emailMismatch = "Both email should be same"
    static let caaModuleUnavailable = "This module is not available to CAAs"
    static let studentModuleUnavailable = "This module is not available to students"
    static let certificationModuleUnavailable = "This module is no longer available. If you want to view your Certification results and scores, tap the History card/block on the member home page"
    
}


