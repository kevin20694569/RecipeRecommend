import UIKit

final class RecipeManager : MainServerAPIManager {
    
    static let shared : RecipeManager = RecipeManager()
    
    override var serverResourcePrefix: String {
        return super.serverResourcePrefix + "/recipe"
    }
    
    func getRecommendRecipes(user_id : String, preference : RecommendRecipePreference) async throws -> (RecommendRecipePreference,  [Recipe]) {
        guard let url = URL(string: "\(self.serverResourcePrefix)/recommend-recipes") else {
            throw APIError.BadRequestURL
        }
        var req = URLRequest(url: url)
        try self.insertJwtTokenToHeadersDefault(req: &req)
        let ingredientsReqString = Ingredient.getRequestString(models: preference.ingredients)
        
        let params : [String : Codable?] = [
            "user_id" : preference.user_id,
            "ingredients" : ingredientsReqString,
        ]
        
        let body = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        req.httpBody = body
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        
        let (data, _) = try await URLSession.shared.data(for: req)
        let decoder = JSONDecoder()
        let result =  try decoder.decode(RecommendRecipesJson.self, from: data)
        
        guard let preJson = result.preference,
              let recJsons = result.recipes else {
            throw APIError.BadRequestURL
        }
        guard let preference = RecommendRecipePreference(json:  preJson),
              let recipes = result.recipes?.compactMap({ json in
                  return Recipe(json: json)
              }) else {
            throw APIError.BadRequestURL
        }
        
        return (preference, recipes)
    }
    
    func generateRecipe(user_id : String, preference : GenerateRecipePreference) async throws -> (GenerateRecipePreference,  Recipe) {
        guard let url = URL(string: "\(self.serverResourcePrefix)/generate-recipe") else {
            throw APIError.BadRequestURL
        }
        
        var req = URLRequest(url: url)
        try self.insertJwtTokenToHeadersDefault(req: &req)
        let ingredients = preference.ingredients.compactMap { element in
            return element.name
        }
        let equipments = preference.equipments.compactMap { element in
            return element.name
        }
        let cuisines = preference.cuisine.compactMap { element in
            return element.name
        }
        let params : [String : Codable?] = [
            "reference_recipe_id" : preference.reference_recipe_id,
            "user_id" : preference.user_id,
            "ingredients" : ingredients,
            "equipments" : equipments,
            "cuisines" : cuisines,
            "temperature" : preference.temperature,
            "additionalText" : preference.additionalText,
        ]
        
        let body = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        req.httpBody = body
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        
        let (data, _) = try await URLSession.shared.data(for: req)
        let decoder = JSONDecoder()
        let result =  try decoder.decode(GenerateRecipeJson.self, from: data)
        
        guard let preJson = result.preference,
              let recJson = result.recipe else {
            throw APIError.BadRequestURL
        }
        guard let preference = GenerateRecipePreference(json: preJson )
        else {
            
            throw APIError.BadRequestURL
        }
        let recipe = Recipe(json: recJson)
        
        return (preference, recipe)
    }
    
    func getRecipesByPreferencID(preference_id : String) async throws -> [Recipe] {
        guard let url = URL(string: "\(self.serverResourcePrefix)/by-preference/\(preference_id)?user_id=\(self.user_id)") else {
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
    
    func getHistoryBrowsedRecipesByDateThresold(user_id : String, dateThresold : String) async throws -> [Recipe] {
        guard let url = URL(string: "\(self.serverResourcePrefix)/browse?user_id=\(user_id)&dateThreshold=\(dateThresold)") else {
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
    
    func getHistoryGeneratedRecipesByDateThreshold(user_id : String, dateThreshold : String) async throws -> [Recipe] {
        guard let url =  URL(string: "\(self.serverResourcePrefix)/generated/user?user_id=\(user_id)&dateThreshold=\(dateThreshold)") else {
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
    
    
    func getGeneratedRecipesByReferenceRecipeID(reference_recipe_id : String, user_id : String, dateThreshold : String? = nil) async throws -> [Recipe] {
        guard let url =  URL(string: "\(self.serverResourcePrefix)/generated/reference-recipe?user_id=\(user_id)&reference_recipe_id=\(reference_recipe_id)&dateThreshold=\(dateThreshold ?? "")") else {
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
    
    func getRecipeByRecipeID(recipe_id : String) async throws -> Recipe {
        guard let url =  URL(string: "\(self.serverResourcePrefix)/\(recipe_id)?user_id=\(self.user_id)") else {
            throw APIError.BadRequestURL
        }
        var req = URLRequest(url: url)
        try self.insertJwtTokenToHeadersDefault(req: &req)
        let (data, _) = try await URLSession.shared.data(for: req)
        let decoder = JSONDecoder()
        let json =  try decoder.decode(RecipeJson.self, from: data)
        return Recipe(json: json)
    }
    
}

struct RecommendRecipesJson : Decodable {
    var preference : RecommendPreferenceJson?
    var recipes : [RecipeJson]?
    
    enum CodingKeys: String, CodingKey {
        case preference = "preference"
        case recipes = "recipes"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.preference = try? container.decodeIfPresent(RecommendPreferenceJson.self, forKey: .preference)
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

struct GenerateRecipeJson : Decodable {
    var preference : GeneratePreferenceJson?
    var recipe : RecipeJson?
    
    enum CodingKeys: String, CodingKey {
        case generated_preference = "generated_preference"
        case recipe = "recipe"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.preference = try? container.decodeIfPresent(GeneratePreferenceJson.self, forKey: .generated_preference)
        self.recipe = try? container.decode(RecipeJson.self, forKey: .recipe)
    }
}

