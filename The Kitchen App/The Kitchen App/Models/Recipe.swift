//
//  Ingredient.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/20/22.
//

import Foundation
import UIKit

class Recipe: Identifiable{
    public var name: String = ""
    public var instructions: String = ""
    public var ingredients: [Ingredient] = []
    public var id = UUID()
    public var onShoppingList: Bool = false
    public var image: UIImage = UIImage(systemName: "photo")!
}
