import UIKit
import RealmSwift
import JTAppleCalendar

class WorkoutLogViewController: UIViewController {
    var numberOfRows = 1

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var tableView: UITableView!

    var date: Date = Date()
    var routines: Results<RepositoryRoutine>?

    let formatter = DateFormatter()
    var testCalendar: Calendar! = Calendar.current

    override func viewDidLoad() {
        let border = CALayer()
        let width = CGFloat(0.5)

        border.borderColor = UIColor(
            red: 70.0/255.0,
            green: 70.0/255.0,
            blue: 80.0/255.0,
            alpha: 1.0
        ).cgColor
        
        border.frame = CGRect(
                x: 0,
                y: self.backgroundView.frame.size.height - width,
                width:  self.backgroundView.frame.size.width,
                height: self.backgroundView.frame.size.height)

        border.borderWidth = width

        self.backgroundView.layer.addSublayer(border)
        self.backgroundView.layer.masksToBounds = true

        self.tableView.register(
                UINib(nibName: "WorkoutLogSectionCell", bundle: nil),
                forCellReuseIdentifier: "WorkoutLogSectionCell")

        self.tableView.register(
                UINib(nibName: "WorkoutLogCardCell", bundle: nil),
                forCellReuseIdentifier: "WorkoutLogCardCell")

        self.tableView.delegate = self
        tableView.dataSource = self

        formatter.dateFormat = "yyyy MM dd"
        testCalendar.timeZone = TimeZone(abbreviation: "GMT")!

        self.calendarView.calendarDelegate = self
        self.calendarView.calendarDataSource = self
        self.calendarView.allowsMultipleSelection = false
        self.calendarView.scrollingMode = .stopAtEachCalendarFrameWidth
        self.calendarView.isRangeSelectionUsed = false
        self.calendarView.reloadData()

        self.calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: false, animateScroll: false) {
            self.calendarView.selectDates([Date()])
        }
    }
    
    func toggleCurrentDayView(_ sender: UIBarButtonItem) {
        self.calendarView.scrollToDate(Date(), animateScroll: false)
        self.calendarView.selectDates([Date()])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.tabBarController?.navigationItem.titleView = nil
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(named: "calendar"),
                landscapeImagePhone: nil,
                style: .plain,
                target: self,
                action: #selector(toggleCurrentDayView))

        self.showOrHideCardViewForDate(date)
    }

    func showOrHideCardViewForDate(_ date: Date) {
        self.date = date

        self.navigationItem.title = date.commonDescription
        
        let routines = RepositoryStream.sharedInstance.getRoutinesForDate(date)
        if (routines.count > 0) {
            self.routines = routines
            self.tableView?.backgroundView = nil
        } else {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))

            label.text = "When you log a workout, you'll see it here."
            label.font = UIFont(name: "Helvetica Neue", size: 15)
            label.textAlignment = .center
            label.sizeToFit()

            self.routines = nil
            self.tableView?.backgroundView = label
        }

        self.tableView.reloadData()
    }
}

extension WorkoutLogViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = self.routines {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let routines = self.routines {
            return routines.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutLogSectionCell") as! WorkoutLogSectionCell
        
        cell.title.text = "Workout Log"
        
        cell.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.97, alpha:1.00)
        cell.contentView.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.97, alpha:1.00)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutLogCardCell", for: indexPath) as! WorkoutLogCardCell
        
        if let routines = self.routines {
            let repositoryRoutine = routines[indexPath.row]
            let completionRate = RepositoryRoutineHelper.getCompletionRate(repositoryRoutine)
            
            cell.parentController = self
            cell.date = date
            
            cell.title.text = repositoryRoutine.title
            cell.subtitle.text = repositoryRoutine.subtitle
            cell.progressView.setCompletionRate(completionRate)
            cell.progressRate.text = completionRate.label
            
            cell.repositoryRoutine = repositoryRoutine
        }
        
        return cell
    }
}

extension WorkoutLogViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = testCalendar.timeZone
        formatter.locale = testCalendar.locale
        
        let startDate = formatter.date(from: "2015 01 01")
        let endDate = Date()
        
        let parameters = ConfigurationParameters(startDate: startDate!,
                                                 endDate: endDate,
                                                 numberOfRows: 1,
                                                 calendar: testCalendar,
                                                 generateInDates: InDateCellGeneration.off,
                                                 generateOutDates: OutDateCellGeneration.off,
                                                 firstDayOfWeek: DaysOfWeek.monday,
                                                 hasStrictBoundaries: false)
        
        return parameters
    }
    
    public func calendar(
        _ calendar: JTAppleCalendar.JTAppleCalendarView,
        cellForItemAt date: Date,
        cellState: JTAppleCalendar.CellState,
        indexPath: IndexPath) -> JTAppleCalendar.JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(
            withReuseIdentifier: "CellView",
            for: indexPath) as! CellView
        
        cell.setupCellBeforeDisplay(cellState, date: date)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        (cell as? CellView)?.setupCellBeforeDisplay(cellState, date: date)
        
        self.showOrHideCardViewForDate(date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        (cell as? CellView)?.setupCellBeforeDisplay(cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
      
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
//        let today = cal.startOfDay(for: date)
        let today: Date = cal.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
        let visibleD = visibleDates.monthDates.map({ (date: Date, _) -> Date in
            date
        })
        
        print(visibleDates)
        print(visibleD)
        print(today)
        
        if let f  = visibleD.first {
            calendar.selectDates([f])
        }
        
        if visibleD.contains(today) {
            print("is today")
        }
//
//        if let startDate = visibleDates.monthDates.first?.date {
//            calendar.selectDates([startDate])
//        }
//
//        if (todayDate.isGreaterThanDate(startDate) && todayDate.isLessThanDate(endDate)) {
//            calendar.selectDates([todayDate])
//        } else if (todayDate.isEqualToDate(startDate) || todayDate.isEqualToDate(endDate)) {
//            calendar.selectDates([todayDate])
//        } else {
//            calendar.selectDates([startDate])
//        }
    }
}
