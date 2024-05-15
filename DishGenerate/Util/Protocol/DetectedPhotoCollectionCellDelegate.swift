import UIKit
enum InputIngredientSection {
    case Photo
    case Text
}
protocol IngredientCellDelegate : NSObject {
    func insertNewIngredient(ingredient : Ingredient, section : InputIngredientSection)
    func deleteIngredient(ingredient : Ingredient, section : InputIngredientSection)
}




protocol AddTextIngrdientCollectionCellDelegate : IngredientCellDelegate {
    
    

}

protocol DetectedPhotoCollectionCellDelegate : IngredientCellDelegate {

    
}
