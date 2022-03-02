//
//  EditIngredientView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 3/1/22.
//

import SwiftUI

struct EditIngredientView: View {
    //name of ingredient recieved
    @Binding var ingredientName: String
    
    //variables to store values for input fields
    @State var name: String = ""
    @State var inStock: Bool = false
    
    //go back when done
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            //create name entry field:
            Text(name)
                .font(.title)
//            TextField("Ingredient name", text: $name)
//                .padding(10)
//                .background(Color(.systemGray6))
//                .cornerRadius(5)
//                .disableAutocorrection(true)
            //create entry to enable in stock
            Toggle(isOn: $inStock) {
                Text("In stock")
                    .padding(.leading)
            }
            
            //button to create new row in db
            Button(action: {
                //call DB to update user with new values
                Ingredient_DB().updateIngredient(nameValue: self.name, inStockValue: self.inStock)
                //go back to previous view
                self.mode.wrappedValue.dismiss()
                //call function to add new row in sqlite
            }, label: {Text("Update ingredient")
            })
                .padding(.top, 10)
                .padding(.bottom, 10)
        }.padding()
            .onAppear(perform: {
                let ingredientModel: Ingredient = Ingredient_DB().getIngredient(nameValue: self.ingredientName)
                
                self.name = ingredientModel.name
                self.inStock = ingredientModel.inStock
            })
    }
}

struct EditIngredientView_Previews: PreviewProvider {
    @State static var ingredientName: String = ""
    static var previews: some View {
        EditIngredientView(ingredientName: $ingredientName)
    }
}
