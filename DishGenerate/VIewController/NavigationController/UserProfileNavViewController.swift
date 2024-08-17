
import UIKit

class UserProfileNavViewController : UINavigationController, EditUserNameViewControllerDelegate {
    func reloadUser() async {
        for controller in viewControllers {
            if let viewController = controller as? EditUserNameViewControllerDelegate {
                await viewController.reloadUser()
            }
        }

        
    }
    
    
}
