//
//  viewRecipeView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/25/22.
//

import SwiftUI

struct viewRecipeView: View {
    //Name of recipe recived from revious view
    @Binding var name: String
    
    //variables to hold instructions and ingredients
    @State var instructions: String = ""
    @State var ingredients: [Ingredient] = []
    
    //variable for if delte warning message shows
    @State private var showingAlert: Bool = false
    
    //To return to previous view
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button("Delete") {
                            showingAlert = true
                }
                .padding()
                .alert(isPresented:$showingAlert) {
                    Alert(
                        title: Text("Are you sure you want to delete this?"),
                        message: Text("There is no undo"),
                        primaryButton: .destructive(Text("Delete")) {
                            print("Deleting...")
                            //TODO Remove recipe from Recipe_DB
                            let recipeDB: Recipe_DB = Recipe_DB()
                            recipeDB.deleteRecipe(recipeName: self.name)
                            //TODO Remove recipe from Recipe_Igredient_DB
                            let recipeIngredientDB: Recipe_Ingredient_DB = Recipe_Ingredient_DB()
                            recipeIngredientDB.deleteRecipe(recipeNameValue: self.name)
                            //return to previous screen
                            self.mode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }//end of HStack
            HStack{
            Text(name).font(.title)
                .padding()
            Spacer()
            }
            Text("Instructions:")
            Text(instructions)
                .padding()
            Text("Ingredients:")
            List(self.ingredients) { (model) in
                HStack{
                    Text(model.name)
                    Spacer()
                    Text(model.inStock ? "In Stock" : "Not in Stock")
                }
            }.padding()
        }
        //populate instructions and ingredient variables
        .onAppear(perform: {
            //get data from database
            let recipeModel: Recipe = Recipe_DB().getRecipe(nameValue: self.name)
            //get list of ingredient names from Recipe_Ingredient
            let ingredientNamesList: [String] = Recipe_Ingredient_DB().getIngredientsList(nameValue: self.name)
            //use list of ingredient names to get list of ingredient objects from Ingredient_DB
            print("call ingredients_DB to get recipe ingredients")
            let listOfIngredients: [Ingredient] = Ingredient_DB().getRecipeIngredients(ingredientsList: ingredientNamesList)
            
            //populate on screen
            self.instructions = recipeModel.instructions
            self.ingredients = listOfIngredients
        })
    }
}

struct viewRecipeView_Previews: PreviewProvider {
    @State static var name: String = ""
    static var previews: some View {
        viewRecipeView(name: $name)
    }
}
