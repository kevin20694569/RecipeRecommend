

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
    
    var leftPropablyTitle : String?
    
    var rightPropablyTitle : String?
    
    var outputedIngredient : Ingredient?
    
    init(image : UIImage) {
        self.image = image
    }
    
    init(image : UIImage, leftTitle : String, rightTitle : String) {
        self.image = image
        self.leftPropablyTitle = leftTitle
        self.rightPropablyTitle = rightTitle
    }
}
