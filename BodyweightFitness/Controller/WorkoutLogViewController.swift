import UIKit
import RealmSwift
import JTAppleCalendar
import UIKit

extension Date {
    public var globalDescription: String {
        get {
            let month = dateFormattedStringWithFormat("MMMM", fromDate: self)
            let year = dateFormattedStringWithFormat("YYYY", fromDate: self)

            return "\(month), \(year)"
        }
    }

    public var commonDescription: String {
        get {
            let day = dateFormattedStringWithFormat("dd", fromDate: self)
            let month = dateFormattedStringWithFormat("MMMM", fromDate: self)
            let year = dateFormattedStringWithFormat("YYYY", fromDate: self)

            return "\(day) \(month), \(year)"
        }
    }

    func dateFormattedStringWithFormat(_ format: String, fromDate date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }

    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false

        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }

        //Return Result
        return isGreater
    }

    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false

        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }

        //Return Result
        return isLess
    }

    func equalToDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqualTo = false

        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }

        //Return Result
        return isEqualTo
    }
}

//class CellView: JTAppleCell {
//    @IBInspectable var todayColor: UIColor!// = UIColor(red: 254.0/255.0, green: 73.0/255.0, blue: 64.0/255.0, alpha: 0.3)
//    @IBInspectable var normalDayColor: UIColor! //UIColor(white: 0.0, alpha: 0.1)
//
//    @IBOutlet var selectedView: AnimationView!
//    @IBOutlet var dot: UIView!
//    @IBOutlet var dayLabel: UILabel!
//
//    lazy var todayDate : String = {
//        [weak self] in
//        let aString = self!.c.string(from: Date())
//        return aString
//    }()
//
//    lazy var c : DateFormatter = {
//        let f = DateFormatter()
//        f.dateFormat = "yyyy-MM-dd"
//
//        return f
//    }()
//
//    func setupCellBeforeDisplay(_ cellState: CellState, date: Date) {
////        let routines = RepositoryStream.sharedInstance.getRoutinesForDate(cellState.date)
////
////        if (routines.count > 0) {
////            self.dot.isHidden = false
////        } else {
////            self.dot.isHidden = true
////        }
////
////        self.dot.layer.cornerRadius = self.dot.frame.width / 2
////        self.selectedView.layer.cornerRadius = self.selectedView.frame.width / 2
////
////        // Setup Cell text
////        self.dayLabel.text = cellState.text
////
////        // Mark todays date
////        if (c.string(from: date) == todayDate) {
////            selectedView.backgroundColor = UIColor.primaryDark()
////        } else {
////            selectedView.backgroundColor = UIColor.white
////        }
////
////        configureTextColor(cellState)
////
////        delayRunOnMainThread(0.0) {
////            self.configureViewIntoBubbleView(cellState)
////        }
////
////        configureVisibility(cellState)
//    }
//
//    func configureVisibility(_ cellState: CellState) {
//        self.isHidden = false
//    }
//
//    func configureTextColor(_ cellState: CellState) {
//        if cellState.isSelected {
//            if (c.string(from: cellState.date as Date) == todayDate) {
//                dayLabel.textColor = UIColor.white
//            } else {
//                dayLabel.textColor = UIColor.black
//            }
//        } else if cellState.dateBelongsTo == .thisMonth {
//            dayLabel.textColor = UIColor.black
//        } else {
//            dayLabel.textColor = UIColor.primaryDark()
//        }
//    }
//
//    func cellSelectionChanged(_ cellState: CellState) {
//        if cellState.isSelected == true {
//            if selectedView.isHidden == true {
//                configureViewIntoBubbleView(cellState)
//                selectedView.animateWithBounceEffect(withCompletionHandler: nil)
//            }
//        } else {
//            configureViewIntoBubbleView(cellState, animateDeselection: true)
//        }
//    }
//
//    fileprivate func configureViewIntoBubbleView(_ cellState: CellState, animateDeselection: Bool = false) {
//        if cellState.isSelected {
//            self.selectedView.layer.cornerRadius =  self.selectedView.frame.width  / 2
//            self.selectedView.isHidden = false
//            self.dot.isHidden = true
//
//            self.configureTextColor(cellState)
//        } else {
//            if animateDeselection {
//                self.configureTextColor(cellState)
//
//                if self.selectedView.isHidden == false {
//                    self.selectedView.animateWithFadeEffect(withCompletionHandler: { () -> Void in
//                        self.selectedView.isHidden = true
//                        self.selectedView.alpha = 1
//                    })
//                }
//            } else {
//                self.selectedView.isHidden = true
//            }
//
////            let routines = RepositoryStream.sharedInstance.getRoutinesForDate(cellState.date)
////
////            if (routines.count > 0) {
////                self.dot.isHidden = false
////            } else {
////                self.dot.isHidden = true
////            }
//        }
//    }
//}

