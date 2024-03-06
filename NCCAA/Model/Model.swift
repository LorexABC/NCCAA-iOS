//
//  Model.swift
//  Snagpay
//
//  Created by Apple on 01/03/21.
//

import UIKit
import ObjectMapper



class TopicsData: Mappable {
    
    var topic_id:Int?
    var topic:String?
    var definition:String?
    var view_sources:String?
    var keywords:String?
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        topic_id <- map["topic_id"]
        topic <- map["topic"]
        definition <- map["definition"]
        view_sources <- map["view_sources"]
        keywords <- map["keywords"]
    }
    
}
class VersesData: Mappable {
    
    var verse_id:Int?
    var topic_id:Int?
    var verse:String?
    var priority:Int?
    var description:String?
    var meaning_context:String?
    var chapter:String?
    var is_like:Int?
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        verse_id <- map["verse_id"]
        topic_id <- map["topic_id"]
        verse <- map["verse"]
        priority <- map["priority"]
        description <- map["description"]
        meaning_context <- map["meaning_context"]
        chapter <- map["chapter"]
        is_like <- map["is_like"]
    }
    
}
class UserData: Mappable {
    
    var user_id:Int?
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        
    }
    
}
class CategoryData: Mappable {
    
    var id:Int?
    var fill:Int?
    var name:String?
    var description:String?
    var target:Int?
    var fill_from_subcategory:Int?
    var sub_category:[[String:Any]]?
    var is_selectable:Bool?
    var display_target:Bool?
    var display_completed:Bool?
    var select_multiple:Bool?
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        id <- map["id"]
        fill <- map["fill"]
        name <- map["name"]
        description <- map["description"]
        target <- map["target"]
        fill_from_subcategory <- map["fill_from_subcategory"]
        sub_category <- map["sub_category"]
        is_selectable <- map["is_selectable"]
        display_target <- map["display_target"]
        display_completed <- map["display_completed"]
        select_multiple <- map["select_multiple"]
    }
    
}
