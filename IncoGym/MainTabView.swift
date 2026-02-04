import SwiftUI

struct MainTabView: View {
    let goal: String
    let profile: UserProfile
    let onLogout: () -> Void

    var body: some View {
        TabView {
            HomeView(userName: profile.name)
                .tabItem {
                    Image(systemName: "house.fill")
                }

            RoutineCreatorView()
                .tabItem {
                    Image(systemName: "calendar.badge.plus")
                }

            ProfileView(profile: profile, onLogout: onLogout)
                .tabItem {
                    Image(systemName: "person.fill")
                }
        }
        .accentColor(.gymTurquoise)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = UIColor(Color.darkBg.opacity(0.95))
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
