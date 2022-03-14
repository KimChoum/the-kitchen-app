//
//  AddRecipeView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/25/22.
//


import SwiftUI

struct AddRecipeView: View {
    
    //vars to hold user input:
    @State var name: String = ""
    @State var instructions: String = ""
    @State var ingredients: [Ingredient] = []
    @State var newRecipe: Recipe = Recipe()
    
    //image vars
    @State private var image = UIImage()
    @State private var showSheet = false
    
    //go back to homescreen after ingredient is added
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            HStack {
                Image(uiImage: self.image)
                    .resizable()
                    .cornerRadius(50)
                    .frame(width: 100, height: 100)
                    .background(Color.black.opacity(0.2))
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                
                Text("Change photo")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.262745098, green: 0.0862745098, blue: 0.8588235294, alpha: 1)), Color(#colorLiteral(red: 0.5647058824, green: 0.462745098, blue: 0.9058823529, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(16)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .onTapGesture {
                        showSheet = true
                    }
            }
            .padding(.horizontal, 20)
            .sheet(isPresented: $showSheet) {
                // Pick an image from the photo library:
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            }
            //create name entry field:
            List{
                Text("Enter Recipe Name:")
                    .font(.title)
                ZStack{
                    TextField("name", text: $name)
                        .padding(10)
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                        .background(Color(.white))
                }
                .shadow(radius: 1)
                Text("Enter Instructions:")
                    .font(.title)
                ZStack{
                    TextEditor(text: $instructions)
                    Text(instructions)
                        .opacity(0)
                        .padding(.all, 8)
                }
                .shadow(radius: 1)
                
            }
            IngredientMultipleSelectView(recipeName: $name, recipeInstructions: $instructions, recipeImage: $image, ingredients: self.ingredients)
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
