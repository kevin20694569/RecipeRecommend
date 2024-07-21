import UIKit

final class RecipeManager : MainServerAPIManager {

    static let shared : RecipeManager = RecipeManager()
    
    override var serverUrlPrefix: String {
        return super.serverUrlPrefix + "/recipe"
    }
    
    func getRecommendRecipes(user_id : String, preference : DishPreference) async throws -> (DishPreference,  [Recipe]) {
        guard let url = URL(string: "\(self.serverUrlPrefix)/recommend-recipes") else {
            throw APIError.BadRequestURL
        }
        
        var req = URLRequest(url: url)
        let ingredientsReqString = Ingredient.getRequestString(models: preference.ingredients)
        let equipmentsReqString = Equipment.getRequestString(models: preference.equipments)
        let cuisineReqString = Cuisine.getRequestString(models: preference.cuisine)

        let params : [String : Any?] = [
            "user_id" : preference.user_id,
            "ingredients" :ingredientsReqString,
            "equipments" :equipmentsReqString,
            "cuisine" :cuisineReqString,
            "complexity" :preference.complexity,
            "timelimit" :preference.timeLimit,
            "temperature" :preference.temperature,
            "addictionalText" :preference.addictionalText,
        ]

        let body = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        req.httpBody = body
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        
        let (data, _) = try await URLSession.shared.data(for: req)
        let decoder = JSONDecoder()
        let result =  try decoder.decode(GenerateRecipesJson.self, from: data)
        
        guard let preJson = result.preference,
              let recJsons = result.recipes else {
            throw APIError.BadRequestURL
        }
        guard let preference = DishPreference(json:  preJson),
              let recipes = result.recipes?.compactMap({ json in
                  return Recipe(json: json)
              }) else {
            throw APIError.BadRequestURL
        }

        return (preference, recipes)
    }
    
    func getRecipesByPreferencID(preference_id : String) async throws -> [Recipe] {
        guard let url = URL(string: "\(self.serverUrlPrefix)?preference_id=\(preference_id)") else {
            throw APIError.BadRequestURL
        }
        
        let req = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: req)
        let decoder = JSONDecoder()
        let results =  try decoder.decode([RecipeJson].self, from: data)
        let recipes = results.compactMap { json in
            return Recipe(json: json)
        }
        return recipes
        
    }
    
    func getLikedRecipesByDateThresold(dateThresold : String) async throws -> [Recipe] {
        guard let url = URL(string: "\(self.serverUrlPrefix)/like?user_id=\(user_id)&dateThrehsold=\(dateThresold)") else {
            throw APIError.BadRequestURL
        }
        
        let req = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: req)
        let decoder = JSONDecoder()
        let result =  try decoder.decode(RecipesResJson.self, from: data)
        guard let recipesJson = result.recipes else {
            throw APIError.BadRequestURL
        }
        let recipes = recipesJson.compactMap { json in
            return Recipe(json: json)
        }
        return recipes
    }
    
    /*func getDishesOrderByCreatedTime(user_id : String, beforeTime : String) async throws -> [Recipe] {
        
        guard let url = URL(string: "\(self.serverUrlPrefix)/dishes/byuserid/\(user_id)?date=\(beforeTime)") else {
            throw APIError.BadRequestURL
        }
        let req = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: req)
        let decoder = JSONDecoder()
        let dishesJson =  try decoder.decode([RecipeJson].self, from: data)

        let dishes = dishesJson.compactMap { json in
            return Recipe(json: json)
        }

        return dishes
    }*/

    /*func generateNewDishes(preference : DishPreference, excluded_foods : [String]?) async throws -> [Recipe] {
        
        guard let url = URL(string: "\(self.serverUrlPrefix)/remote/generatedishes") else {
            throw APIError.BadRequestURL
        }
        
        var req = URLRequest(url: url)
        let ingredientsReqString = Ingredient.getRequestString(models: preference.ingredients)
        let equipmentsReqString = Equipment.getRequestString(models: preference.equipments)
        let cuisineReqString = Cuisine.getRequestString(models: preference.cuisine)
        let params : [String : Any?] = [
            "user_id" : preference.user_id,
            "ingredients" : ingredientsReqString,
            "quantity" : String(preference.quantity) + "位",
            "equipments" : equipmentsReqString,
            "excluded_foods" : excluded_foods,
            "cuisine" : cuisineReqString,
            "complexity" : preference.complexity.description,
            "timelimit" : preference.timeLimit,
            "limit" : preference.countLimit,
            "temperature" : preference.temperature,
            "addictionalText" : preference.    addictionalText,
            "reference_in_history" : preference.referenced_in_history
        ]

        let body = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        req.httpBody = body
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        
        let (data, _) = try await URLSession.shared.data(for: req)
        let decoder = JSONDecoder()
        let result =  try decoder.decode(RecipesJsonResponse.self, from: data)
        let dishes = result.dishes.compactMap { json in
            return Recipe(json: json)
        }
        return dishes
    }
    
    func generateDishDetail(dish_id : String, quantity : Int) async throws -> Recipe {
        guard let url = URL(string: "\(self.serverUrlPrefix)/remote/generateddishdetail") else {
            throw APIError.BadRequestURL
        }
        
        let params : [String : Any?] = [
            "dish_id" : dish_id,
            "user_id" : self.user_id,
            "quantity" : quantity,
            "maxsteps" : 12
        ]
        var req = URLRequest(url: url)
        
        let body = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        req.httpBody = body
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        let (data, _) = try await URLSession.shared.data(for: req)
       
        let decoder = JSONDecoder()
        let result = try decoder.decode(RecipesJsonResponse.self, from: data)
        if let json = result.dishes.first {
            if let recipe = Recipe(json: json) {
                return recipe
            }
        }
        
        throw DishError.RespondError
        

       
    }*/
    
    func markAsLiked(recipe_id : String, like : Bool) async throws {
        guard let url = URL(string: "\(self.serverUrlPrefix)/like") else {
            throw APIError.BadRequestURL
        }
        
        var req = URLRequest(url: url)

        let params : [String : Any?] = [
            "user_id" : user_id,
            "recipe_id" : recipe_id,
            "like" : like
        ]

        let body = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        req.httpBody = body
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        
        let (data, response) = try await URLSession.shared.data(for: req)
        guard let httpRes = response as? HTTPURLResponse else {
            throw APIError.BadRequestURL
        }
        if  200...299  ~= httpRes.statusCode {
            throw APIError.BadRequestURL
        }
    }
    
}

struct GenerateRecipesJson : Decodable {
    var preference : DishPreferenceJson?
    var recipes : [RecipeJson]?
    
    enum CodingKeys: String, CodingKey {
        case preference = "preference"
        case recipes = "recipes"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.preference = try? container.decodeIfPresent(DishPreferenceJson.self, forKey: .preference)
        self.recipes = try? container.decode([RecipeJson].self, forKey: .recipes)
    }
}

struct RecipesResJson : Decodable {
    var recipes : [RecipeJson]?
    
    enum CodingKeys: String, CodingKey {
        
        case recipes = "recipes"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.recipes = try? container.decode([RecipeJson].self, forKey: .recipes)
    }
}

