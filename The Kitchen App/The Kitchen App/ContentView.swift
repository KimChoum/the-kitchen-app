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
                NavigationLink (destination: PantryView(), label: { Text("Pantry")
                })
            }
        }
        /*
        VStack {
            Text("Pantry")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            Divider()
            Text("Ingredients:")
        }
    */
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
