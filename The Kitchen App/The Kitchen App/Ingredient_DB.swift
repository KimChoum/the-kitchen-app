//
//  Ingredient_DB.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/20/22.
//

import Foundation
import SQLite
import SwiftUI


class Ingredient_DB{
    
    //SQLite instance:
    private var db: Connection!
    //Table instance
    private var ingredients: Table!
    //Table column instances:
    private var name: Expression<String>!
    private var inStock: Expression<Bool>!
    
    init(){
        
        //do for exception handling
        do{
            
            //path of document directory
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            print(path)
            //connect to database, creates database if no connection
            db = try Connection("\(path)/my_ingredients.sqlite3")
            
            //create table:
            ingredients = Table("ingredients")
            //initialize columns
            name = Expression<String>("name")
            inStock = Expression<Bool>("inStock")
            //if if table already exists:
            if(!UserDefaults.standard.bool(forKey: "is_db_created")){
                //case that table does not exist yet
                try db.run(ingredients.create { (t) in
                    t.column(name, primaryKey: true)
                    t.column(inStock)
                })
                //make is_db_created true so table is not created again
                UserDefaults.standard.set(true, forKey: "is_db_created")
            }
        } catch{
            print(error.localizedDescription)
        }

    }
    
    public func addIngredient(nameValue: String, inStockValue: Bool){
        
        do{
            try db.run(ingredients.insert(name <- nameValue, inStock <- inStockValue))
        } catch{
            print(error.localizedDescription)
        }
    }
    
    
    //return array of ingredients
    public func getIngredients() -> [Ingredient] {
        
        //empty array
        var ingredientsList: [Ingredient] = []
         
        //get ingredients in order of in stock
        ingredients = ingredients.order(inStock.desc, name.asc)
        
        do{
            
            //loop through
            for ingredient in try db.prepare(ingredients){
                
                //create ingredient object for each loop iteration
                let ingredientReturn: Ingredient = Ingredient()
                //set values of ingredient object to that of querried ingredient
                ingredientReturn.name = ingredient[name]
                ingredientReturn.inStock = ingredient[inStock]
                //append object to array
                ingredientsList.append(ingredientReturn)
            }
        } catch{
            print(error.localizedDescription)
        }
        return ingredientsList
    }
    
    public func numberOfIngredients() -> Int{
        var count: Int = 0
        do{
            count = try db.scalar(ingredients.filter(inStock == true).count)
            // SELECT count(*) FROM "users"
        } catch{
            print(error.localizedDescription)
        }
        return count
    }
    
}
