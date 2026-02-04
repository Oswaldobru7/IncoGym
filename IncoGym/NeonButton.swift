import SwiftUI

struct NeonButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .bold()
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gymTurquoise)
            .foregroundColor(.black)
            .cornerRadius(14)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
