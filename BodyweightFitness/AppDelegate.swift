import UIKit
import CoreData
import Fabric
import Crashlytics

class TabBarController: UITabBarController {
    let homeViewController = HomeViewController()
    let workoutLogViewController = WorkoutLogViewController()
    let supportDeveloperViewController = SupportDeveloperViewController()
    let settingsViewController = SettingsViewController()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tabBar.tintColor = UIColor.primary()
        self.tabBar.barTintColor = UIColor.white

        self.homeViewController.tabBarItem = UITabBarItem(
                title: "Home",
                image: UIImage(named: "tab_home"),
                selectedImage: UIImage(named: "tab_home"))

        self.workoutLogViewController.tabBarItem = UITabBarItem(
            title: "Workout Log",
            image: UIImage(named: "tab_workout_log"),
            selectedImage: UIImage(named: "tab_workout_log"))
        
        self.supportDeveloperViewController.tabBarItem = UITabBarItem(
            title: "Support Developer",
            image: UIImage(named: "tab_support_developer"),
            selectedImage: UIImage(named: "tab_support_developer"))

        self.settingsViewController.tabBarItem = UITabBarItem(
                title: "Settings",
                image: UIImage(named: "tab_settings"),
                selectedImage: UIImage(named: "tab_settings"))

        self.viewControllers = [
            self.homeViewController,
            self.workoutLogViewController,
            self.supportDeveloperViewController,
            self.settingsViewController
        ]
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])

        self.migrateSchemaIfNeeded()
        self.setDefaultSettings()
//
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        self.window?.tintColor = UIColor.primaryDark()
//        self.window?.backgroundColor = UIColor.primary()
//        self.window?.rootViewController = UINavigationController(rootViewController: TabBarController())
//        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func setDefaultSettings() {
        let defaults = Foundation.UserDefaults.standard
        
        if(defaults.object(forKey: "playAudioWhenTimerStops") == nil) {
            defaults.set(true, forKey: "playAudioWhenTimerStops")
        }
        
        if(defaults.object(forKey: "showRestTimer") == nil) {
            defaults.set(true, forKey: "showRestTimer")
        }
        
        if(defaults.object(forKey: "showRestTimerAfterWarmup") == nil) {
            defaults.set(false, forKey: "showRestTimerAfterWarmup")
        }
        
        if(defaults.object(forKey: "showRestTimerAfterBodylineDrills") == nil) {
            defaults.set(true, forKey: "showRestTimerAfterBodylineDrills")
        }
        
        if(defaults.object(forKey: "showRestTimerAfterFlexibilityExercises") == nil) {
            defaults.set(false, forKey: "showRestTimerAfterFlexibilityExercises")
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
    
    func migrateSchemaIfNeeded(_ routine: Routine, currentSchema: RepositoryRoutine) -> (Bool, RepositoryRoutine) {
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
    
    func isValidSchema(_ routine: Routine, currentSchema: RepositoryRoutine) -> Bool {
        for exercise in routine.exercises {
            if let exercise = exercise as? Exercise {
                let containsExercise = currentSchema.exercises.contains(where: {
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

