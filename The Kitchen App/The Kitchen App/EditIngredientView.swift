//
//  EditIngredientView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 3/1/22.
//

import SwiftUI

struct EditIngredientView: View {
    //name of ingredient recieved
    @Binding var ingredientID: String
    
    //variables to store values for input fields
    @State var ingredient: Ingredient = Ingredient()
    @State var name: String = ""
    @State var inStock: Bool = false
    
    //ingredient is deleted
    @State var ingredientButtonPressed: Bool = false
    
    //go back when done
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        
        VStack{
            //navigation if delete button is pressed
            NavigationLink (destination: ContentView(), isActive: self.$ingredientButtonPressed){
                EmptyView()
            }
            //Delete Button
            HStack{
                Spacer()
                Button(action: {
                    let ingredientDB: Ingredient_DB = Ingredient_DB()
                    ingredientDB.deleteIngredient(ingredient: self.ingredient)
                    //TODO Remove ingredient from Recipe_Igredient_DB
                    let recipeIngredientDB: Recipe_Ingredient_DB = Recipe_Ingredient_DB()
                    recipeIngredientDB.deleteIngredient(ingredient: self.ingredient)
                    //self.ingredientButtonPressed = true
                    self.mode.wrappedValue.dismiss()
                }, label: {
                    Text("Delete")
                        .foregroundColor(.red)
                })
                    .buttonStyle(PlainButtonStyle())
                    .padding()
            }
            //create name entry field:
            //            Text(name)
            //                .font(.title)
            TextField("Ingredient name", text: $name)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .disableAutocorrection(true)
            //create entry to enable in stock
            Toggle(isOn: $inStock) {
                Text("In stock")
                    .padding(.leading)
            }
            
            //button to update db
            Button(action: {
                //call DB to update user with new values
                Ingredient_DB().updateIngredient(idValue: self.ingredientID, nameValue: self.name, inStockValue: self.inStock)
                //go back to previous view
                self.mode.wrappedValue.dismiss()
                //call function to add new row in sqlite
            }, label: {Text("Update ingredient")
            })
                .padding(.top, 10)
                .padding(.bottom, 10)
        }
        .onAppear(perform: {
            let ingredientModel: Ingredient = Ingredient_DB().getIngredient(idValue: self.ingredientID)
            self.ingredient = ingredientModel
            self.name = ingredientModel.name
            self.inStock = ingredientModel.inStock
        })
    }
}

struct EditIngredientView_Previews: PreviewProvider {
    @State static var ingredientID: String = ""
    static var previews: some View {
        EditIngredientView(ingredientID: $ingredientID)
    }
}
