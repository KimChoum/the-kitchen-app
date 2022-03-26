//
//  viewRecipeView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/25/22.
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
  let style: Style // custom param

  func makeBody(configuration: Configuration) -> some View {
    Button(action: {
      configuration.isOn.toggle() // toggle the state binding
    }, label: {
      HStack {
        Image(systemName: configuration.isOn ? "checkmark.\(style.sfSymbolName).fill" : style.sfSymbolName)
          .imageScale(.large)
          .foregroundColor(configuration.isOn ? .green : .black)
        configuration.label
      }
    }).buttonStyle(PlainButtonStyle()) // remove any implicit styling from the button
  }

  enum Style {
    case square, circle

    var sfSymbolName: String {
      switch self {
      case .square:
        return "square"
      case .circle:
        return "circle"
      }
    }
  }
}

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
                VStack(alignment: .leading){
                    Text(recipe.name)
                        .font(.title)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                    if (Ingredient_DB().allInStock(allIngredientIDs: Recipe_Ingredient_DB().getIngredientIDsList(recipeIDValue: recipe.id.uuidString))){
                        HStack{
                            Text("All ingredient in stock!")
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                        }
                    }
                }
                .background(Color(.white))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .padding(.top, 73)
                .padding(.leading, 5)
                Spacer()
            }
            ScrollView{
                VStack(alignment: .leading) {
                    HStack{
                        Toggle("On shopping list", isOn: $onShoppingList)
                            .onChange(of: onShoppingList, perform: { value in
                                //call DB to update user with new values
                                recipe.onShoppingList = self.onShoppingList
                                Recipe_DB().updateOnShoppingList(recipeIDValue: recipe.id.uuidString, onShoppingListValue: recipe.onShoppingList)
                            })
                            .toggleStyle(CheckboxToggleStyle(style: .circle))
                            .padding()
                        Spacer()
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
                    .frame(minHeight: 300)
                    .listStyle(.plain)
                }
                .background(Color(.white))
                .padding(.top, 110)
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
