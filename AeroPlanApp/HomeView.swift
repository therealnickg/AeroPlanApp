//
//  HomeView.swift
//  AeroPlan
//
//  Created by Nguyen Vo on 7/4/23.
//

import SwiftUI
import Firebase




struct VisualEffectView: UIViewRepresentable {
    let blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)

    }
}

struct HomeView: View {
    @Binding var isUserLoggedIn: Bool
    @Binding var appMode: AppMode
    @State private var isMenuOpen = false
    let logoutAction: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    init(isUserLoggedIn: Binding<Bool>, logoutAction: @escaping () -> Void, appMode: Binding<AppMode>) {
        _isUserLoggedIn = isUserLoggedIn
        self.logoutAction = logoutAction
        _appMode = appMode
        
    }
    
    var appModeBinding: Binding<AppMode?> {
        Binding<AppMode?>(
            get: { self.appMode },
            set: { self.appMode = $0 ?? .none } // Provide a default value if nil
        )
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            logoutAction()
            isMenuOpen.toggle()
            presentationMode.wrappedValue.dismiss() // Dismiss the HomeView and return to ContentView
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                // Main content view
                VStack(spacing: 0) {
                    // Top navigation bar
                    HStack {
                        Button(action: {
                            isMenuOpen.toggle()
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .font(.title)
                                .foregroundColor(.black)
                                .opacity(isMenuOpen ? 0 : 1)
                                .padding(.top)
                                .padding(.leading, 16)
                        }
                        Spacer()
                    }
                    
                    Text("Main Content") // Your content here
                        .frame(maxWidth: .infinity)
                        .padding(.top)
                        .background(Color.white)
                    
                    
                    // AIR & GROUND MODES
                    HStack(spacing: 0) {
                        if appMode == .ground {
                            NavigationLink(destination: GroundView(), tag: .ground, selection: appModeBinding) {
                                EmptyView()
                            }
                        } else if appMode == .air {
                            NavigationLink(destination: AirView(), tag: .air, selection: appModeBinding) {
                                EmptyView()
                            }
                        }
                        else if appMode == .pReview {
                            NavigationLink(destination: PilotReviewNotesView(viewModel: PilotReviewNotesView.TextEditorViewModel()), tag: .pReview, selection: appModeBinding) {
                                EmptyView()
                            }
                        }
                        else if appMode == .logs {
                                NavigationLink(destination: LogsView(), tag: .logs, selection: appModeBinding) {
                                    EmptyView()
                                }
                            }
                        else if appMode == .lostCom {
                            NavigationLink(destination: LostComView(), tag: .lostCom, selection: appModeBinding) {
                                EmptyView()
                            }
                        }
                        else if appMode == .GAPC {
                            NavigationLink(destination: GAPCView(), tag: .GAPC, selection: appModeBinding){
                                EmptyView()
                            }
                        }
                        

                        
                    }
                    
                    HStack{
                        Button(action: {
                            appMode = .ground
                        }) {
                            Image("Ground")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth:  geometry.size.width / 2.5,maxHeight: geometry.size.height / 4)
                                .background(Color(red:171/255, green:187/255,blue: 214/255))
                                .cornerRadius(50)
                                .padding(10)
                        }
                        
                        Button(action: {
                            appMode = .air
                        }) {
                            Image("Air")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth:  geometry.size.width / 2.5,maxHeight: geometry.size.height / 4)
                                .background(Color(red:171/255, green:187/255,blue: 214/255))
                                .cornerRadius(50)
                                .padding(10)
                        }
                        Button(action: {
                            appMode = .pReview
                        }) {
                            Image("Notes")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth:  geometry.size.width / 2.5,maxHeight: geometry.size.height / 4)
                                .background(Color(red:171/255, green:187/255,blue: 214/255))
                                .cornerRadius(50)
                                .padding(10)
                        }
                        Button(action: {
                            appMode = .GAPC
                        }) {
                            Image("Check.svg")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth:  geometry.size.width / 2.5,maxHeight: geometry.size.height / 4)
                                .background(Color(red:171/255, green:187/255,blue: 214/255))
                                .cornerRadius(50)
                                .padding(10)
                        }
                        
                        
                    }
                }
                .background(Color.white)
                .frame(width: geometry.size.width)
                .offset(x: isMenuOpen ? geometry.size.width * 0.5 : 0) // Slide the main content view based on menu state
                
                // Blurred background
                if isMenuOpen {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            isMenuOpen.toggle() // Close the menu when tapped outside
                        }
                }
                
                // Side menu view
                if isMenuOpen {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Image(systemName: "line.horizontal.3")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                            Spacer()
                        }
                        .background(Color.blue)
                        
                        // VIEW PROFILE
                        NavigationLink(destination: ProfileView()) {
                            Text("Profile")
                                .foregroundColor(.black)
                                .font(.headline)
                        }
                        
                        // SIGN OUT
                        Button(action: {
                            signOut()
                            
                        }) {
                            Text("Log out")
                                .foregroundColor(.black)
                                .font(.headline)
                        }
                        Spacer()
                    }
                    .padding()
                    .frame(width: geometry.size.width * 0.5)
                    .background(VisualEffectView(blurStyle: .systemMaterial))
                    .cornerRadius(10)
                    .offset(x: isMenuOpen ? 0 : -geometry.size.width * 0.5) // Slide the menu from left to right
                    .animation(.default, value: isMenuOpen) // Apply animation
                }
                
                
            }
            .frame(maxWidth: geometry.size.width)
            .background(Color(red:171/255, green:187/255,blue: 214/255))
            
            
        }
    }
    
}
    

        
        
        
        
        
        










