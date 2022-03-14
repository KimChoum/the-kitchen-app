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
                        //navigation link to view ingredient view details
                        NavigationLink (destination: ViewIngredientView(id: self.$selectedIngredientID), isActive: self.$ingredientSelected){
                            EmptyView()
                        }
                        //print each ingredient
                        ForEach(self.ingredients) { ingredientModel in
                            HStack{
                                Button(action: {
                                    self.selectedIngredientID = ingredientModel.id.uuidString
                                    self.ingredientSelected = true
                                }, label: {
                                    Text(ingredientModel.name)
                                        .frame(maxWidth: 350, minHeight: 35, alignment: .leading)
                                        .foregroundColor(Color(labelColor))
                                        .background(Color(ingredientModel.inStock ? inStockColor : outOfStockColor))
                                        .clipShape(RoundedRectangle(cornerRadius: 7))
                                        .shadow(radius: 2)
                                    //.border(Color(labelColor))
                                })
                            }
                        }
                        
                    }
                }
                .onAppear(perform: {
                    self.ingredients = Ingredient_DB().getIngredients()
                })
            }
            //load data to array
            .onAppear(perform: {
                self.ingredients = Ingredient_DB().getIngredients()
                })
                
        }

}


struct PantryView_Previews: PreviewProvider {
    static var previews: some View {
        PantryView()
    }
}
