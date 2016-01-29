import UIKit

class LogWorkoutController: UIViewController {
    var exercise: RepositoryExercise?
    var routine: RepositoryRoutine?
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var addSetButton: UIButton!
    @IBOutlet weak var removeSetButton: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var actionView: UIView!
    
    @IBOutlet weak var increaseRepsButton: UIButton!
    @IBOutlet weak var decreaseRepsButton: UIButton!
    
    @IBOutlet weak var increaseWeightButton: UIButton!
    @IBOutlet weak var decreaseWeightButton: UIButton!
    
    @IBOutlet weak var setNumber: UILabel!
    @IBOutlet weak var repsNumber: UILabel!
    @IBOutlet weak var weightNumber: UILabel!
    
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    var verticalStackView: UIStackView?
    var horizontalStackView: UIStackView?
    
    var timer: NSTimer!
    let timerInterval = 0.15
    
    var numberOfSetViews = 0
    var isActionViewShowing = false
    
    var setView: SetView?
    var set: RepositorySet?
    
    let realm = RepositoryStream.sharedInstance.getRealm()
    
    var parentController: UIViewController?
    
    func increaseRepsButtonDown(sender: AnyObject) {
        increaseReps()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(
            timerInterval,
            target: self,
            selector: "increaseReps",
            userInfo: nil,
            repeats: true)
    }
    
    func decreaseRepsButtonDown(sender: AnyObject) {
        decreaseReps()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(
            timerInterval,
            target: self,
            selector: "decreaseReps",
            userInfo: nil,
            repeats: true)
    }
    
    func increaseWeightButtonDown(sender: AnyObject) {
        increaseWeight()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(
            timerInterval,
            target: self,
            selector: "increaseWeight",
            userInfo: nil,
            repeats: true)
    }
    
    func decreaseWeightButtonDown(sender: AnyObject) {
        decreaseWeight()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(
            timerInterval,
            target: self,
            selector: "decreaseWeight",
            userInfo: nil,
            repeats: true)
    }
    
    func invalidateTimer(sender: AnyObject) {
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.increaseRepsButton.addTarget(
            self,
            action: "increaseRepsButtonDown:",
            forControlEvents: .TouchDown)
        
        self.increaseRepsButton.addTarget(
            self,
            action: "invalidateTimer:",
            forControlEvents: [.TouchUpInside, .TouchUpOutside])
        
        self.decreaseRepsButton.addTarget(
            self,
            action: "decreaseRepsButtonDown:",
            forControlEvents: .TouchDown)
        
        self.decreaseRepsButton.addTarget(
            self,
            action: "invalidateTimer:",
            forControlEvents: [.TouchUpInside, .TouchUpOutside])
        
        self.increaseWeightButton.addTarget(
            self,
            action: "increaseWeightButtonDown:",
            forControlEvents: .TouchDown)
        
        self.increaseWeightButton.addTarget(
            self,
            action: "invalidateTimer:",
            forControlEvents: [.TouchUpInside, .TouchUpOutside])
        
        self.decreaseWeightButton.addTarget(
            self,
            action: "decreaseWeightButtonDown:",
            forControlEvents: .TouchDown)
        
        self.decreaseWeightButton.addTarget(
            self,
            action: "invalidateTimer:",
            forControlEvents: [.TouchUpInside, .TouchUpOutside])
        
        self.popupView.layer.borderColor = UIColor.blackColor().CGColor
        self.popupView.layer.borderWidth = 0.25
        self.popupView.layer.shadowColor = UIColor.blackColor().CGColor
        self.popupView.layer.shadowOpacity = 0.4
        self.popupView.layer.shadowRadius = 15
        self.popupView.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.popupView.layer.masksToBounds = false
        
        self.isActionViewShowing = false
        self.actionView?.hidden = true
        
        self.verticalStackView = UIStackView()
        self.verticalStackView?.axis = UILayoutConstraintAxis.Vertical;
        self.verticalStackView?.distribution = UIStackViewDistribution.EqualSpacing;
        self.verticalStackView?.alignment = UIStackViewAlignment.Center;
        self.verticalStackView?.spacing = 8;
        
        self.verticalStackView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.verticalStackView!)
        
        self.verticalStackView?.centerXAnchor.constraintEqualToAnchor(self.contentView.centerXAnchor).active = true
        self.verticalStackView?.centerYAnchor.constraintEqualToAnchor(self.contentView.centerYAnchor).active = true
        self.verticalStackView?.hidden = false
        
