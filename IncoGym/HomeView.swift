import SwiftUI

struct HomeView: View {
    let userName: String
    @EnvironmentObject var manager: RoutineManager
    
    var today: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: Date()).capitalized
    }
    
    private func getExercises(for day: String) -> [Exercise] {
        return manager.weeklyRoutine[day] ?? []
    }
    
    var body: some View {
        ZStack {
            Color.darkBg.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    headerSection
                    
                    trainingCard(exercises: getExercises(for: today))
                    
                    Text("Tu Plan Semanal")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        ForEach(["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"], id: \.self) { dayName in
                            let dayExercises = getExercises(for: dayName)
                            // Aquí llamamos a DayRow
                            DayRow(
                                day: String(dayName.prefix(3)).uppercased(),
                                muscle: dayExercises.isEmpty ? "Descanso" : dayExercises.map({$0.name}).joined(separator: ", "),
                                status: dayExercises.isEmpty ? "Recuperación" : "Programado",
                                isCurrent: dayName == today
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .foregroundColor(.white)
                .padding(.top, 20)
            }
        }
    }
    
    // MARK: - Componentes Privados
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Hola, \(userName)")
                    .font(.system(size: 28, weight: .bold))
                Text("Hoy es \(today)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private func trainingCard(exercises: [Exercise]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("ENTRENAMIENTO")
                .font(.system(size: 10, weight: .black))
                .tracking(2)
                .foregroundColor(.gymTurquoise)
            
            Text(exercises.isEmpty ? "Día de Descanso" : exercises.map({$0.name}).prefix(2).joined(separator: ", "))
                .font(.title3.bold())
                .lineLimit(1)
            
            HStack {
                Label("\(exercises.count) ejercicios", systemImage: "dumbbell")
                Spacer()
                if !exercises.isEmpty {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gymTurquoise)
                }
            }
            .font(.caption.bold())
        }
        .padding(25)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.gymTurquoise.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal)
    }
}

// MARK: - COMPONENTE FUERA DE HOMEVIEW
// Esto soluciona el error de "Cannot find in scope"
struct DayRow: View {
    let day: String
    let muscle: String
    let status: String
    let isCurrent: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            Text(day)
                .font(.system(size: 10, weight: .bold))
                .frame(width: 45, height: 45)
                .background(isCurrent ? Color.gymTurquoise : Color.white.opacity(0.1))
                .foregroundColor(isCurrent ? .black : .white)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(muscle)
                    .font(.subheadline.bold())
                    .lineLimit(1)
                Text(status)
                    .font(.caption)
                    .foregroundColor(isCurrent ? Color.gymTurquoise : .gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
    }
}
