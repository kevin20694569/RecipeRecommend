import UIKit

class GenerateRecipePreference : Equatable {
    static func == (lhs: GenerateRecipePreference, rhs: GenerateRecipePreference) -> Bool {
        lhs.id == rhs.id
    }
    
    var id : String! = UUID().uuidString
    
    var user_id : String!

    var created_time : String?
    
    var complexity : Complexity!
    var timeLimit : Int!

    var temperature : Double!
    var addictionalText : String?
    var ingredients : [Ingredient]!
    var equipments : [Equipment]!
    var cuisine : [Cuisine]!
    
    var ingredientsDescription : String {
        var text = ingredients[0].name ?? ""
        for (index, ingredient) in ingredients.enumerated() {
            if index == 0 {
                continue
            }
            if let name = ingredient.name {
                text += ("、" + name)
            }
        }
        return text
    }
    
    var cuisinesDescription : String {
        var text = cuisine[0].name ?? ""
        for (index, cuisine) in cuisine.enumerated() {
            if index == 0 {
                continue
            }
            if let name = cuisine.name {
                text += ("、" + name)
            }
        }
        return text
    }
    
    var equipementsDescription : String {
        var text = equipments[0].name ?? ""
        for (index, equipment) in equipments.enumerated() {
            if index == 0 {
                continue
            }
            if let name = equipment.name {
                text += ("、" + name)
            }
        }
        return text
    }
    
    var timeLimitDescription : String {
        return "< \(String(timeLimit))分鐘"
    }
    
    
    init() {
        
    }
    
    init(id: String, user_id: String, ingredients: [Ingredient], cuisine: [Cuisine], complexity : Complexity, timeLimit : Int, equipments: [Equipment], temperature: Double,  additional_text: String? = nil, created_time: String? = nil) {
        self.id = id
        self.user_id = user_id
        self.created_time = created_time
        self.complexity = complexity
        self.timeLimit = timeLimit
        self.equipments = equipments
        self.temperature = temperature
        self.cuisine = cuisine
        self.ingredients = ingredients
        self.addictionalText = additional_text
    }
    
    convenience init?(json : DishPreferenceJson) {
        guard let id = json.id,
              let user_id = json.user_id,
              let timeLimit = json.timelimit,
              let temperature = json.temperature,
        let created_time = json.created_time else {
            return nil
        }
        let ingredients = json.ingredients?.split(separator: ",").compactMap() { name in
            return Ingredient(name: String(name))
            
        }
        let complexity = Complexity(rawValue: json.complexity ?? "簡單")!
        let equipments = json.equipments?.split(separator: ",").compactMap() { name in
            return Equipment(name: String(name), isSelected: true)
            
        }
        
        let cuisine = json.cuisine?.split(separator: ",").compactMap() { name in
            return Cuisine(name: String(name), isSelected: true)
        }
        
        self.init(id: id, user_id: user_id, ingredients: ingredients ?? [], cuisine: cuisine ?? [], complexity: complexity, timeLimit: timeLimit, equipments: equipments ?? [], temperature: temperature, additional_text: json.additional_text, created_time: created_time)
    }
    
    static var examples : [GenerateRecipePreference] = [GenerateRecipePreference(id: UUID().uuidString, user_id: UUID().uuidString, ingredients: Ingredient.examples, cuisine: Cuisine.examples, complexity: .easy, timeLimit: 50, equipments: Equipment.examples, temperature: 0.5), GenerateRecipePreference(id: UUID().uuidString, user_id: UUID().uuidString, ingredients: Ingredient.examples, cuisine: Cuisine.examples, complexity: .easy, timeLimit: 50, equipments: Equipment.examples, temperature: 0.5), GenerateRecipePreference(id: UUID().uuidString, user_id: UUID().uuidString, ingredients: Ingredient.examples, cuisine: Cuisine.examples, complexity: .easy, timeLimit: 50, equipments: Equipment.examples, temperature: 0.5)]
    
    
}



struct DishPreferenceJson : Codable {
    var id : String?
    var user_id : String?
    var ingredients : String?
    var cuisine : String?
    var complexity : String?
    var timelimit : Int?
    var equipments : String?
    var temperature : Double?
    var additional_text : String?
    var created_time : String?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container.decode(String.self, forKey: .id)
        self.user_id = try? container.decode(String.self, forKey: .user_id)
        self.ingredients = try? container.decode(String.self, forKey: .ingredients)
        self.complexity = try? container.decode(String.self, forKey: .complexity)
        self.additional_text = try? container.decode(String.self, forKey: .additional_text)
        self.created_time = try? container.decode(String.self, forKey: .created_time)
        self.timelimit = try? container.decode(Int.self, forKey: .timelimit)
        self.equipments = try? container.decode(String.self, forKey: .equipments)
        self.temperature = try? container.decode(Double.self, forKey: .temperature)
        self.cuisine = try? container.decode(String.self, forKey: .cuisine)
    }
}
