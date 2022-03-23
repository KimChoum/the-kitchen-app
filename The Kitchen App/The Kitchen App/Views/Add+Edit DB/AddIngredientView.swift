//
//  AddIngredientView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/20/22.
//

import SwiftUI

struct AddIngredientView: View {
    
    let catagories = ["None", "Produce", "Dairy/Eggs", "Meat", "Bakery", "Canned Goods", "Baking", "Frozen", "Bulk", "Snack Foods", "Spices/Seasonings", "Pasta/Rice", "Drinks", "Liquor", "Condiments"]
    //vars to hold user input:
    @State var name: String = ""
    @State var inStock: Bool = false
    @State var id: String = UUID().uuidString
    @State var catagorySelected: String = "None"
    @State var keepInStock: Bool = false
    
    //go back to homescreen after ingredient is added
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        
        Form {
            Section(header: Text("NEW INGREDIENT")){
                //create name entry field:
                TextField("Ingredient name", text: $name)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                HStack{
                    //create entry to enable in stock
                    Toggle(isOn: $inStock,label: {
                        Text("In stock")
                    })
                    .toggleStyle(CheckboxStyle())
                    .padding()
                    
                    //create entry to get keepInStock
                    Toggle(isOn: $keepInStock,label: {
                        Text("Always in stock")
                    })
                    .toggleStyle(CheckboxStyle())
                    .padding()
                }
                    //select a catagory
                Picker(selection: $catagorySelected, label: Text("Category")) {
                        ForEach(catagories, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.automatic)
                    
                
                //button to create new row in db
                Button(action: {
                    //call function to add new row in sqlite
                    Ingredient_DB().addIngredient(idValue: self.id, nameValue: self.name, inStockValue: self.inStock, catagoryValue: self.catagorySelected, keepInStockValue: true)
                    //go back to homepage
                    self.mode.wrappedValue.dismiss()
                }, label: {
                    Text("Add Ingredient")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(16)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                })
            }
        }
    }
}

struct AddIngredientView_Previews: PreviewProvider {
    static var previews: some View {
        AddIngredientView()
    }
}

