//
//  PilotReviewNotesView.swift
//  AeroPlanApp
//
//  Created by Aaron Yu on 8/31/23.
//
import Foundation
import SwiftUI



struct PilotReviewNotesView: View {
    /*
     these variables removed because they are not adequate enough to handle data and states for our view
     @State private var newEntry = ""
     @State private var txtData: [TextEditorData] = [] --> replaced in TextEditorViewModel Class down below
     
     */
    
    //replaced the variables above with TextEditorViewModel class object
    @ObservedObject var viewModel: TextEditorViewModel
    
    init(viewModel: TextEditorViewModel){
        self.viewModel = viewModel
    }
    
    
    
    //Main layer of the PilotReviewNotesView excluded the actual notes UI
    var body: some View {
        VStack{
            
            Text("Pilot Review Notes")
                .font(.custom("Futura", size: 42))
                .foregroundColor(.red)
                .padding(.top)
            
            HStack{
                Button(action: {
                    let data = TextEditorData(text: "", sldVal: 0)
                    viewModel.txtData.append(data)
                    viewModel.saveData() //saves the data when adding a new item into the view and exit the view
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
                ForEach(viewModel.txtData.indices, id: \.self) { index in
                    VStack {
                        TextEditorView(data: $viewModel.txtData[index])
                            .padding(.bottom, 10)

                        HStack {
                            Spacer()
                            Button(action: {
                                viewModel.removeItem(at: index)
                            }) {
                                Text("Delete")
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.trailing)// Add padding to the button
                            .offset(x:-140,y:-60)
                        }
                    }
                }
            }
            
            /* The original ScrollView just incase you fuck up
             ScrollView{
                 ForEach(viewModel.txtData.indices, id: \.self){ index in
                     TextEditorView(data: $viewModel.txtData[index])
                         .padding(.bottom, 10)
                 }
             }
             */
            
    }
}
    //TextEditor UI with Slider
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
    
    //this is an interface that holds texteditor data
    struct TextEditorData : Identifiable, Codable{
        var id = UUID()
        var text: String
        var sldVal: Double
    }
    
    /*We are creating a TextEditorViewModel Class to handle the
     data that is localized on the users device so that
     the data will not be deleted after they exit the view
     */
    class TextEditorViewModel: ObservableObject{
        @Published var txtData: [TextEditorData] = []
        
        //initialization of each class object
        init(){
            if let savedData = UserDefaults.standard.data(forKey: "txtData"),
               let decodedData = try? JSONDecoder().decode([TextEditorData].self, from: savedData){
                self.txtData =  decodedData
            }
        }
        func saveData(){
            //encodes and saves the data to userdefault
            if let encodeData = try? JSONEncoder().encode(txtData){
                UserDefaults.standard.set(encodeData, forKey: "txtData")
            }
        }
        // Function to remove an item at a specific index
        func removeItem(at index: Int) {
            guard index >= 0, index < txtData.count else {
                return // Ensure the index is valid
            }
                txtData.remove(at: index) // Remove the item from the list
                saveData() // Save the updated data
            }
        }
    
    
    struct PilotReviewNotesView_Previews: PreviewProvider {
        static var previews: some View {
            PilotReviewNotesView(viewModel: PilotReviewNotesView.TextEditorViewModel())
        }
    }
    
}
