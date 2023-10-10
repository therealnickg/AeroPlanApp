//
//  GAPCView.swift
//  AeroPlanApp
//
//  Created by Aaron Yu on 9/26/23.
//

import SwiftUI

//all the classes are labled as Codable in order to save data in the view when navigating to others
//class to create objects of items
class TogglelistItem : ObservableObject, Identifiable{
    let id = UUID()
    @Published var name : String
    @Published var isChecked = false
    
    init(name: String){
        self.name = name
    }
}

class PickerlistItem : ObservableObject, Identifiable{
    let id = UUID()
    @Published var title: String
    @Published var values: [String]
    @Published var selectedValue: String
    
    init(title: String, values: [String], selectedValue: String){
        self.title = title
        self.values = values
        self.selectedValue = selectedValue
    }
}
//different picker style object lol
class PickerlistItem2 : ObservableObject, Identifiable{
    let id = UUID()
    @Published var title: String
    @Published var values: [String]
    @Published var selectedValue: String
    
    init(title: String, values: [String], selectedValue: String){
        self.title = title
        self.values = values
        self.selectedValue = selectedValue
    }
}

protocol IdentifiableItem: Identifiable{
    var id: UUID {get}
}




//im creating a class so that the data persists across other views held within a list
class ListData: ObservableObject{
    //This is where you put your Item Objects to Display
    @Published var itemList: [Any] = [
        TogglelistItem(name: "Master"),
        TogglelistItem(name: "PFD Verify"),
        TogglelistItem(name: "Fuel Gauges"),
        PickerlistItem2(title: "Control Lock", values: ["On", "Off"], selectedValue: "On"),
        PickerlistItem2(title: "Low Fuel Lights", values: ["On", "Off"], selectedValue: "On"),
        PickerlistItem(title: "Flaps", values: ["Up", "Down"], selectedValue: "Up"),
        PickerlistItem(title: "Weather", values: ["Clear", "Windy", "Overcast", "Rainy", "Stormy"], selectedValue: "Clear")
    ]
    
    
    
    
    //resets all the values in the UI for the user
    func resetItems() {
        for index in itemList.indices {
            if let toggleItem = itemList[index] as? TogglelistItem {
                toggleItem.isChecked = false // Reset toggle items
            } else if let pickerItem = itemList[index] as? PickerlistItem {
                pickerItem.selectedValue = pickerItem.values.first ?? "" // Reset picker items
            } else if let pickerItem2 = itemList[index] as? PickerlistItem2 {
                pickerItem2.selectedValue = pickerItem2.values.first ?? "" // Reset picker items
            }
        }
    }
    
    
    /*//User Default Save function to persist data
    func saveUserDefault(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(itemList){
            UserDefaults.standard.set(encoded, forKey: "ItemListKey")
        }
    }
    */
    
}



//this is the main ContentView --> of this view
struct GAPCView: View {
    //object instance of ChecklistData the object holds the list of objects that will be displayed in the GAPCview
    @ObservedObject var  checkList = ListData()
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading){
                    Text("General Aircraft Preflight Checklist")
                        .padding(10)
                        .font(.largeTitle)
                        .border(Color.black)
                    Spacer()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    //This is the reset button that will reset all values in the UI
                        Button(action: {
                            checkList.resetItems()
                        }){
                            Text("Reset")
                                .foregroundColor(.white)
                                
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.red)
                                        .frame(width: 70, height: 40)
                                )
                        }
                        .offset(x:320, y:-60)
                        
                    
                    
                    
                    
                    //Section Divider for Initial and Exteriror
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .frame(width: 370, height: 50)
                            .padding(10)
                        
                        Text("Initial")
                            .foregroundColor(.white)
                            .font(.system(size:30))
                    }
            
                    
                        
                    
                    Text("ON/OFF")
                        .font(.system(size:12))
                        .offset(x:315)
                        .bold()
                    ForEach(checkList.itemList.indices, id: \.self) { index in
                        if let toggleItem = checkList.itemList[index] as? TogglelistItem {
                            ToggleListItemView(item: toggleItem)
                        } else if let pickerItem = checkList.itemList[index] as? PickerlistItem {
                            PickerlistItemView(item2: pickerItem)
                        }
                        else if let pickerItem2 = checkList.itemList[index] as? PickerlistItem2 {
                            PickerlistItem2View(item3: pickerItem2)
                        }
                    }
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .frame(width: 370, height: 50)
                            .padding(10)
                        
                        Text("Exterior Summary")
                            .foregroundColor(.white)
                            .font(.system(size:30))
                    }
                    
                }
            }
        }
    }
}
        
struct ToggleListItemView: View{
    @ObservedObject var item: TogglelistItem
    
    var body: some View{
        HStack{
            Text(item.name)
                .offset(x: 20)
                .font(.system(size: 24))
                .bold()
            Toggle("", isOn: $item.isChecked)
                .offset(x:-30)
        }
        .padding(.top, 10)
    }
}


struct PickerlistItemView : View{
    @ObservedObject var item2: PickerlistItem
    
    var body: some View{
        VStack(alignment: .leading){
            Text(item2.title)
                .font(.system(size: 24))
                .bold()
            
            Picker(item2.title, selection: $item2.selectedValue){
                ForEach(item2.values, id: \.self) {value in
                    Text(value).tag(value)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
        }
        .padding()
    }
}


struct PickerlistItem2View : View{
    @ObservedObject var item3: PickerlistItem2
    
    var body: some View{
        VStack(alignment: .leading){
            Text(item3.title)
                .font(.system(size: 24))
                .bold()
            
            Picker(item3.title, selection: $item3.selectedValue){
                ForEach(item3.values, id: \.self) {value in
                    Text(value).tag(value)
                }
            }
            .pickerStyle(DefaultPickerStyle())
            .frame(maxWidth: .infinity, alignment: .trailing)
            .offset(y:-40)
            
            
        }
        .padding()
        Spacer(minLength: -40)
    }
}









struct GAPCView_Previews: PreviewProvider {
    static var previews: some View {
        GAPCView()
    }
}
