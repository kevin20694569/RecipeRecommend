

import UIKit

class IngredientTitleLabelCollectionCell : TitleLabelSideCollectionCell {
    
    var ingredient : Ingredient!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundSetup()
        labelSetup()
        
        initLayout()
    }
    
    func configure(ingredient : Ingredient) {
        self.ingredient = ingredient
        titleLabel.text = ingredient.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class IngredientTitleLabelCenterCollectionCell : IngredientTitleLabelCollectionCell {
    override func initLayout() {
        super.initLayout()
        backgroundCenterAnchor.isActive = true

    }

}

class IngredientTitleLabelLeadingCollectionCell : IngredientTitleLabelCollectionCell {
    override func initLayout() {
        super.initLayout()
        
        backgroundLeadingAnchor.isActive = true
    }

}


class IngredientTitleLabelTrailingCollectionCell : IngredientTitleLabelCollectionCell {
    override func initLayout() {
        super.initLayout()
        
        backgroundTrailingAnchor.isActive = true
    }

}



