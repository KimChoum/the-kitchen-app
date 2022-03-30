//
//  IngredientMultipleSelectUpdateView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 3/27/22.
//

import SwiftUI

struct IngredientMultipleSelectUpdateView: View {
    //file manager instance for saving images
    public var fileManager = LocalFileManager.instance
    
    //Name of recipe recived from previous view
    @Binding var recipeName: String
    
    @Binding var recipeInstructions: String
    @Binding var recipeImage: UIImage
    @Binding var recipeMealType: String
    @Binding var selectedRows: Set<UUID>
    @Binding var recipeID: String
    @Binding var recipeLink: String
    
    @State var recipeValue: Recipe = Recipe()
    @State var ingredients: [Ingredient] = []
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    
    //for searching
    @State var searchText: String = ""
    @State var searchBarShowing: Bool = true
    @State var ingredientSearchResults: [Ingredient] = []
    @State var isEditing: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                Text("Ingredients")
                    .font(.title)
                    .foregroundColor(Color(.black))
                Spacer()
                //Add ingredient link
                NavigationLink (destination: AddIngredientView(), label: { Text("Add Ingredient").foregroundColor(Color(.black))
                    .padding(.trailing, 8)})
            }
            HStack {
                TextField("Search...", text: $searchText)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .onChange(of: searchText) { searchText in
                        if !searchText.isEmpty {
                            ingredientSearchResults = ingredients.filter { $0.name.contains(searchText) }
                        } else {
                            ingredientSearchResults = ingredients
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
            List(selection: $selectedRows){
                ForEach(ingredientSearchResults){ ingredient in
                    IngredientRow(ingredient: ingredient, selectedItems: $selectedRows)
                }
            }   //load data to array
            .frame(height: 400)
            .onAppear(perform: {
                self.ingredients = Ingredient_DB().getIngredients()
                self.ingredientSearchResults = ingredients
            })
        }.toolbar(content: {
            Button(action: {
                //save image to local file
                fileManager.saveImage(image: recipeImage, imageName: recipeID, folderName: "recipeImages")
                
                recipeValue.instructions = recipeInstructions
                recipeValue.name = recipeName
                recipeValue.mealType = recipeMealType
                recipeValue.id = UUID(uuidString: recipeID)!
                
                Recipe_Ingredient_DB().deleteRecipe(recipeIDValue: recipeValue.id.uuidString)
                //add all selected ingredients to junction table
                for ingredientValue in ingredients{
                    //if currently selected add to junction table
                    if(selectedRows.contains(ingredientValue.id)){
                        Recipe_Ingredient_DB().recipeToIngredient(recipeIDValue: recipeValue.id.uuidString, ingredientIDValue: ingredientValue.id.uuidString)
                    }
                }
                //call function to add new row in sqlite
                Recipe_DB().updateRecipe(recipeIDValue: recipeValue.id.uuidString, nameValue: recipeValue.name, instructionsValue: recipeValue.instructions, mealTypeValue: recipeMealType, recipeLinkValue: recipeLink)
                self.mode.wrappedValue.dismiss()
            }, label: {
                Text("Done")
                    .padding(1)
                    .padding(.horizontal, 2)
                    .foregroundColor(.white)
                    .background(Color(.systemBlue))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            })
        })
    }
}

struct IngredientMultipleSelectUpdateView_Previews: PreviewProvider {
    @State static var recipeName: String = ""
    @State static var recipeInstructions: String = ""
    @State static var recipeImage: UIImage = UIImage()
    @State static var recipeMealType: String = ""
    @State static var selectedRows = Set<UUID>()
    @State static var recipeID: String = ""
    @State static var recipeLink: String = ""
    static var previews: some View {
        IngredientMultipleSelectUpdateView(recipeName: $recipeName, recipeInstructions: $recipeInstructions, recipeImage: $recipeImage, recipeMealType: $recipeMealType, selectedRows: $selectedRows, recipeID: $recipeID, recipeLink: $recipeLink)
    }
}
