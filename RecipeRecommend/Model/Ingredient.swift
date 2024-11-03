

import UIKit

class Ingredient : Equatable, SelectedModel {
    

    
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.id == rhs.id
    }
    
    static func getRequestString(models : [Ingredient]) -> String {
        guard models.count > 0 && !models.isEmpty else {
            return ""
        }
        var titles = models.compactMap() {
            return $0.name
        }
        let result = titles.joined(separator: ",")
        return result
    }
    
    var id : String = UUID().uuidString
    
    
    var name : String?
    
    var quantity : String?
    
    var image : UIImage?
    
    var probalyName : [String]?
    
    var order_index : Int?
    var isSelected: Bool = false
     
    var multiplication : Double = 1
    var quantityDescription : String? {
        if let (num, text) = getQuantityNum() {
            let numString = convertDoubleToFraction(num)
            return String(numString) + text
        }
        return quantity
        
        func decimalToFraction(_ decimal: Double) -> String {
            let tolerance = 1.0E-6
            var h1 = 1, h2 = 0, k1 = 0, k2 = 1
            var b = decimal
            repeat {
                let a = floor(b)
                let aux = h1; h1 = Int(a) * h1 + h2; h2 = aux
                let aux2 = k1; k1 = Int(a) * k1 + k2; k2 = aux2
                b = 1 / (b - a)
            } while abs(decimal - Double(h1) / Double(k1)) > tolerance

            let numerator = h1
            let denominator = k1
            let gcdValue = gcd(numerator, denominator)
            let simplifiedNumerator = numerator / gcdValue
            let simplifiedDenominator = denominator / gcdValue
            if simplifiedNumerator == 0 {
                return "0"
            } else if simplifiedDenominator == 1 {
                return "\(simplifiedNumerator)"
            } else {
                return "\(simplifiedNumerator) / \(simplifiedDenominator)"
            }
        }

        func gcd(_ a: Int, _ b: Int) -> Int {
            var a = a
            var b = b
            while b != 0 {
                let t = b
                b = a % b
                a = t
            }
            return a
        }

        func convertDoubleToFraction(_ number: Double) -> String {
            let integerValue = Int(number)
            let fractionalValue = number - Double(integerValue)

            if fractionalValue == 0 {
                return "\(integerValue)"
            } else {
                let fractionString = decimalToFraction(fractionalValue)
                if integerValue == 0 {
                    return fractionString
                } else {
                    return "\(integerValue) + \(fractionString)"
                }
            }
        }
    }
    
    init(name : String) {
        self.name = name
    }
    
    init(name : String, quantity : String) {
        self.name = name
        self.quantity = quantity
        
    }
    
    
    convenience init(json : IngredientJson) {
        self.init(id: json.id ?? UUID().uuidString, name: json.name, quantity: json.quantity, created_time: json.created_time, dish_id: json.dish_id, order_index:    json.order_index    )
    }
    
    func getQuantityNum() -> (Double, String)? {
        guard let input = quantity else {
            return nil
        }
        

        
        var numberString = ""
        var unitString = ""
        var encounteredNumber = false
        
        for char in input {
            if char.isNumber || char == "/" || char == "." {
                numberString.append(char)
                encounteredNumber = true
            } else if encounteredNumber {
                unitString.append(char)
            }
        }

        if numberString.contains("/") {
            let components = numberString.split(separator: "/")
            if let numerator = Double(components[0]), let denominator = Double(components[1]) {
                

                let fraction = numerator / denominator
                
                let result = fraction * self.multiplication

                return (result, unitString)
                
            }
        } else if let number = Double(numberString) {
            let result = number * self.multiplication
            return (result, unitString)
        }
        return nil
    }
    
    init(id : String, name : String, quantity : String, created_time : String?, dish_id : String?, order_index : Int?) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.order_index = order_index
    }
    
    init() {
        
    }
    
    static let emptyHolder = Ingredient(name: "高麗菜", quantity: "1 / 4 顆")
    
    static var examples : [Ingredient] = Array.init(repeating: emptyHolder, count: 8)

    static var dish1Ingredient : [Ingredient] = [Ingredient(name: "空心菜", quantity: "1/2把"),
                                                 Ingredient(name: "牛肉絲", quantity: "150g"),
                                                 Ingredient(name: "蔥段", quantity: "適量"),
                                                 Ingredient(name: "蒜片", quantity: "適量"),
                                                 Ingredient(name: "鹽", quantity: "適量"),
                                                 Ingredient(name: "醬油", quantity: "少許"),
                                                 Ingredient(name: "太白粉", quantity: "少許"),
                                                 Ingredient(name: "調理油", quantity: "適量"),
                                                 Ingredient(name: "水", quantity: "少許"),
    ]

    static var realIngredientsArray : [[Ingredient]] = [[Ingredient(name: "酸高麗菜", quantity: "四分之一顆"), Ingredient(name: "清雞胸肉", quantity: "半片"), Ingredient(name: "小黃瓜刨絲", quantity: "兩條"), Ingredient(name: "洋蔥絲", quantity: "半顆"), Ingredient(name: "辣椒", quantity: "適量")]]
    
    
}

struct IngredientJson : Decodable {
    var id : String?
    var name : String
    var quantity : String
    var created_time : String?
    var dish_id : String?
    var order_index : Int?
    

    
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
        self.id = try? container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.quantity = try container.decode(String.self, forKey: .quantity)
        self.created_time = try? container.decode(String.self, forKey: .created_time)
        self.dish_id = try? container.decode(String.self, forKey: .dish_id)
        self.order_index = try? container.decode(Int.self, forKey: .order_index)
    }
    
}
