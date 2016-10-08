import UIKit

class SideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet var tableView: UITableView!
    
    var appDelegate: AppDelegate?
    
    init() {
        super.init(nibName: "SideView", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        self.tableView.registerNib(
            UINib(nibName: "SideViewHeaderCell", bundle: nil),
            forCellReuseIdentifier: "SideViewHeaderCell")
        
        self.tableView.registerNib(
            UINib(nibName: "SideViewMenuCell", bundle: nil),
            forCellReuseIdentifier: "SideViewMenuCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 150
        }
        
        return 45
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("SideViewHeaderCell") as! SideViewHeaderCell
        
        cell.backgroundColor = UIColor(red:0, green:0.59, blue:0.53, alpha:1)
        cell.contentView.backgroundColor = UIColor(red:0, green:0.59, blue:0.53, alpha:1)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SideViewMenuCell", forIndexPath: indexPath) as UITableViewCell!
        
        switch(indexPath.row) {
        case 0:
            self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
            
            cell.textLabel?.text = "Home"
            break;

        case 1:
            cell.textLabel?.text = "Workout"
            break;
            
        case 2:
            cell.textLabel?.text = "Workout Log"
            break;
            
        case 3:
            cell.textLabel?.text = "Support Developer"
            break;
            
        case 4:
            cell.textLabel?.text = "Settings"
            break;
            
        default:
            break;
        }
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        switch(indexPath.row) {
//        case 0:
//            appDelegate?.main!.setViewControllers([(appDelegate?.homeViewController)!], animated: false)
//        break;
//        case 1:
//            appDelegate?.main!.setViewControllers([(appDelegate?.workoutViewController)!], animated: false)
//            break;
//        case 2:
//            appDelegate?.main!.setViewControllers([(appDelegate?.workoutLogViewController)!], animated: false)
//            break;
//        case 3:
//            appDelegate?.main!.setViewControllers([(appDelegate?.supportDeveloperViewController)!], animated: false)
//            break;
//        case 4:
//            appDelegate?.main!.setViewControllers([(appDelegate?.settingsViewController)!], animated: false)
//            break;
//        default:
//            break;
//        }
        
//        sideNavigationController?.toggleLeftView()
    }
}