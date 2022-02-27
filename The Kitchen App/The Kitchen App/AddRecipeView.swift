//
//  AddRecipeView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/25/22.
//

import SwiftUI

struct AddRecipeView: View {
    
    //vars to hold user input:
    @State var name: String = ""
    @State var instructions: String = ""
    @State var ingredients: [Ingredient] = []
    @State var newRecipe: Recipe = Recipe()
    
    //go back to homescreen after ingredient is added
    //@Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView{
            VStack{
                //create name entry field:
                Text("Enter Recipe Name:")
                TextField("name", text: $name)
                    .padding(10)
                    .cornerRadius(5)
                    .disableAutocorrection(true)
                    .background(Color(.white))
                //create instructions entry field
                Text("Enter Instructions:")
                ZStack{
                TextEditor(text: $instructions)
                    Text(instructions)
                        .opacity(0)
                        //.padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
//                    .disableAutocorrection(true)
                }
                .shadow(radius: 1)
                .padding(10)
                
                Button(action: {
                    //create Recipe object with given values
                    //var newRecipe: Recipe = Recipe()
                    self.newRecipe.name = name
                    self.newRecipe.instructions = instructions},
                    label: {Text("Create Recipe")})
                
                
                    //go to multiple select view for ingridient additions
                NavigationLink(destination: IngredientMultipleSelectView(recipeValue: self.$newRecipe, ingredients: self.ingredients), label: { Text("Add Ingredients")})
                       //label: {Text("Add Ingredient")})
            }
            .background(Color(.systemGray6))
            .onAppear(perform: {
                self.ingredients = Ingredient_DB().getIngredients()
                })
        }
    }
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView()
    }
}
