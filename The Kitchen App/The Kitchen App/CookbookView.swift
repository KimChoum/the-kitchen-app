//
//  CookbookView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/25/22.
//

import SwiftUI



struct CookbookView: View {
    
    //list of colors to be used
    //UIColor(Color(0x49393B))
    let backGroundColor = UIColor(Color.white)
    let labelColor = UIColor(Color(0x1F271B))
    let inStockColor = UIColor(Color(0x6aab7d))
    let outOfStockColor = UIColor(Color(0xEE6352))
    let accentColor = UIColor(Color(0xFCF6B1))
    
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
    
    var body: some View {
        VStack{
            HStack{
                //navigation link to view recipes in full page view
                NavigationLink (destination: CookbookView(), isActive: self.$viewAllRecipesSelected){
                    EmptyView()
                }
                //button to view all recipes
                Button(action: {self.viewAllRecipesSelected = true}, label: {Text("Recipes").font(.title).foregroundColor(Color(labelColor))})
                
                Spacer()
                NavigationLink (destination: AddRecipeView(), label: { Text("Add Recipe")
                        .foregroundColor(Color(labelColor))
                }).padding(8)
            }
            .background(Color(backGroundColor))
            
            VStack{
                //navigation link to view recipe view details
                NavigationLink (destination: viewRecipeView(id: self.$selectedRecipeID), isActive: self.$recipeSelected){
                    EmptyView()
                }
                
                //List to show recipes:
                ScrollView(.vertical){
                    ForEach(self.recipes) { (recipeModel) in

                        Button(action: {
                            self.selectedRecipeID = recipeModel.id.uuidString
                            self.recipeSelected = true
                        }, label: {
                            VStack {
                                Image(uiImage: fileManager.getImage(imageName: recipeModel.id.uuidString, folderName: "recipeImages") ?? UIImage(named: "test-recipe-image")!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Meal Type")
                                            .font(.headline)
                                            .foregroundColor(.secondary)
                                        Text(recipeModel.name)
                                            .font(.title)
                                            .fontWeight(.black)
                                            .foregroundColor(.primary)
                                            .lineLimit(3)
                                        HStack{
                                            Text("On Shopping List".uppercased())
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            Image(systemName: recipeModel.onShoppingList ? "checkmark.circle" : "circle")
                                                .foregroundColor(recipeModel.onShoppingList ? .green : .blue)
                                        }
                                    }
                                    .layoutPriority(100)
                                    
                                    Spacer()
                                }
                                .padding()
                            }
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
                            )
                            .padding([.top, .horizontal])
                            //.frame(height: 150)
                        })
                    }
                }
            }
            //load data to array
            .onAppear(perform: {
                self.recipes = Recipe_DB().getRecipes()
            })
        }
    }
}

struct CookbookView_Previews: PreviewProvider {
    static var previews: some View {
        CookbookView()
    }
}
