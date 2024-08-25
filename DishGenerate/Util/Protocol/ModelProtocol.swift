import UIKit


class Formatter {
    static func timeAgoOrDate(from dateString: String) -> String? {

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = isoFormatter.date(from: dateString) else {
            return "無效的日期格式"
        }
        
        let taipeiTimeZone = TimeZone(identifier: "Asia/Taipei")!
        let outputFormatter = DateFormatter()
        outputFormatter.timeZone = taipeiTimeZone
        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        let timeZone = TimeZone(identifier: "Asia/Taipei")!
        let calendar = Calendar.current
        let taipeiDate = calendar.date(byAdding: .second, value: timeZone.secondsFromGMT(for: date), to: date)!
        let taipeiNow = calendar.date(byAdding: .second, value: timeZone.secondsFromGMT(for: Date()), to: Date())!

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.calendar?.locale = Locale(identifier: "zh_TW")

        let components = Calendar.current.dateComponents([.year, .month, .weekOfMonth, .day, .hour, .minute, .second], from: taipeiDate, to: taipeiNow)

        if let weeks = components.weekOfMonth, weeks >= 1 {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "MMMM d EEE"
            outputDateFormatter.timeZone = timeZone
            
            let formattedDate = outputDateFormatter.string(from: taipeiDate)
            return formattedDate
        }

        if components.year! == 0 && components.month! == 0 && components.hour! == 0 && components.minute! == 0 {
            if components.second! < 5 {
                return "剛剛"
            }
        }

        guard let timeAgoString = formatter.string(from: components) else {
            return "剛剛"
        }

        return timeAgoString + "前"
    }
}



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
         //   print(recipe.steps)
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



