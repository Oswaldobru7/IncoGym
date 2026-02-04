import SwiftUI
import Charts

struct GoalPreviewView: View {

    let goal: FitnessGoal
    let onConfirm: () -> Void

    let labels = ["Fuerza", "Cardio", "Volumen", "Descanso"]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 30) {
                Text(goal.name)
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                Chart {
                    ForEach(Array(goal.distribution.enumerated()), id: \.offset) { index, value in
                        BarMark(
                            x: .value("Tipo", labels[index]),
                            y: .value("Valor", value)
                        )
                        .foregroundStyle(.green)
                    }
                }
                .frame(height: 250)

                Button("CONFIRMAR OBJETIVO") {
                    onConfirm()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.black)
                .cornerRadius(14)
            }
            .padding()
        }
    }
}
