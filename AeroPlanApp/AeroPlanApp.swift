import SwiftUI
import Firebase

// main app to connect to FireBase and take in the default parameters initially.
@main
struct AeroPlanApp: App {
    @StateObject var dataManager = DataManager()
    @State private var isUserLoggedIn = false
    @State private var token = ""
    @State private var appMode: AppMode = .none
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(isUserLoggedIn: $isUserLoggedIn, token: $token,appMode: $appMode
            ).environmentObject(dataManager)
        }
    }
    
}
