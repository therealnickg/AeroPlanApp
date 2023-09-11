//
//  PilotReviewNotesView.swift
//  AeroPlanApp
//
//  Created by Aaron Yu on 9/5/23.
//

import SwiftUI

struct PilotReviewNotesView: View {
    @State private var newEntry = ""
    @State private var txtData: [TextEditorData] = []
    
    var body: some View {
        VStack{
            
            Text("Pilot Review Notes")
                .font(.custom("Futura", size: 42))
                .foregroundColor(.red)
                .padding(.top)
            
            HStack{
                Button(action: {
                    let data = TextEditorData(text: newEntry, sldVal: 0)
                    txtData.append(data)
                    newEntry = ""
                })
                {
                    Text("Add")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            
            ScrollView{
                ForEach(txtData.indices, id: \.self){ index in
                    TextEditorView(data: $txtData[index])
                        .padding(.bottom, 10)
                        }
                    }
                
            
          //original Text Editor box with slider
            //RoundedRectangle(cornerRadius: 10)
                /*.fill(Color.black)
            TextEditor(text: $userText)
                .frame(maxWidth: 325, maxHeight: 200)
                .background(Color.clear)
                .cornerRadius(10)
                .offset(y:-80)
            Text("Airport Rating Scale")
                .offset(y:100)
                .foregroundColor(.white)
                .font(.custom("Futura", size: 20))
            Slider(value: $sldVal, in: 0...1)
                .padding()
                .offset(y:130)
                .offset(y:-30)
                .frame(maxHeight: 400)
                .padding()
                Spacer()
                 */
        }
    }
    
    struct TextEditorData : Identifiable{
        var id = UUID()
        var text: String
        var sldVal: Double
    }
    
    struct TextEditorView: View{
        @Binding var data: TextEditorData
        
        var body: some View{
            VStack{
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.black)
                        .frame(width: 350)
                        .frame(height: 325)
                    TextEditor(text: $data.text)
                        .frame(width: 300, height: 180)
                        .background(Color.clear)
                        .cornerRadius(10)
                        .offset(x: 25, y:10)
                    Text("Airport Rating Scale")
                        .offset(x: 80, y:200)
                        .foregroundColor(.white)
                        .font(.custom("Futura", size: 20))
                    Text("0")
                        .offset(x: 25, y:275)
                        .foregroundColor(.cyan)
                        .font(.custom("Futura", size: 20))
                    Text("10")
                        .offset(x:300, y:275)
                        .foregroundColor(.cyan)
                        .font(.custom("Futura", size:20))
                   
                    
                }
                Slider(value: $data.sldVal, in: 0...1)
                    .frame(width: 300)
                    .offset(y: -110)
            }
            
            
        }
    }
}
        
    
        
        
        
        
        
        
        
        
        
        
        

    
    
    
    
    


struct PilotReviewNotesView_Previews: PreviewProvider {
    static var previews: some View {
        PilotReviewNotesView()
    }
}
