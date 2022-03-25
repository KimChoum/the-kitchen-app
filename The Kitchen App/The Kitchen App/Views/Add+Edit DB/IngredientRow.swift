//
//  IngredientRow.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/25/22.
//

import SwiftUI

struct IngredientRow: View {
    
    //list of colors to be used
    let defaultColor = UIColor(Color(0x767A7C))
    let cellColor = UIColor(Color(0xEAEAEA))
    let catagories: [String: UIColor] = ["None": UIColor(Color(0x767A7C)), "Produce": UIColor(Color(0x97D091)), "Dairy/Eggs": UIColor(Color(0xFEAA84)), "Meat": UIColor(Color(0xFED184)), "Bakery": UIColor(Color(0xFEF884)), "Canned Goods": UIColor(Color(0xE9FE84)), "Baking": UIColor(Color(0xC7FE84)), "Frozen": UIColor(Color(0x84ADFE)), "Bulk": UIColor(Color(0x84FEBD)), "Snack Foods": UIColor(Color(0x84FEED)), "Spices/Seasonings": UIColor(Color(0x84D9FE)), "Pasta/Rice": UIColor(Color(0xFE8684)), "Drinks": UIColor(Color(0x8584FE)), "Liquor": UIColor(Color(0xB784FE)), "Condiments": UIColor(Color(0xE984FE))]
    
    var ingredient: Ingredient
    @Binding var selectedItems: Set<UUID>
    
    var isSelected: Bool {
        selectedItems.contains(ingredient.id)
        //selectedItems.contains(ingredient.name)
    }
    var body: some View {
        HStack {
            if !ingredient.inStock{
                Image(systemName: "x.square")
                    .foregroundColor(.red)
                    .padding(.leading, 5)
            }
            Text(ingredient.name)
                .font(.body)
                .padding(.leading, 5)
                .frame(minWidth: 100)
            Divider()
                .frame(width: 10)
            Text(ingredient.catagory)
                .font(.body)
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                .background(Color(self.catagories[self.ingredient.catagory] ?? defaultColor))
                .cornerRadius(15)
                .foregroundColor(.black)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.accentColor)
            }
        }
        .background(Color(ingredient.catagory))
        //.padding(.top, 3)
        .padding(.bottom, 3)
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
