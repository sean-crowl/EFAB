import UIKit
import MBProgressHUD

class BudgetListViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeControl: UISegmentedControl!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    let refreshControl = UIRefreshControl()
    var currentDate = Utils.adjustedTime()
    
    let weekIndex = 0
    let monthIndex = 1
    
    var weekCategories: [Date: [Category]] = [:]
    var monthCategories: [Date: [Category]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        refreshControl.addTarget(self, action: #selector(BudgetListViewController.loadCategories), for:
            .valueChanged)
        tableView.addSubview(refreshControl)
        
        dateLabel.text = getDateRange()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !WebServices.shared.userAuthTokenExists() || WebServices.shared.userAuthTokenExpired() {
            
            performSegue(withIdentifier: "PresentLoginNoAnimation", sender: self)
        } else {
            loadCategories()
        }
    }
    
    //Mark: IBActions
    
    @IBAction func logoutTapped(_ sender: Any) {
        UserStore.shared.logout {
            self.performSegue(withIdentifier:"PresentLogin", sender: self)
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        switch timeControl.selectedSegmentIndex {
        case weekIndex:
            currentDate = currentDate.dateBySubtractingDays(7)
        default:
            let day = currentDate.day()
            currentDate = currentDate.dateAtTheStartOfMonth().dateBySubtractingDays(1)
            currentDate = currentDate.dateAtTheStartOfMonth().dateByAddingDays(min(day - 1, currentDate.monthDays() - 1))
        }
        setupDateHeader()
    }
    
    @IBAction func forwardTapped(_ sender: Any) {
        switch timeControl.selectedSegmentIndex {
        case weekIndex:
            currentDate = currentDate.dateByAddingDays(7)
        default:
            let day = currentDate.day()
            currentDate = currentDate.dateAtTheStartOfMonth().dateByAddingDays(currentDate.monthDays())
            currentDate = currentDate.dateByAddingDays(min(day - 1, currentDate.monthDays() - 1))
        }
        setupDateHeader()
    }
    
    @IBAction func timePeriodChanged(_ sender: Any) {
        setupDateHeader()
    }
    
    //Mark: Methods
    func loadCategories() {
        var showSpinner = false
        let category: Category!
        if timeControl.selectedSegmentIndex == weekIndex {
            category = Category(week: currentDate)
            if getCurrentWeek().isEmpty {
                showSpinner = true
            }
        } else {
            category = Category(month: currentDate)
            if getCurrentMonth().isEmpty {
                showSpinner = true
            }
        }
        
        if showSpinner {
            MBProgressHUD.showAdded(to: view, animated: true)
        }
        
        WebServices.shared.getObjects(category) { (objects, error) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refreshControl.endRefreshing()
            if var categories = objects {
                categories.sort(by: { (c1, c2) -> Bool in
                    switch (c1.name, c2.name) {
                    case let (name1?, name2?):
                        return name1 < name2
                    case (nil, _?):
                        return true
                    default:
                        return false
                    }
                })
                if self.timeControl.selectedSegmentIndex == self.weekIndex {
                    self.weekCategories[self.currentDate.dateAtStartOfWeek().dateAtStartOfDay()] = categories
                } else {
                    self.monthCategories[self.currentDate.dateAtTheStartOfMonth().dateAtStartOfDay()] = categories
                }
                self.tableView.reloadData()
            } else {
                self.present(Utils.createAlert(message: error ?? Constants.JSON.unknownError), animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func getDateRange() -> String {
        let timePeriod = timeControl.selectedSegmentIndex
        switch timePeriod {
        case weekIndex:
            let startDate = currentDate.dateAtStartOfWeek()
            let endDate = currentDate.dateAtEndOfWeek()
            let startMonth = startDate.toString(.custom("MMM"))
            let endMonth = endDate.toString(.custom("MMM"))
            if startDate.year() == endDate.year() {
                if startDate.month() == endDate.month() {
                    return "\(startMonth) \(startDate.day()) - \(endDate.day()), \(startDate.year())"
                } else {
                    return "\(startMonth) \(startDate.day()) - \(endMonth) \(endDate.day()), \(startDate.year())"
                }
            } else {
                return "\(startMonth) \(startDate.day()), \(startDate.year()) - \(endMonth) \(endDate.day()), \(endDate.year())"
            }
        default:
            return "\(currentDate.toString(.custom("MMM"))) \(currentDate.year())"
        }
    }
    
    fileprivate func setupDateHeader() {
        switch timeControl.selectedSegmentIndex {
        case weekIndex:
            if currentDate.isSameWeekAsDate(Date()) {
                currentDate = Utils.adjustedTime()
            }
            
            if !getCurrentWeek().isEmpty {
                tableView.reloadData()
            }
        default:
            if currentDate.month() == Date().month() && currentDate.year() == Date().year() {
                currentDate = Utils.adjustedTime()
            }
            
            if !getCurrentMonth().isEmpty {
                tableView.reloadData()
            }
        }
        dateLabel.text = getDateRange()
        loadCategories()
    }
    
    fileprivate func getCurrentWeek() -> [Category] {
        return weekCategories[currentDate.dateAtStartOfWeek().dateAtStartOfDay()] ?? []
    }
    
    fileprivate func getCurrentMonth() -> [Category] {
        return monthCategories[currentDate.dateAtTheStartOfMonth().dateAtStartOfDay()] ?? []
    }
    
    fileprivate func getCategories() -> [Category] {
        if timeControl.selectedSegmentIndex == weekIndex {
            return getCurrentWeek()
        }else {
            return getCurrentMonth()
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

extension BudgetListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let categories = getCategories()
        return categories.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CategoryCell.self)) as! CategoryCell
        
        let categories = getCategories()
        
        if (indexPath as NSIndexPath).row < categories.count {
            let category = categories[(indexPath as NSIndexPath).row]
            
            cell.setupCell(category, total: false)
        } else {
            let category = Category()
            category.name = "\(timeControl.titleForSegment(at: timeControl.selectedSegmentIndex)!) Total"
            category.amount = categories.reduce(0.0) { $0 +++ $1.amount }
            cell.setupCell(category, total: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}


// Step 14: Custom operator for summing categories
infix operator +++
func +++ (a: Double?, b: Double?) -> Double {
    return (a ?? 0) + (b ?? 0)
}
