import UIKit

class RestTimerViewController: UIViewController {
    @IBOutlet var previousButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    var rootViewController: WorkoutViewController? = nil
    var current: Exercise = RoutineStream.sharedInstance.routine.getFirstExercise()
    
    init() {
        super.init(nibName: "RestTimerView", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func previousButtonClicked(sender: AnyObject) {
        self.rootViewController?.previousButtonClicked(sender)
    }
    
    @IBAction func nextButtonClicked(sender: AnyObject) {
        self.rootViewController?.nextButtonClicked(sender)
    }
}
