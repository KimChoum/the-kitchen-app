//
//  CardListRowNoDelete.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 3/28/22.
//

import SwiftUI

struct CardListRowNoDelete: View {
    @Binding var item: Ingredient
    @State var inStock: Bool = false
    @State var showingAlert: Bool = false
    var body: some View {
        ZStack {
            Color.white
                .cornerRadius(12)
            IngredientListItemNoDelete(ingredient: $item)
        }
        .fixedSize(horizontal: false, vertical: true)
        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
    }
}

struct CardListRowNoDelete_Previews: PreviewProvider {
    @State static var item = Ingredient()
    static var previews: some View {
        CardListRow(item: $item)
    }
}
