

import UIKit
enum Side {
    case left
    case right
}

class PhotoInputedIngredient : Equatable {
    static func == (lhs: PhotoInputedIngredient, rhs: PhotoInputedIngredient) -> Bool {
        lhs.title == rhs.title
    }
    
    
    var image : UIImage!
    
    var title : String?
    
    var buttonSide : Side?
    
    var outputedIngredient : Ingredient?
    
    init(image : UIImage) {
        self.image = image
    }
}
