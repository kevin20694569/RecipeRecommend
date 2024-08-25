import UIKit

final class RecipeManager : MainServerAPIManager {

    static let shared : RecipeManager = RecipeManager()
    
    override var serverResourcePrefix: String {
        return super.serverResourcePrefix + "/recipe"
    }
    
    func getRecommendRecipes(user_id : String, preference : GenerateRecipePreference) async throws -> (GenerateRecipePreference,  [Recipe]) {
        guard let url = URL(string: "\(self.serverResourcePrefix)/recommend-recipes") else {
            throw APIError.BadRequestURL
        }
        var req = URLRequest(url: url)
        try self.insertJwtTokenToHeadersDefault(req: &req)
        let ingredientsReqString = Ingredient.getRequestString(models: preference.ingredients)
        let equipmentsReqString = Equipment.getRequestString(models: preference.equipments)
        let cuisineReqString = Cuisine.getRequestString(models: preference.cuisine)

        let params : [String : Codable?] = [
            "user_id" : preference.user_id,
            "ingredients" : ingredientsReqString,
            "equipments" : equipmentsReqString,
            "cuisine" : cuisineReqString,
            "complexity" : preference.complexity.description,
            "timelimit" : preference.timeLimit,
            "temperature" : preference.temperature,
            "addictionalText" : preference.addictionalText,
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
        guard let preference = GenerateRecipePreference(json:  preJson),
              let recipes = result.recipes?.compactMap({ json in
                  return Recipe(json: json)
              }) else {
            throw APIError.BadRequestURL
        }

        return (preference, recipes)
    }
    
    func getRecipesByPreferencID(preference_id : String) async throws -> [Recipe] {
        guard let url = URL(string: "\(self.serverResourcePrefix)?preference_id=\(preference_id)") else {
            throw APIError.BadRequestURL
        }
        var req = URLRequest(url: url)
        try self.insertJwtTokenToHeadersDefault(req: &req)
        let (data, _) = try await URLSession.shared.data(for: req)
        let decoder = JSONDecoder()
        let results =  try decoder.decode([RecipeJson].self, from: data)
        let recipes = results.compactMap { json in
            return Recipe(json: json)
        }
        return recipes
        
    }
    
    func getLikedRecipesByDateThresold(dateThresold : String) async throws -> [Recipe] {
        guard let url = URL(string: "\(self.serverResourcePrefix)/like?user_id=\(user_id)&dateThreshold=\(dateThresold)") else {
            throw APIError.BadRequestURL
        }
        var req = URLRequest(url: url)
        try self.insertJwtTokenToHeadersDefault(req: &req)
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
    
    func getHistoryBrowsedRecipesByDateThresold(dateThresold : String) async throws -> [Recipe] {
        guard let url = URL(string: "\(self.serverResourcePrefix)/browse?user_id=\(self.user_id)&dateThreshold=\(dateThresold)") else {
            throw APIError.BadRequestURL
        }
        var req = URLRequest(url: url)
        try self.insertJwtTokenToHeadersDefault(req: &req)
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
    
    func markRecipeBrowsed(recipe_id : String) async throws {
        guard let url = URL(string: "\(self.serverResourcePrefix)/browse") else {
            throw APIError.BadRequestURL
        }
        var req = URLRequest(url: url)
        try self.insertJwtTokenToHeadersDefault(req: &req)

        let params : [String : Codable?] = [
            "user_id" : self.user_id,
            "recipe_id" : recipe_id
        ]

        let body = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        req.httpBody = body
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        
        let (_, res) = try await URLSession.shared.data(for: req)
        let httpRes = res as! HTTPURLResponse
        if 200...299  ~= httpRes.statusCode {
            return
        } else {
            throw APIError.BadRequestURL
        }
    }
    
    func searchRecipesInLikedByQuery(query : String, excluded_recipe_ids : [String]? = nil) async throws -> [Recipe] {
        
        guard let url = URL(string: "\(self.serverResourcePrefix)/search") else {
            throw APIError.BadRequestURL
        }
        var req = URLRequest(url: url)
        try self.insertJwtTokenToHeadersDefault(req: &req)
        
        let params : [String : Codable?] = [
            "query" : query,
            "user_id" : self.user_id,
            "excluded_recipe_ids" : excluded_recipe_ids
        ]

        let body = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        req.httpBody = body
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.method = .post
        
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
    
    
    
    func searchRecipesByQuery(query : String, excluded_recipe_ids : [String]? = nil) async throws -> [Recipe] {
        
        guard let url = URL(string: "\(self.serverResourcePrefix)/search/like") else {
            throw APIError.BadRequestURL
        }
        var req = URLRequest(url: url)
        try self.insertJwtTokenToHeadersDefault(req: &req)
        let params : [String : Codable?] = [
            "query" : query,
            "user_id" : self.user_id,
            "excluded_recipe_ids" : excluded_recipe_ids
        ]

        let body = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        req.httpBody = body
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.method = .post
        
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
    
    
    func markAsLiked(recipe_id : String, like : Bool) async throws {
        guard let url = URL(string: "\(self.serverResourcePrefix)/like") else {
            throw APIError.BadRequestURL
        }
        var req = URLRequest(url: url)
        try self.insertJwtTokenToHeadersDefault(req: &req)
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

        if 200...299  ~= httpRes.statusCode {
            return
        } else {
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

