//
//  AddIngredientView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/20/22.
//

import SwiftUI

struct AddIngredientView: View {
    
    
    //vars to hold user input:
    @State var name: String = ""
    @State var inStock: Bool = false
    @State var id: String = ""
    @State var ingredient: Ingredient = Ingredient()
    
    //go back to homescreen after ingredient is added
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        
        VStack{
            //create name entry field:
            TextField("Ingredient name", text: $name)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                //.disableAutocorrection(true)
            //create entry to enable in stock
            Toggle(isOn: $inStock) {
                Text("In stock")
                    .padding(.leading)
            }
            
            //button to create new row in db
            Button(action: {
                //call function to add new row in sqlite
                Ingredient_DB().addIngredient(idValue: self.ingredient.id.uuidString, nameValue: self.name, inStockValue: self.inStock)
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

