//
//  Ingredient.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/20/22.
//

import Foundation

class Ingredient: Identifiable{
    public var id = UUID()
    public var name: String = ""
    public var inStock: Bool = false
}