//class AnimationClass {
//
//    class func BounceEffect() -> (UIView, (Bool) -> Void) -> () {
//        return {
//            view, completion in
//            view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
//                view.transform = CGAffineTransform(scaleX: 1, y: 1)
//            }, completion: completion)
//        }
//    }
//
//    class func FadeOutEffect() -> (UIView, (Bool) -> Void) -> () {
//        return {
//            view, completion in
//
//            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: {
//                view.alpha = 0
//            },
//                    completion: completion)
//        }
//    }
//
//    fileprivate class func get3DTransformation(_ angle: Double) -> CATransform3D {
//
//        var transform = CATransform3DIdentity
//        transform.m34 = -1.0 / 500.0
//        transform = CATransform3DRotate(transform, CGFloat(angle * Double.pi / 180.0), 0, 1, 0.0)
//
//        return transform
//    }
//
//    class func flipAnimation(_ view: UIView, completion: (() -> Void)?) {
//
//        let angle = 180.0
//        view.layer.transform = get3DTransformation(angle)
//
//        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
//            view.layer.transform = CATransform3DIdentity
//        }) { (finished) -> Void in
//            completion?()
//        }
//    }
//}

//class AnimationView: UIView {
//
//    func animateWithFlipEffect(withCompletionHandler completionHandler:(()->Void)?) {
//        AnimationClass.flipAnimation(self, completion: completionHandler)
//    }
//    func animateWithBounceEffect(withCompletionHandler completionHandler:(()->Void)?) {
//        let viewAnimation = AnimationClass.BounceEffect()
//        viewAnimation(self){ _ in
//            completionHandler?()
//        }
//    }
//    func animateWithFadeEffect(withCompletionHandler completionHandler:(()->Void)?) {
//        let viewAnimation = AnimationClass.FadeOutEffect()
//        viewAnimation(self) { _ in
//            completionHandler?()
//        }
//    }
//}

class WorkoutLogViewController: UIViewController,
        UITableViewDataSource,
UITableViewDelegate {
//        JTAppleCalendarViewDataSource,
//        JTAppleCalendarViewDelegate {

    var numberOfRows = 1

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet var tableView: UITableView!

    var date: Date = Date()
    var routines: Results<RepositoryRoutine>?

    let formatter = DateFormatter()
    var testCalendar: Calendar! = Calendar(identifier: Calendar.Identifier.gregorian)

    init() {
        super.init(nibName: "WorkoutLogView", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        self.setNavigationBar()

        let border = CALayer()
        let width = CGFloat(0.5)

        border.borderColor = UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
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

        tableView.delegate = self
        tableView.dataSource = self

        formatter.dateFormat = "yyyy MM dd"
        testCalendar.timeZone = TimeZone(abbreviation: "GMT")!

//        calendarView.delegate = self
//        calendarView.dataSource = self
//        calendarView.registerCellViewXib(fileName: "CellView")
//        calendarView.direction = .horizontal
//        calendarView.cellInset = CGPoint(x: 0, y: 0)
//        calendarView.allowsMultipleSelection = false
//        calendarView.firstDayOfWeek = .monday
//        calendarView.scrollEnabled = true
//        calendarView.scrollingMode = .stopAtEachCalendarFrameWidth
//        calendarView.itemSize = nil
//        calendarView.rangeSelectionWillBeUsed = false

        calendarView.reloadData()

        calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: false, animateScroll: false) {
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

        self.tabBarController?.title = date.commonDescription

        self.showOrHideCardViewForDate(date)
    }

    func showOrHideCardViewForDate(_ date: Date) {
        self.date = date

//        let routines = RepositoryStream.sharedInstance.getRoutinesForDate(date)
//        if (routines.count > 0) {
//            self.routines = routines
//            self.tableView?.backgroundView = nil
//        } else {
//            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
//
//            label.text = "When you log a workout, you'll see it here."
//            label.font = UIFont(name: "Helvetica Neue", size: 15)
//            label.textAlignment = .center
//            label.sizeToFit()
//
//            self.routines = nil
//            self.tableView?.backgroundView = label
//        }

        self.tableView.reloadData()
    }

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

    func configureCalendar(_ calendar: JTAppleCalendarView) -> (
            startDate: Date,
            endDate: Date,
            numberOfRows: Int,
            calendar: Calendar) {

        let firstDate = formatter.date(from: "2015 01 01")
        let secondDate = Date()
        let aCalendar = Calendar.current

        return (startDate: firstDate!,
                endDate: secondDate,
                numberOfRows: numberOfRows,
                calendar: aCalendar)
    }

//    func calendar(_ calendar: JTAppleCalendarView, isAboutToDisplayCell cell: JTAppleCell, date: Date, cellState: CellState) {
//        (cell as? CellView)?.setupCellBeforeDisplay(cellState, date: date)
//    }
//
//    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
//        (cell as? CellView)?.cellSelectionChanged(cellState)
//    }
//
//    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
//        (cell as? CellView)?.cellSelectionChanged(cellState)
//
//        self.date = cellState.date as Date
//        self.tabBarController?.navigationItem.title = self.date.commonDescription
//
//        showOrHideCardViewForDate(self.date)
//    }
//
//    func calendar(_ calendar: JTAppleCalendarView, isAboutToResetCell cell: JTAppleCell) {
//        (cell as? CellView)?.selectedView.isHidden = true
//    }
//
//    func calendar(_ calendar: JTAppleCalendarView,
//                  didScrollToDateSegmentStartingWithdate startDate: Date,
//                  endingWithDate endDate: Date) {
//
//        let todayDate = Date()
//
//        if (todayDate.isGreaterThanDate(startDate) && todayDate.isLessThanDate(endDate)) {
//            calendar.selectDates([todayDate])
//        } else if ((todayDate == startDate) || (todayDate == endDate)) {
//            calendar.selectDates([todayDate])
//        } else {
//            calendar.selectDates([startDate])
//        }
//    }
}
