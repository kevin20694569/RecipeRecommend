
import UIKit

class UserProfileNavViewController : UINavigationController, EditUserNameViewControllerDelegate {
    func reloadUserName() {
        self.viewControllers.forEach() { viewController in
            if let viewController = viewController as? EditUserNameViewControllerDelegate {
                viewController.reloadUserName()
            }
        }
    }
    
    
}
