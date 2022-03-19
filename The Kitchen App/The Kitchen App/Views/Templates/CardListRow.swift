//
//  CardListRow.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 3/16/22.
//

import SwiftUI

struct CardListRow: View {
    @Binding var item: Ingredient
    @State var inStock: Bool = false
    @State var showingAlert: Bool = false
    
    var body: some View {
        ZStack {
            Color.white
                .cornerRadius(12)
            IngredientListItem(ingredient: $item)
        }
        .fixedSize(horizontal: false, vertical: true)
        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
        .swipeActions() {
            if self.inStock == true {
                Button (action: {
                    self.inStock = false
                    item.inStock = self.inStock
                    Ingredient_DB().updateIngredient(idValue: self.item.id.uuidString, nameValue: self.item.name, inStockValue: self.item.inStock)
                }) {
                    Text("Out of stock")
                }
                .tint(.yellow)
            }else{
                Button (action: {
                    self.inStock = true
                    item.inStock = self.inStock
                    Ingredient_DB().updateIngredient(idValue: self.self.item.id.uuidString, nameValue: self.item.name, inStockValue: self.item.inStock)
                }) {
                    Text("In stock")
                }
                .tint(.green)
            }
        }
        .onAppear(perform: {self.inStock = item.inStock})
    }
}

struct CardListRow_Previews: PreviewProvider {
    @State static var item = Ingredient()
    static var previews: some View {
        CardListRow(item: $item)
    }
}
