import Foundation
import RealmSwift

class RepositorySection: Object {
    @objc dynamic var id = "Section-" + UUID().uuidString
    @objc dynamic var sectionId = ""
    @objc dynamic var title = ""
    @objc dynamic var mode = ""
    @objc dynamic var routine: RepositoryRoutine?
    @objc dynamic var category: RepositoryCategory?
    
    let exercises = List<RepositoryExercise>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["sectionId"]
    }
}
