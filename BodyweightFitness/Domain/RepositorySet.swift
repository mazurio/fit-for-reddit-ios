import Foundation
import RealmSwift

class RepositorySet: Object {
    @objc dynamic var id = "Set-" + UUID().uuidString
    @objc dynamic var isTimed = false
    @objc dynamic var weight = 0.0
    @objc dynamic var reps = 0
    @objc dynamic var seconds = 0
    @objc dynamic var exercise: RepositoryExercise?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
