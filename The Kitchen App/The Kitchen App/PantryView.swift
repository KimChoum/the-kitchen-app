//
//  PantryView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/20/22.
//

import SwiftUI

struct PantryView: View {
    
    //array to hold ingredients:
    @State var ingredients: [Ingredient] = []
    @State var inStockNum: Int = 0
    
    var body: some View {
        NavigationView{
            VStack{
                //List Number of ingredients in stock
                HStack {
                    Text("Ingredients in stock:")
                    Text(String(self.inStockNum))
                        .background((self.inStockNum>0) ? Color.green : Color.red)
                }
                Divider()
                //List to show ingredients:
                List(self.ingredients) { (model) in
                    HStack{
                        Text(model.name)
                        Spacer()
                        Text(model.inStock ? "In Stock" : "Not in Stock")
                    }
                }.padding()
                NavigationLink (destination: AddIngredientView(), label: { Text("Add Ingredient")
                        .padding()
                })
            }
            //load data to array
            .onAppear(perform: {
                self.inStockNum = Ingredient_DB().numberOfIngredients()
                    self.ingredients = Ingredient_DB().getIngredients()
                })
        }
    }
}

struct PantryView_Previews: PreviewProvider {
    static var previews: some View {
        PantryView()
    }
}
