//
//  CardListRow.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 3/16/22.
//

import SwiftUI

struct RecipeRow: View {
    @Binding var item: Recipe

    var body: some View {
        ZStack {
            Color.white
                .cornerRadius(12)
            RecipeItem(recipe: $item)
        }
        .fixedSize(horizontal: false, vertical: true)
        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
    }
}

struct RecipeRow_Previews: PreviewProvider {
    @State static var item = Recipe()
    static var previews: some View {
        RecipeRow(item: $item)
    }
}
