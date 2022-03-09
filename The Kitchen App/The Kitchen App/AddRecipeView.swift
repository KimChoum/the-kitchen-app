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
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            //create name entry field:
            List{
                Text("Enter Recipe Name:")
                    .font(.title)
                ZStack{
                    TextField("name", text: $name)
                        .padding(10)
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                        .background(Color(.white))
                }
                .shadow(radius: 1)
                Text("Enter Instructions:")
                    .font(.title)
                ZStack{
                    TextEditor(text: $instructions)
                    Text(instructions)
                        .opacity(0)
                        .padding(.all, 8)
                }
                .shadow(radius: 1)
                
//                NavigationLink(destination: IngredientMultipleSelectView(recipeName: $name, recipeInstructions: $instructions, ingredients: self.ingredients), label: { Text("Add Ingredients").font(.body)})
//                    .padding(10)
//                    .simultaneousGesture(TapGesture().onEnded{
//                        self.mode.wrappedValue.dismiss()
//                    })
            }
            IngredientMultipleSelectView(recipeName: $name, recipeInstructions: $instructions, ingredients: self.ingredients)
        }
        .background(Color(.systemGray6))
        .onAppear(perform: {
            self.ingredients = Ingredient_DB().getIngredients()
        })
    }
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView()
    }
}
