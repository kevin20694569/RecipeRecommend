

import UIKit

struct Ingredient {
    
    var name : String!
    
    var image : UIImage?
    
    var probalyName : [String]?
    
    static let emptyHolder = Ingredient()
    
    static var examples : [Ingredient] = Array.init(repeating: emptyHolder, count: 8)
}
