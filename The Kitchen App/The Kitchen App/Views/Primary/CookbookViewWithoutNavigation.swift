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
            //List to show recipes:
            List{
                ForEach(self.$recipeSearchResults) { (recipeModel) in
                    RecipeRow(item: recipeModel)
                        .listRowSeparator(.hidden)
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onChange(of: searchText) { searchText in
                if !searchText.isEmpty {
                    recipeSearchResults = recipes.filter { $0.name.contains(searchText) }
                } else {
                    recipeSearchResults = recipes
                }
            }
            .listStyle(.plain)
            .onAppear(perform: {
                self.recipes = Recipe_DB().getRecipes()
                self.recipeSearchResults = recipes
            })
        }
        .navigationTitle(Text("My Recipes"))
        .navigationBarItems(trailing:
                                HStack{
            Spacer()
            NavigationLink (destination: AddRecipeView(), label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .accentColor(.blue)
                    .padding(.trailing, 5)
            })
        })
    }
}

struct CookbookViewWithoutNavigation_Previews: PreviewProvider {
    static var previews: some View {
        CookbookViewWithoutNavigation()
    }
}

