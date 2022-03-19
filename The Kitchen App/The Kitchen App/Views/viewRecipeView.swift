//
//  viewRecipeView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/25/22.
//

import SwiftUI

struct viewRecipeView: View {
    //Name of recipe recived from revious view
    @Binding var recipe: Recipe
    
    //file manager instance for getting image
    public var fileManager = LocalFileManager.instance
    
    //variable for if delte warning message shows
    @State private var showingAlert: Bool = false
    
    //variable to see if ingredient has been clicked on
    @State var ingredientSelected: Bool = false
    
    //variable that will be updated
    @State var onShoppingList: Bool = false
    
    //To return to previous view
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        ZStack(alignment: .top) {
            Image(uiImage: fileManager.getImage(imageName: recipe.id.uuidString, folderName: "recipeImages") ?? UIImage(named: "test-recipe-image")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxHeight: 250)
                .ignoresSafeArea()
            HStack{
                Text(recipe.name)
                    .background(Color(.white))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding(.top, 73)
                    .padding(.leading, 5)
                    .font(.title)
                Spacer()
            }
            ScrollView{
                VStack(alignment: .leading) {
                    HStack{
                        Text("On shopping list")
                            .padding()
                        Toggle("", isOn: $onShoppingList)
                            .onChange(of: onShoppingList, perform: { value in
                                //call DB to update user with new values
                                recipe.onShoppingList = self.onShoppingList
                                Recipe_DB().updateOnShoppingList(recipeIDValue: recipe.id.uuidString, onShoppingListValue: recipe.onShoppingList)
                            })
                    }
                    Text("Instructions:")
                        .font(.title)
                        .padding(.leading, 5)
                    Text(recipe.instructions)
                        .padding()
                    Text("Ingredients:")
                        .font(.title)
                        .padding(.leading, 5)
                    
                    //print each ingredient
                    List{
                        ForEach(self.$recipe.ingredients, id: \.id){ ingredientModel in
                            //print each ingredient
                            CardListRow(item: ingredientModel)
                                .listRowSeparator(.hidden)
                        }
                    }
                    .frame(height: 180)
                    .listStyle(.plain)
                }
                .background(Color(.white))
                .padding(.top, 150)
            }
            //populate instructions and ingredient variables
            .onAppear(perform: {
                let listOfIngredients: [Ingredient] = Ingredient_DB().getRecipeIngredients(ingredientIDList: Recipe_Ingredient_DB().getIngredientIDsList(recipeIDValue: recipe.id.uuidString))
                //populate on screen
                recipe.ingredients = listOfIngredients
                self.onShoppingList = recipe.onShoppingList
            })
            .navigationBarItems(trailing:
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
                            //Remove recipe from Recipe_DB
                            let recipeDB: Recipe_DB = Recipe_DB()
                            recipeDB.deleteRecipe(recipeIDValue: recipe.id.uuidString)
                            //Remove recipe from Recipe_Igredient_DB
                            let recipeIngredientDB: Recipe_Ingredient_DB = Recipe_Ingredient_DB()
                            recipeIngredientDB.deleteRecipe(recipeIDValue: recipe.id.uuidString)
                            //return to previous screen
                            self.mode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }//end of HStack
            )
            //.navigationBarTitle(recipe.name)
        }
    }
}

struct viewRecipeView_Previews: PreviewProvider {
    @State static var recipe: Recipe = Recipe()
    static var previews: some View {
        viewRecipeView(recipe: $recipe)
    }
}
