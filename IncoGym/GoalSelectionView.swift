import SwiftUI

struct GoalSelectionView: View {

    @Binding var selectedGoal: FitnessGoal?

    let goals = [
        FitnessGoal(name: "Ganar Músculo", icon: "figure.strengthtraining.traditional", distribution: [70,10,15,5]),
        FitnessGoal(name: "Perder Grasa", icon: "drop.fill", distribution: [30,40,20,10]),
        FitnessGoal(name: "Ganar Fuerza", icon: "bolt.fill", distribution: [80,5,10,5]),
        FitnessGoal(name: "Salud General", icon: "heart.fill", distribution: [40,30,20,10])
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 20) {
                Text("¿Cuál es tu objetivo?")
                    .font(.title.bold())
                    .foregroundColor(.white)

                ForEach(goals) { goal in
                    Button {
                        selectedGoal = goal
                    } label: {
                        HStack {
                            Image(systemName: goal.icon)
                            Text(goal.name).bold()
                            Spacer()
                        }
                        .padding()
                        .foregroundColor(.green)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(14)
                    }
                }
            }
            .padding()
        }
    }
}
