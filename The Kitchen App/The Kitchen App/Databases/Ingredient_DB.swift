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
    private var id: Expression<String>!
    private var name: Expression<String>!
    private var inStock: Expression<Bool>!
    private var catagory: Expression<String>!
    
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
            id = Expression<String>("id")
            name = Expression<String>("name")
            inStock = Expression<Bool>("inStock")
            catagory = Expression<String>("catagory")
            //id = Expression<Int64>("id")
            //if if table already exists:
            if(!UserDefaults.standard.bool(forKey: "is_ingredient_db_created")){
                //case that table does not exist yet
                try db.run(ingredients.create { (t) in
                    t.column(id, primaryKey: true)
                    t.column(name)
                    t.column(inStock)
                    t.column(catagory)
                })
                //make is_db_created true so table is not created again
                UserDefaults.standard.set(true, forKey: "is_ingredient_db_created")
            }
        } catch{
            print(error.localizedDescription)
        }

    }
    
    public func addIngredient(idValue: String, nameValue: String, inStockValue: Bool, catagoryValue: String){
        
        do{
            try db.run(ingredients.insert(id <- idValue, name <- nameValue, inStock <- inStockValue, catagory <- catagoryValue))
        } catch{
            print(error.localizedDescription)
        }
    }
    
    
    //return array of ingredients
    public func getIngredients() -> [Ingredient] {
        
        //empty array
        var ingredientsList: [Ingredient] = []
         
        //get ingredients in order of in stock
        ingredients = ingredients.order(inStock.desc, catagory.asc, name.asc)
        
        do{
            
            //loop through
            for ingredient in try db.prepare(ingredients){
                
                //create ingredient object for each loop iteration
                let ingredientReturn: Ingredient = Ingredient()
                //set values of ingredient object to that of querried ingredient
                ingredientReturn.id = UUID(uuidString: ingredient[id])!
                ingredientReturn.name = ingredient[name]
                ingredientReturn.inStock = ingredient[inStock]
                ingredientReturn.catagory = ingredient[catagory]
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
    
    
    public func getRecipeIngredients(ingredientIDList: [String]) -> [Ingredient]{
        //empty array
        print("initializeing ingredients list that will be returned")
        var ingredientsListReturn: [Ingredient] = []
         
        //get ingredients in order of in stock
        //ingredients = ingredients.order(inStock.desc, name.asc)
        print("looping over ingredientsList given")
        for ingredientIDToGet in ingredientIDList {
        
            do{
            print("about to try and query ingredients")
            for ingredientItem in try db.prepare(ingredients.filter(id == ingredientIDToGet)) {
                
                //create ingredient object for each loop iteration
                let ingredientReturn: Ingredient = Ingredient()
                //set values of ingredient object to that of querried ingredient
                ingredientReturn.id = UUID(uuidString: ingredientItem[id])!
                ingredientReturn.name = ingredientItem[name]
                ingredientReturn.inStock = ingredientItem[inStock]
                ingredientReturn.catagory = ingredientItem[catagory]
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
    public func deleteIngredient(ingredientID: String){
        do{
            //get recipe using id
            let ingredient: Table = ingredients.filter(id == ingredientID)
            
            //delete recipe by running the delete query
            try db.run(ingredient.delete())
        } catch{
            print(error.localizedDescription)
        }
    }
    
    //return a single recipe
    public func getIngredient(idValue: String) -> Ingredient{
        //initialize recipe obj
        let ingredientReturn: Ingredient = Ingredient()
        do{
            //loop through recipes
            for ingredient in try db.prepare(ingredients.where(id == idValue)){
                //set recipe object values
                ingredientReturn.id = UUID(uuidString: ingredient[id])!
                ingredientReturn.name = ingredient[name]
                ingredientReturn.inStock = ingredient[inStock]
                ingredientReturn.catagory = ingredient[catagory]
            }
        }catch{
            print(error.localizedDescription)
        }
        return ingredientReturn
    }
    
    //function to update Ingredient
    public func updateIngredient(idValue: String, nameValue: String, inStockValue: Bool){
        do{
            //get ingredient
            let ingredient: Table = ingredients.filter(id == idValue)
            
            try db.run(ingredient.update(inStock <- inStockValue, name <- nameValue))
        }catch{
            print(error.localizedDescription)
        }
        print(inStockValue)
    }
    
    //function to get a shopping list
    public func getShoppingList(allIngredientIDs: Set<String>) -> [Ingredient]{
        var shoppingList: [Ingredient] = []
        do{
            for idValue in allIngredientIDs {
                for ingredient in try db.prepare(ingredients.where(id == idValue)){
                    let tempIngredient: Ingredient = Ingredient()
                    //set recipe object values
                    if(ingredient[inStock] == false){
                        tempIngredient.name = ingredient[name]
                        tempIngredient.inStock = ingredient[inStock]
                        tempIngredient.id = UUID(uuidString: ingredient[id])!
                        shoppingList.append(tempIngredient)
                    }
                }
            }
        }catch{
            print(error.localizedDescription)
        }
        return shoppingList
    }
    
}
