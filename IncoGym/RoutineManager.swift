import SwiftUI
internal import Combine

class RoutineManager: ObservableObject {
    @Published var todayExercises: [Exercise] = []
    
    @Published var weeklyRoutine: [String: [Exercise]] = [
        "Lunes": [], "Martes": [], "Miércoles": [],
        "Jueves": [], "Viernes": [], "Sábado": [], "Domingo": []
    ]
    
    func addExercise(_ exercise: Exercise) {
        if !todayExercises.contains(where: { $0.name == exercise.name }) {
            todayExercises.append(exercise)
            
            let todayName = getCurrentDayName()
            if var dayList = weeklyRoutine[todayName],
               !dayList.contains(where: { $0.name == exercise.name }) {
                dayList.append(exercise)
                weeklyRoutine[todayName] = dayList
            }
        }
    }
    
    private func getCurrentDayName() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: Date()).capitalized
    }
    func addExercise(_ exercise: Exercise, to day: String) {
        var currentExercises = weeklyRoutine[day] ?? []
        
        if !currentExercises.contains(where: { $0.name == exercise.name }) {
            currentExercises.append(exercise)
            weeklyRoutine[day] = currentExercises
            
            let todayName = getCurrentDayName()
            if day == todayName {
                todayExercises = currentExercises
            }
        }
    }
}
