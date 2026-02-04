import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    var onLoginSuccess: (UserProfile) -> Void
    
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            Color.darkBg.ignoresSafeArea()
            
            VStack(spacing: 25) {
                Image(systemName: "bolt.ring.closed")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gymTurquoise)
                
                Text("INCOGYM")
                    .font(.system(size: 40, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    TextField("Correo electrónico", text: $email)
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(14)
                        .foregroundColor(.white)
                        .textInputAutocapitalization(.never)
                    
                    SecureField("Contraseña", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(14)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 30)
                
                VStack(spacing: 15) {
                    HStack(spacing: 15) {
                        Button(action: loginEmail) {
                            Text("ENTRAR")
                                .bold()
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gymTurquoise)
                                .cornerRadius(14)
                        }
                        
                        Button(action: { onLoginSuccess(UserProfile()) }) { 
                            Text("REGISTRAR")
                                .bold()
                                .foregroundColor(.gymTurquoise)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(14)
                        }
                    }
                    
                    Button(action: signInWithGoogle) {
                        HStack {
                            Image(systemName: "g.circle.fill")
                            Text("Continuar con Google")
                                .bold()
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(14)
                    }
                }
                .padding(.horizontal, 30)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
        }
    }
    

    func loginEmail() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else if let user = result?.user {
                onLoginSuccess(createProfile(from: user))
            }
        }
    }
    
    func registerEmail() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else if let user = result?.user {
                onLoginSuccess(createProfile(from: user))
            }
        }
    }
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else if let user = result?.user {
                    onLoginSuccess(createProfile(from: user))
                }
            }
        }
    }

    private func createProfile(from user: User) -> UserProfile {
        return UserProfile(
            name: user.displayName ?? "Usuario",
            lastName: "",
            email: user.email ?? "",
            weight: "75",
            height: "175",
            age: "25",
            goal: "Salud General",
            gender: "Masculino"
        )
    }
}
