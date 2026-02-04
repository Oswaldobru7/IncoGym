import SwiftUI

struct Question {
    let text: String
    let options: [String]
}

struct QuestionnaireView: View {
    @Binding var finished: Bool
    @Binding var finalGoal: String?
    
    @State private var currentBlock = 0
    @State private var selectedAnswers: [String: Int] = [:]
    
    let blocks: [[Question]] = [
        [
            Question(text: "¿Cuál es tu objetivo principal?", options: ["Ganar masa muscular", "Perder grasa", "Aumentar fuerza", "Salud General"]),
            Question(text: "¿Cuántos días entrenarás?", options: ["2-3 días", "4-5 días", "6 días"])
        ]
    ]

    var body: some View {
        ZStack {
            Color.darkBg.ignoresSafeArea()
            
            VStack(spacing: 25) {
                headerSection
                
                ScrollView {
                    VStack(spacing: 30) {
                        ForEach(0..<blocks[currentBlock].count, id: \.self) { qIdx in
                            questionBlock(qIdx: qIdx)
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()

                Button(action: nextStep) {
                    Text(currentBlock == blocks.count - 1 ? "FINALIZAR" : "SIGUIENTE")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gymTurquoise)
                        .foregroundColor(.black)
                        .cornerRadius(15)
                }
                .padding()
            }
        }
    }

    // MARK: - Subvistas para evitar errores de compilador
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Paso \(currentBlock + 1) de \(blocks.count)")
                .font(.caption.bold())
                .foregroundColor(.gymTurquoise)
            
            ProgressView(value: Double(currentBlock + 1), total: Double(blocks.count))
                .tint(.gymTurquoise)
                .padding(.horizontal, 40)
        }
        .padding(.top)
    }

    private func questionBlock(qIdx: Int) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(blocks[currentBlock][qIdx].text)
                .font(.title3.bold())
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                ForEach(0..<blocks[currentBlock][qIdx].options.count, id: \.self) { oIdx in
                    optionButton(qIdx: qIdx, oIdx: oIdx)
                }
            }
        }
    }

    private func optionButton(qIdx: Int, oIdx: Int) -> some View {
        let key = "\(currentBlock)-\(qIdx)"
        let isSelected = selectedAnswers[key] == oIdx
        
        return Button(action: { selectedAnswers[key] = oIdx }) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                Text(blocks[currentBlock][qIdx].options[oIdx])
                    .font(.body)
                Spacer()
            }
            .padding()
            .background(isSelected ? Color.gymTurquoise.opacity(0.15) : Color.white.opacity(0.05))
            .foregroundColor(isSelected ? .gymTurquoise : .white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.gymTurquoise : Color.clear, lineWidth: 1)
            )
        }
    }

    func nextStep() {
        if currentBlock < blocks.count - 1 {
            withAnimation { currentBlock += 1 }
        } else {
            let firstAns = selectedAnswers["0-0"] ?? 0
            let goals = ["Ganar Músculo", "Perder Grasa", "Ganar Fuerza", "Salud General"]
            finalGoal = goals[firstAns]
            finished = true
        }
    }
}
