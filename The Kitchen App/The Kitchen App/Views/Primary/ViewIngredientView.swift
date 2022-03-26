//
//  ViewIngredientView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 3/1/22.
//

import SwiftUI

struct ViewIngredientView: View {
    //Name of recipe recived from revious view
    @Binding var ingredient: Ingredient
    
    //variable for if delte warning message shows
    @State private var showingAlert: Bool = false
    
    @State var inStock: Bool = false
    
    //To return to previous view
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        VStack {
            Text(ingredient.name)
                .font(.title)
                .padding(.leading, 5)
            Text(inStock ? "In Stock" : "Out Of Stock")
                .font(.title)
                .padding(.leading, 5)
                .foregroundColor(inStock ? .green : .red)
            Toggle("", isOn: $inStock)
                .frame(width: 1, alignment: .center)
                .onChange(of: inStock, perform: { value in
                    //call DB to update user with new values
                    ingredient.inStock = self.inStock
                    Ingredient_DB().updateIngredient(idValue: self.ingredient.id.uuidString, nameValue: ingredient.name, inStockValue: ingredient.inStock, categoryValue: ingredient.catagory, keepInStockValue: ingredient.keepInStock)
                })
            if ingredient.keepInStock{
                HStack{
                    Text("Always keep in stock:")
                    Image(systemName: "checkmark")
                }}
        }
        .onAppear(perform: {
            self.inStock = ingredient.inStock
        })
        .navigationBarItems(trailing:
                                HStack{
            Spacer()
            //Delete Button
            Button("Delete") {
                showingAlert = true
            }
            .padding()
            .alert(isPresented:$showingAlert) {
                Alert(
                    title: Text("Are you sure you want to delete this?"),
                    message: Text("There is no undo"),
                    primaryButton: .destructive(Text("Delete")) {
                        ingredient.name = "Deleted"
                        //Remove recipe from Recipe_DB
                        Ingredient_DB().deleteIngredient(ingredientID: ingredient.id.uuidString)
                        //Remove recipe from Recipe_Igredient_DB
                        Recipe_Ingredient_DB().deleteIngredient(ingredientIDValue: ingredient.id.uuidString)
                        //return to previous screen
                        self.mode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
            Spacer()
            NavigationLink(destination: EditIngredientView(ingredient: $ingredient), label: {Text("Edit")})
        })
    }
}

struct ViewIngredientView_Previews: PreviewProvider {
    @State static var ingredient: Ingredient = Ingredient()
    static var previews: some View {
        Group {
            ViewIngredientView(ingredient: $ingredient)
        }
    }
}
