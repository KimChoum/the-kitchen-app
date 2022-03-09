//
//  Recipe_DB.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 2/23/22.
//

import Foundation
import SQLite
import SwiftUI


class Recipe_DB{
    
    //SQLite instance:
    private var db: Connection!
    //Table instance
    private var recipes: Table!
    //Table column instances:
    private var name: Expression<String>!
    private var instructions: Expression<String>!
    private var onShoppingList: Expression<Bool>!
    //private var ingredients: Expression<[Ingredient]>!
    
    init(){
        
        //do for exception handling
        do{
            
            //path of document directory
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            print(path)
            //connect to database, creates database if no connection
            db = try Connection("\(path)/my_recipes.sqlite3")
            //create table:
            recipes = Table("recipes")
            //initialize columns
            name = Expression<String>("name")
            instructions = Expression<String>("instructions")
            onShoppingList = Expression<Bool>("onShoppingList")
            //if if table already exists:
            if(!UserDefaults.standard.bool(forKey: "is_recipe_db_created")){
                //case that table does not exist yet
                try db.run(recipes.create { (t) in
                    t.column(name, primaryKey: true)
                    t.column(instructions)
                    t.column(onShoppingList)
                })
                //make is_db_created true so table is not created again
                UserDefaults.standard.set(true, forKey: "is_recipe_db_created")
            }
        } catch{
            print(error.localizedDescription)
        }

    }
    
    //Add recipe to database
    public func addRecipe(nameValue: String, instructionsValue: String){
        
        do{
            print("adding recipe to database")
            print("name")
            print(nameValue)
            try db.run(recipes.insert(name <- nameValue, instructions <- instructionsValue, onShoppingList <- false))
        } catch{
            print(error.localizedDescription)
        }
    }
    
    
    //return array of recipes
    public func getRecipes() -> [Recipe] {
        
        //empty array
        var recipesList: [Recipe] = []
         
        //get recipes in alphabetical order
        recipes = recipes.order(name.asc)
        
        do{
            
            //loop through
            for recipe in try db.prepare(recipes){
                
                //create ingredient object for each loop iteration
                let recipeReturn: Recipe = Recipe()
                //set values of ingredient object to that of querried ingredient
                recipeReturn.name = recipe[name]
                recipeReturn.instructions = recipe[instructions]
                recipeReturn.onShoppingList = recipe[onShoppingList]
                //append object to array
                recipesList.append(recipeReturn)
            }
        } catch{
            print(error.localizedDescription)
        }
        return recipesList
    }
    
    //return a single recipe
    public func getRecipe(nameValue: String) -> Recipe{
        //initialize recipe obj
        let recipeReturn: Recipe = Recipe()
        do{
            //loop through recipes
            for recipe in try db.prepare(recipes.where(name == nameValue)){
                //set recipe object values
                recipeReturn.name = recipe[name]
                recipeReturn.instructions = recipe[instructions]
                recipeReturn.onShoppingList = recipe[onShoppingList]
            }
        }catch{
            print(error.localizedDescription)
        }
        return recipeReturn
    }
    
    //Function to delete a recipe from the databse
    public func deleteRecipe(recipeName: String){
        do{
            //get recipe using name
            let recipe: Table = recipes.filter(name == recipeName)
            
            //delete recipe by running the delete query
            try db.run(recipe.delete())
        } catch{
            print(error.localizedDescription)
        }
    }
    
    //Function to change value of onShoppingList for a recipe
    public func updateOnShoppingList(nameValue: String, onShoppingListValue: Bool){
        do{
            //get ingredient
            let recipe: Table = recipes.filter(name == nameValue)
            
            try db.run(recipe.update(onShoppingList <- onShoppingListValue))
        }catch{
            print(error.localizedDescription)
        }
    }
    
    //Function to return the names of all recipes that currently have onShoppingList = true
    public func getRecipesOnShoppingList() -> [Recipe]{
        var listOfRecipes: [Recipe] = []
        var recipeToAdd: Recipe = Recipe()
        do{
            //loop through recipes
            for recipe in try db.prepare(recipes.where(onShoppingList == true)){
                //set recipe object values
                recipeToAdd.name = recipe[name]
                listOfRecipes.append(recipeToAdd)
            }
        }catch{
            print(error.localizedDescription)
        }
        return listOfRecipes
    }
    
    //function to return number of recipes in database you can currently make
    public func getRecipesCanMake(){
        //TODO
    }
    
}
