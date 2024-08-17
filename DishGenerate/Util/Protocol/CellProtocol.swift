import UIKit

protocol RecipeStatusControll : NSObject {
    func markRecipeLike(recipe_id : String, like : Bool) async
    
    func configureRecipeLikedStatus(liked : Bool)
}

protocol RecipeTableCell : UITableViewCell, RecipeStatusControll {
    func configure(recipe : Recipe)
    
    
}

extension RecipeStatusControll {
    func markRecipeLike(recipe_id : String, like : Bool) async {
        do {
            try await RecipeManager.shared.markAsLiked(recipe_id: recipe_id, like: like)
        } catch {
            print("markRecipeLikeError", error)
        }
    }
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
    func editModeToggleTo(enable : Bool)
    func backgroundSetup()

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
        self.layoutIfNeeded()
    }
    
    
}

enum GeneratedOptionIntertactionSection {
    case equipment, cuisine
}

protocol EditCuisineCellDelegate : NSObject, AddButtonHeaderViewDelegate  {
    var collectionView : UICollectionView! { get }
    var cuisines : [Cuisine] { get set }
    var cuisineEditModeEnable : Bool! { get set }
    func addCuisineCell(cuisine : Cuisine)
    
    func deleteCuisine(cuisine : Cuisine)
}

protocol EditEquipmentCellDelegate : NSObject, AddButtonHeaderViewDelegate {
    var collectionView : UICollectionView! { get }
    var equipments : [Equipment] { get set }
    func addEquipmentCell(equipment : Equipment)
    func deleteEquipment(equipment : Equipment)
    var equipmentEditModeEnable: Bool! { get set }
    
    
}

protocol GenerateOptionCellDelegate : AddButtonHeaderViewDelegate, EditEquipmentCellDelegate, EditCuisineCellDelegate {

    var ingrdients : [Ingredient] { get set }
    
    var temperature : Double { get }

}

extension GenerateOptionCellDelegate {
    func editModeToggleTo(type : GeneratedOptionIntertactionSection) {
        if type == .equipment {
            guard self.equipments.count > 0 else {
                return
            }
            self.collectionView.visibleCells.forEach() {
                if let cell = $0 as? EquipmentTextFieldCollectionCell {
                    cell.editModeToggleTo(enable: self.equipmentEditModeEnable)
                }
            }
        } else {
            
            self.collectionView.visibleCells.forEach() {
                if let cell = $0 as? CuisineTextFieldCollectionCell {
                    cell.editModeToggleTo(enable: self.cuisineEditModeEnable)
                }
            }
            
        }
        
    }
}

protocol SummaryRecipeTableCellDelegate : UIViewController {
    func showRecipeDetailViewController(recipe : Recipe)
}

extension SummaryRecipeTableCellDelegate {
    func showRecipeDetailViewController(recipe : Recipe) {
        guard let steps = recipe.steps,
              let ingredients = recipe.ingredients else {
            return
        }
        
        let controller = RecipeDetailViewController(recipe: recipe, steps: steps, ingredients: ingredients)
        self.show(controller, sender: nil)

    }
}

protocol EditUserProfileCellDelegate : EditUserNameViewControllerDelegate {
    var user : User! { get }
    func showEditUserImageViewController()
    func showEditNameViewController()
    func showEditEquipementViewController()
    func showEditFavoriteCuisineViewController()
    func showImagePicker()
}

extension EditUserProfileCellDelegate {
    func showEditUserImageViewController() {
        let controller = EditUserImageViewController(user: user)
        self.show(controller, sender: nil)
    }
    
    func showImagePicker() {
        
    }
    
    func showEditNameViewController() {
        let controller = EditUserNameViewController(user: user)
        controller.editUserNameViewControllerDelegate = self
        self.show(controller, sender: nil)
        
    }
    func showEditEquipementViewController() {
        let controller = EditEquipementViewController(equipments: Equipment.examples)
        self.show(controller, sender: nil)
    }
    
    func showEditFavoriteCuisineViewController() {
        let controller = EditFavoriteCuisineViewController(cuisines: Cuisine.examples)
        self.show(controller, sender: nil)
        
    }
}

protocol UserProfileCellDelegate : ShowRecipeViewControllerDelegate {
    var user : User! { get }
    func showEditUserProfileViewController()
    
}

extension UserProfileCellDelegate {
    func showEditUserProfileViewController() {
        let controller = EditUserProfileViewController(user : self.user)
        show(controller, sender: nil)
        navigationController?.isNavigationBarHidden = false
    }
    func showRecipeDetailViewController(recipe : Recipe) {
        guard let steps = recipe.steps,
              let ingredients = recipe.ingredients else {
            return
        }
        
        let controller = RecipeDetailViewController(recipe: recipe, steps: steps, ingredients: ingredients)
        show(controller, sender: nil)
        navigationController?.isNavigationBarHidden = false
    }
    func showGeneratedDishesDisplayController(newDishes : [Recipe]) {
        let controller = RecipeSummaryDisplayController(dishes: newDishes)
        show(controller, sender: nil)
        navigationController?.isNavigationBarHidden = false
    }
    
}

protocol DisplayPreferenceCellDelegate : UIViewController {
    func showDishSummaryViewController(preference_id : String)
}
extension DisplayPreferenceCellDelegate {
    func showDishSummaryViewController(preference_id : String) {
        let controller = RecipeSummaryDisplayController(preference_id: preference_id)
        show(controller, sender: nil)
    }
}
