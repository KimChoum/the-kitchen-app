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
    //private var id: Expression<Int64>!
    
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
            //id = Expression<Int64>("id")
            //if if table already exists:
            if(!UserDefaults.standard.bool(forKey: "is_ingredient_db_created")){
                //case that table does not exist yet
                try db.run(ingredients.create { (t) in
                    t.column(name, primaryKey: true)
                    t.column(inStock)
                    //t.column(id, primaryKey: true)
                })
                //make is_db_created true so table is not created again
                UserDefaults.standard.set(true, forKey: "is_ingredient_db_created")
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
    
    
    public func getRecipeIngredients(ingredientsList: [String]) -> [Ingredient]{
        //empty array
        print("initializeing ingredients list that will be returned")
        var ingredientsListReturn: [Ingredient] = []
         
        //get ingredients in order of in stock
        //ingredients = ingredients.order(inStock.desc, name.asc)
        print("looping over ingredientsList given")
        for ingredientNameToGet in ingredientsList {
        
            do{
            print("about to try and query ingredients")
            for ingredientItem in try db.prepare(ingredients.filter(name == ingredientNameToGet)) {
                
                //create ingredient object for each loop iteration
                let ingredientReturn: Ingredient = Ingredient()
                //set values of ingredient object to that of querried ingredient
                ingredientReturn.name = ingredientItem[name]
                print(ingredientItem[name])
                ingredientReturn.inStock = ingredientItem[inStock]
                //append object to array
                ingredientsListReturn.append(ingredientReturn)
            }
            } catch{
                print(error.localizedDescription)
            }
        }
        return ingredientsListReturn
    }
    
    //function to delete an ingredient from the databse
    public func deleteIngredient(ingredient: Ingredient){
        do{
            let ingredientName = ingredient.name
            //get recipe using name
            let ingredient: Table = ingredients.filter(name == ingredientName)
            
            //delete recipe by running the delete query
            try db.run(ingredient.delete())
        } catch{
            print(error.localizedDescription)
        }
    }
    
    //return a single recipe
    public func getIngredient(nameValue: String) -> Ingredient{
        //initialize recipe obj
        let ingredientReturn: Ingredient = Ingredient()
        do{
            //loop through recipes
            for ingredient in try db.prepare(ingredients.where(name == nameValue)){
                //set recipe object values
                ingredientReturn.name = ingredient[name]
                ingredientReturn.inStock = ingredient[inStock]
            }
        }catch{
            print(error.localizedDescription)
        }
        return ingredientReturn
    }
    
    //function to update Ingredient
    public func updateIngredient(nameValue: String, inStockValue: Bool){
        do{
            //get ingredient
            let ingredient: Table = ingredients.filter(name == nameValue)
            
            try db.run(ingredient.update(inStock <- inStockValue))
        }catch{
            print(error.localizedDescription)
        }
    }
    
}
