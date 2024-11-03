import UIKit

class RecommendRecipePreference : Equatable {
    static func == (lhs: RecommendRecipePreference, rhs: RecommendRecipePreference) -> Bool {
        lhs.id == rhs.id
    }
    
    var id : String = UUID().uuidString
    
    var user_id : String!

    var created_time : String?
    
  //  var complexity : Complexity!
   // var timeLimit : Int!

   // var temperature : Double!
  //  var additionalText : String?
    var ingredients : [Ingredient]! = []
  //  var equipments : [Equipment]! = []
  //  var cuisine : [Cuisine]!
    
    var ingredientsDescription : String {
        guard !ingredients.isEmpty else {
            return "無"
        }
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
    
  /*  var cuisinesDescription : String {
        guard !cuisine.isEmpty else {
            return "無"
        }
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
        guard !equipments.isEmpty else {
            return "無"
        }
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
        return ""
       // return "< \(String(timeLimit))分鐘"
    }*/
    
    
    init() {
        
    }
    
    init(id: String, user_id: String, ingredients: [Ingredient], created_time: String? = nil) {
        self.id = id
        self.user_id = user_id
        self.created_time = created_time
        self.ingredients = ingredients
    }
    
    convenience init?(json : RecommendPreferenceJson) {
        guard let id = json.id,
              let user_id = json.user_id,
        let created_time = json.created_time else {
            return nil
        }
        let ingredients = json.ingredients?.split(separator: ",").compactMap() { name in
            return Ingredient(name: String(name))
        }
        
        self.init(id: id, user_id: user_id, ingredients: ingredients ?? [], created_time: created_time)
    }
    
    static var examples : [RecommendRecipePreference] = [RecommendRecipePreference(id: UUID().uuidString, user_id: UUID().uuidString, ingredients: Ingredient.examples), RecommendRecipePreference(id: UUID().uuidString, user_id: UUID().uuidString, ingredients: Ingredient.examples), RecommendRecipePreference(id: UUID().uuidString, user_id: UUID().uuidString, ingredients: Ingredient.examples)]
    
    
}



class GenerateRecipePreference : Equatable {
    static func == (lhs: GenerateRecipePreference, rhs: GenerateRecipePreference) -> Bool {
        lhs.generated_recipe_id == rhs.generated_recipe_id
    }
    
    var generated_recipe_id : String = UUID().uuidString
    
    var reference_recipe_id : String = ""
    
    var user_id : String!

    var created_time : String?
    


    var temperature : Double!
    var additionalText : String?
    var ingredients : [Ingredient] = []
    var equipments : [Equipment] = []
    var cuisine : [Cuisine] = []
    
    var ingredientsDescription : String {
        guard !ingredients.isEmpty else {
            return "無"
        }
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
        guard !cuisine.isEmpty else {
            return "無"
        }
        
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
        guard !equipments.isEmpty else {
            return "無"
        }
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
    
    
    
    init(generated_recipe_id: String, reference_recipe_id: String, user_id: String!, created_time: String? = nil, temperature: Double!, additionalText: String? = nil, ingredients: [Ingredient] = [], equipments: [Equipment] = [], cuisine: [Cuisine] = []) {
        self.generated_recipe_id = generated_recipe_id
        self.reference_recipe_id = reference_recipe_id
        self.user_id = user_id
        self.created_time = created_time
        self.temperature = temperature
        self.additionalText = additionalText
        self.ingredients = ingredients
        self.equipments = equipments
        self.cuisine = cuisine
    }
    

    convenience init?(json : GeneratePreferenceJson) {
        guard let generated_recipe_id = json.generated_recipe_id,
              let user_id = json.user_id,
              let reference_recipe_id = json.reference_recipe_id,
        let created_time = json.created_time else {
            return nil
        }
        
        let ingredients = json.ingredients?.split(separator: ",").compactMap() { name in
            return Ingredient(name: String(name))
        }
        let cuisines = json.cuisines?.split(separator: ",").compactMap({ name in
            return Cuisine(name: String(name))
        })
        
        let equipments = json.equipments?.split(separator: ",").compactMap({ name in
            return Equipment(name: String(name))
        })
        self.init(generated_recipe_id: generated_recipe_id, reference_recipe_id: reference_recipe_id, user_id: user_id, temperature: json.temperature ?? 0.5, ingredients: ingredients ?? [], equipments: equipments ?? [], cuisine: cuisines ?? [])
    }
    
    
}



struct RecommendPreferenceJson : Codable {
    var id : String?
    var user_id : String?
    var ingredients : String?
    var created_time : String?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container.decode(String.self, forKey: .id)
        self.user_id = try? container.decode(String.self, forKey: .user_id)
        self.ingredients = try? container.decode(String.self, forKey: .ingredients)
        self.created_time = try? container.decode(String.self, forKey: .created_time)
    }
}

struct GeneratePreferenceJson : Codable {
    var generated_recipe_id: String?
    var reference_recipe_id: String?
    var user_id: String?
    var ingredients: String?
    var cuisines: String?
    var equipments: String?
    var temperature: Double?
    var additional_text: String?
    var created_time : String?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.generated_recipe_id = try? container.decodeIfPresent(String.self, forKey: .generated_recipe_id)
        self.reference_recipe_id = try? container.decodeIfPresent(String.self, forKey: .reference_recipe_id)
        self.user_id = try? container.decodeIfPresent(String.self, forKey: .user_id)
        self.ingredients = try? container.decodeIfPresent(String.self, forKey: .ingredients)
        self.cuisines = try? container.decodeIfPresent(String.self, forKey: .cuisines)
        self.equipments = try? container.decodeIfPresent(String.self, forKey: .equipments)
        self.temperature = try? container.decodeIfPresent(Double.self, forKey: .temperature)
        self.additional_text = try? container.decodeIfPresent(String.self, forKey: .additional_text)
        self.created_time = try? container.decodeIfPresent(String.self, forKey: .created_time)
    }
}

