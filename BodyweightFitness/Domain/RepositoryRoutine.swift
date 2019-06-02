import Foundation
import RealmSwift

class RepositoryRoutine: Object {
    @objc dynamic var id = "Routine-" + UUID().uuidString
    @objc dynamic var routineId = ""
    @objc dynamic var title = ""
    @objc dynamic var subtitle = ""
    @objc dynamic var startTime = Date()
    @objc dynamic var lastUpdatedTime = Date()
    
    let categories = List<RepositoryCategory>()
    let sections = List<RepositorySection>()
    let exercises = List<RepositoryExercise>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["routineId"]
    }
}
