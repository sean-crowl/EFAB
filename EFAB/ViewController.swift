//
//  ViewController.swift
//  EFAB
//
//  Created by Sean Crowl on 10/31/16.
//  Copyright © 2016 Interapt. All rights reserved.
//

import UIKit
import Alamofire
import Freddy

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let test = Test()
        print("making call")
        
        request(WebServices.AuthRouter.restRequest(test)).response { (d) in
            let request = d.request
            let response = d.response
            let data = d.data
            let error = d.error
            
            print("call returned")
            if error != nil {
                print("error: \(error)")
            }
                        print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            
            // Step 4: process response
            var testReturn: Test?
            var errorString: String?
            
            let statusCode = response?.statusCode
            if let statusCode = statusCode {
                switch statusCode {
                case 200:
                    if let data = data {
                        do {
                            let json = try JSON(data: data)
                            testReturn = try Test(json: json)
                        } catch {}
                    } else {
                        errorString = Constants.JSON.unknownError
                    }
                case 400:
                    errorString = Constants.JSON.unknownError
                default:
                    errorString = Constants.JSON.unknownError
                }
            }
            
            if let testReturn = testReturn {
                print(testReturn.description())
            } else {
                print(errorString ?? Constants.JSON.unknownError)
            }
        }
        
        print("Request was sent")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

