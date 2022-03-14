//
//  ViewIngredientView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 3/1/22.
//

import SwiftUI

struct ViewIngredientView: View {
    //Name of recipe recived from revious view
    @Binding var id: String
    
    //variables to hold ingredient
    //@State var ingredientValue: Ingredient = Ingredient()
    @State var ingredientName: String = ""
    @State var inStock: Bool = false
    
    //variable for if delte warning message shows
    @State private var showingAlert: Bool = false
    
    //To return to previous view
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        VStack {
            Text(ingredientName)
                .font(.title)
                .padding(.leading, 5)
            Text(inStock ? "In Stock" : "Out Of Stock")
                .font(.title)
                .padding(.leading, 5)
                .foregroundColor(inStock ? .green : .red)
            Toggle("", isOn: self.$inStock)
                .frame(width: 1, alignment: .center)
            .onChange(of: inStock, perform: { value in
                //call DB to update user with new values
                Ingredient_DB().updateIngredient(idValue: self.id, nameValue: self.ingredientName, inStockValue: self.inStock)
                print(value)
            })
        }
        //populate instructions and ingredient variables
        .onAppear(perform: {
            //Ingredient data from DB
            let ingredientModel: Ingredient = Ingredient_DB().getIngredient(idValue: self.id)
            
            //populate on screen
            self.ingredientName = ingredientModel.name
            self.inStock = ingredientModel.inStock
        })
        .navigationBarItems(trailing:
                                HStack{
            Spacer()
            NavigationLink(destination: EditIngredientView(ingredientID: self.$id), label: {Text("Edit")})
        }
        )
        //.navigationBarTitle(self.name)
    }
}

struct ViewIngredientView_Previews: PreviewProvider {
    @State static var id: String = ""
    static var previews: some View {
        Group {
            ViewIngredientView(id: $id)
        }
    }
}
