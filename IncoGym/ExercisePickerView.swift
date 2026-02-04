import SwiftUI

struct ExercisePickerView: View {
    @EnvironmentObject var manager: RoutineManager
    let day: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.darkBg.ignoresSafeArea()
            
            List {
                ForEach(gymDatabase) { category in
                    Section(header: sectionHeader(category.name)) {
                        ForEach(category.exercises) { exercise in
                            ExerciseRow(exercise: exercise) {
                                manager.addExercise(exercise, to: day)
                                dismiss()
                            }
                        }
                    }
                    .listRowBackground(Color.white.opacity(0.05))
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Añadir a \(day)")
        }
    }
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.caption.bold())
            .foregroundColor(.gray)
    }
}

struct ExerciseRow: View {
    let exercise: Exercise
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "play.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.gymTurquoise)
                    )
                
                VStack(alignment: .leading) {
                    Text(exercise.name)
                        .foregroundColor(.white)
                        .font(.body)
                }
                
                Spacer()
                
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.gymTurquoise)
            }
        }
    }
}
