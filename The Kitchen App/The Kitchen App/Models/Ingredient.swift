//
//  Ingredient.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/20/22.
//

import Foundation

class Ingredient: Identifiable, Hashable{
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        if (lhs.id == rhs.id) {return true}
        else {return false}
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var id = UUID()
    public var name: String = ""
    public var inStock: Bool = false
    public var catagory: String = ""
    public var keepInStock: Bool = false
}
