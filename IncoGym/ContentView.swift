import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var userProfile: UserProfile? = nil
    @State private var registrationCompleted = false // Este es nuestro disparador

    var body: some View {
        Group {
            if isLoggedIn {
                
                if registrationCompleted || (userProfile != nil && !userProfile!.name.isEmpty) {
                    MainTabView(
                        goal: userProfile?.goal ?? "Fitness",
                        profile: userProfile ?? UserProfile(),
                        onLogout: {
                            isLoggedIn = false
                            registrationCompleted = false
                        }
                    )
                } else {
                    // Pasamos el cierre que cambia el estado a true
                    UserDataFormView(profile: Binding(
                        get: { self.userProfile ?? UserProfile() },
                        set: { self.userProfile = $0 }
                    ), onComplete: {
                        withAnimation {
                            self.registrationCompleted = true
                        }
                    })
                }
            } else {
                LoginView(onLoginSuccess: { profile in
                    self.userProfile = profile
                    withAnimation { self.isLoggedIn = true }
                })
            }
        }
    }
}
