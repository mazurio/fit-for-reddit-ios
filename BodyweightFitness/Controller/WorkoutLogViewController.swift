import UIKit
import RealmSwift
import JTAppleCalendar
import UIKit

class AnimationView: UIView {
    func animateWithFlipEffect(withCompletionHandler completionHandler:(() -> Void)?) {
        AnimationClass.flipAnimation(self, completion: completionHandler)
    }
    func animateWithBounceEffect(withCompletionHandler completionHandler:(() -> Void)?) {
        let viewAnimation = AnimationClass.BounceEffect()
        viewAnimation(self) { _ in
            completionHandler?()
        }
    }
    func animateWithFadeEffect(withCompletionHandler completionHandler:(() -> Void)?) {
        let viewAnimation = AnimationClass.fadeOutEffect()
        viewAnimation(self) { _ in
            completionHandler?()
        }
    }
}

extension UIView {
    enum FoldDirection {
        case open, closed
    }
    
    func fold(withTransparency: Bool, completionHandler:(()->Void)?, inDirection: FoldDirection ) {
        let topAndBottomView = self.prepareSplitImage()
        let topHalfView = topAndBottomView[0]
        let bottomHalfView = topAndBottomView[1]
        
        let animationContainer = UIView(frame: self.bounds)
        let originalBackgroundColor = self.backgroundColor
        if (withTransparency) {
            animationContainer.backgroundColor = UIColor.clear
            self.backgroundColor = UIColor.clear
            for subview in self.subviews {
                subview.isHidden = true
            }
        } else {
            animationContainer.backgroundColor = UIColor.black
        }
        
        self.addSubview(animationContainer)
        animationContainer.addSubview(topHalfView)
        animationContainer.addSubview(bottomHalfView)
        
        var startingTransform = CATransform3DIdentity
        startingTransform.m34 = -1 / 500
        
        let startingFrame = CGRect(x: 0,
                                   y: -topHalfView.frame.size.height / 2,
                                   width: topHalfView.frame.size.width,
                                   height: topHalfView.frame.size.height)
        
        topHalfView.frame = startingFrame
        bottomHalfView.frame = startingFrame
        
        
        topHalfView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        bottomHalfView.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        
        topHalfView.layer.transform = startingTransform;
        bottomHalfView.layer.transform = startingTransform;
        
        let topShadowLayer = CAGradientLayer()
        topShadowLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        topShadowLayer.frame = topHalfView.bounds
        topHalfView.layer.addSublayer(topShadowLayer)
        
        let bottomShadowLayer = CAGradientLayer()
        bottomShadowLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        bottomShadowLayer.frame = bottomHalfView.bounds
        bottomHalfView.layer.addSublayer(bottomShadowLayer)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.3)
        
        CATransaction.setCompletionBlock {
            self.backgroundColor = originalBackgroundColor
            
            if (withTransparency) {
                for subview in self.subviews {
                    subview.isHidden = false
                }
            }
            
            animationContainer.removeFromSuperview()
            completionHandler?()
        }
        
        
        
        let topRotationAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
        topRotationAnimation.fillMode = kCAFillModeForwards
        topRotationAnimation.isRemovedOnCompletion = false
        switch (inDirection) {
        case .open:
            topRotationAnimation.fromValue = -(.pi / 2.0)
            topRotationAnimation.toValue = 0
            break;
        case .closed:
            topRotationAnimation.fromValue = 0
            topRotationAnimation.toValue = -(.pi / 2.0)
        }
        
        topHalfView.layer.add(topRotationAnimation, forKey:nil)
        
        
        let bottomRotationAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
        bottomRotationAnimation.fillMode = kCAFillModeForwards;
        bottomRotationAnimation.isRemovedOnCompletion = false
        switch (inDirection) {
        case .open:
            bottomRotationAnimation.fromValue = (.pi / 2.0)
            bottomRotationAnimation.toValue = 0
            break;
        case .closed:
            bottomRotationAnimation.fromValue = 0
            bottomRotationAnimation.toValue = (.pi / 2.0)
        }
        bottomHalfView.layer.add(bottomRotationAnimation, forKey:nil)
        
        let bottomTranslationAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        bottomTranslationAnimation.fillMode = kCAFillModeForwards
        bottomTranslationAnimation.isRemovedOnCompletion = false
        switch (inDirection) {
        case .open:
            bottomTranslationAnimation.fromValue = topHalfView.frame.minY
            bottomTranslationAnimation.toValue = 2 * bottomHalfView.frame.size.height
            bottomTranslationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            break;
        case .closed:
            bottomTranslationAnimation.fromValue = 2 * bottomHalfView.frame.size.height
            bottomTranslationAnimation.toValue = topHalfView.frame.minY
            bottomTranslationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        }
        
