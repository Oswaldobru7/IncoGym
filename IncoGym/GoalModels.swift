import SwiftUI

struct FitnessGoal: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let distribution: [Double]
}
