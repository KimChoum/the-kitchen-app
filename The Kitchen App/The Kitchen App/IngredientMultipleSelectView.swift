//
//  IngredientMultipleSelectView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/25/22.
//

import SwiftUI

struct IngredientMultipleSelectView: View {
    //Name of recipe recived from previous view
    @Binding var recipeValue: Recipe
    
    
    @State var selectedRows = Set<UUID>()
    @State var ingredients: [Ingredient]
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        
        List(selection: $selectedRows){
            ForEach(ingredients){ ingredient in
            IngredientRow(ingredient: ingredient, selectedItems: $selectedRows)
            }
        }   //load data to array
        .onAppear(perform: {
            self.ingredients = Ingredient_DB().getIngredients()
            })
        
        NavigationLink(destination: CookbookView(), label: { Text("Add Recipe")}).simultaneousGesture(TapGesture().onEnded{

            //add all selected ingredients to junction table
            for ingredientValue in ingredients{
                //if currently selected add to junction table
                if(selectedRows.contains(ingredientValue.id)){
                    Recipe_Ingredient_DB().recipeToIngredient(recipeNameValue: recipeValue.name, ingredientNameValue: ingredientValue.name)
                }
            }
            //call function to add new row in sqlite
            Recipe_DB().addRecipe(nameValue: recipeValue.name, instructionsValue: recipeValue.instructions)
        })
    }
}

struct IngredientMultipleSelectView_Previews: PreviewProvider {
    @State static var recipeValue: Recipe = Recipe()
    static var previews: some View {
        IngredientMultipleSelectView(recipeValue: $recipeValue, ingredients: [Ingredient()])
    }
}