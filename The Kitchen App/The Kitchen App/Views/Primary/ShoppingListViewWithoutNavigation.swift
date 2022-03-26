//
//  ShoppingListViewWithoutNavigation.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 3/16/22.
//

import SwiftUI

struct ShoppingListViewWithoutNavigation: View {
    
    let defaultColor = UIColor(Color(0x767A7C))
    //for category tag
    let catagories: [String: UIColor] = ["None": UIColor(Color(0x767A7C)), "Produce": UIColor(Color(0x97D091)), "Dairy/Eggs": UIColor(Color(0xFEAA84)), "Meat": UIColor(Color(0xFED184)), "Bakery": UIColor(Color(0xFEF884)), "Canned Goods": UIColor(Color(0xE9FE84)), "Baking": UIColor(Color(0xC7FE84)), "Frozen": UIColor(Color(0x84ADFE)), "Bulk": UIColor(Color(0x84FEBD)), "Snack Foods": UIColor(Color(0x84FEED)), "Spices/Seasonings": UIColor(Color(0x84D9FE)), "Pasta/Rice": UIColor(Color(0xFE8684)), "Drinks": UIColor(Color(0x8584FE)), "Liquor": UIColor(Color(0xB784FE)), "Condiments": UIColor(Color(0xE984FE))]
    
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
    
    //for navigation:
    @Binding var shouldPopToRootView : Bool
    
    
    var body: some View {
        VStack{
            HStack{
                Text("Shopping List")
                    .font(.system(size: 40, weight: .bold, design: .default))
                    .padding()
                Spacer()
            }
            ScrollView{
                
                if(ingredientsToBuy.isEmpty){
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
                            //TODO
                            Ingredient_DB().updateIngredient(idValue: ingredientModel.id.uuidString, nameValue: ingredientModel.name, inStockValue: true, categoryValue: ingredientModel.catagory, keepInStockValue: ingredientModel.keepInStock)

                            self.ingredientsToBuy = Ingredient_DB().getShoppingList(allIngredientIDs: Recipe_Ingredient_DB().getAllIngredientIDsNeeded(recipesList: recipesToMake))
                        }, label: {
                            HStack {
                                Text(ingredientModel.name)
                                    .font(.body)
                                    .padding(.leading, 5)
                                    .frame(minWidth: 100)
                                    .foregroundColor(.black)
                                Divider()
                                    .frame(width: 10)
                                Text(ingredientModel.catagory)
                                    .font(.body)
                                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                    .background(Color(self.catagories[ingredientModel.catagory] ?? self.defaultColor))
                                    .cornerRadius(15)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .padding(.bottom, 3)
                            .padding(.leading, 5)
                            .padding(.trailing, 5)
                        })
                    }
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: {
                    print("Online recipes")
                }, label: {
                    Image(systemName: "globe.americas")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .accentColor(.black)
                })
                Spacer()
                Button (action: {print("Do nothing, already shopping list")}, label: {
                    ZStack(alignment: .topTrailing){
                        Image(systemName: "cart")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .accentColor(.black)
                        Image(systemName: "checklist")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .accentColor(.black)
                            .background(Color(.white))
                    }
                })
                Spacer()
                
                Button (action: { self.shouldPopToRootView = false }, label:
                            {
                    Image(systemName: "house.circle.fill")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .accentColor(.black)
                })
                
                Spacer()
                NavigationLink (destination: CookbookViewWithoutNavigation(shouldPopToRootView: self.$shouldPopToRootView),
                                label:
                                    {
                    Image(systemName: "menucard")
                        .resizable()
                        .frame(width: 20, height: 30)
                        .accentColor(.black)
                })
                .isDetailLink(false)
                
                Spacer()
                
                NavigationLink (destination: PantryViewWithoutNavigation(shouldPopToRootView: self.$shouldPopToRootView), label:
                                    {
                    Image(systemName: "fork.knife")
                        .resizable()
                        .frame(width: 20, height: 30)
                        .accentColor(.black)
                })
                .isDetailLink(false)
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

//struct ShoppingListViewWithoutNavigation_Previews: PreviewProvider {
//
//    static var previews: some View {
//        ShoppingListViewWithoutNavigation()
//    }
//}
