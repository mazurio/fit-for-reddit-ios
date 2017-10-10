import UIKit
import Eureka

class NewSettingsViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createForm()
        
        self.title = "Settings"
    }
}

extension NewSettingsViewController {
    func createForm() {
        let hideWhenRestTimerIsOffCondition = Condition.function(["showRestTimerSwitchRow"], { form in
            return !((form.rowBy(tag: "showRestTimerSwitchRow") as? SwitchRow)?.value ?? false)
        })
        
        form
            +++ Eureka.Section("General")
            <<< SwitchRow() {
                $0.title = "Play Audio"
                $0.value = false
                $0.onChange { [unowned self] row in
                    
                }
            }
            +++ Eureka.Section("Rest Timer")
            <<< SwitchRow("showRestTimerSwitchRow") {
                $0.title = "Show Rest Timer"
                $0.value = false
                $0.onChange { [unowned self] row in
                    
                }
            }
            <<< PushRow<String>() {
                $0.title = "Default Rest Time"
                $0.hidden = hideWhenRestTimerIsOffCondition
                $0.options = [
                    "30 Seconds",
                    "1 Minute",
                    "1 Minute 30 Seconds",
                    "2 Minutes",
                    "2 Minutes 30 Seconds"
                ]
                $0.onChange { [unowned self] row in
                    
                }
            }
            +++ Eureka.Section("Show Rest Timer") {
                $0.hidden = hideWhenRestTimerIsOffCondition
            }
            <<< SwitchRow() {
                $0.title = "After Warmup"
                $0.hidden = hideWhenRestTimerIsOffCondition
                $0.value = false
                $0.onChange { [unowned self] row in
                    
                }
            }
            <<< SwitchRow() {
                $0.title = "After Bodyline Drills"
                $0.hidden = hideWhenRestTimerIsOffCondition
                $0.value = false
                $0.onChange { [unowned self] row in
                    
                }
            }
            <<< SwitchRow() {
                $0.title = "After Flexibility Exercises"
                $0.hidden = hideWhenRestTimerIsOffCondition
                $0.value = false
                $0.onChange { [unowned self] row in
                    
                }
            }
            +++ Eureka.Section("Weight Measurement")
            <<< PushRow<String>() {
                $0.title = "Kilograms (kg)"
                $0.options = ["Kilograms (kg)", "Pounds (lbs)"]
                $0.onChange { [unowned self] row in

                }
            }
            +++ Eureka.Section("Author")
            <<< TextRow() {
                $0.title = "Name"
                $0.value = "Damian Mazurkiewicz"
                $0.disabled = true
            }
            <<< TextRow() {
                $0.title = "GitHub"
                $0.value = "https://github.com/mazurio/"
                $0.disabled = true
            }
            +++ Eureka.Section("About")
            <<< TextRow() {
                $0.title = "Name"
                $0.value = "Bodyweight Fitness"
                $0.disabled = true
            }
            <<< TextRow() {
                $0.title = "Version"
                $0.value = version()
                $0.disabled = true
            }
        
    }
    
    func version() -> String? {
        if let anyObject = Bundle.main.infoDictionary?["CFBundleShortVersionString"] {
            if let version: String = anyObject as? String {
                return version
            }
        }
        return nil
    }
}

