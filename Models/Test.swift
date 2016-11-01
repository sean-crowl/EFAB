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

// Just a test object to exercise the network stack
class Test : NetworkModel {
    // properties we got from http://jsonplaceholder.typicode.com/posts
    var userId : Int?
    var id : Int?
    var title : String?
    var body : String?
    
    // empty constructor
    required init() {}
    
    // create an object from JSON
    required init(json: JSON) throws {
        userId = try? json.getInt(at: Constants.Test.userId)
        id = try? json.getInt(at: Constants.Test.id)
        title = try? json.getString(at: Constants.Test.title)
        body = try? json.getString(at: Constants.Test.body)
    }
    
    // Alwayss return HTTP.GET
    func method() -> Alamofire.HTTPMethod {
        return .get
    }
    
    // A sample path to a single post
    func path() -> String {
        return "/posts/1"
    }
    
    // Demo object isn't being posted to a server, so just return nil
    func toDictionary() -> [String : AnyObject]? {
        return nil
    }
    
    // Helper method for debugging
    func description() -> String {
        var text = ""
        text += "title: \(title ?? "")\n"
        text += "body: \(body ?? "")\n"
        return text
    }
}
