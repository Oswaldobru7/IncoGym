import SwiftUI

struct ProfileView: View {
    let profile: UserProfile
    let onLogout: () -> Void
    
    var body: some View {
        ZStack {
            Color(red: 0.08, green: 0.08, blue: 0.11).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    VStack {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable().frame(width: 80, height: 80)
                            .foregroundColor(.white.opacity(0.2))
                        Text(profile.name).font(.title.bold()).foregroundColor(.white)
                        Text(profile.country).foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 20) {
                        metricItem(label: "Peso", value: profile.weight, unit: "kg")
                        metricItem(label: "Altura", value: profile.height, unit: "cm")
                        metricItem(label: "Edad", value: profile.age, unit: "años")
                    }
                    .padding().background(Color.white.opacity(0.05)).cornerRadius(20)
                    
                    ProductivityChart()
                    
                    Button(action: onLogout) {
                        Text("Cerrar Sesión").foregroundColor(.red).bold()
                    }
                }
                .padding()
            }
        }
    }
    
    private func metricItem(label: String, value: String, unit: String) -> some View {
        VStack {
            Text("\(value) \(unit)").bold().foregroundColor(.white)
            Text(label).font(.caption2).foregroundColor(.gray)
        }.frame(maxWidth: .infinity)
    }
}

struct ProductivityChart: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Estadísticas de Productividad").font(.headline).foregroundColor(.white)
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.05))
                .frame(height: 150)
                .overlay(
                    Text("Gráfico de Actividad").foregroundColor(.orange.opacity(0.5))
                )
        }
    }
}
