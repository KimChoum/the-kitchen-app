//
//  IngredientListItem.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 3/14/22.
//

import SwiftUI

struct IngredientListItem: View {
    
    //list of colors to be used
    let defaultColor = UIColor(Color(0x767A7C))
    let cellColor = UIColor(Color(0xEAEAEA))
    let catagories: [String: UIColor] = ["None": UIColor(Color(0x767A7C)), "Produce": UIColor(Color(0x97D091)), "Dairy/Eggs": UIColor(Color(0xFEAA84)), "Butcher": UIColor(Color(0xFED184)), "Bakery": UIColor(Color(0xFEF884)), "Canned Goods": UIColor(Color(0xE9FE84)), "Baking": UIColor(Color(0xC7FE84)), "Frozen": UIColor(Color(0x84ADFE)), "Bulk": UIColor(Color(0x84FEBD)), "Snack Foods": UIColor(Color(0x84FEED)), "Spices/Seasonings": UIColor(Color(0x84D9FE)), "Pasta/Rice": UIColor(Color(0xFE8684)), "Drinks": UIColor(Color(0x8584FE)), "Liquor": UIColor(Color(0xB784FE)), "Condiments": UIColor(Color(0xE984FE))]
    
    //ingredient id to display
    @Binding var ingredient: Ingredient
    //to see if ingredient was clicked on
    @State var ingredientSelected: Bool = false
    //@State var catagoryColor: UIColor
    
    var body: some View {
        //navigation link to view ingredient info
        NavigationLink (destination: ViewIngredientView(ingredient: $ingredient), isActive: self.$ingredientSelected){
            EmptyView()
        }
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
                .background(Color(self.catagories[self.ingredient.catagory] ?? self.defaultColor))
                .cornerRadius(15)
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.top, 3)
        .padding(.bottom, 3)
    }
}

struct IngredientListItem_Previews: PreviewProvider {
    @State static var ingredient = Ingredient()
    static var previews: some View {
        IngredientListItem(ingredient: $ingredient)
    }
}
