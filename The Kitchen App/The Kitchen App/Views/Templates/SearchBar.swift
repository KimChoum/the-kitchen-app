//
//  SearchBar.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 3/19/22.
//

import SwiftUI

struct SearchBar: View {
    @Binding var isShowing: Bool // determines visibility
    @Binding var searchText: String // the inputted search text
    @State var text: String = ""
    
    @State private var isEditing = false

    var body: some View {
        Group {
            // If the bar should be shown, render it, otherwise
            // use an EmptyView
            if isShowing {
                HStack {
                    TextField("Search...", text: $text)
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(HStack { // Add the search icon to the left
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)

                            // If the search field is focused, add the clear (X) button
                            if isEditing {
                                Button(action: {
                                    self.text = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }).padding(.horizontal, 10)
                        .onTapGesture {
                            self.isEditing = true
                        }
                }
            } else {
                EmptyView()
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    @State static var isShowing: Bool = true // determines visibility
    @State static var text: String = "" // the inputted search text
    static var previews: some View {
        SearchBar(isShowing: self.$isShowing, searchText: self.$text)
    }
}
