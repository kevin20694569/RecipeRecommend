

import UIKit

class IngredientTitleLabelCollectionCell : TitleLabelSideCollectionCell {
    
    var ingredient : Ingredient!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundSetup()
        labelSetup()
        
        initLayout()
    }
    
    func configure(ingredient : Ingredient, backgroundAnchorSide : HorizontalAnchorSide) {
        self.ingredient = ingredient
        titleLabel.text = ingredient.name
        self.configureSide(cellSide: backgroundAnchorSide)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class IngredientTextFieldCollectionCell : TextFieldSideCollectionCell {
    
    var ingredient : Ingredient!
    
    weak var textfieldDelegate : UITextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configure(ingredient : Ingredient, backgroundAnchorSide : HorizontalAnchorSide) {
        self.ingredient = ingredient
        textField.text = ingredient.name
        textField.delegate = textfieldDelegate
        configureSide(cellSide: backgroundAnchorSide)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
