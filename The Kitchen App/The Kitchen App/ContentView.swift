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
            .padding([.bottom], 110)
        //.background(Color.blue)
            .background(Image("test-recipe-image")
                            .resizable()
                            .scaledToFill())
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
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
    
    //variables for recipe list
    //array to hold recipes:
    @State var recipes: [Recipe] = []
    //check if recipe is selected
    @State var recipeSelected: Bool = false
    //name of recipe to view
    @State var selectedRecipeName: String = ""
    //if view all is selected
    @State var viewAllRecipesSelected: Bool = false
    
    //variable to see if ingredient has been clicked on
    @State var ingredientSelected: Bool = false
    @State var selectedIngredientName: String = ""
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(backGroundColor)
                ScrollView{
                    VStack{
                        //Ingredient Section
                        HStack{
                            Text("Ingredients")
                                .font(.title)
                                .foregroundColor(Color(labelColor))
                            Spacer()
                            //Add ingredient link
                            NavigationLink (destination: AddIngredientView(), label: { Text("Add Ingredient").foregroundColor(Color(labelColor))
                                    .padding(.trailing, 8)
                            })}
                        .padding(.top, 40)
                        .background(Color(backGroundColor))
                        ScrollView(.vertical){
                            VStack{
                                //navigation link to view all ingredients
                                NavigationLink (destination: PantryView(), isActive: self.$viewAllIngredientsSelected){
                                    EmptyView()
                                }
                                //navigation link to view ingredient view details
                                NavigationLink (destination: ViewIngredientView(name: self.$selectedIngredientName), isActive: self.$ingredientSelected){
                                    EmptyView()
                                }
                                //print each ingredient
                                ForEach(self.ingredients) { ingredientModel in
                                    HStack{
                                        Button(action: {
                                            self.selectedIngredientName = ingredientModel.name
                                            self.ingredientSelected = true
                                        }, label: {
                                            Text(ingredientModel.name)
                                                .frame(maxWidth: 350, minHeight: 35, alignment: .leading)
                                                .foregroundColor(Color(labelColor))
                                                .background(Color(ingredientModel.inStock ? inStockColor : outOfStockColor))
                                                .clipShape(RoundedRectangle(cornerRadius: 7))
                                                //.border(Color(labelColor))
                                        })
                                    }
                                }
                                Button(action: {self.viewAllIngredientsSelected = true}, label: {Text("View All Ingredient")})
                                
                            }
                        }
                        .onAppear(perform: {
                            self.inStockNum = Ingredient_DB().numberOfIngredients()
                            self.ingredients = Ingredient_DB().getIngredients()
                        })
                        .frame(maxHeight: 200)
                        
                        
                        //Recipe Section
                        HStack{
                            //button to view all recipes
                            Button(action: {self.viewAllRecipesSelected = true}, label: {Text("Recipes").font(.title).foregroundColor(Color(labelColor))})
                            //Text("Recipes")
                            //    .font(.title)
                            Spacer()
                            NavigationLink (destination: AddRecipeView(), label: { Text("Add Recipe")
                                    .foregroundColor(Color(labelColor))
                            }).padding(8)
                        }
                        .background(Color(backGroundColor))
                        
                        VStack{
                            //navigation link to view recipe view details
                            NavigationLink (destination: viewRecipeView(name: self.$selectedRecipeName), isActive: self.$recipeSelected){
                                EmptyView()
                            }
                            //navigation link to view all recipes
                            NavigationLink (destination: CookbookView(), isActive: self.$viewAllRecipesSelected){
                                EmptyView()
                            }
                            
                            //List to show ingredients:
                            ScrollView(.vertical){
                                Button(action: {
                                    
                                }, label: {
                                    
                                })
                                ForEach(self.recipes) { (recipeModel) in
                                    Button(action: {
                                        self.selectedRecipeName = recipeModel.name
                                        self.recipeSelected = true
                                    }, label: {
                                        HStack{
                                            Text(recipeModel.name)
                                                .padding()
                                                .font(.headline)
                                                .background(Color(inStockColor)
                                                                .clipShape(Capsule()))
                                                .foregroundColor(Color(labelColor))
                                            Spacer()
                                            //Text("TODO: Have the ingredients?")
                                        }.padding()
                                    }).buttonStyle(GrowingButton())
                                }
                                //button to view all recipes
                                Button(action: {self.viewAllRecipesSelected = true}, label: {Text("View All Recipes")})
                            }
                        }
                        //load data to array
                        .onAppear(perform: {
                            self.recipes = Recipe_DB().getRecipes()
                        })
                        .frame(height: 350)
                    }
                    //.navigationBarTitle(Text("My Kitchen")).navigationBarHidden(false)
                }//end of scrollview
//                Drawer(heights: .constant([50, 340])) {
//                    Color(backGroundColor)
//                }.edgesIgnoringSafeArea(.vertical)
            }
            .edgesIgnoringSafeArea(.vertical)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
