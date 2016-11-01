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
        
        print("starting call")
        WebServices.shared.getObject(test) { (object, error) in
            print("call returned")
            if let object = object {
                print(object.description())
            } else {
                print (error ?? Constants.JSON.unknownError)
            }
        }
        print("call made")
    }
    
}
