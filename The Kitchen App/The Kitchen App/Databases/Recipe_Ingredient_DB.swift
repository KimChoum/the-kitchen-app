//
//  Recipe_Ingredient_DB.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/25/22.
//

import Foundation
import SQLite
import SwiftUI

//Database to handle recipe to ingredient relationship
class Recipe_Ingredient_DB{
    
    //SQLite instance:
    private var db: Connection!
    //Table instance
    private var recipe_ingredient: Table!
    //Table column instances:
    private var recipeID: Expression<String>!
    private var ingredientID: Expression<String>!
    
    init(){
        
        //do for exception handling
        do{
            
            //path of document directory
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            print(path)
            //connect to database, creates database if no connection
            db = try Connection("\(path)/recipe_ingredient.sqlite3")
            
            //create table:
            recipe_ingredient = Table("recipes")
            //initialize columns
            recipeID = Expression<String>("recipeID")
            ingredientID = Expression<String>("ingredientID")
            //if if table already exists:
            if(!UserDefaults.standard.bool(forKey: "is_recipe_ingredient_db_created")){
                //case that table does not exist yet
                try db.run(recipe_ingredient.create { (t) in
                    t.column(recipeID)
                    t.column(ingredientID)
                })
                //make is_db_created true so table is not created again
                UserDefaults.standard.set(true, forKey: "is_recipe_ingredient_db_created")
            }
        } catch{
            print(error.localizedDescription)
        }

    }
    
    //Add a recipe to ingredient relationship into database
    public func recipeToIngredient(recipeIDValue: String, ingredientIDValue: String){
        
        do{
            try db.run(recipe_ingredient.insert(recipeID <- recipeIDValue, ingredientID <- ingredientIDValue))
        } catch{
            print(error.localizedDescription)
        }
    }
    
    //Return a list of ingredient ids for a given recipe
    public func getIngredientIDsList(recipeIDValue: String) -> [String]{
        //empty array
        var ingredientsList: [String] = []
        
        do{
            
            //loop through
            for recipe_ingredient_item in try db.prepare(recipe_ingredient.where(recipeID == recipeIDValue)){
                //append object to array
                ingredientsList.append(recipe_ingredient_item[ingredientID])
            }
        } catch{
            print(error.localizedDescription)
        }
        print("added ingredients to list and returning to ingredient DB")
        return ingredientsList
    }
    
    //Returns a list of ingredient ids needed for a given list of recipes
    public func getAllIngredientIDsNeeded(recipesList: [Recipe]) -> Set<String>{
        var ingredientsList = Set<String>()
        
        do{
            for recipeItem in recipesList{
                //loop through
                for recipe_ingredient_item in try db.prepare(recipe_ingredient.where(recipeID == recipeItem.id.uuidString)){
                    //append object to array
                    ingredientsList.insert(recipe_ingredient_item[ingredientID])
                }
            }
        }catch{
            print(error.localizedDescription)
        }
        return ingredientsList
    }
    
    
    
    //function to delete all recipe->ingredient relations for a given RECIPE
    public func deleteRecipe(recipeIDValue: String){
        do{
            //for recipe_ingredient_row in try db.prepare(recipe_ingredient.where(recipeName == recipeNameValue)) {
            let recipe_ingredient_table: Table = recipe_ingredient.filter(recipeID == recipeIDValue)
            try db.run(recipe_ingredient_table.delete())
        }catch{
            print(error.localizedDescription)
        }
    }
    
    //function to delete all recipe->ingredient relations for a given INGREDIENT
    public func deleteIngredient(ingredient: Ingredient){
        do{
            let ingredientIDValue = ingredient.id.uuidString
            let recipe_ingredient_table: Table = recipe_ingredient.filter(ingredientID == ingredientIDValue)
            try db.run(recipe_ingredient_table.delete())
        }catch{
            print(error.localizedDescription)
        }
    }
}
