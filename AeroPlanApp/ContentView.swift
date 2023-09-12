    
import SwiftUI
import Firebase
import CryptoKit

struct ContentView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var isUserLoggedIn: Bool
    let stayLoggedInKey = "stayLoggedInKey"
    @State private var stayLoggedIn: Bool
    
    
    @Binding var token: String
    @EnvironmentObject var dataManager: DataManager
    @Binding var appMode: AppMode
    
    init(isUserLoggedIn: Binding<Bool>, token: Binding<String>,appMode: Binding<AppMode>) {
           _isUserLoggedIn = isUserLoggedIn
           _token = token
            _appMode = appMode
        
            // persistent data
            _stayLoggedIn = State(initialValue: UserDefaults.standard.bool(forKey: stayLoggedInKey))
            _email = State(initialValue: UserDefaults.standard.string(forKey: "userEmail") ?? "")
        
       }
    
    var body: some View {
          NavigationView {
              if isUserLoggedIn{
                  NavigationView{
                      HomeView(isUserLoggedIn: $isUserLoggedIn, logoutAction: logout, appMode: $appMode)
                          .navigationBarBackButtonHidden(true)
                  }
              } else { // shows the Login Page
                  content
              }
          }
         
          .onAppear {
              checkUserAuthentication()
          }.environmentObject(dataManager)
      }
    
    var content: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Welcome")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                
                TextField("Email", text: $email)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: email.isEmpty) {
                        Text("Email")
                            .foregroundColor(.black)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                SecureField("Password", text: $password)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: password.isEmpty) {
                        Text("Password")
                            .foregroundColor(.black)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                Toggle("Stay Logged In", isOn: $stayLoggedIn)
                    .foregroundColor(.white)
                    .padding()
                    .onChange(of: stayLoggedIn) {newValue in
                        UserDefaults.standard.set(newValue, forKey: stayLoggedInKey)
                    }
                
                Button(action: login) {
                    Text("Login")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(Color.white)
                        .foregroundColor(.orange)
                }
                .padding(.top)
                .offset(y: 100)
                
                Button(action: register) {
                    Text("Sign up")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(.white)
                        .foregroundColor(.orange)
                }
                .padding(.top)
                .offset(y: 100)
                
            }
            .frame(width: 350)
            .onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        isUserLoggedIn.toggle()
                    }
                }
            }
        }
        .background(
            Image("Home_background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height)
        )
    }
    var backButton: some View {
            Button(action: {
                isUserLoggedIn = false // Set userIsLoggedIn to false to navigate back to the ContentView
            }) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
            }
        }
    
    func checkUserAuthentication() {
        if stayLoggedIn, let storedToken = UserDefaults.standard.string(forKey: "token") {
            Auth.auth().signIn(withCustomToken: storedToken) { authResult, error in
                if authResult != nil {
                    isUserLoggedIn = true
                    // Navigate to the appropriate view
                }
            }
        } else if let currentUser = Auth.auth().currentUser {
            isUserLoggedIn = true
            email = currentUser.email ?? ""
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                isUserLoggedIn = true
                dataManager.didLogin(username: email)
                dataManager.email = email
                // store email
                UserDefaults.standard.set(email, forKey: "userEmail")
                
                dataManager.password = password
                // store the token after a successful login
                if stayLoggedIn {
                               UserDefaults.standard.set(generateToken(), forKey: "token")
                           }
            }
        }
    }
    
    // hash for the user login
    func generateToken() -> String {
        let randomValue = UUID().uuidString
        let timestamp = "\(Date().timeIntervalSince1970)"
        let combinedValue = randomValue + timestamp
        
        if let data = combinedValue.data(using: .utf8) {
            let hashedData = SHA256.hash(data: data)
            let token = hashedData.compactMap { String(format: "%02x", $0) }.joined()
            return token
        }
        
        // Default fallback token generation (if hashing fails)
        return randomValue
    }
    
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "token")
        stayLoggedIn = false
        password = ""
        isUserLoggedIn = false // Set userIsLoggedIn to false to navigate back to the ContentView
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isUserLoggedIn: .constant(false), token: .constant(""), appMode: .constant(.ground))
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

