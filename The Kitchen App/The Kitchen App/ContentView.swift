//
//  ContentView.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/16/22.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationView{
            VStack{
                NavigationLink (destination: CookbookView(), label: {Text("Recipes")})
                NavigationLink (destination: PantryView(), label: { Text("Ingredients")})
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
