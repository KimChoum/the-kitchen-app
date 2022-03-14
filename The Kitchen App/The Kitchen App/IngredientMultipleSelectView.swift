//
//  IngredientMultipleSelectView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/25/22.
//

import SwiftUI

func documentDirectoryPath() -> URL? {
    let path = FileManager.default.urls(for: .documentDirectory,
                                           in: .userDomainMask)
    return path.first
}


struct IngredientMultipleSelectView: View {
    //file manager instance for saving images
    public var fileManager = LocalFileManager.instance
    
    //Name of recipe recived from previous view
    @Binding var recipeName: String
    @Binding var recipeInstructions: String
    @Binding var recipeImage: UIImage
    
    @State var recipeValue: Recipe = Recipe()
    @State var selectedRows = Set<UUID>()
    @State var ingredients: [Ingredient]
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            HStack{
                Text("Ingredients list")
                    .font(.title)
                    .foregroundColor(Color(labelColor))
                Spacer()
                //Add ingredient link
                NavigationLink (destination: AddIngredientView(), label: { Text("Add Ingredient").foregroundColor(Color(labelColor))
                    .padding(.trailing, 8)})
            }
            List(selection: $selectedRows){
                ForEach(ingredients){ ingredient in
                    IngredientRow(ingredient: ingredient, selectedItems: $selectedRows)
                }
            }   //load data to array
            .onAppear(perform: {
                self.ingredients = Ingredient_DB().getIngredients()
            })
            
            Button(action: {
                //save image to local file
                fileManager.saveImage(image: recipeImage, imageName: recipeValue.id.uuidString, folderName: "recipeImages")
                
                recipeValue.instructions = recipeInstructions
                recipeValue.name = recipeName
                
                //add all selected ingredients to junction table
                for ingredientValue in ingredients{
                    //if currently selected add to junction table
                    if(selectedRows.contains(ingredientValue.id)){
                        Recipe_Ingredient_DB().recipeToIngredient(recipeIDValue: recipeValue.id.uuidString, ingredientIDValue: ingredientValue.id.uuidString)
                    }
                }
                //call function to add new row in sqlite
                Recipe_DB().addRecipe(recipeIDValue: recipeValue.id.uuidString, nameValue: recipeValue.name, instructionsValue: recipeValue.instructions)
                self.mode.wrappedValue.dismiss()
            }, label: {Text("Add Recipe")})
        }
    }
}

struct IngredientMultipleSelectView_Previews: PreviewProvider {
    @State static var recipeName: String = ""
    @State static var recipeInstructions: String = ""
    @State static var recipeImage: UIImage = UIImage()
    static var previews: some View {
        IngredientMultipleSelectView(recipeName: $recipeName, recipeInstructions: $recipeInstructions, recipeImage: $recipeImage, ingredients: [Ingredient()])
    }
}
