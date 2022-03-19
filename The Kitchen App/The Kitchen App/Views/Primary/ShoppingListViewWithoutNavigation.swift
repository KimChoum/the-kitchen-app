//
//  ShoppingListViewWithoutNavigation.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 3/16/22.
//

import SwiftUI

struct ShoppingListViewWithoutNavigation: View {
    
    //array to hold ingredients/recieps:
    @State var recipesToMake: [Recipe] = []
    @State var ingredientsToBuy: [Ingredient] = []
    
    //vars handing selection of an ingredient
    @State var selectedIngredientName: String = ""
    @State var selectedIngredientID: String = ""
    
    //handle navigation button selected
    @State var viewShoppingListSelected: Bool = false
    
    //handle ingredient pressed
    @State var showingAlert: Bool = false
    
    
    var body: some View {
        HStack{
            Text("Shopping list")
                .font(.title)
                .foregroundColor(Color(.black))
            Spacer()
        }
        ScrollView{
            
            if(recipesToMake.isEmpty){
                Text("\n\nShopping list is empty\n\n")
                    .font(.title)
                    .foregroundColor(.red)
                Text("Add ingredients to shopping list")
                    .font(.body)
                Text("or")
                Text("select recipes to add ingredients to list automatically")
                    .font(.body)
                    .multilineTextAlignment(.center)
            }
            else if(ingredientsToBuy.isEmpty){
                VStack{
                    Text("\n\n\n\nAll ingredients for selected recipes are in stock!")
                        .font(.title)
                        .multilineTextAlignment(.center)
                    Image(systemName: "checkmark.square")
                        .foregroundColor(.green)
                }
            }
            VStack{
                //print each ingredient
                ForEach(self.ingredientsToBuy) { ingredientModel in
                    Button(action: {
                        self.selectedIngredientName = ingredientModel.name
                        self.showingAlert = true
                    }, label: {
                        Text(ingredientModel.name)
                            .frame(maxWidth: 350, minHeight: 35, alignment: .leading)
                            .foregroundColor(Color(.black))
                            .background(Color(ingredientModel.inStock ? .green : .red))
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                            .shadow(radius: 2)
                        //.border(Color(labelColor))
                    })
                        .alert("Add \(self.selectedIngredientName) to your pantry", isPresented: $showingAlert) {
                            Button("Cencel") { }
                            Button("Yes") {
                                //call DB to update user with new values
                                Ingredient_DB().updateIngredient(idValue: ingredientModel.id.uuidString, nameValue: ingredientModel.name, inStockValue: true)
                                
                                self.ingredientsToBuy = Ingredient_DB().getShoppingList(allIngredientIDs: Recipe_Ingredient_DB().getAllIngredientIDsNeeded(recipesList: recipesToMake))
                            }
                        }
                }
                Spacer()
            }
        }
        //load data to array
        .onAppear(perform: {
            self.recipesToMake = Recipe_DB().getRecipesOnShoppingList()
            self.ingredientsToBuy = Ingredient_DB().getShoppingList(allIngredientIDs: Recipe_Ingredient_DB().getAllIngredientIDsNeeded(recipesList: recipesToMake))
        })
    }
}

struct ShoppingListViewWithoutNavigation_Previews: PreviewProvider {
    
    static var previews: some View {
        ShoppingListViewWithoutNavigation()
    }
}