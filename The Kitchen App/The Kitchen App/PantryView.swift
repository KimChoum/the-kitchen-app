//
//  PantryView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/20/22.
//

import SwiftUI

struct PantryView: View {
    
    //array to hold ingredients:
    @State var ingredients: [Ingredient] = []
    @State var inStockNum: Int = 0
    
    var body: some View {
            List{
                //Add ingredient link
                NavigationLink (destination: AddIngredientView(), label: { Text("Add Ingredient")
                        .padding()
                })
                //print each ingredient
                ForEach(self.ingredients) { model in
                    HStack{
                        Text(model.name)
                        Spacer()
                        Text(model.inStock ? "In Stock" : "Not in Stock")
                            .foregroundColor(model.inStock ? .green : .red)
                        Button(action: {
                            let ingredientDB: Ingredient_DB = Ingredient_DB()
                            ingredientDB.deleteIngredient(ingredient: model)
                            //TODO Remove ingredient from Recipe_Igredient_DB
                            let recipeIngredientDB: Recipe_Ingredient_DB = Recipe_Ingredient_DB()
                            recipeIngredientDB.deleteIngredient(ingredient: model)
                            //reload from DB
                            self.inStockNum = Ingredient_DB().numberOfIngredients()
                            self.ingredients = Ingredient_DB().getIngredients()
                        }, label: {
                            Text("Delete")
                                .foregroundColor(.red)
                        })
                            .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            //load data to array
            .onAppear(perform: {
                self.inStockNum = Ingredient_DB().numberOfIngredients()
                self.ingredients = Ingredient_DB().getIngredients()
                })
                
        }

}


struct PantryView_Previews: PreviewProvider {
    static var previews: some View {
        PantryView()
    }
}
