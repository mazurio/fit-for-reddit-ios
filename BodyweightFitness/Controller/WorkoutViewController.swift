import UIKit
import AVFoundation

class WorkoutViewController: UIViewController {
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var topView: UIView!

    @IBOutlet var mainView: UIView!
    @IBOutlet var videoView: UIView!
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    @IBOutlet weak var middleViewHeightConstraint: NSLayoutConstraint!
    
    let navigationViewController: NavigationViewController = NavigationViewController()
    let timedViewController: TimedViewController = TimedViewController()
    let weightedViewController: WeightedViewController = WeightedViewController()
    
    var current: Exercise = RoutineStream.sharedInstance.routine.getFirstExercise()
    
    init() {
        super.init(nibName: "WorkoutView", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timedViewController.rootViewController = self
        self.weightedViewController.rootViewController = self
        self.timedViewController.view.frame = self.topView.frame
        self.timedViewController.willMoveToParentViewController(self)
        self.addChildViewController(self.timedViewController)
        self.topView.addSubview(self.timedViewController.view)
        self.timedViewController.didMoveToParentViewController(self)
        self.weightedViewController.view.frame = self.topView.frame
        self.weightedViewController.willMoveToParentViewController(self)
        self.addChildViewController(self.weightedViewController)
        self.topView.addSubview(self.weightedViewController.view)
        self.weightedViewController.didMoveToParentViewController(self)
        
        
        
        self.setNavigationBar()
        
        let menuItem = UIBarButtonItem(
            image: UIImage(named: "menu"),
            landscapeImagePhone: nil,
            style: .Plain,
            target: self,
            action: #selector(dismiss))

        let dashboardItem = UIBarButtonItem(
            image: UIImage(named: "dashboard"),
            landscapeImagePhone: nil,
            style: .Plain,
            target: self,
            action: #selector(dashboard))

        self.tabBarController?.navigationItem.leftBarButtonItem = menuItem
        self.tabBarController?.navigationItem.rightBarButtonItem = dashboardItem
        self.tabBarController?.navigationItem.titleView = navigationViewController.view
        
        self.timedViewController.updateLabel()
        
        let rate = RateMyApp.sharedInstance
        
        rate.appID = "1018863605"
        rate.trackAppUsage()
        
        _ = RoutineStream.sharedInstance.routineObservable().subscribe(onNext: {
            self.current = $0.getFirstExercise()
            self.changeExercise(self.current)
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setTitle()
    }
    
    override func viewDidLayoutSubviews() {
        self.changeExercise(current)
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        setTitle()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        setTitle()
    }
    
    func dismiss(sender: UIBarButtonItem) {
        self.sideNavigationController?.toggleLeftView()
    }
    
    func dashboard(sender: UIBarButtonItem) {
        let dashboard = DashboardViewController()
        dashboard.currentExercise = current
        dashboard.rootViewController = self
        
        let controller = UINavigationController(rootViewController: dashboard)
        
        self.navigationController?.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func onClickLogWorkoutAction(sender: AnyObject) {
        self.timedViewController.stopTimer()
        
        let logWorkoutController = LogWorkoutController()
        
        logWorkoutController.parentController = self.sideNavigationController
        logWorkoutController.setRepositoryRoutine(current, repositoryRoutine: RepositoryStream.sharedInstance.getRepositoryRoutineForToday())
        
        logWorkoutController.modalTransitionStyle = .CoverVertical
        logWorkoutController.modalPresentationStyle = .Custom
    
        self.sideNavigationController?.dim(.In, alpha: 0.5, speed: 0.5)
        self.sideNavigationController?.presentViewController(logWorkoutController, animated: true, completion: nil)
    }
    
    func setTitle() {
        let navigationBarSize = self.navigationController?.navigationBar.frame.size
        let titleView = self.tabBarController?.navigationItem.titleView
        var titleViewFrame = titleView?.frame
        titleViewFrame?.size = navigationBarSize!
        self.tabBarController?.navigationItem.titleView?.frame = titleViewFrame!
        
        titleView?.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin]
        titleView?.autoresizesSubviews = true
    }
    
    internal func changeExercise(currentExercise: Exercise) {
        self.current = currentExercise
        
        self.timedViewController.changeExercise(currentExercise)
        self.weightedViewController.changeExercise(currentExercise)
        
        self.navigationViewController.topLabel?.text = currentExercise.title
        self.navigationViewController.bottomLeftLabel?.text = currentExercise.section?.title
        self.navigationViewController.bottomRightLabel?.text = currentExercise.desc

        self.setVideo(currentExercise.videoId)
        
        if (currentExercise.section?.mode == SectionMode.All) {
            if let image = UIImage(named: "plus") {
                actionButton.setImage(image, forState: .Normal)
            }
        } else {
            if let image = UIImage(named: "progression") {
                actionButton.setImage(image, forState: .Normal)
            }
        }
        
        if current.isTimed() {
            self.timedViewController.view.hidden = false
            self.weightedViewController.view.hidden = true
        } else {
            self.timedViewController.view.hidden = true
            self.weightedViewController.view.hidden = false
        }
    }
    
    func setVideo(videoId: String) {
        // if contains videoId then
        
        if !videoId.isEmpty {
            if let player = self.player {
                player.pause()
                self.player = nil
                
            }
            if let layer = self.playerLayer {
                layer.removeFromSuperlayer()
                self.playerLayer = nil
            }
            
            self.videoView.layer.sublayers?.removeAll()
            
            let path = NSBundle.mainBundle().pathForResource(videoId, ofType: "mp4")
            
            player = AVPlayer(URL: NSURL(fileURLWithPath: path!))
            player!.actionAtItemEnd = AVPlayerActionAtItemEnd.None;
            
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = videoView.bounds
            
            self.videoView.layer.insertSublayer(playerLayer, atIndex: 0)
            
            NSNotificationCenter.defaultCenter().addObserver(
                self,
                selector: #selector(WorkoutViewController.playerItemDidReachEnd),
                name: AVPlayerItemDidPlayToEndTimeNotification,
                object: player!.currentItem)
            
            player!.seekToTime(kCMTimeZero)
            player!.play()
        } else {
            if let player = self.player {
                player.pause()
                self.player = nil
                
            }
            if let layer = self.playerLayer {
                layer.removeFromSuperlayer()
                self.playerLayer = nil
            }
            
            self.videoView.layer.sublayers?.removeAll()
        }
    }
    
    func playerItemDidReachEnd() {
        player!.seekToTime(kCMTimeZero)
    }
    
    @IBAction func actionButtonClicked(sender: AnyObject) {
        guard let button = sender as? UIView else {
            return
        }
        
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .ActionSheet)
        
        alertController.popoverPresentationController
        alertController.modalPresentationStyle = .Popover
        
        if let presenter = alertController.popoverPresentationController {
            presenter.sourceView = button;
            presenter.sourceRect = button.bounds;
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Watch Full Video", style: .Default) { (action) in
  
                if let requestUrl = NSURL(string: "https://www.youtube.com/watch?v=" + self.current.youTubeId) {
                    UIApplication.sharedApplication().openURL(requestUrl)
                }
            
        })
        
        alertController.addAction(UIAlertAction(title: "Today's Workout", style: .Default) { (action) in
            let backItem = UIBarButtonItem()
            backItem.title = "Back"

            self.tabBarController?.navigationItem.backBarButtonItem = backItem
            
            let progressViewController = ProgressViewController()
            
            progressViewController.setRoutine(NSDate(), repositoryRoutine: RepositoryStream.sharedInstance.getRepositoryRoutineForToday())
            
            self.showViewController(progressViewController, sender: nil)
        })
        
        if let currentSection = current.section {
            if (currentSection.mode == .Levels || currentSection.mode == .Pick) {
                // ... Choose Progression
                alertController.addAction(
                    UIAlertAction(title: "Choose Progression", style: .Default) { (action) in
                        if let exercises = self.current.section?.exercises {
                            let alertController = UIAlertController(
                                title: "Choose Progression",
                                message: nil,
                                preferredStyle: .ActionSheet)
                            
                            alertController.modalPresentationStyle = .Popover
                            
                            if let presenter = alertController.popoverPresentationController {
                                presenter.sourceView = button;
                                presenter.sourceRect = button.bounds;
                            }
                            
                            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                            
                            for anyExercise in exercises {
                                if let exercise = anyExercise as? Exercise {
                                    var title = ""
                                    
                                    if(exercise.section?.mode == SectionMode.Levels) {
                                        title = "\(exercise.level): \(exercise.title)"
                                    } else {
                                        title = "\(exercise.title)"
                                    }
                                    
                                    alertController.addAction(
                                        UIAlertAction(title: title, style: .Default) { (action) in
                                            RoutineStream.sharedInstance.routine.setProgression(exercise)
                                            
                                            self.changeExercise(exercise)
                                            
                                            PersistenceManager.storeRoutine(RoutineStream.sharedInstance.routine)
                                        }
                                    )
                                }
                            }
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    }
                )
            }
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func previousButtonClicked(sender: AnyObject) {
        if let previous = self.current.previous {
            changeExercise(previous)
        }
    }
 
    @IBAction func nextButtonClicked(sender: AnyObject) {
        if let next = self.current.next {
            changeExercise(next)
        }
    }
  }