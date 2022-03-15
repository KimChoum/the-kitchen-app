//
//  PantryView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/20/22.
//

//list of colors to be used
//UIColor(Color(0x49393B))
let backGroundColor = UIColor(Color.white)
let labelColor = UIColor(Color(0x1F271B))
let inStockColor = UIColor(Color(0x6aab7d))
let outOfStockColor = UIColor(Color(0xEE6352))
let accentColor = UIColor(Color(0xFCF6B1))


import SwiftUI

struct PantryView: View {
    
    //variables for Ingredient list:
    @State var ingredients: [Ingredient] = []
    @State var inStockNum: Int = 0
    //variable to see if ingredient has been clicked on
    @State var ingredientSelected: Bool = false
    @State var selectedIngredientID: String = ""
    //variable to see if ingredients was selected
    @State var viewAllIngredientsSelected: Bool = false
    
    @State var inStock: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                //navigation link to view recipes in full page view
                NavigationLink (destination: PantryView(), isActive: self.$viewAllIngredientsSelected){
                    EmptyView()
                }
                //button to view all recipes
                Button(action: {self.viewAllIngredientsSelected = true}, label: {Text("Ingredients").font(.title).foregroundColor(Color(labelColor))})
                Spacer()
                //Add ingredient link
                NavigationLink (destination: AddIngredientView(), label: { Text("Add Ingredient").foregroundColor(Color(labelColor))
                        .padding(.trailing, 8)
                })}
            .background(Color(backGroundColor))
            ScrollView(.vertical){
                VStack{
                    //print each ingredient
                    ForEach(self.ingredients) { ingredientModel in
                        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center)){
                            IngredientListItem(ingredient: ingredientModel)
//                            HStack{
//                                Toggle("", isOn: self.$inStock)
//                                    .onChange(of: inStock, perform: { value in
//                                        //call DB to update user with new values
//                                        Ingredient_DB().updateIngredient(idValue: ingredientModel.id.uuidString, nameValue: ingredientModel.name, inStockValue: ingredientModel.inStock)
//                                        self.ingredients = Ingredient_DB().getIngredients()
//                                    })
//                                    .onAppear(perform: {self.inStock = ingredientModel.inStock})
//                            }
                        }
                    }
                    
                }
            }
            .onAppear(perform: {
                print("Load ingredients from DB")
                self.ingredients = Ingredient_DB().getIngredients()
            })
        }
    }
}


struct PantryView_Previews: PreviewProvider {
    static var previews: some View {
        PantryView()
    }
}
