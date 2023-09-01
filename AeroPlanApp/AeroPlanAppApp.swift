import SwiftUI
import Firebase

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
            ContentView(isUserLoggedIn: $isUserLoggedIn, token: $token,appMode: $appMode, dataManager: $dataManager
            ).environmentObject(dataManager)
        }
    }
    
}
