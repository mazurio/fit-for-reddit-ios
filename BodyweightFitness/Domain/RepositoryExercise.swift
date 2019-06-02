import Foundation
import RealmSwift

class RepositoryExercise: Object {
    @objc dynamic var id = "Exercise-" + UUID().uuidString
    @objc dynamic var exerciseId = ""
    @objc dynamic var title = ""
    @objc dynamic var desc = ""
    @objc dynamic var defaultSet = ""
    @objc dynamic var visible = true
    @objc dynamic var routine: RepositoryRoutine?
    @objc dynamic var category: RepositoryCategory?
    @objc dynamic var section: RepositorySection?
    
    let sets = List<RepositorySet>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["exerciseId"]
    }
}
