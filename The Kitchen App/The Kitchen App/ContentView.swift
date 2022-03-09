//
//  ContentView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/16/22.
//
import SwiftUI
import Drawer

extension Color {
    init(_ hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct IngredientButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        //.padding([.bottom], 110)
        //.background(Color.blue)
        //.background(Color(model.inStock ? calmGreen : .red))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct navigateButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding([.bottom], 50)
            .background(Color.mint)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ContentView: View {
    
    //list of colors to be used
    //UIColor(Color(0x49393B))
    let backGroundColor = UIColor(Color.white)
    let labelColor = UIColor(Color(0x1F271B))
    let inStockColor = UIColor(Color(0x6aab7d))
    let outOfStockColor = UIColor(Color(0xEE6352))
    let accentColor = UIColor(Color(0xFCF6B1))
    
    //variables for Ingredient list:
    @State var ingredients: [Ingredient] = []
    @State var inStockNum: Int = 0
    @State var viewAllIngredientsSelected: Bool = false
    //variable to see if ingredient has been clicked on
    @State var ingredientSelected: Bool = false
    @State var selectedIngredientName: String = ""
    
    //variables for recipe list
    //array to hold recipes:
    @State var recipes: [Recipe] = []
    //check if recipe is selected
    @State var recipeSelected: Bool = false
    //name of recipe to view
    @State var selectedRecipeName: String = ""
    //if view all is selected
    @State var viewAllRecipesSelected: Bool = false
    
    //var to see if view shopping list is pressed
    @State var viewShoppingListSelected: Bool = false
    
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(backGroundColor)
                ScrollView{
                    VStack{
                        ShoppingListView()
                            .frame(maxHeight: 150)
                        //Ingredient Section
                        PantryView()
                            .frame(maxHeight: 200)
                        
                        
                        //Recipe Section
                        CookbookView()
                            .frame(maxHeight: .infinity)
                    }
                    .navigationBarTitle(Text("My Kitchen")).navigationBarHidden(false)
                }
            }
            //.edgesIgnoringSafeArea(.vertical)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        PantryView()
        CookbookView()
    }
}
