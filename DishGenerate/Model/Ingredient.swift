

import UIKit

class Ingredient : Equatable {
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.id == rhs.id
    }
    
    static func getRequestString(models : [Ingredient]) -> String {
        guard models.count > 0 && !models.isEmpty else {
            return ""
        }
        var result : String = ""
        if let name = models[0].name {
            result = name
        }
        for model in models {
            if let name = model.name {
                result += ", \(name)"
            }
        }
        return result
    }
    
    var id : String! = UUID().uuidString
    
    
    var name : String?
    
    var quantity : String?
    
    var image : UIImage?
    
    var probalyName : [String]?
    
    var order_index : Int?
    
    init(name : String) {
        self.name = name
    }
    
    init(name : String, quantity : String) {
        self.name = name
        self.quantity = quantity
    }
    
    
    convenience init(json : IngredientJson) {
        self.init(id: json.id, name: json.name, quantity: json.quantity, created_time: json.created_time, dish_id: json.dish_id, order_index:    json.order_index    )
    }
    
    init(id : String?, name : String, quantity : String, created_time : String?, dish_id : String?, order_index : Int?) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.order_index = order_index
    }
    
    init() {
        
    }
    
    static let emptyHolder = Ingredient(name: "高麗菜", quantity: "1 / 4 顆")
    
    static var examples : [Ingredient] = Array.init(repeating: emptyHolder, count: 8)
    
    
}

struct IngredientJson : Decodable {
    var id : String
    var name : String
    var quantity : String
    var created_time : String
    var dish_id : String
    var order_index : Int
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case quantity
        case created_time
        case dish_id
        case order_index
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.quantity = try container.decode(String.self, forKey: .quantity)
        self.created_time = try container.decode(String.self, forKey: .created_time)
        self.dish_id = try container.decode(String.self, forKey: .dish_id)
        self.order_index = try container.decode(Int.self, forKey: .order_index)
    }
    
}
