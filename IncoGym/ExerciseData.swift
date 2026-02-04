import Foundation

struct Exercise: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let gifName: String
}

struct ExerciseCategory: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let exercises: [Exercise]
}


let gymDatabase: [ExerciseCategory] = [
    ExerciseCategory(name: "PECHO", icon: "square.stack.3d.up", exercises: [
        Exercise(name: "Press banca plano", gifName: "bench_press"),
        Exercise(name: "Press banca inclinado", gifName: "inclined_press"),
        Exercise(name: "Cruces en poleas", gifName: "cable_cross")
    ]),
    ExerciseCategory(name: "ESPALDA", icon: "line.3.horizontal", exercises: [
        Exercise(name: "Remo con barra", gifName: "barbell_row"),
        Exercise(name: "Jalón al pecho", gifName: "lat_pulldown"),
        Exercise(name: "Dominadas", gifName: "pull_ups")
    ]),
    ExerciseCategory(name: "PIERNAS", icon: "rectangle.grid.1x2", exercises: [
        Exercise(name: "Sentadilla libre", gifName: "squat"),
        Exercise(name: "Prensa de piernas", gifName: "leg_press")
    ])
]
