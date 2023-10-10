//
//  ProfileView.swift
//  AeroPlan
//
//  Created by Nguyen Vo on 7/7/23.
//
import SwiftUI
import Firebase

struct ProfileView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View{
        VStack(alignment: .leading){
                Text("Email: \(dataManager.email) ")
                SecureField("Password:" , text:.constant(dataManager.password))
                Spacer()
        }.padding()
            .navigationTitle("Profile")
        
        
    }
}

