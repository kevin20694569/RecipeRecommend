import UIKit

protocol DishTableCell : UITableViewCell {
    func configure(dish : Dish)
}

enum HorizontalAnchorSide {
    case leading, center, trailing
}

protocol HorizontalAnchorSideCell : UICollectionViewCell {
    var anchorSide : HorizontalAnchorSide! { get set }
    func initLayout()
    func configureSide(cellSide : HorizontalAnchorSide)
}

protocol HorizontalButtonAnchorSideCell : HorizontalAnchorSideCell {
    var button : ZoomAnimatedButton! { get }
    var backgroundLeadingAnchor : NSLayoutConstraint { get }
    var backgroundTrailingAnchor : NSLayoutConstraint { get }
    var backgroundCenterAnchor : NSLayoutConstraint { get }
}

extension HorizontalButtonAnchorSideCell {
    
    var backgroundLeadingAnchor : NSLayoutConstraint { button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor) }
    var backgroundTrailingAnchor : NSLayoutConstraint { button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor) }
    var backgroundCenterAnchor : NSLayoutConstraint { button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor) }
    
    func buttonSetup() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .thirdaryBackground
        config.baseForegroundColor = .primaryLabel
        button.configuration = config
    }
    
    
    func configureSide(cellSide : HorizontalAnchorSide) {
        
        switch cellSide {
        case .leading :
            backgroundCenterAnchor.isActive = false
            backgroundTrailingAnchor.isActive = false
            backgroundLeadingAnchor.isActive = true
        case .center :
            backgroundLeadingAnchor.isActive = false
            backgroundTrailingAnchor.isActive = false
            backgroundCenterAnchor.isActive = true
        case .trailing :
            backgroundLeadingAnchor.isActive = false
            backgroundCenterAnchor.isActive = false
            backgroundTrailingAnchor.isActive = true
        }
    }
}



protocol HorizontalBackgroundAnchorSideCell : HorizontalAnchorSideCell {

    var background : UIView! { get }

    var backgroundTrailingAnchor : NSLayoutConstraint {get }
    var backgroundLeadingAnchor : NSLayoutConstraint { get }
    var backgroundCenterAnchor : NSLayoutConstraint { get }

}



extension HorizontalBackgroundAnchorSideCell {
    
    
    
    var backgroundLeadingAnchor : NSLayoutConstraint { background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor) }
    var backgroundTrailingAnchor : NSLayoutConstraint { background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor) }
    var backgroundCenterAnchor : NSLayoutConstraint { background.centerXAnchor.constraint(equalTo: contentView.centerXAnchor) }
    
    func backgroundSetup() {
        background.backgroundColor = .themeColor
        background.clipsToBounds = true
        background.layer.cornerRadius = 12
    }
    
    func configureSide(cellSide : HorizontalAnchorSide) {
        
        switch cellSide {
        case .leading :
            backgroundCenterAnchor.isActive = false
            backgroundTrailingAnchor.isActive = false
            backgroundLeadingAnchor.isActive = true
        case .center :
            backgroundLeadingAnchor.isActive = false
            backgroundTrailingAnchor.isActive = false
            backgroundCenterAnchor.isActive = true
        case .trailing :
            backgroundLeadingAnchor.isActive = false
            backgroundCenterAnchor.isActive = false
            backgroundTrailingAnchor.isActive = true
        }
    }
    
    
}

protocol GenerateOptionCellDelegate : NSObject {
    var quantity : Int { get set }
    var equipments : [Equipment] { get set }
    
    var cuisines : [Cuisine] { get set }
    var ingrdients : [Ingredient] { get set }
    
    var temperature : Double { get set }
    
    func addEquipmentCell(equipment : Equipment)
    
    func addCuisineCell(cuisine : Cuisine)
}
