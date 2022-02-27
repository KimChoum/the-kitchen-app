//
//  CookbookView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/25/22.
//

import SwiftUI

struct CookbookView: View {
    //array to hold recipes:
    @State var recipes: [Recipe] = []
    
    //check if recipe is selected
    @State var recipeSelected: Bool = false
    
    //name of recipe to view
    @State var selectedRecipeName: String = ""
    
    var body: some View {
        //NavigationView{
            VStack{
                //List Number of ingredients in stock
                Divider()
                //navigation link to view recipe view
                NavigationLink (destination: viewRecipeView(name: self.$selectedRecipeName), isActive: self.$recipeSelected){
                    EmptyView()
                }
                //List to show ingredients:
                List(self.recipes) { (recipeModel) in
                    Button(action: {
                        self.selectedRecipeName = recipeModel.name
                        self.recipeSelected = true
                    }, label: {
                    HStack{
                        Text(recipeModel.name)
                        Spacer()
                        //Text("TODO: Have the ingredients?")
                    }.padding()})
                }
                NavigationLink (destination: AddRecipeView(), label: { Text("Add Recipe")
                        .padding()
                })
            }
            //load data to array
            .onAppear(perform: {
                    self.recipes = Recipe_DB().getRecipes()
                })
            .navigationBarTitle("Recipes")
        //}
    }
}

struct CookbookView_Previews: PreviewProvider {
    static var previews: some View {
        CookbookView()
    }
}