        //TODO: figure out a more precise timing function
        bottomHalfView.layer.add(bottomTranslationAnimation, forKey:nil)
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fillMode = kCAFillModeForwards
        opacityAnimation.isRemovedOnCompletion = false
        switch (inDirection) {
        case .open:
            opacityAnimation.fromValue = 1.0
            opacityAnimation.toValue = 0.0
            break;
        case .closed:
            opacityAnimation.fromValue = 0.0
            opacityAnimation.toValue = 1.0
        }
        
        topShadowLayer.add(opacityAnimation, forKey: nil)
        bottomShadowLayer.add(opacityAnimation, forKey: nil)
        
        CATransaction.commit()
    }
    
    func prepareSplitImage() -> [UIImageView] {
        
        
        let topImageFrame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: floor(self.frame.size.height / 2.0))
        let bottomImageFrame = CGRect(x: 0, y: topImageFrame.maxY, width: self.frame.size.width, height: ceil(self.frame.size.height / 2))
        
        UIGraphicsBeginImageContext(self.frame.size)
        let context = UIGraphicsGetCurrentContext()!
        self.layer.render(in: context)
        
        let fullViewImage = UIGraphicsGetImageFromCurrentImageContext()!
        var imageRef = fullViewImage.cgImage!.cropping(to: topImageFrame)!
        let topHalf = UIImage(cgImage: imageRef)
        
        imageRef = fullViewImage.cgImage!.cropping(to: bottomImageFrame)!
        let bottomHalf = UIImage(cgImage: imageRef)
        
        
        UIGraphicsEndImageContext();
        
        let topHalfView = UIImageView(image: topHalf)
        topHalfView.frame = topImageFrame
        
        let bottomHalfView = UIImageView(image: bottomHalf)
        bottomHalfView.frame = bottomImageFrame
        
        return [topHalfView, bottomHalfView]
    }
}

class AnimationClass {
    
    
    class func BounceEffect() -> (UIView, @escaping (Bool) -> Void) -> () {
        
        return {
            view, completion in
            view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(
                withDuration: 0.5,
                delay: 0, usingSpringWithDamping: 0.3,
                initialSpringVelocity: 0.1,
                options: UIViewAnimationOptions.beginFromCurrentState,
                animations: {
                    view.transform = CGAffineTransform(scaleX: 1, y: 1)
            },
                completion: completion
            )
        }
        
    }
    
    class func fadeOutEffect() -> (UIView, @escaping (Bool) -> Void) -> () {
        
        return {
            view, completion in
            UIView.animate(withDuration: 0.6,
                           delay: 0, usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0,
                           options: [],
                           animations: {
                            view.alpha = 0
            },
                           completion: completion)
        }
        
    }
    
    fileprivate class func get3DTransformation(_ angle: Double) ->
        CATransform3D {
            var transform = CATransform3DIdentity
            transform.m34 = -1.0 / 500.0
            transform = CATransform3DRotate(transform,
                                            CGFloat(angle * .pi / 180.0), 0, 1, 0.0)
            return transform
    }
    
    class func flipAnimation(_ view: UIView, completion: (() -> Void)?) {
        let angle = 180.0
        view.layer.transform = get3DTransformation(angle)
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: { () -> Void in
                        view.layer.transform = CATransform3DIdentity
        }) { (finished) -> Void in
            completion?()
        }
    }
    
}

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

class WorkoutLogViewController: UIViewController {

    var numberOfRows = 1

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet var tableView: UITableView!

    var date: Date = Date()
    var routines: Results<RepositoryRoutine>?

    let formatter = DateFormatter()
    var testCalendar: Calendar! = Calendar.current

    override func viewDidLoad() {
        self.setNavigationBar()

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

        tableView.delegate = self
        tableView.dataSource = self

        formatter.dateFormat = "yyyy MM dd"
        testCalendar.timeZone = TimeZone(abbreviation: "GMT")!

        calendarView.register(CellView.self, forCellWithReuseIdentifier: "CellView")
        
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        calendarView.allowsMultipleSelection = false
        calendarView.scrollingMode = .stopAtEachCalendarFrameWidth
        calendarView.isRangeSelectionUsed = false
        calendarView.reloadData()

        calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: false, animateScroll: false) {
            self.calendarView.selectDates([Date()])
        }
    }
    
    func toggleCurrentDayView(_ sender: UIBarButtonItem) {
//        self.calendarView.scrollToDate(Date(), animateScroll: false)
//        self.calendarView.selectDates([Date()])
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
//        self.date = date
//
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
//
//        self.tableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = self.routines {
            return 1
        } else {
            return 0
        }
    }

}

extension WorkoutLogViewController: UITableViewDataSource, UITableViewDelegate {
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
                                                 generateInDates: InDateCellGeneration.forAllMonths,
                                                 generateOutDates: OutDateCellGeneration.tillEndOfGrid,
                                                 firstDayOfWeek: DaysOfWeek.monday,
                                                 hasStrictBoundaries: true)
        
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
        
//        cell.dayLabel.text = "1"
//        cell.dayLabel.text = "Text"
//        cell.dayLabel.text = cellState.text
        
        return cell
    }
    
    
}
