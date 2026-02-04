import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct IncoGymApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    

    @StateObject private var routineManager = RoutineManager()

    var body: some Scene {
        WindowGroup {
            // 2. PASAMOS EL MANAGER AL CONTENT VIEW
            ContentView()
                .environmentObject(routineManager)
                .preferredColorScheme(.dark) 
        }
    }
}
