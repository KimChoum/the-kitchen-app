//
//  PantryViewWithoutNavigation.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 3/16/22.
//

import SwiftUI

struct PantryViewWithoutNavigation: View {
    
    //variables for Ingredient list:
    @State var ingredients: [Ingredient] = []
    @State var inStockNum: Int = 0
    //variable to see if ingredient has been clicked on
    @State var ingredientSelected: Bool = false
    @State var selectedIngredientID: String = ""
    //variable to see if ingredients was selected
    @State var viewAllIngredientsSelected: Bool = false
    
    @State var inStock: Bool = false
    
    //to search ingredients
    @State private var searchText: String = ""
    @State private var isEditing: Bool = false
    @State var ingredientSearchResults: [Ingredient] = []
    
    @Binding var shouldPopToRootView : Bool
    
    var body: some View {
        VStack{
            HStack{
                Text("Ingredients")
                    .font(.system(size: 40, weight: .bold, design: .default))
                    .padding()
                Spacer()
                NavigationLink (destination: AddIngredientView(), label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .accentColor(.blue)
                        .padding()
                })
            }
            //search bar
            HStack {
                TextField("Search...", text: $searchText)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .onChange(of: searchText) { searchText in
                        if !searchText.isEmpty {
                            ingredientSearchResults = ingredients.filter { $0.name.contains(searchText) }
                        } else {
                            ingredientSearchResults = ingredients
                        }
                    }
                    .overlay(HStack { // Add the search icon to the left
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                        // If the search field is focused, add the clear (X) button
                        if isEditing {
                            Button(action: {
                                self.searchText = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }).padding(.horizontal, 10)
                    .onTapGesture {
                        self.isEditing = true
                    }
            }
            List{
                ForEach($ingredientSearchResults){ ingredientModel in
                    //print each ingredient
                    
                    CardListRow(item: ingredientModel)
                        .listRowSeparator(.hidden)
                }
            }
            .onChange(of: searchText) { searchText in

                if !searchText.isEmpty {
                    ingredientSearchResults = ingredients.filter { $0.name.contains(searchText) }
                } else {
                    ingredientSearchResults = ingredients
                }
            }
            .listStyle(.plain)
            .onAppear(perform: {
                print("Load ingredients from DB")
                self.ingredients = Ingredient_DB().getIngredients()
                self.ingredientSearchResults = ingredients
            })
        }
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
                
                NavigationLink (destination: ShoppingListViewWithoutNavigation(shouldPopToRootView: self.$shouldPopToRootView), label: {
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
                .isDetailLink(false)
                
                Spacer()
                
                Button (action: { self.shouldPopToRootView = false }, label:
                                    {
                        Image(systemName: "house.circle.fill")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .accentColor(.black)
                    })
                
                Spacer()
                
                NavigationLink (destination: CookbookViewWithoutNavigation(shouldPopToRootView: self.$shouldPopToRootView), label:
                                    {
                        Image(systemName: "menucard")
                            .resizable()
                            .frame(width: 20, height: 30)
                            .accentColor(.black)
                    })
                .isDetailLink(false)
                
                Spacer()
                Button (action: {print("Do nothing, already at pantry")}, label:
                                    {
                        Image(systemName: "fork.knife")
                            .resizable()
                            .frame(width: 20, height: 30)
                            .accentColor(.black)
                    })
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}


//struct PantryViewWithoutNavigation_Previews: PreviewProvider {
//    static var previews: some View {
//        PantryViewWithoutNavigation()
//    }
//}
