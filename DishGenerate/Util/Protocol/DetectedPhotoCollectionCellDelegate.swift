import UIKit
enum InputIngredientSection {
    case Photo
    case Text
}
protocol IngredientCellDelegate : NSObject {
    func insertNewIngredient(ingredient : Ingredient, section : InputIngredientSection)
    func deleteIngredient(ingredient : Ingredient, section : InputIngredientSection)
}




protocol AddTextIngrdientCellDelegate : IngredientCellDelegate {
    
    

}

protocol DetectedPhotoCollectionCellDelegate : IngredientCellDelegate {

    
}
