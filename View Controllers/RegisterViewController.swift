//
//  RegisterViewController.swift
//  EFAB
//
//  Created by Sean Crowl on 11/1/16.
//  Copyright © 2016 Interapt. All rights reserved.
//

import UIKit
import MBProgressHUD

class RegisterViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - IBActions
    @IBAction func registerButtonClicked(_ sender: Any) {
        // Validate user input
        guard let username = usernameTextField.text , username != "" else {
            // show error
            let alert = Utils.createAlert("Login Error", message: "Please provide a username", dismissButtonTitle: "Close")
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard let email = emailTextField.text , email != "" && Utils.isValidEmail(email) else {
            present(Utils.createAlert("Login Error", message: "Please provide a valid email address"), animated: true, completion: nil)
            return
        }
        
        guard let password = passwordTextField.text , password != "" else {
            present(Utils.createAlert("Login Error", message: "Please provide a password"), animated: true, completion: nil)
            return
        }
        
        guard let confirm = confirmPasswordTextField.text , password == confirm else {
            present(Utils.createAlert("Login Error", message: "Passwords do not match"), animated: true, completion: nil)
            return
        }
        
        // Going to go ahead with the register
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
        let user = User(username: username, password: password, email: email)
        
        UserStore.shared.register(user) { (success, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if success {
                self.dismiss(animated: true, completion: nil)
            } else if let error = error {
                self.present(Utils.createAlert(message: error), animated: true, completion: nil)
            } else {
                
                self.present(Utils.createAlert(message: Constants.JSON.unknownError), animated: true, completion: nil)
            }
        }
    }
    
}
