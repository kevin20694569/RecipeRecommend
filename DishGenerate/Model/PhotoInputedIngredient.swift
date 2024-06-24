

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
    
    
    static var examples : [PhotoInputedIngredient] = {
        let staticTitles : [(String, String)] = [("牛番茄", "蓮霧"), ("雞蛋", "鱈魚丸"), ("空心菜", "水蓮" )]
        let results =  staticTitles.enumerated().compactMap() { index, titles in
            let image = UIImage.ingredientImages[index]!

            return PhotoInputedIngredient(image: image, leftTitle: titles.0, rightTitle: titles.1)
            
        }
        return results
       
    }()
}
