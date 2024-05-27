

import UIKit

class Ingredient : Equatable {
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.id == rhs.id
    }
    
    var id : UUID! = UUID()
    
    
    var name : String?
    
    var quantity : String?
    
    var image : UIImage?
    
    var probalyName : [String]?
    
    init(name : String) {
        self.name = name
    }
    
    init(name : String, quantity : String) {
        self.name = name
        self.quantity = quantity
    }
    
    init() {
        
    }
    
    static let emptyHolder = Ingredient(name: "高麗菜", quantity: "1 / 4 顆")
    
    static var examples : [Ingredient] = Array.init(repeating: emptyHolder, count: 8)
}
