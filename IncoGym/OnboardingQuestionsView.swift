import SwiftUI

struct OnboardingQuestionsView: View {

    @Binding var finished: Bool
    @Binding var finalGoal: String?

    @State private var step = 0
    @State private var muscle = 0
    @State private var fat = 0
    @State private var strength = 0
    @State private var health = 0

    let questions = [
        "¿Qué te motiva más?",
        "¿Qué resultado buscas?",
        "¿Qué te importa más?",
        "¿Cuántos días entrenarás?",
        "¿Cuánto tiempo por sesión?",
        "¿Prefieres pesas o cardio?",
        "¿Tu nivel?",
        "¿Tienes lesiones?",
        "¿Quieres verte más grande?",
        "¿Quieres bajar grasa?",
        "¿Quieres ser más fuerte?",
        "¿Buscas salud general?",
        "¿Te gusta entrenar duro?",
        "¿Qué tan constante eres?",
        "¿Objetivo principal?"
    ]

    var body: some View {
        ZStack {
            Color.darkBg.ignoresSafeArea()

            VStack(spacing: 25) {
                Text(questions[step])
                    .foregroundColor(.white)
                    .font(.title.bold())

                Button("Ganar músculo 💪") { add(m: 2) }
                Button("Perder grasa 🔥") { add(f: 2) }
                Button("Fuerza ⚡") { add(s: 2) }
                Button("Salud ❤️") { add(h: 2) }
            }
            .buttonStyle(NeonButton())
            .padding()
        }
    }

    func add(m: Int = 0, f: Int = 0, s: Int = 0, h: Int = 0) {
        muscle += m
        fat += f
        strength += s
        health += h

        if step < questions.count - 1 {
            step += 1
        } else {
            calculateGoal()
        }
    }

    func calculateGoal() {
        let max = max(muscle, fat, strength, health)

        if max == muscle { finalGoal = "Ganar Músculo" }
        else if max == fat { finalGoal = "Perder Grasa" }
        else if max == strength { finalGoal = "Ganar Fuerza" }
        else { finalGoal = "Salud General" }

        finished = true
    }
}
