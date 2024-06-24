import UIKit

final class DishManager : MainServerAPIManager {

    static let shared : DishManager = DishManager()
    
    func getDishesOrderByCreatedTime(user_id : String, createdTime : String) async throws -> [Dish] {
        
        guard let url = URL(string: "\(self.serverUrlPrefix)/dishes/byuserid/\(user_id)") else {
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

    func generateNewDishes() async throws -> [Dish] {
        
        guard let url = URL(string: "\(self.serverUrlPrefix)/remote/generatedishes") else {
            throw APIError.BadRequestURL
        }
    
        var req = URLRequest(url: url)
        let params : [String : Any?] = [
            "user_id" : self.user_id,
            "ingredients" : "高麗菜、白蘿蔔、杏鮑菇、火鍋肉片、花椰菜、雞皮、雞肉片、起司",
            "quantity" : "2位大人、3位兒童",
            "equipments" : "烤箱、氣炸鍋、瓦斯爐",
            "excludedIngredients" : "",
            "cuisine" : "中式, 歐式",
            "complexity" : "簡單",
            "timelimit" : "20分鐘",
            "limit" : 2,
            "temperature" : 0.6,
            "excludedFoods" : nil,
            "addictionalText" : nil,
            "reference_in_history" : false
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
    
}
