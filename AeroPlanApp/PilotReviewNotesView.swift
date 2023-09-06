//
//  PilotReviewNotesView.swift
//  AeroPlanApp
//
//  Created by Aaron Yu on 9/5/23.
//

import SwiftUI

struct PilotReviewNotesView: View {
    @State private var userInput: String = ""
    
    var body: some View {
        VStack{
            Text("Pilot Review Notes")
                .font(.largeTitle)
                .foregroundColor(.red)
                .padding(.top)
            Spacer()
            
            TextField("Pilot Notes", text: $userInput)
                .textFieldStyle(.roundedBorder)
            }
        GroupBox(label: Text("Pilot Notes")) {
            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Content")/*@END_MENU_TOKEN@*/
        }
        
        
        
    }
    
    
    
    
    
    
    
}

struct PilotReviewNotesView_Previews: PreviewProvider {
    static var previews: some View {
        PilotReviewNotesView()
    }
}
