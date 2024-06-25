import UIKit

class DishPreference : Equatable {
    static func == (lhs: DishPreference, rhs: DishPreference) -> Bool {
        lhs.id == rhs.id
    }
    
    var id : String!
    var user_id : String!
    var quantity : Int!
    var excluded_food : String?
    var referenced_in_history : Bool!
    var complexity : Complexity!
    var additional_text : String?
    var created_time : String?
    
    var countLimit : Int! = 4
    
    var timeLimit : String!

    var temperature : Double!
    var ingredients : [Ingredient]!
    var equipments : [Equipment]!
    var cuisine : [Cuisine]!
    
    
    
    init(id: String!, user_id: String!, quantity: Int!, excluded_food: String!, referenced_in_history: Bool!, complexity: Complexity!, additional_text: String!, created_time: String? = nil, timeLimit: String!, equipments: [Equipment], temperature: Double!, cuisine: [Cuisine], ingredients : [Ingredient]) {
        self.id = id
        self.user_id = user_id
        self.quantity = quantity
        self.excluded_food = excluded_food
        self.referenced_in_history = referenced_in_history
        self.complexity = complexity
        self.additional_text = additional_text
        self.created_time = created_time
        self.timeLimit = timeLimit
        self.equipments = equipments
        self.temperature = temperature
        self.cuisine = cuisine
        self.ingredients = ingredients
    }
    
    
}



struct DishPreferenceJsonResponse : Codable {
    var id : String
    var user_id : String
    var quantity : String
    var excluded_food : String
    var referenced_in_history : String
    var complexity : String
    var additional_text : String
    var created_time : String
    var timelimit : String
    var equipments : String
    var temperature : String
    var cuisine : String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.user_id = try container.decode(String.self, forKey: .user_id)
        self.quantity = try container.decode(String.self, forKey: .quantity)
        self.excluded_food = try container.decode(String.self, forKey: .excluded_food)
        self.referenced_in_history = try container.decode(String.self, forKey: .referenced_in_history)
        self.complexity = try container.decode(String.self, forKey: .complexity)
        self.additional_text = try container.decode(String.self, forKey: .additional_text)
        self.created_time = try container.decode(String.self, forKey: .created_time)
        self.timelimit = try container.decode(String.self, forKey: .timelimit)
        self.equipments = try container.decode(String.self, forKey: .equipments)
        self.temperature = try container.decode(String.self, forKey: .temperature)
        self.cuisine = try container.decode(String.self, forKey: .cuisine)
    }
}
