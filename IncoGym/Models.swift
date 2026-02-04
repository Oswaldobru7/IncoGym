import Foundation

struct ExerciseG: Identifiable, Codable, Equatable {
    var id = UUID()
    let name: String
    let muscle: String
    let gifName: String
    let description: String
    
    static func == (lhs: ExerciseG, rhs: Exercise) -> Bool {
        return lhs.name == rhs.name
    }
}
