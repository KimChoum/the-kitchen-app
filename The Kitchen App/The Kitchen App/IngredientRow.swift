//
//  IngredientRow.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/25/22.
//

import SwiftUI

struct IngredientRow: View {
    
    var ingredient: Ingredient
    @Binding var selectedItems: Set<UUID>
    
    var isSelected: Bool {
        selectedItems.contains(ingredient.id)
        //selectedItems.contains(ingredient.name)
    }
    var body: some View {
        HStack {
            Text(ingredient.name)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.accentColor)
            }
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            if isSelected {
                self.selectedItems.remove(ingredient.id)
            } else {
                self.selectedItems.insert(ingredient.id)
            }
        }
    }
}

struct IngredientRow_Previews: PreviewProvider {
    static var previews: some View {
        let id = UUID()
        IngredientRow(ingredient: Ingredient(), selectedItems: .constant([id]))
    }
}
