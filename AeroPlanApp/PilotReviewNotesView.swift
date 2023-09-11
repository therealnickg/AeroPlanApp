//
//  PilotReviewNotesView.swift
//  AeroPlanApp
//
//  Created by Aaron Yu on 9/5/23.
//

import SwiftUI

struct PilotReviewNotesView: View {
    @State private var userInput: String = ""
    @State private var userText: String = ""
    
    var body: some View {
        VStack{
        
            Text("Pilot Review Notes")
                .font(.largeTitle)
                .foregroundColor(.red)
                .padding(.top)
           
            
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black)
                TextEditor(text: $userText)
                    .frame(maxWidth: 325, maxHeight: 250)
                    .background(Color.clear)
                    .cornerRadius(10)
            }
            .frame(maxHeight: 275)
            .padding()
            Spacer()
            }
        
    
        
        
        
        
        
        
        
        
        
        
        
        //Text Boxes for Airport Review (delete later this is not it)
        NavigationView{
            List{
                NavigationLink(destination: DetailView()){
                    Text("Personal Notes")
                }
            }
            .navigationTitle("Airport Review Notes")
        }
        
        
    }
    
    struct DetailView: View {
        var body: some View {
            Text("Detail View Content")
                .navigationBarTitle("Detail View")
        }
    }
    
    
    
    
    
}

struct PilotReviewNotesView_Previews: PreviewProvider {
    static var previews: some View {
        PilotReviewNotesView()
    }
}
