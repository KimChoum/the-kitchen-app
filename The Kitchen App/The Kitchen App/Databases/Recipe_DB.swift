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
    private var id: Expression<String>!
    private var mealType: Expression<String>!
    private var link: Expression<String>!
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
            id = Expression<String>("id")
            name = Expression<String>("name")
            instructions = Expression<String>("instructions")
            onShoppingList = Expression<Bool>("onShoppingList")
            mealType = Expression<String>("mealType")
            link = Expression<String>("link")
            //if if table already exists:
            if(!UserDefaults.standard.bool(forKey: "is_recipe_db_created")){
                //case that table does not exist yet
                try db.run(recipes.create { (t) in
                    t.column(id, primaryKey: true)
                    t.column(name)
                    t.column(instructions)
                    t.column(onShoppingList)
                    t.column(mealType)
                    t.column(link)
                })
                //make is_db_created true so table is not created again
                UserDefaults.standard.set(true, forKey: "is_recipe_db_created")
            }
        } catch{
            print(error.localizedDescription)
        }

    }
    
    //Add recipe to database
    public func addRecipe(recipeIDValue: String, nameValue: String, instructionsValue: String, mealTypeValue: String, recipeLinkValue: String){
        
        do{
            try db.run(recipes.insert(id <- recipeIDValue, name <- nameValue, instructions <- instructionsValue, onShoppingList <- false, mealType <- mealTypeValue, link <- recipeLinkValue))
        } catch{
            print(error.localizedDescription)
        }
    }
    
    //update recipe in database
    public func updateRecipe(recipeIDValue: String, nameValue: String, instructionsValue: String, mealTypeValue: String, recipeLinkValue: String){
        do{
            let recipe: Table = recipes.filter(id == recipeIDValue)
            
            try db.run(recipe.update(id <- recipeIDValue, name <- nameValue, instructions <- instructionsValue, onShoppingList <- false, mealType <- mealTypeValue, link <- recipeLinkValue))
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
                recipeReturn.id = UUID(uuidString: recipe[id])!
                recipeReturn.mealType = recipe[mealType]
                recipeReturn.link = recipe[link]
                //append object to array
                recipesList.append(recipeReturn)
            }
        } catch{
            print(error.localizedDescription)
        }
        return recipesList
    }
    
    //return a single recipe
    public func getRecipe(recipeIDValue: String) -> Recipe{
        //initialize recipe obj
        let recipeReturn: Recipe = Recipe()
        do{
            //loop through recipes
            for recipe in try db.prepare(recipes.where(id == recipeIDValue)){
                //set recipe object values
                recipeReturn.name = recipe[name]
                recipeReturn.instructions = recipe[instructions]
                recipeReturn.onShoppingList = recipe[onShoppingList]
                recipeReturn.id = UUID(uuidString: recipeIDValue)!
                recipeReturn.mealType = recipe[mealType]
                recipeReturn.link = recipe[link]
            }
        }catch{
            print(error.localizedDescription)
        }
        return recipeReturn
    }
    
    //Function to delete a recipe from the databse
    public func deleteRecipe(recipeIDValue: String){
        do{
            //get recipe using name
            let recipe: Table = recipes.filter(id == recipeIDValue)
            
            //delete recipe by running the delete query
            try db.run(recipe.delete())
        } catch{
            print(error.localizedDescription)
        }
    }
    
    //Function to change value of onShoppingList for a recipe
    public func updateOnShoppingList(recipeIDValue: String, onShoppingListValue: Bool){
        do{
            //get ingredient
            let recipe: Table = recipes.filter(id == recipeIDValue)
            
            try db.run(recipe.update(onShoppingList <- onShoppingListValue))
        }catch{
            print(error.localizedDescription)
        }
    }
    
    //Function to return the ids of all recipes that currently have onShoppingList = true
    public func getRecipesOnShoppingList() -> [Recipe]{
        var listOfRecipes: [Recipe] = []
        let recipeToAdd: Recipe = Recipe()
        do{
            //loop through recipes
            for recipe in try db.prepare(recipes.where(onShoppingList == true)){
                //set recipe object values
                recipeToAdd.id = UUID(uuidString: recipe[id])!
                listOfRecipes.append(recipeToAdd)
            }
        }catch{
            print(error.localizedDescription)
        }
        return listOfRecipes
    }
    
    //get recipes from list of recipe IDs
    public func getRecipesFromIDs(recipeIDS: [String]) -> [Recipe]{
        var listOfRecipes: [Recipe] = []
        let recipeReturn: Recipe = Recipe()
        
        for recipeId in recipeIDS {
            do{
                for recipe in try db.prepare(recipes.where(id == recipeId)){
                    recipeReturn.name = recipe[name]
                    recipeReturn.instructions = recipe[instructions]
                    recipeReturn.onShoppingList = recipe[onShoppingList]
                    recipeReturn.id = UUID(uuidString: recipeId)!
                    recipeReturn.mealType = recipe[mealType]
                    recipeReturn.link = recipe[link]
                    listOfRecipes.append(recipeReturn)
                }
            }catch{
                print(error.localizedDescription)
            }
        }
        return listOfRecipes
    }
    
}
