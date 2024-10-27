import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        initEntryControllers(windowScene : windowScene)
    }
    
    func initEntryControllers(windowScene : UIWindowScene) {
        let controller =  initViewController()
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = controller
        self.window = window
        window.makeKeyAndVisible()
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {

        
        
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        guard let viewController = MainTabBarViewController.shared.getTopViewController() else {
            return
        }
        if let jwt_token = SessionManager.shared.jwt_token {
           
            Task {
                do {
                    try await SessionManager.shared.verifyJwtTokenToLogout(currentViewController: viewController ,token: jwt_token)
                } catch {
                    //viewController.dismiss(animated: true)
                }
            }
        }
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {

        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    
    @MainActor
    static func logout() {
        let nav  = LoginViewController.navShared
        let loginViewController = nav.viewControllers.first as! LoginViewController
        guard var tabBarController = MainTabBarViewController.shared else {
            return
        }
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        guard let topViewController = MainTabBarViewController.shared.getTopViewController(),
        let view = topViewController.view else {
            return
        }
        SessionManager.shared.deleteUserID()
        SessionManager.shared.deleteJWT_Token()
        
        DispatchQueue.main.async {
            let animatedView = UIView()
            animatedView.backgroundColor = .primaryBackground
            animatedView.alpha = 0
            animatedView.frame = tabBarController.view.bounds
            animatedView.clipsToBounds = true
            animatedView.layer.cornerRadius = 16
            
            window.addSubview(animatedView)
            
            window.insertSubview(nav.view, at: 0)
            loginViewController.view.layoutIfNeeded()
            loginViewController.mainView.subviews.forEach() {
                $0.alpha = 0
            }
            loginViewController.mainView.isHidden = true
            
            UIView.animate(withDuration: 0.5, animations: {
                animatedView.alpha = 1
            }) { bool in

                MainTabBarViewController.shared.view.removeFromSuperview()
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, animations: {
                    let targetFrame = loginViewController.view.convert(loginViewController.mainView.frame, to: window)
                    animatedView.frame = targetFrame
                    animatedView.layer.cornerRadius = loginViewController.mainView.layer.cornerRadius
                    
                }) { bool in
                    window.subviews.forEach() {
                        if !nav.view.subviews.contains($0) {
                            $0.removeFromSuperview()
                        }
                    }
                    window.addSubview(nav.view)
                    loginViewController.mainView.isHidden = false
                    
                    animatedView.removeFromSuperview()
                    animatedView.isHidden = true

                    UIView.animate(withDuration: 0.3, animations: {
                        loginViewController.mainView.subviews.forEach() {
                            $0.alpha = 1
                        }
                    })
                }
            }
        }
    }
}

#Preview {
    
    return initViewController()
}

@MainActor
func initViewController() -> UIViewController {
  
    
    
    let nav = LoginViewController.navShared
    guard let tabBarViewController = MainTabBarViewController.shared else {
        return nav
    }
    if let jwt_token = SessionManager.shared.jwt_token {
        
        Task {
            try await SessionManager.shared.verifyJwtTokenToLogout(currentViewController: tabBarViewController ,token: jwt_token)
        }
        return tabBarViewController
        
    }
    return nav
}
