import UIKit


protocol GetImageModel : AnyObject, Equatable {
    var image : UIImage? { get set }
    var image_URL : URL? { get set }
    
    func getImage() async -> UIImage?
}

extension GetImageModel {
    func getImage() async -> UIImage? {

        if let image = self.image {
            return image
        }
        return nil
        if let image = await image_URL?.getImage() {
            self.image = image
        }
        return image
    }
}

protocol RecipeDelegate : NSObject {
    func reloadRecipe(recipe : Recipe)
    
}

protocol ShowRecipeViewControllerDelegate : UIViewController, RecipeDelegate {
    func showRecipeDetailViewController(recipe : Recipe)
    func showRecipeSummaryDisplayController(recipes : [Recipe])
}

extension ShowRecipeViewControllerDelegate  {
    func showRecipeDetailViewController(recipe : Recipe) {
        guard let steps = recipe.steps,
              let ingredients = recipe.ingredients else {
            return
        }
        let controller = RecipeDetailViewController(recipe: recipe, steps: steps, ingredients: ingredients)
        controller.recipeStatusDelegate = self as? any RecipeStatusControll
        show(controller, sender: nil)
        navigationController?.isNavigationBarHidden = false
    }
    
    func showRecipeSummaryDisplayController(recipes : [Recipe]) {
        let controller = RecipeSummaryDisplayController(dishes: recipes)
        controller.reloadDishDelegate = self

        show(controller, sender: nil)
        navigationController?.isNavigationBarHidden = false

    }
}

