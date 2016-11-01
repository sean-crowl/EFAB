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
    
    // Request Type
    enum RequestType {
        case getPost
        case getPosts
        case createPost
    }

    var requestType = RequestType.getPost
    
    
    
    // empty constructor
    required init() {}
    
    // create an object from JSON
    required init(json: JSON) throws {
        userId = try? json.getInt(at: Constants.Test.userId)
        id = try? json.getInt(at: Constants.Test.id)
        title = try? json.getString(at: Constants.Test.title)
        body = try? json.getString(at: Constants.Test.body)
    }
    
    // Always return HTTP.GET
    func method() -> Alamofire.HTTPMethod {
        switch requestType {
        case .getPost, .getPosts:
            return .get
        default:
            return .post
        }
    }
    
    // A sample path to a single post
    func path() -> String {
        switch requestType {
        case .getPost:
            return "/posts/1"
        case .getPosts:
            return "/posts"
        case .createPost:
            return "/posts"
        }
    }
    
    // Demo object isn't being posted to a server, so just return nil
    func toDictionary() -> [String : AnyObject]? {
        switch requestType {
        case .createPost:
            var params: [String: AnyObject] = [:]
            
            params[Constants.Test.userId] = userId as AnyObject?? ?? 0 as AnyObject?
            params[Constants.Test.title] = title as AnyObject?? ?? "" as AnyObject?
            params[Constants.Test.body] = body as AnyObject?? ?? "" as AnyObject?
            
            return params
        default:
            return nil
        }
    }
    
    // Helper method for debugging
    func description() -> String {
        var text = ""
        text += "title: \(title ?? "")\n"
        text += "body: \(body ?? "")\n"
        return text
    }
}
