//
//  AddCategoryViewController.swift
//  EFAB
//
//  Created by Sean Crowl on 11/2/16.
//  Copyright © 2016 Interapt. All rights reserved.
//

import UIKit

class AddCategoryViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    
    var currentTextField : UITextField?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func saveTapped(_ sender: Any) {
        saveCategory()
    }
    
    func saveCategory() {
        currentTextField?.resignFirstResponder()
        currentTextField = nil
        
        guard let name = nameField.text , name != "" else {
            present(Utils.createAlert(message: "You must provide a category name"), animated: true, completion: nil)
            return
        }
        
        guard let amount = amountField.text , amount != "" else {
            present(Utils.createAlert(message: "You must provide an amount"), animated: true, completion: nil)
            return
        }
        
        guard let amountNumber = Double(amount) else {
            present(Utils.createAlert(message: "You must provide a valid amount"), animated: true, completion: nil)
            return
        }
        
        let category = Category(name: name, amount: amountNumber)
        WebServices.shared.postObject(category) { (object, error) in
            if let _ = object {
                self.present(Utils.createAlert("Success", message: "Category Created", dismissButtonTitle: "OK"), animated: true, completion: nil)
            } else {
                self.present(Utils.createAlert(message: "There was an error creating your category"), animated: true, completion: nil)
            }
        }
        
    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddCategoryViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            amountField.becomeFirstResponder()
        } else if textField == amountField {
            saveCategory()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == amountField {
            return Utils.isNumber(string)
        }
        return true
    }
}
