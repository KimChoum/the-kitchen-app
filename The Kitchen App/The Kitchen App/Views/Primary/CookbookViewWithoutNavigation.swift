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
    
    //for navigation:
    @Binding var shouldPopToRootView : Bool
    
    var body: some View {
        VStack{
            HStack{
                Text("Recipes")
                    .font(.system(size: 40, weight: .bold, design: .default))
                    .padding()
                Spacer()
                NavigationLink (destination: AddRecipeView(), label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .accentColor(.blue)
                        .padding()
                })
            }
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
                
                Button (action: {print("Do nothing, already at cookbook")}, label:
                            {
                    Image(systemName: "menucard")
                        .resizable()
                        .frame(width: 20, height: 30)
                        .accentColor(.black)
                })
                
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
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

//struct CookbookViewWithoutNavigation_Previews: PreviewProvider {
//    static var previews: some View {
//        CookbookViewWithoutNavigation()
//    }
//}

