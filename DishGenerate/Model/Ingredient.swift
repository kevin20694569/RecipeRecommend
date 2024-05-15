

import UIKit

struct Ingredient : Equatable {
    
    var name : String!
    
    var image : UIImage?
    
    var probalyName : [String]?
    
    static let emptyHolder = Ingredient(name: "高麗菜")
    
    static var examples : [Ingredient] = Array.init(repeating: emptyHolder, count: 8)
}
