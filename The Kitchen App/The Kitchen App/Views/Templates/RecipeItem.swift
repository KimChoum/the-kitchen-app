//
//  RecipeListItem.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 3/18/22.
//

import SwiftUI

struct RecipeItem: View {
    @Binding var recipe: Recipe
    @State var recipeSelected: Bool = false
    //file manager instance for getting images
    public var fileManager = LocalFileManager.instance
    var body: some View {
        NavigationLink (destination: viewRecipeView(recipe: $recipe), isActive: self.$recipeSelected){
            EmptyView()
        }
        Button(action: {
            self.recipeSelected = true
        },
               label: {
            VStack {
                Image(uiImage: fileManager.getImage(imageName: recipe.id.uuidString, folderName: "recipeImages") ?? UIImage(named: "test-recipe-image")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxHeight: 150)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(recipe.mealType)
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(recipe.name)
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .lineLimit(3)
                        HStack{
                            Text("On Shopping List".uppercased())
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Image(systemName: recipe.onShoppingList ? "checkmark.circle" : "circle")
                                .foregroundColor(recipe.onShoppingList ? .green : .blue)
                        }
                    }
                    .padding(.leading, 5)
                    .layoutPriority(100)
                    
                    Spacer()
                }
                .background(Color(.white))
            }
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
            )
            .shadow(radius: 10)
        })
    }
}

struct RecipeItem_Previews: PreviewProvider {
    @State static var recipe = Recipe()
    static var previews: some View {
        RecipeItem(recipe: $recipe)
    }
}
