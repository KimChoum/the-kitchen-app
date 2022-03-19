//
//  CookbookViewWithoutNavigation.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 3/16/22.
//

import SwiftUI



struct CookbookViewWithoutNavigation: View {
    
    //file manager instance for saving images
    public var fileManager = LocalFileManager.instance
    
    //array to hold recipes:
    @State var recipes: [Recipe] = []
    //check if recipe is selected
    @State var recipeSelected: Bool = false
    //name of recipe to view
    @State var selectedRecipeID: String = ""
    //if view all is selected
    @State var viewAllRecipesSelected: Bool = false
    @State var searchText: String = ""
    @State var recipeSearchResults: [Recipe] = []
    
    var body: some View {
        VStack{
            HStack{
                //button to view all recipes
                Text("Recipes")
                .font(.title)
                .foregroundColor(Color(.black))
                
                Spacer()
                NavigationLink (destination: AddRecipeView(), label: { Text("Add Recipe")
                        .foregroundColor(Color(.black))
                }).padding(8)
            }
            .background(Color(.white))
            
            VStack{
                
                //List to show recipes:
                List{
                    ForEach(self.$recipeSearchResults) { (recipeModel) in
                        RecipeRow(item: recipeModel)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .frame(height: 610)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                .onChange(of: searchText) { searchText in
                    if !searchText.isEmpty {
                        recipeSearchResults = recipes.filter { $0.name.contains(searchText) }
                    } else {
                        recipeSearchResults = recipes
                    }
                }
            }
            //load data to array
            .onAppear(perform: {
                self.recipes = Recipe_DB().getRecipes()
                self.recipeSearchResults = recipes
            })
        }
    }
}

struct CookbookViewWithoutNavigation_Previews: PreviewProvider {
    static var previews: some View {
        CookbookViewWithoutNavigation()
    }
}

