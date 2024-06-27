import UIKit

final class DishManager : MainServerAPIManager {

    static let shared : DishManager = DishManager()
    
    func getDishesOrderByCreatedTime(user_id : String, beforeTime : String) async throws -> [Dish] {
        
        guard let url = URL(string: "\(self.serverUrlPrefix)/dishes/byuserid/\(user_id)?date=\(beforeTime)") else {
            throw APIError.BadRequestURL
        }
        let req = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: req)
        let decoder = JSONDecoder()
        let dishesJson =  try decoder.decode([DishJson].self, from: data)

        let dishes = dishesJson.compactMap { json in
            return Dish(json: json)
        }

        return dishes
    }

    func generateNewDishes(preference : DishPreference, excluded_foods : [String]?) async throws -> [Dish] {
        
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
            "addictionalText" : preference.additional_text,
            "reference_in_history" : preference.referenced_in_history
        ]

        let body = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        req.httpBody = body
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        
        let (data, _) = try await URLSession.shared.data(for: req)
        let decoder = JSONDecoder()
        let result =  try decoder.decode(DishesJsonResponse.self, from: data)
        let dishes = result.dishes.compactMap { json in
            return Dish(json: json)
        }
        return dishes
    }
    
    func generateDishDetail(dish_id : String, quantity : Int) async throws -> Dish {
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
        let result = try decoder.decode(DishesJsonResponse.self, from: data)
        if let json = result.dishes.first {
            if let dish = Dish(json: json) {
                return dish
            }
        }
        
        throw DishError.RespondError
        

       
    }
    
    func markAsLiked(dish_id : String) {
        
    }
    

    

    
}
