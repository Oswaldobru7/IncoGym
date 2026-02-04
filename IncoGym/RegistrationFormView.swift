import SwiftUI

struct RegistrationFormView: View {
    @Binding var profile: UserProfile
    var onNext: () -> Void
    
    var body: some View {
        ZStack {
            Color.darkBg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    Text("Tus Datos").font(.title.bold()).foregroundColor(.white)
                    
                    Group {
                        TextField("Nombre", text: $profile.name)
                            .onChange(of: profile.name) { oldValue, newValue in
                                UserDefaults.standard.set(newValue, forKey: "user_name")
                            }
                        
                        TextField("Peso", text: $profile.weight).keyboardType(.decimalPad)
                        
                        Picker("Unidad", selection: $profile.weightUnit) {
                            Text("kg").tag("kg")
                            Text("lb").tag("lb")
                        }.pickerStyle(.segmented)
                    }
                    .padding().background(Color.white.opacity(0.1)).cornerRadius(10).foregroundColor(.white)
                    
                    Button("SIGUIENTE") { onNext() }
                        .padding().frame(maxWidth: .infinity).background(Color.gymTurquoise).foregroundColor(.black).cornerRadius(10)
                }
                .padding()
            }
        }
    }
}
