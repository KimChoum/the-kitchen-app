//
//  SmallRecipeItem.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 3/26/22.
//

import SwiftUI

struct SmallRecipeItem: View {
    @Binding var recipe: Recipe
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(recipe.mealType)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(recipe.name)
                    .font(.body)
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
    }
}
    
    //struct SmallRecipeItem_Previews: PreviewProvider {
    //    static var previews: some View {
    //        SmallRecipeItem()
    //    }
    //}
