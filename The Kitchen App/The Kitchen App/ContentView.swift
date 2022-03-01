//
//  ContentView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/16/22.
//
import SwiftUI
import Drawer

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
    let calmGreen = UIColor(red: 0.23, green: 0.8, blue: 0.5, alpha: 1)
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
    
    var body: some View {
        
        NavigationView{
            ZStack{
                ScrollView{
                    VStack{
                        //Ingredient Section
                        HStack{
                            Text("Ingredients")
                                .font(.title)
                            Spacer()
                            //Add ingredient link
                            NavigationLink (destination: AddIngredientView(), label: { Text("Add Ingredient")
                                    .padding(8)
                            })}
                        ScrollView(.vertical){
                            VStack{
                                NavigationLink (destination: PantryView(), isActive: self.$viewAllIngredientsSelected){
                                    EmptyView()
                                }
                                //print each ingredient
                                ForEach(self.ingredients) { model in
                                    HStack{
                                        Text(model.name)
                                            .frame(width: 300, height: 45)
                                            .background(Color(model.inStock ? calmGreen : .red))
                                            .foregroundColor(.white)
                                            .clipShape(Capsule())
                                        Spacer()
                                        //Text(model.inStock ? "In Stock" : "Not in Stock")
                                        //    .foregroundColor(model.inStock ? .green : .red)
                                        Button(action: {
                                            let ingredientDB: Ingredient_DB = Ingredient_DB()
                                            ingredientDB.deleteIngredient(ingredient: model)
                                            //TODO Remove ingredient from Recipe_Igredient_DB
                                            let recipeIngredientDB: Recipe_Ingredient_DB = Recipe_Ingredient_DB()
                                            recipeIngredientDB.deleteIngredient(ingredient: model)
                                            //reload from DB
                                            self.inStockNum = Ingredient_DB().numberOfIngredients()
                                            self.ingredients = Ingredient_DB().getIngredients()
                                        }, label: {
                                            Text("Delete")
                                                .foregroundColor(.red)
                                        })
                                            .buttonStyle(PlainButtonStyle())
                                            .padding()
                                    }
                                }
                                Button(action: {self.viewAllIngredientsSelected = true}, label: {Text("View All Ingredient")})
                            }
                        }
                        .onAppear(perform: {
                            self.inStockNum = Ingredient_DB().numberOfIngredients()
                            self.ingredients = Ingredient_DB().getIngredients()
                        })
                        .frame(height: 150)
                        
                        
                        //Recipe Section
                        HStack{
                            //button to view all recipes
                            Button(action: {self.viewAllRecipesSelected = true}, label: {Text("Recipes").font(.title).foregroundColor(.black)})
                            //Text("Recipes")
                            //    .font(.title)
                            Spacer()
                            NavigationLink (destination: AddRecipeView(), label: { Text("Add Recipe")
                            })}
                        
                        VStack{
                            //navigation link to view recipe view
                            NavigationLink (destination: viewRecipeView(name: self.$selectedRecipeName), isActive: self.$recipeSelected){
                                EmptyView()
                            }
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
                                                .background(Color(.white)
                                                                .clipShape(Capsule()))
                                                .foregroundColor(.black)
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
                    .navigationBarTitle(Text("My Kitchen"))
                }//end of scrollview
                Drawer(heights: .constant([50, 340])) {
                        Color.blue
                }.edgesIgnoringSafeArea(.vertical)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
