//
//  Expense.swift
//  EFAB
//
//  Created by Sean Crowl on 11/3/16.
//  Copyright © 2016 Interapt. All rights reserved.
//

import UIKit
import AFDateHelper
import Alamofire
import Freddy

// Step 16: Create class
class Expense: NetworkModel {
    var id: Int?
    var amount: Double?
    var categoryId: Int?
    var date: Date?
    var note: String?
    var categoryName: String?
    var requestType: RequestType = .recent
    
    // Step 19: Add month/year vars
    var month: Int?
    var year: Int?
    
    enum RequestType {
        case create
        // Step 17: Add Recent case
        case recent
        // Step 19: Add Month case
        case month
    }
    
    required init() {}
    
    required init(json: JSON) throws {
        id = try? json.getInt(at: Constants.Expense.id)
        amount = try? json.getDouble(at: Constants.Expense.amount)
        categoryId = try? json.getInt(at: Constants.Expense.categoryId)
        if let dateString = try? json.getString(at: Constants.Expense.date) {
            date = Date(fromString: dateString, format: .iso8601(nil))
        }
        note = try? json.getString(at: Constants.Expense.note)
        categoryName = try? json.getString(at: Constants.Expense.categoryName)
    }
    
    init(amount: Double, categoryId: Int, date: Date, note: String) {
        self.amount = amount
        self.categoryId = categoryId
        self.date = date
        self.note = note
        self.requestType = .create
    }
    
    // Step 17: add category init
    init(categoryId: Int) {
        self.categoryId = categoryId
        self.requestType = .recent
    }
    
    // Step 19: add month/year init
    init (month: Int, year: Int) {
        self.month = month
        self.year = year
        self.requestType = .month
    }
    
    func method() -> Alamofire.HTTPMethod {
        switch requestType {
        case .create:
            return .post
        // Step 17: add default
        default:
            return .get
        }
    }
    
    func path() -> String {
        switch requestType {
        case .create:
            return "/api/expense/createExpense"
        // Step 17: add Recent case
        case .recent:
            return "/api/expense/getExpenses/categoryId/\(categoryId!)"
        // Step 19: add Month case
        case .month:
            return "/api/expense/getExpenses/year/\(year!)/month/\(month!)"
        }
    }
    
    func toDictionary() -> [String: AnyObject]? {
        switch requestType {
        case .create:
            var params: [String: AnyObject] = [:]
            
            params[Constants.Expense.amount] = amount as AnyObject?
            params[Constants.Expense.categoryId] = categoryId as AnyObject?
            params[Constants.Expense.date] = date?.toString(.iso8601(nil)) as AnyObject?
            params[Constants.Expense.note] = note as AnyObject?
            
            return params
        // Step 17: add default
        default:
            return nil
        }
    }
    
    // Step 17: dateString and dateDay functions
    func dateString() -> String {
        if let date = date {
            return date.toString(.custom(Constants.monthDayYear))
        }
        return ""
    }
    
    func dateDay() -> String {
        if let date = date {
            if date.isThisWeek() {
                return date.weekdayToString()
            } else {
                return dateString()
            }
        }
        return ""
    }
}
