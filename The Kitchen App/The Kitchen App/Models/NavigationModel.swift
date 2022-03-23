//
//  NavigationModel.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 3/22/22.
//

import Foundation

class NavigationModel: ObservableObject {

    @Published var shoppingListView = false
    @Published var pantryView = false
    @Published var cookBookView = false

    func returnToViewHome() {
        shoppingListView = false
        pantryView = false
        cookBookView = false
    }
}
