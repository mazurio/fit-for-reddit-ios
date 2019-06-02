import Foundation
import RealmSwift

class RepositoryCategory: Object {
    @objc dynamic var id = "Category-" + UUID().uuidString
    @objc dynamic var categoryId = ""
    @objc dynamic var title = ""
    @objc dynamic var routine: RepositoryRoutine?
    
    let sections = List<RepositorySection>()
    let exercises = List<RepositoryExercise>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["categoryId"]
    }
}
