//
//  Test.swift
//  EFAB
//
//  Created by Sean Crowl on 10/31/16.
//  Copyright © 2016 Interapt. All rights reserved.
//

import Foundation
import Alamofire
import Freddy

class Test : NetworkModel {
    var userId : Int?
    var id : Int?
    var title : String?
    var body : String?
    
    required init() {}
    
    required init(json: JSON) throws {
        userId = try? json.getInt(at: Constants.Test.userId)
        id = try? json.getInt(at: Constants.Test.id)
        title = try? json.getString(at: Constants.Test.title)
        body = try? json.getString(at: Constants.Test.body)
    }
    
    func method() -> Alamofire.HTTPMethod {
        return .get
    }
    
    func path() -> String {
        return "/posts/1"
    }
    
    func toDictionary() -> [String : AnyObject]? {
        return nil
    }
    
    func description() -> String {
        var text = ""
        text += "title: \(title ?? "")\n"
        text += "body: \(body ?? "")\n"
        return text
    }
}
