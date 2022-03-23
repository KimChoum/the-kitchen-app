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
    //variable to see if ingredients was selected
    @State var viewAllIngredientsSelected: Bool = false
    //variable for searching ingredients
    @State private var searchText = ""
    @State var ingredientSearchResults: [Ingredient] = []
    
    
    
    //file manager instance for saving images
    public var fileManager = LocalFileManager.instance
    
    //array to hold recipes:
    @State var recipes: [Recipe] = []
    //check if recipe is selected
    @State var recipeSelected: Bool = false
    //name of recipe to view
    @State var selectedRecipeID: String = ""
    //if view all is selected
    @State var viewAllRecipesSelected: Bool = false
    //for search
    @State var recipeSearchResults: [Recipe] = []
    
    //for navigation
    @State var shoppingListViewIsActive : Bool = false
    @State var cookbookViewIsActive : Bool = false
    @State var pantryViewIsActive : Bool = false
    
    
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    //Ingredient Section
                    VStack{
                        HStack{
                            //navigation link to view recipes in full page view
//                            NavigationLink (destination: PantryViewWithoutNavigation(), isActive: self.$viewAllIngredientsSelected){
//                                EmptyView()
//                            }
                            //button to view all recipes
                            Button(action: {self.viewAllIngredientsSelected = true}, label: {
                                Text("Ingredients").font(.title).foregroundColor(Color(labelColor))
                                    .padding(.leading, 10)
                            })
                            Spacer()
                            //Add ingredient link
                            NavigationLink (destination: AddIngredientView(), label: {
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .accentColor(.blue)
                                    .padding(.trailing, 25)
                            })}
                        List{
                            ForEach(self.$ingredientSearchResults, id: \.id){ ingredientModel in
                                //print each ingredient
                                CardListRow(item: ingredientModel)
                                    .listRowSeparator(.hidden)
                            }
                        }
                        .frame(height: 180)
                        .onChange(of: searchText) { searchText in
                            if !searchText.isEmpty {
                                ingredientSearchResults = ingredients.filter { $0.name.contains(searchText) }
                            } else {
                                ingredientSearchResults = ingredients
                            }
                        }
                        .listStyle(.plain)
                        .onAppear(perform: {
                            print("Load ingredients from DB")
                            self.ingredients = Ingredient_DB().getIngredients()
                            self.ingredientSearchResults = Ingredient_DB().getIngredients()
                        })
                    }
                    
                    
                    //Recipe Section
                    VStack{
                        HStack{
                            //navigation link to view recipes in full page view
//                            NavigationLink (destination: CookbookViewWithoutNavigation(), isActive: self.$viewAllRecipesSelected){
//                                EmptyView()
//                            }
                            //button to view all recipes
                            Button(action: {self.viewAllRecipesSelected = true}, label: {
                                Text("Recipes").font(.title).foregroundColor(Color(labelColor))
                                    .padding(.leading, 10)
                            })
                            Spacer()
                            NavigationLink (destination: AddRecipeView(), label: {
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .accentColor(.blue)
                                    .padding(.trailing, 25)
                            }).padding(8)
                        }
                        .background(Color(backGroundColor))
                        //List to show recipes:
                        List{
                            ForEach(self.$recipeSearchResults) { (recipeModel) in
                                RecipeRow(item: recipeModel)
                                    .listRowSeparator(.hidden)
                            }
                        }
                        .listStyle(.plain)
                        .frame(height: 610)
                        .onChange(of: searchText) { searchText in
                            if !searchText.isEmpty {
                                recipeSearchResults = recipes.filter { $0.name.contains(searchText) }
                            } else {
                                recipeSearchResults = recipes
                            }
                        }
                        //load data to array
                        .onAppear(perform: {
                            self.recipes = Recipe_DB().getRecipes()
                            self.recipeSearchResults = recipes
                        })
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                .navigationBarTitle(Text("My Kitchen"))
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {
                        print("Online recipes")
                    }, label: {
                        Image(systemName: "globe.americas")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .accentColor(.black)
                    })
                    
                    Spacer()
                    
                    NavigationLink (
                        destination: ShoppingListViewWithoutNavigation(shouldPopToRootView: self.$shoppingListViewIsActive),
                        isActive: self.$shoppingListViewIsActive,
                        label: {
                        ZStack(alignment: .topTrailing){
                            Image(systemName: "cart")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .accentColor(.black)
                            Image(systemName: "checklist")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .accentColor(.black)
                                .background(Color(.white))
                        }
                    })
                    .isDetailLink(false)
                    
                    Spacer()
                    
                    Button (action: {print("Do nothing, already home")}, label:
                                        {
                            Image(systemName: "house.circle.fill")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .accentColor(.black)
                        })
                    
                    Spacer()
                    
                    NavigationLink (destination: CookbookViewWithoutNavigation(shouldPopToRootView: self.$cookbookViewIsActive),
                                    isActive: self.$cookbookViewIsActive,
                                    label:
                                        {
                            Image(systemName: "menucard")
                                .resizable()
                                .frame(width: 20, height: 30)
                                .accentColor(.black)
                        })
                    .isDetailLink(false)
                    
                    Spacer()
                    
                    NavigationLink (destination: PantryViewWithoutNavigation(shouldPopToRootView: self.$pantryViewIsActive),
                                    isActive: self.$pantryViewIsActive,
                                    label:
                                        {
                            Image(systemName: "fork.knife")
                                .resizable()
                                .frame(width: 20, height: 30)
                                .accentColor(.black)
                        })
                    .isDetailLink(false)
                    
                    Spacer()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
