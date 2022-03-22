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
    @State var ingredientSearchResults: [Ingredient] = []
    
    var body: some View {
        VStack{
            List{
                ForEach($ingredientSearchResults){ ingredientModel in
                    //print each ingredient
                    
                    CardListRow(item: ingredientModel)
                        .listRowSeparator(.hidden)
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
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
                self.ingredientSearchResults = Ingredient_DB().getIngredients()
            })
        }
        .navigationTitle(Text("Ingredients"))
        .navigationBarItems(trailing:
                                HStack{
                                    Spacer()
                                    //Add ingredient link
            NavigationLink (destination: AddIngredientView(), label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .accentColor(.blue)
                    .padding(.trailing, 5)
                                    })}
                            )
    }
}


struct PantryViewWithoutNavigation_Previews: PreviewProvider {
    static var previews: some View {
        PantryViewWithoutNavigation()
    }
}
