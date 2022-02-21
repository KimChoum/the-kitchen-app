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
    
    var body: some View {
        NavigationView{
            VStack{
                
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
