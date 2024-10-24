
import UIKit

class UserProfileNavViewController : UINavigationController, EditUserNameViewControllerDelegate {
    func reloadUser() async {
        for controller in viewControllers {
            if let viewController = controller as? EditUserNameViewControllerDelegate {
                await viewController.reloadUser()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.backgroundColor = .clear
        navigationBar.barTintColor = .clear
        navigationBar.standardAppearance.configureWithTransparentBackground()
        navigationBar.scrollEdgeAppearance?.configureWithTransparentBackground()
        
        
    }
    
    
}
