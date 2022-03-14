//
//  ShoppingListView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 3/7/22.
//

import SwiftUI

struct ShoppingListView: View {
    //list of colors to be used
    //UIColor(Color(0x49393B))
    let backGroundColor = UIColor(Color.white)
    let labelColor = UIColor(Color(0x1F271B))
    let inStockColor = UIColor(Color(0x6aab7d))
    let outOfStockColor = UIColor(Color(0xEE6352))
    let accentColor = UIColor(Color(0xFCF6B1))
    
    //array to hold ingredients/recieps:
    @State var recipesToMake: [Recipe] = []
    @State var ingredientsToBuy: [Ingredient] = []
    
    //vars handing selection of an ingredient
    @State var selectedIngredientName: String = ""
    
    //handle navigation button selected
    @State var viewShoppingListSelected: Bool = false
    
    //handle ingredient pressed
    @State var showingAlert: Bool = false
    
    
    var body: some View {
        //navigation link to view shopping list
        NavigationLink (destination: ShoppingListView(), isActive: self.$viewShoppingListSelected){
            EmptyView()
        }
        //navigation link to view ingredient view details
        //        NavigationLink (destination: ViewIngredientView(name: self.$selectedIngredientName), isActive: self.$ingredientSelected){
        //            EmptyView()
        //        }
        HStack{
            Button(action: {
                self.viewShoppingListSelected = true
            }, label: {Text("Shopping list").font(.title).foregroundColor(Color(labelColor))})
            Spacer()
        }
        ScrollView{
            VStack{
                //print each ingredient
                ForEach(self.ingredientsToBuy) { ingredientModel in
                    Button(action: {
                        self.selectedIngredientName = ingredientModel.name
                        //                        self.ingredientSelected = true
                        self.showingAlert = true
                    }, label: {
                        Text(ingredientModel.name)
                            .frame(maxWidth: 350, minHeight: 35, alignment: .leading)
                            .foregroundColor(Color(labelColor))
                            .background(Color(ingredientModel.inStock ? inStockColor : outOfStockColor))
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                            .shadow(radius: 2)
                        //.border(Color(labelColor))
                    })
                        .alert("Add \(self.selectedIngredientName) to your pantry", isPresented: $showingAlert) {
                            Button("Cencel") { }
                            Button("Yes") {
                                //call DB to update user with new values
                                Ingredient_DB().updateIngredient(nameValue: self.selectedIngredientName, inStockValue: true)
                                self.ingredientsToBuy = Ingredient_DB().getShoppingList(allIngredients: Recipe_Ingredient_DB().getAllIngredientsNeeded(recipesList: recipesToMake))
                            }
                        }
                }
                Spacer()
            }
        }
        //load data to array
        .onAppear(perform: {
            self.recipesToMake = Recipe_DB().getRecipesOnShoppingList()
            self.ingredientsToBuy = Ingredient_DB().getShoppingList(allIngredients: Recipe_Ingredient_DB().getAllIngredientsNeeded(recipesList: recipesToMake))
        })
    }
}

struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView()
    }
}
