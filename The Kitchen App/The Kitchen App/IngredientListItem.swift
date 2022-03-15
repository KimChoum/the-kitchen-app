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
    @State var ingredient: Ingredient
    //to see if ingredient was clicked on
    @State var ingredientSelected: Bool = false
    @State var name: String = ""
    @State var inStock: Bool = false
    @State var idString: String = ""
    @State var catagory: String = ""
    //@State var catagoryColor: UIColor
    
    var body: some View {
        //navigation link to view ingredient view details
        NavigationLink (destination: ViewIngredientView(id: $idString), isActive: self.$ingredientSelected){
            EmptyView()
        }
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
            RoundedRectangle(cornerRadius: 5)
                //.stroke(Color.gray, lineWidth: 1)
                .foregroundColor(Color(cellColor))
            HStack {
                if !inStock{
                    Image(systemName: "x.square")
                        .foregroundColor(.red)
                        .padding(.leading, 5)
                }
                    Text(name)
                        .font(.body)
                        .padding(.leading, 5)
                        .frame(minWidth: 100)//, maxWidth: 200)
                Divider()
                Spacer()
                    .frame(width: 10)
                Text(catagory)
                    .font(.body)
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    .background(Color(self.catagories[self.catagory] ?? self.defaultColor))
                    .cornerRadius(15)
                    .foregroundColor(.white)
            }
            .onTapGesture {
                self.ingredientSelected = true
            }
            .padding(.top, 4)
            .padding(.bottom, 4)
        }
        .padding(5)
        .onAppear(perform: {
            //get ingredient from database
            self.inStock = ingredient.inStock
            self.name = ingredient.name
            self.idString = ingredient.id.uuidString
            self.catagory = ingredient.catagory
            //self.catagoryColor = catagories[self.catagory]!
    })
    }
}

struct IngredientListItem_Previews: PreviewProvider {
    @State static var ingredient = Ingredient()
    static var previews: some View {
        IngredientListItem(ingredient: ingredient)
    }
}
