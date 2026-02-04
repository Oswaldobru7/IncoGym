import SwiftUI
public import Combine
import FirebaseAuth
import FirebaseFirestore

struct WBCountry: Codable, Identifiable {
    var id: String { iso2Code }
    let name: String
    let iso2Code: String
}

class CountryService: ObservableObject {
    @Published var countries: [WBCountry] = []
    @Published var isLoading = false
    
    func fetchCountries() {
        self.isLoading = true
        guard let url = URL(string: "https://api.worldbank.org/v2/country?format=json&per_page=300") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [Any],
               json.count > 1,
               let countriesData = try? JSONSerialization.data(withJSONObject: json[1]),
               let decoded = try? JSONDecoder().decode([WBCountry].self, from: countriesData) {
                
                DispatchQueue.main.async {
                    self.countries = decoded.filter { !$0.name.isEmpty && !$0.iso2Code.isEmpty }
                        .sorted(by: { $0.name < $1.name })
                    self.isLoading = false
                }
            }
        }.resume()
    }
}

struct UserDataFormView: View {
    @Binding var profile: UserProfile
    var onComplete: () -> Void
    
    @StateObject private var countryService = CountryService()
    @State private var isRegistering = false
    @State private var errorMessage = ""
    
    let genders = ["Hombre", "Mujer", "Otro"]
    
    var isFormValid: Bool {
        !profile.email.isEmpty &&
        profile.password.count >= 6 &&
        !profile.name.isEmpty &&
        !profile.country.isEmpty &&
        !profile.weight.isEmpty &&
        !profile.height.isEmpty &&
        !profile.gender.isEmpty
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.08).ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    headerSection
                    
                    VStack(spacing: 20) {
                        sectionTitle("DATOS DE ACCESO")
                        CustomInputField(label: "Correo", text: $profile.email, icon: "envelope", keyboard: .emailAddress)
                        CustomInputField(label: "Contraseña (mín. 6)", text: $profile.password, icon: "lock", isSecure: true)
                        
                        sectionTitle("PERFIL")
                        CustomInputField(label: "Nombre Completo", text: $profile.name, icon: "person")
                        
                        // Selector de Sexo
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Sexo", systemImage: "person.fill.questionmark").font(.caption.bold()).foregroundColor(.cyan)
                            Picker("Sexo", selection: $profile.gender) {
                                Text("Seleccionar...").tag("")
                                ForEach(genders, id: \.self) { gender in
                                    Text(gender).tag(gender)
                                }
                            }
                            .pickerStyle(.segmented)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                        }
                        
                        countryPicker
                        
                        sectionTitle("MÉTRICAS FÍSICAS")
                        HStack(spacing: 15) {
                            CustomInputField(label: "Peso (kg)", text: $profile.weight, icon: "scalemass", keyboard: .decimalPad)
                            CustomInputField(label: "Altura (cm)", text: $profile.height, icon: "ruler", keyboard: .decimalPad)
                        }
                    }
                    .padding(.horizontal)
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    Button(action: registerInFirebase) {
                        if isRegistering {
                            ProgressView().tint(.white)
                        } else {
                            Text("FINALIZAR REGISTRO").bold()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? LinearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: [Color.gray.opacity(0.2)], startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(15)
                    .foregroundColor(.white)
                    .disabled(!isFormValid || isRegistering)
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear { countryService.fetchCountries() }
    }
    

    
    private var countryPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("País", systemImage: "globe").font(.caption.bold()).foregroundColor(.cyan)
            HStack {
                if countryService.isLoading {
                    ProgressView().tint(.white)
                } else {
                    Picker("País", selection: $profile.country) {
                        Text("Seleccionar país...").tag("")
                        ForEach(countryService.countries) { country in
                            Text(country.name).tag(country.name)
                        }
                    }
                    .pickerStyle(.menu)
                    .accentColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 10) {
            Image(systemName: "bolt.fill").font(.largeTitle).foregroundColor(.orange)
            Text("IncoGym").font(.title.bold()).foregroundColor(.white)
        }.padding(.top, 40)
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title).font(.caption2.bold()).foregroundColor(.gray).frame(maxWidth: .infinity, alignment: .leading)
    }

    func registerInFirebase() {
        isRegistering = true
        errorMessage = ""
        
        Auth.auth().createUser(withEmail: profile.email, password: profile.password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.isRegistering = false
                return
            }
            
            guard let uid = result?.user.uid else {
                self.isRegistering = false
                return
            }
            
            let userData: [String: Any] = [
                "uid": uid,
                "name": profile.name,
                "email": profile.email,
                "country": profile.country,
                "gender": profile.gender,
                "weight": profile.weight,
                "height": profile.height,
                "createdAt": FieldValue.serverTimestamp()
            ]
            
            Firestore.firestore().collection("users").document(uid).setData(userData) { error in
                self.isRegistering = false
                if let error = error {
                    self.errorMessage = "Error en base de datos: \(error.localizedDescription)"
                } else {
                    onComplete()
                }
            }
        }
    }
}

struct CustomInputField: View {
    let label: String
    @Binding var text: String
    let icon: String
    var keyboard: UIKeyboardType = .default
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon).foregroundColor(.cyan).frame(width: 25)
            if isSecure {
                SecureField("", text: $text, prompt: Text(label).foregroundColor(.gray))
            } else {
                TextField("", text: $text, prompt: Text(label).foregroundColor(.gray))
                    .keyboardType(keyboard)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .foregroundColor(.white)
    }
}
