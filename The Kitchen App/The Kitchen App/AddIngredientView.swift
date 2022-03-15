//
//  AddIngredientView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/20/22.
//

import SwiftUI

struct AddIngredientView: View {
    
    let catagories = ["None", "Produce", "Dairy/Eggs", "Butcher", "Bakery", "Canned Goods", "Baking", "Frozen", "Bulk", "Snack Foods", "Spices/Seasonings", "Pasta/Rice", "Drinks", "Liquor", "Condiments"]
    //vars to hold user input:
    @State var name: String = ""
    @State var inStock: Bool = false
    @State var id: String = UUID().uuidString
    @State var catagorySelected: String = "None"
    
    //go back to homescreen after ingredient is added
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        
        VStack{
            //create name entry field:
            TextField("Ingredient name", text: $name)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
            //select a catagory
            Picker("Select Catagory", selection: $catagorySelected) {
                            ForEach(catagories, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
            //create entry to enable in stock
            Toggle(isOn: $inStock) {
                Text("In stock")
                    .padding(.leading)
            }
            
            //button to create new row in db
            Button(action: {
                //call function to add new row in sqlite
                Ingredient_DB().addIngredient(idValue: self.id, nameValue: self.name, inStockValue: self.inStock, catagoryValue: self.catagorySelected)
                //go back to homepage
                self.mode.wrappedValue.dismiss()
            }, label: {Text("Add ingredient")
            })
        }
    }
}

struct AddIngredientView_Previews: PreviewProvider {
    static var previews: some View {
        AddIngredientView()
    }
}

