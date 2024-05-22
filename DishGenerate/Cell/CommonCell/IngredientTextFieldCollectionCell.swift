import UIKit

class IngredientTextFieldCollectionCell : TextFieldSideCollectionCell {
    
    var ingredient : Ingredient!
    

    weak var ingredientCellDelegate : IngredientCellDelegate?
    
         
    
    override func deleteSelfGesureTrigger(_ gesture: UITapGestureRecognizer) {
        super.deleteSelfGesureTrigger(gesture)

        ingredientCellDelegate?.deleteIngredient(ingredient: self.ingredient, section: .Text)
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configure(ingredient : Ingredient) {
        self.ingredient = ingredient
        textField.text = ingredient.name
        textField.delegate = textfieldDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class IngredientTextFieldCenterCollectionCell : IngredientTextFieldCollectionCell {
    
    

    override func initLayout() {
        super.initLayout()
        backgroundCenterAnchor.isActive = true

    }

}

class IngredientTextFieldLeadingCollectionCell : IngredientTextFieldCollectionCell {
    override func initLayout() {
        super.initLayout()
        
        backgroundLeadingAnchor.isActive = true
    }

}


class IngredientTextFieldTrailingCollectionCell : IngredientTextFieldCollectionCell {
    override func initLayout() {
        super.initLayout()
        
        backgroundTrailingAnchor.isActive = true
    }

}
