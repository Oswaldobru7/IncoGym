import SwiftUI
struct RoutineCreatorView: View {
    @EnvironmentObject var manager: RoutineManager
    @State private var selectedDay = "Lunes"
    let days = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.darkBg.ignoresSafeArea()
                
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(days, id: \.self) { day in
                                Button(day) { selectedDay = day }
                                    .padding(.horizontal, 16).padding(.vertical, 8)
                                    .background(selectedDay == day ? Color.gymTurquoise : Color.white.opacity(0.05))
                                    .foregroundColor(selectedDay == day ? .black : .white)
                                    .cornerRadius(12)
                            }
                        }.padding()
                    }
                    
                    
                    List {
                        let currentExercises = manager.weeklyRoutine[selectedDay] ?? []
                        
                        if currentExercises.isEmpty {
                            Text("No hay ejercicios para el \(selectedDay)")
                                .foregroundColor(.gray).listRowBackground(Color.clear)
                        }
                        
                        ForEach(currentExercises) { ex in
                            Text(ex.name).foregroundColor(.white)
                        }
                        .onDelete { indexSet in
                            manager.weeklyRoutine[selectedDay]?.remove(atOffsets: indexSet)
                        }
                        
                        NavigationLink(destination: ExercisePickerView(day: selectedDay)) {
                            Label("Agregar Ejercicio", systemImage: "plus")
                                .foregroundColor(.gymTurquoise).bold()
                        }
                        .listRowBackground(Color.white.opacity(0.05))
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Tu Rutina")
        }
    }
}
