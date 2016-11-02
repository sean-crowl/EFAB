//
//  User.swift
//  EFAB
//
//  Created by TEKYAdmin on 11/2/16.
//  Copyright © 2016 EFA. All rights reserved.
//
//
//  Test.swift
//  EFAB
//
//  Created by Terrence Kunstek on 10/31/16.
//  Copyright © 2016 EFA. All rights reserved.
//

import Foundation
import Alamofire
import Freddy

// Just a test object to excercise the network stack
class User : NetworkModel {
    /*
     "username": "string",
     "password": "string",
     "email": "string"
     "token": "string",
     "expiration": "2016-11-01T20:58:52.318Z"
     */
    
    var id : Int?
    var username : String?
    var password : String?
    var email : String?
    var token : String?
    var expiration : String?
    
    // Request Type
    enum RequestType {
        case login
        case register
    }
    var requestType = RequestType.login
    
    
    // empty constructor
    required init() {}
    
    // create an object from JSON
    required init(json: JSON) throws {
        token = try? json.getString(at: Constants.BudgetUser.token)
        expiration = try? json.getString(at: Constants.BudgetUser.expirationDate)
    }
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
        requestType = .login
    }
    
    init(username: String, password: String, email: String) {
        self.username = username
        self.password = password
        self.email = email
        requestType = .register
    }
    
    init(id: Int) {
        self.id = id
    }
    
    // Always return HTTP.GET
    func method() -> Alamofire.HTTPMethod {
        return .post
    }
    
    // A sample path to a single post
    func path() -> String {
        switch requestType {
        case .login:
            return "/auth"
        case .register:
            return "/register"
        }
    }
    
    // Demo object isn't being posted to a server, so just return nil
    func toDictionary() -> [String: AnyObject]? {
        
        var params: [String: AnyObject] = [:]
        params[Constants.BudgetUser.username] = username as AnyObject?
        params[Constants.BudgetUser.password] = password as AnyObject?
        
        
        switch requestType {
        case .register:
            params[Constants.BudgetUser.email] = email as AnyObject?
        default:
            break
        }
        
        return params
    }
    
}
