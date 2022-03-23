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
    
    //for navigation:
    @Binding var shouldPopToRootView : Bool
    
    
    var body: some View {
        HStack{
            Text("Shopping list")
                .font(.title)
                .foregroundColor(Color(.black))
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
                        self.selectedIngredientName = ingredientModel.name
                        self.showingAlert = true
                    }, label: {
                        Text(ingredientModel.name)
                            .padding(.leading, 10)
                            .frame(maxWidth: 350, minHeight: 35, alignment: .leading)
                            .foregroundColor(Color(.black))
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                            .shadow(radius: 2)
                            .border(Color(.black))
                    })
                        .alert("Add \(self.selectedIngredientName) to your pantry", isPresented: $showingAlert) {
                            Button("Cencel") { }
                            Button("Yes") {
                                //call DB to update user with new values
                                print(ingredientModel.keepInStock)
                                Ingredient_DB().updateIngredient(idValue: ingredientModel.id.uuidString, nameValue: ingredientModel.name, inStockValue: true, categoryValue: ingredientModel.catagory, keepInStockValue: ingredientModel.keepInStock)
                                
                                self.ingredientsToBuy = Ingredient_DB().getShoppingList(allIngredientIDs: Recipe_Ingredient_DB().getAllIngredientIDsNeeded(recipesList: recipesToMake))
                            }
                        }
                }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
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
