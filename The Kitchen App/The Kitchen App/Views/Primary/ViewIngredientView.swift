//
//  ViewIngredientView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 3/1/22.
//

import SwiftUI

struct ViewIngredientView: View {
    //categories for picker
    let defaultColor = UIColor(Color(0x767A7C))
    let catagories = ["None", "Produce", "Dairy/Eggs", "Meat", "Breads", "Canned Goods", "Baking", "Frozen", "Bulk", "Snack Foods", "Spices/Seasonings", "Pasta/Rice", "Drinks", "Liquor", "Condiments"]
    let catagoriesColors: [String: UIColor] = ["None": UIColor(Color(0x767A7C)), "Produce": UIColor(Color(0x97D091)), "Dairy/Eggs": UIColor(Color(0xFEAA84)), "Meat": UIColor(Color(0xFED184)), "Breads": UIColor(Color(0xFEF884)), "Canned Goods": UIColor(Color(0xE9FE84)), "Baking": UIColor(Color(0xC7FE84)), "Frozen": UIColor(Color(0x84ADFE)), "Bulk": UIColor(Color(0x84FEBD)), "Snack Foods": UIColor(Color(0x84FEED)), "Spices/Seasonings": UIColor(Color(0x84D9FE)), "Pasta/Rice": UIColor(Color(0xFE8684)), "Drinks": UIColor(Color(0x8584FE)), "Liquor": UIColor(Color(0xB784FE)), "Condiments": UIColor(Color(0xE984FE))]
    //Name of recipe recived from revious view
    @Binding var ingredient: Ingredient
    
    //variable for if delte warning message shows
    @State private var showingAlert: Bool = false
    
    //ingredient vairable that can be updated
    @State var inStock: Bool = false
    @State var category: String = ""
    @State var keepInStock: Bool = false
    
    //recipes that use the ingredient:
    @State var recipes: [Recipe] = []
    
    //To return to previous view
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text(ingredient.name)
                    .font(.title)
                    .padding(.leading, 5)
                Menu {
                    Picker("picker", selection: $category) {
                        ForEach(catagories, id: \.self) {
                            Text($0)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(InlinePickerStyle())
                    
                } label: {
                    Text(category)
                        .foregroundColor(.black)
                        .padding(5)
                        .labelsHidden()
                        .clipped()
                        .background(Color(catagoriesColors[category] ?? defaultColor))
                        .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                }
                
            }
            HStack{
                Toggle("In Stock", isOn: $inStock)
                    .frame(width: 120, alignment: .center)
                    .onChange(of: inStock, perform: { value in
                        //call DB to update user with new values
                        ingredient.inStock = self.inStock
                        Ingredient_DB().updateIngredient(idValue: self.ingredient.id.uuidString, nameValue: ingredient.name, inStockValue: ingredient.inStock, categoryValue: ingredient.catagory, keepInStockValue: ingredient.keepInStock)
                    })
                Toggle("Always Keep In Stock", isOn: $keepInStock)
                    .frame(width: 120, alignment: .center)
                    .onChange(of: keepInStock, perform: { value in
                        //call DB to update user with new values
                        ingredient.keepInStock = self.keepInStock
                        Ingredient_DB().updateIngredient(idValue: self.ingredient.id.uuidString, nameValue: ingredient.name, inStockValue: ingredient.inStock, categoryValue: ingredient.catagory, keepInStockValue: ingredient.keepInStock)
                    })
            }
            Text("Used in:")
                .font(.title2)
            List{
                ForEach(self.$recipes) { (recipeModel) in
                    SmallRecipeItem(recipe: recipeModel)
                        .listRowSeparator(.hidden)
                }
            }
        }
        .onAppear(perform: {
            self.inStock = ingredient.inStock
            self.category = ingredient.catagory
            self.keepInStock = ingredient.keepInStock
            self.recipes = Recipe_DB().getRecipesFromIDs(recipeIDS: Recipe_Ingredient_DB().getRecipesThatUseIngredient(ingredientIDValue: ingredient.id.uuidString))
        })
        .navigationBarItems(trailing:
                                HStack{
            Spacer()
            //Delete Button
            Button("Delete") {
                showingAlert = true
            }
            .padding()
            .alert(isPresented:$showingAlert) {
                Alert(
                    title: Text("Are you sure you want to delete this?"),
                    message: Text("There is no undo"),
                    primaryButton: .destructive(Text("Delete")) {
                        ingredient.name = "Deleted"
                        //Remove recipe from Recipe_DB
                        Ingredient_DB().deleteIngredient(ingredientID: ingredient.id.uuidString)
                        //Remove recipe from Recipe_Igredient_DB
                        Recipe_Ingredient_DB().deleteIngredient(ingredientIDValue: ingredient.id.uuidString)
                        //return to previous screen
                        self.mode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
            Spacer()
            NavigationLink(destination: EditIngredientView(ingredient: $ingredient), label: {Text("Edit")})
        })
    }
}

struct ViewIngredientView_Previews: PreviewProvider {
    @State static var ingredient: Ingredient = Ingredient()
    static var previews: some View {
        Group {
            ViewIngredientView(ingredient: $ingredient)
        }
    }
}
