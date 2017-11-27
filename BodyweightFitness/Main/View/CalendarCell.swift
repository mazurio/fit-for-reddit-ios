import UIKit
import MessageUI

func getWeightUnit() -> String {
    if PersistenceManager.getWeightUnit() == "lbs" {
        return "lbs"
    } else {
        return "kg"
    }
}

class WorkoutLogCardCell: UITableViewCell, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var progressRate: UILabel!
    
    var parentController: UIViewController?
    var date: Date?
    var repositoryRoutine: RepositoryRoutine?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onClickView(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "WorkoutLog", bundle: Bundle.main)
        
        let p = storyboard.instantiateViewController(
            withIdentifier: "WorkoutLogViewController"
        ) as! WorkoutLogViewController
        
        p.date = date
        p.repositoryRoutine = repositoryRoutine
        p.hidesBottomBarWhenPushed = true
        
        self.parentController?.navigationController?.pushViewController(p, animated: true)
    }
    
    @IBAction func onClickExport(_ sender: AnyObject) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }

        guard let routine = repositoryRoutine else {
            return
        }

        let weightUnit = getWeightUnit()

        let companion = RepositoryRoutineCompanion(routine)

        let mailString = companion.exercisesAsCSV(weightUnit: weightUnit)
        let data = mailString.data(using: String.Encoding.utf8, allowLossyConversion: false)

        let subject = companion.emailSubject()
        let body = companion.emailBody(weightUnit: weightUnit)
        let csvName = companion.csvName()

        let emailViewController = configuredMailComposeViewController(subject: subject, messageBody: body, csv: data, csvName: csvName)
        self.parentController?.present(emailViewController, animated: true, completion: nil)
    }
    
    @IBAction func onClickRemove(_ sender: AnyObject) {
        let alertController = UIAlertController(
            title: "Remove Workout",
            message: "Are you sure you want to remove this workout?",
            preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.cancel,
            handler: nil))
        
        alertController.addAction(UIAlertAction(
            title: "Remove",
            style: UIAlertActionStyle.destructive,
            handler: { (action: UIAlertAction!) in
                let realm = RepositoryStream.sharedInstance.getRealm()
                
                try! realm.write {
                    realm.delete(self.repositoryRoutine!)
                }
                
                if let parent = self.parentController as? CalendarViewController {
                    if let date = self.date {
                        parent.showOrHideCardViewForDate(date)
                    }
                }

                RoutineStream.sharedInstance.setRepository()
        }))
        
        self.parentController?.present(alertController, animated: true, completion: nil)
    }

    func configuredMailComposeViewController(subject: String, messageBody: String, csv: Data?, csvName: String) -> MFMailComposeViewController {
        let emailController = MFMailComposeViewController()

        emailController.mailComposeDelegate = self
        emailController.setSubject(subject)
        emailController.setMessageBody(messageBody, isHTML: false)

        if let data = csv {
            emailController.addAttachmentData(data, mimeType: "text/csv", fileName: csvName)
        }

        return emailController
    }

    // MARK: - MFMailComposeViewControllerDelegate

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
