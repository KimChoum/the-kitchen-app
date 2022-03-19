//
//  AddRecipeView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/25/22.
//


import SwiftUI

struct AddRecipeView: View {
    
    //Types of meals to choose from
    let mealTypes = ["Breakfast ", "Lunch", "Dinner", "Side", "Drink", "Other"]
    
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
        ZStack(alignment: .top){
                ZStack(alignment: .bottom) {
                    Image(uiImage: self.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.top)
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .background(Color.black.opacity(0.2))
                }
                .sheet(isPresented: $showSheet) {
                    // Pick an image from the photo library:
                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                }
                //create name entry field:
            ScrollView{
                ZStack(alignment: .topLeading){
                HStack{
                    Spacer()
                    Text("Change Cover")
                        .padding(5)
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
                .padding(.top, 100)
                VStack(alignment: .leading){
                    //select a catagory
                    Picker("Meal Type", selection: $mealType) {
                        ForEach(mealTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    Text("Recipe Name:")
                        .font(.title)
                    TextField("name", text: $name)
                        .padding()
                        .frame(width: 220, height: 50)
                        .disableAutocorrection(true)
                        .background(Color(.white))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .shadow(radius: 1)
                        .padding(.leading, 5)
                    Text("Instructions:")
                        .font(.title)
                    ZStack(alignment: .topLeading){
                        TextEditor(text: $instructions)
                            .frame(minWidth: 300, minHeight: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .padding(.horizontal, 5)
                        if instructions == "" {
                        Text("instructions")
                            .opacity(0.2)
                            .padding()
                        }
                    }
                    .shadow(radius: 1)
                    IngredientMultipleSelectView(recipeName: $name, recipeInstructions: $instructions, recipeImage: $image, recipeMealType: $mealType, ingredients: self.ingredients)
                }
                .background(Color(.systemGray6))
                .padding(.top, 150)
                }
            }
        }
        //.background(Color(.systemGray6))
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