        for set in (self.exercise?.sets)! {
            self.addSet(set)
        }
    }
    
    func setRepositoryRoutine(repositoryExercise: RepositoryExercise, repositoryRoutine: RepositoryRoutine) {
        self.exercise = repositoryExercise
        self.routine = repositoryRoutine
    }
    
    func setRepositoryRoutine(exercise: Exercise, repositoryRoutine: RepositoryRoutine) {
        if let repositoryExercise = repositoryRoutine.exercises.filter({
            $0.exerciseId == exercise.exerciseId
        }).first {
            self.exercise = repositoryExercise
            self.routine = repositoryRoutine
        }
    }
    
    func addHorizontalStackViewIfNeeded() {
        if(numberOfSetViews == 0 || numberOfSetViews == 3 || numberOfSetViews == 6 || numberOfSetViews == 9) {
            self.horizontalStackView = UIStackView()
            self.horizontalStackView?.axis = UILayoutConstraintAxis.Horizontal;
            self.horizontalStackView?.distribution = UIStackViewDistribution.EqualSpacing;
            self.horizontalStackView?.alignment = UIStackViewAlignment.Center;
            self.horizontalStackView?.spacing = 8;
            
            self.horizontalStackView?.translatesAutoresizingMaskIntoConstraints = false
            
            self.verticalStackView?.addArrangedSubview(self.horizontalStackView!)
        }
    }
    
    func pressed(setView: SetView!) {
        showActionView(setView)
    }
    
    func showActionView(setView: SetView) {
        self.setView = setView
        self.set = setView.repositorySet
        self.isActionViewShowing = true
        
        self.verticalStackView?.hidden = true
        self.actionView?.hidden = false
        
        self.closeButton?.titleLabel?.text = "Back"
        
        self.addSetButton?.hidden = true
        self.removeSetButton?.hidden = true
        
        updateActionView()
    }
    
    func updateActionView() {
        if let set = set {
            if set.isTimed {
                
            } else {
                if let setView = self.setView {
                    if let index = self.exercise?.sets.indexOf(setView.repositorySet!) {
                        self.setNumber.text = "\(index + 1)"
                    } else {
                        self.setNumber.text = ""
                    }
                }
                
                self.repsNumber.text = "\(set.reps)"
                self.repsLabel.text = "Reps"
                
                self.weightNumber.text = "\(set.weight)"
                self.weightLabel.text = "Weight (lbs)"
            }
        }
    }
    
    func hideActionView() {
        self.isActionViewShowing = false
        
        self.verticalStackView?.hidden = false
        self.actionView?.hidden = true
        
         self.closeButton?.titleLabel?.text = "Close"
        
        self.addSetButton?.hidden = false
        self.removeSetButton?.hidden = false
    }
    
    func addSet(repositorySet: RepositorySet) {
        let setView = SetView()
        setView.repositorySet = repositorySet
        
        setView.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        setView.widthAnchor.constraintEqualToConstant(70).active = true
        setView.heightAnchor.constraintEqualToConstant(70).active = true
        
        self.addHorizontalStackViewIfNeeded()
        self.horizontalStackView?.addArrangedSubview(setView)
        
        setView.customizeAppearance()
        
        numberOfSetViews++
    }
    
    /**
     * TODO:
     * Update last updated time.
     *
     * Update only if the difference between start time and last updated time is less than
     * 120 minutes (it ignores changing the time later in the day after the workout ends
     * if we decide to update some values).
     */
    func setLastUpdatedTime() {
        self.routine?.lastUpdatedTime = NSDate()
    }
    
    @IBAction func onClickAddSet(sender: AnyObject) {
        if self.numberOfSetViews >= 9 {
            return;
        }

        try! realm.write {
            let repositorySet = RepositorySet()
            repositorySet.exercise = self.exercise!
                
            if(self.exercise?.defaultSet == "weighted") {
                repositorySet.isTimed = false
            } else {
                repositorySet.isTimed = true
            }
            
            //
            // Copy data from last set so we don't have to modify it again.
            //
            if let lastSet = self.exercise?.sets.last {
                repositorySet.reps = lastSet.reps
                repositorySet.weight = lastSet.weight
                repositorySet.seconds = lastSet.seconds
            }
            
            self.exercise?.sets.append(repositorySet)
            self.addSet(repositorySet)
        }
    }
    
    @IBAction func onClickRemoveSet(sender: AnyObject) {
        if (numberOfSetViews == 1) {
            return;
        }
        
        try! realm.write {
            exercise?.sets.removeLast()
        }
       
        self.horizontalStackView?.subviews.last!.removeFromSuperview()
        
        if self.horizontalStackView?.subviews.count == 0 {
            self.horizontalStackView?.removeFromSuperview()
            
            self.horizontalStackView = self.verticalStackView?.subviews.last as? UIStackView
        }
        
        numberOfSetViews -= 1
    }
    
    @IBAction func onClickButtonClose(sender: AnyObject) {
        if isActionViewShowing {
            self.hideActionView()
        } else {
            try! realm.write {
                realm.add(exercise!, update: true)
            }
            
            self.parentController?.dim(.Out, alpha: 0.5, speed: 0.5)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func increaseReps() {
        try! realm.write {
            if let set = set {
                if set.isTimed {
                    
                } else {
                    if set.reps >= 50 {
                        return;
                    }
                    
                    set.reps += 1
                }
                
                setView?.updateView()
                
                updateActionView()
                setLastUpdatedTime()
            }
        }
    }
    
    func decreaseReps() {
        try! realm.write {
            if let set = set {
                if set.isTimed {
                    
                } else {
                    if set.reps == 0 {
                        return;
                    }
                    
                    set.reps -= 1
                }
                
                setView?.updateView()
                
                updateActionView()
                setLastUpdatedTime()
            }
        }
    }
    
    func increaseWeight() {
        try! realm.write {
            if let set = set {
                if set.isTimed {
                    
                } else {
                    if set.weight >= 250 {
                        return;
                    }
                    
                    set.weight += 0.5
                }
                
                setView?.updateView()
                
                updateActionView()
                setLastUpdatedTime()
            }
        }
    }
    
    func decreaseWeight() {
        try! realm.write {
            if let set = set {
                if set.isTimed {
                    
                } else {
                    if set.weight <= 0 {
                        return;
                    }
                    
                    set.weight -= 0.5
                }
                
                setView?.updateView()
                
                updateActionView()
                setLastUpdatedTime()
            }
        }
    }
}

class SetView: UIButton {
    var repositorySet: RepositorySet?
    
    let horizontalPadding: CGFloat = 14.0
    var buttonColor: UIColor?
    var topLabel: UILabel?
    var centerLabel: UILabel?
    var bottomLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customizeAppearance()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        customizeAppearance()
    }
    
    override func drawRect(rect: CGRect) {
        layer.borderColor = UIColor(red:0, green:0.27, blue:0.24, alpha:1).CGColor
        layer.backgroundColor = UIColor.whiteColor().CGColor
        
        setTitleColor(tintColor, forState: UIControlState.Normal)
        setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
    }
    
    func customizeAppearance() {
        let containsEdgeInsets = !UIEdgeInsetsEqualToEdgeInsets(contentEdgeInsets, UIEdgeInsetsZero)
        
        contentEdgeInsets = containsEdgeInsets ? contentEdgeInsets : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.blackColor().CGColor
        layer.cornerRadius = 70 / 2.0
        layer.masksToBounds = false
        
        self.updateView()
    }
    
    func updateView() {
        self.removeAllSubviews()
        
        if let set = repositorySet {
            if set.weight == 0 {
                self.centerLabel = UILabel(frame: CGRect.init(x: 0, y: 25, width: 70, height: 20))
                self.centerLabel?.font = UIFont.boldSystemFontOfSize(14.0)
                self.centerLabel?.textAlignment = NSTextAlignment.Center
                self.centerLabel?.text = "\(set.reps)"
                
                self.addSubview(self.centerLabel!)
            } else {
                self.topLabel = UILabel(frame: CGRect.init(x: 0, y: 20, width: 70, height: 15))
                self.topLabel?.font = UIFont.boldSystemFontOfSize(12.0)
                self.topLabel?.textAlignment = NSTextAlignment.Center
                self.topLabel?.text = "\(set.reps) x"
                
                self.bottomLabel = UILabel(frame: CGRect.init(x: 0, y: 38, width: 70, height: 15))
                self.bottomLabel?.font = UIFont.systemFontOfSize(12.0)
                self.bottomLabel?.textAlignment = NSTextAlignment.Center
                self.bottomLabel?.text = "\(set.weight) lbs"
                
                self.addSubview(self.topLabel!)
                self.addSubview(self.bottomLabel!)
            }
        }
    }
}