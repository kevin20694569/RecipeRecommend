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
        if let image = await self.image_URL?.getImage() {
            self.image = image
        }
        return image
    }
}

protocol DishDelegate : NSObject {
    func reloadDish(dish : Dish)
    
}

protocol ShowDishViewControllerDelegate : UIViewController, DishDelegate {
    func showDishDetailViewController(dish : Dish)
    func showDishSummaryDisplayController(dishes : [Dish])
}

extension ShowDishViewControllerDelegate  {
    func showDishDetailViewController(dish : Dish) {
        guard let steps = dish.steps,
              let ingredients = dish.ingredients else {
            return
        }
        let controller = DishDetailViewController(dish: dish, steps: steps, ingredients: ingredients)
        show(controller, sender: nil)
        navigationController?.isNavigationBarHidden = false
    }
    
    func showDishSummaryDisplayController(dishes : [Dish]) {
        let controller = DishSummaryDisplayController(dishes: dishes)
        controller.reloadDishDelegate = self

        show(controller, sender: nil)
        navigationController?.isNavigationBarHidden = false

    }
}

