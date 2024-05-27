import UIKit
enum InputIngredientSection {
    case Photo
    case Text
}
protocol IngredientCellDelegate : NSObject {
    func insertNewIngredient(ingredient : Ingredient, section : InputIngredientSection)
    func deleteIngredient(ingredient : Ingredient, section : InputIngredientSection)
    
}

protocol AddButtonHeaderViewDelegate : NSObject {
    func editModeToggleTo(type : AddButtonHeaderViewType)
}

protocol IngredientAddButtonHeaderViewDelegate : AddButtonHeaderViewDelegate, IngredientCellDelegate {
    
}

protocol OptionGeneratedAddButtonHeaderViewDelegate : AddButtonHeaderViewDelegate, GenerateOptionCellDelegate {
    
}

protocol DetectedPhotoCollectionCellDelegate : IngredientCellDelegate {
  //  func reloadSection(sectionIndex : Int)
    
}

