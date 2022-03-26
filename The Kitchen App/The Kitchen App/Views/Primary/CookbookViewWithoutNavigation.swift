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
    //for searching
    @State var searchText: String = ""
    @State var recipeSearchResults: [Recipe] = []
    @State var isEditing: Bool = false
    //sorting:
    @State var selectedSort: String = "all"
    
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
            //search bar
            HStack {
                TextField("Search...", text: $searchText)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .onChange(of: searchText) { searchText in
                        if !searchText.isEmpty {
                            recipeSearchResults = recipes.filter { $0.name.contains(searchText) }
                        } else {
                            recipeSearchResults = recipes
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
            //sorting
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    Text("All")
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                        .background(Color(self.selectedSort == "all" ? .systemGray2 : .systemGray6))
                        .cornerRadius(15)
                        .foregroundColor(.black)
                        .onTapGesture {
                            self.selectedSort = "all"
                            recipeSearchResults = recipes
                        }
                        .padding(.leading, 5)
                    Text("Can Make Now")
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                        .background(Color(self.selectedSort == "in stock" ? .systemGray2 : .systemGray6))
                        .cornerRadius(15)
                        .foregroundColor(.black)
                        .onTapGesture {
                            self.selectedSort = "in stock"
                            recipeSearchResults = []
                            for recipeModel in recipes {
                                if (Ingredient_DB().allInStock(allIngredientIDs: Recipe_Ingredient_DB().getIngredientIDsList(recipeIDValue: recipeModel.id.uuidString))){
                                    recipeSearchResults.append(recipeModel)
                                }
                            }
                        }
                    Text("On Shopping List")
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                        .background(Color(self.selectedSort == "On Shopping List" ? .systemGray2 : .systemGray6))
                        .cornerRadius(15)
                        .foregroundColor(.black)
                        .onTapGesture {
                            self.selectedSort = "On Shopping List"
                            recipeSearchResults = []
                            for recipeModel in recipes {
                                if (recipeModel.onShoppingList){
                                    recipeSearchResults.append(recipeModel)
                                }
                            }
                        }
                    Text("Few More Items")
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                        .background(Color(self.selectedSort == "Few More Items" ? .systemGray2 : .systemGray6))
                        .cornerRadius(15)
                        .foregroundColor(.black)
                        .onTapGesture {
                            self.selectedSort = "Few More Items"
                            recipeSearchResults = []
                            for recipeModel in recipes {
                                if (Ingredient_DB().threeOrLess(allIngredientIDs: Recipe_Ingredient_DB().getIngredientIDsList(recipeIDValue: recipeModel.id.uuidString))){
                                    recipeSearchResults.append(recipeModel)
                                }
                            }
                        }
                }
                .onDisappear(perform: {
                    self.selectedSort = "alphabetical"
                })
            }
            //List to show recipes:
            List{
                ForEach(self.$recipeSearchResults) { (recipeModel) in
                    RecipeRow(item: recipeModel)
                        .listRowSeparator(.hidden)
                }
            }
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

