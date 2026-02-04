import Foundation

struct UserProfile: Codable {
    var name: String = ""
    var lastName: String = ""
    var email: String = ""
    var password: String = "" 
    var country: String = ""
    var weight: String = ""
    var weightUnit: String = "kg"
    var height: String = ""
    var heightUnit: String = "cm"
    var age: String = ""
    var goal: String = "Fitness"
    var gender: String = "Masculino"
}
