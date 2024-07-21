import UIKit


protocol GetImageModel : AnyObject {
    var image : UIImage? { get set }
    var image_URL : URL? { get set }
    
    func getImage() async -> UIImage?
}

extension GetImageModel {
    func getImage() async -> UIImage? {

        if let image = self.image {
            return image
        }
        //return nil
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
    func showRecipeDetailViewController(dish : Recipe)
    func showDishSummaryDisplayController(dishes : [Recipe])
}

extension ShowRecipeViewControllerDelegate  {
    func showRecipeDetailViewController(dish : Recipe) {
        guard let steps = dish.steps,
              let ingredients = dish.ingredients else {
            return
        }
        let controller = DishDetailViewController(dish: dish, steps: steps, ingredients: ingredients)
        controller.recipeStatusDelegate = self as? any RecipeStatusControll
        show(controller, sender: nil)
        navigationController?.isNavigationBarHidden = false
    }
    
    func showDishSummaryDisplayController(dishes : [Recipe]) {
        let controller = RecipeSummaryDisplayController(dishes: dishes)
        controller.reloadDishDelegate = self

        show(controller, sender: nil)
        navigationController?.isNavigationBarHidden = false

    }
}

