//
//  BudgetListViewController.swift
//  EFAB
//
//  Created by Sean Crowl on 11/1/16.
//  Copyright © 2016 Interapt. All rights reserved.
//

import UIKit

class BudgetListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeControl: UISegmentedControl!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !WebServices.shared.userAuthTokenExists() || WebServices.shared.userAuthTokenExpired() {
            performSegue(withIdentifier: "PresentLoginNoAnimation", sender: self)
        }
    }

    
    // MARK: - IBActions
    @IBAction func logoutTapped(_ sender: Any) {
        UserStore.shared.logout {
            self.performSegue(withIdentifier: "PresentLogin", sender: self)
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        print("Back tapped")
    }
    
    @IBAction func forwardTapped(_ sender: Any) {
        print("Forward tapped")
    }
    
    @IBAction func timePeriodChanged(_ sender: Any) {
        print("Period changed")
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

extension BudgetListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
