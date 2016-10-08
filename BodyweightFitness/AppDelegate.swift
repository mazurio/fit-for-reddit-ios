import UIKit
import CoreData
import Fabric
import Crashlytics

class DashboardTabBarController: UITabBarController, UITabBarControllerDelegate {
    let homeViewController = HomeViewController()
    let workoutViewController = WorkoutViewController()
    let workoutLogViewController = WorkoutLogViewController()
    let supportDeveloperViewController = SupportDeveloperViewController()
    let settingsViewController = SettingsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        homeViewController.tabBarItem = UITabBarItem(
                title: "Home",
                image: UIImage(named: "someImage.png"),
                selectedImage: UIImage(named: "otherImage.png"))

        workoutViewController.tabBarItem = UITabBarItem(
                title: "Workout",
                image: UIImage(named: "someImage.png"),
                selectedImage: UIImage(named: "otherImage.png"))

        workoutLogViewController.tabBarItem = UITabBarItem(
                title: "Workout Log",
                image: UIImage(named: "someImage.png"),
                selectedImage: UIImage(named: "otherImage.png"))

        settingsViewController.tabBarItem = UITabBarItem(
                title: "Settings",
                image: UIImage(named: "someImage.png"),
                selectedImage: UIImage(named: "otherImage.png"))

        let controllers = [
                homeViewController,
                workoutViewController,
                workoutLogViewController,
                settingsViewController
        ]

        self.viewControllers = controllers
    }

    //Delegate methods
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title) ?")
        return true;
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    var main: UINavigationController? = nil
//
//    var sideNavigationViewController: SideNavigationController?
//    let sideViewController = SideViewController()
//
//    let homeViewController = HomeViewController()
//    let workoutViewController = WorkoutViewController()
//    let workoutLogViewController = WorkoutLogViewController()
//    let supportDeveloperViewController = SupportDeveloperViewController()
//    let settingsViewController = SettingsViewController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics.self])

        main = UINavigationController(rootViewController: DashboardTabBarController())

        self.migrateSchemaIfNeeded()
        self.setDefaultSettings()
        
//        self.sideNavigationViewController = SideNavigationController(
//            rootViewController: self.main!,
//            leftViewController: self.sideViewController
//        )
//
//        self.sideNavigationViewController?.setLeftViewWidth(260, hidden: true, animated: false)

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.tintColor = UIColor.primaryDark()
        self.window?.backgroundColor = UIColor.primary()
        self.window?.rootViewController = main!
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationDidEnterBackground(application: UIApplication) {
        UIApplication.sharedApplication().idleTimerDisabled = false
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        UIApplication.sharedApplication().idleTimerDisabled = true
    }
    
    func setDefaultSettings() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if(defaults.objectForKey("playAudioWhenTimerStops") == nil) {
            defaults.setBool(true, forKey: "playAudioWhenTimerStops")
        }
    }
    
    func migrateSchemaIfNeeded() {
        if (RepositoryStream.sharedInstance.repositoryRoutineForTodayExists()) {
            let routine = RoutineStream.sharedInstance.routine
            let currentSchema = RepositoryStream.sharedInstance.getRepositoryRoutineForToday()
            
            let (shouldRemoveCurrentSchema, newSchema) = migrateSchemaIfNeeded(routine, currentSchema: currentSchema)
            
            if shouldRemoveCurrentSchema {
                let realm = RepositoryStream.sharedInstance.getRealm()
                
                try! realm.write {
                    realm.add(newSchema, update: false)
                    realm.delete(currentSchema)
                }
            }
        }
    }
    
    func migrateSchemaIfNeeded(routine: Routine, currentSchema: RepositoryRoutine) -> (Bool, RepositoryRoutine) {
        if (!isValidSchema(routine, currentSchema: currentSchema)) {
            let newSchema = RepositoryStream.sharedInstance.buildRoutine(routine)
            
            newSchema.startTime = currentSchema.startTime
            newSchema.lastUpdatedTime = currentSchema.lastUpdatedTime
            
            for exercise in newSchema.exercises {
                if let currentExercise = currentSchema.exercises.filter({
                    $0.exerciseId == exercise.exerciseId
                }).first {
                    exercise.sets.removeAll()
                    
                    for set in currentExercise.sets {
                        exercise.sets.append(set)
                    }
                }
            }
            
            return (true, newSchema)
        }
        
        return (false, currentSchema)
    }
    
    func isValidSchema(routine: Routine, currentSchema: RepositoryRoutine) -> Bool {
        for exercise in routine.exercises {
            if let exercise = exercise as? Exercise {
                let containsExercise = currentSchema.exercises.contains({
                    $0.exerciseId == exercise.exerciseId
                })
                
                if (!containsExercise) {
                    return false
                }
            }
        }
        
        return true
    }
}

