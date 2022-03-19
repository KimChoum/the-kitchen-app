//
//  AddRecipeView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/25/22.
//


import SwiftUI

struct AddRecipeView: View {
    
    //Types of meals to choose from
    let mealTypes = ["Breakfast ", "Lunch", "Dinner", "Snack", "Drink", "Other"]
    
    //vars to hold user input:
    @State var name: String = ""
    @State var instructions: String = ""
    @State var ingredients: [Ingredient] = []
    @State var newRecipe: Recipe = Recipe()
    @State var mealType: String = ""
    
    //image vars
    @State private var image = UIImage()
    @State private var showSheet = false
    
    //go back to homescreen after ingredient is added
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView{
            VStack{
                ZStack(alignment: .bottom) {
                    Image(uiImage: self.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.top)
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .background(Color.black.opacity(0.2))
                    HStack{
                        Spacer()
                        Text("Change Cover")
                            .font(.body)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.262745098, green: 0.0862745098, blue: 0.8588235294, alpha: 1)), Color(#colorLiteral(red: 0.5647058824, green: 0.462745098, blue: 0.9058823529, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(5)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .onTapGesture {
                                showSheet = true
                            }
                            .padding()
                    }
                }
                .sheet(isPresented: $showSheet) {
                    // Pick an image from the photo library:
                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                }
                //create name entry field:
                List{
                    Text("Recipe Name:")
                        .font(.title)
                    TextField("name", text: $name)
                        .padding(10)
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                        .background(Color(.white))
                    //select a catagory
                    Picker("Meal Type", selection: $mealType) {
                        ForEach(mealTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.automatic)
                    Text("Instructions:")
                        .font(.title)
                    ZStack{
                        TextEditor(text: $instructions)
                        Text(instructions)
                            .opacity(0)
                            .padding(.all, 8)
                    }
                    .shadow(radius: 1)
                    
                }
                IngredientMultipleSelectView(recipeName: $name, recipeInstructions: $instructions, recipeImage: $image, recipeMealType: $mealType, ingredients: self.ingredients)
                    //.frame(height: 300)
                //padding()
            }
            .frame(height: 650)
        }
        .background(Color(.systemGray6))
        .onAppear(perform: {
            self.ingredients = Ingredient_DB().getIngredients()
        })
    }
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView()
    }
}
