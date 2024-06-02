import UIKit

class MainTabBarViewController : UIViewController, UITabBarDelegate {
    
    static let shared : MainTabBarViewController! = MainTabBarViewController()
    
    var mainNavViewController : MainNavgationController!
    
    var userProfileNavViewController : UINavigationController!
    
    static var bottomBarFrame : CGRect! = .zero
    
    var currentIndex : Int! = 0
    
    var tabBar : UITabBar! = UITabBar()
    
    var bottomBarView : UIView! = UIView()
    
    lazy var viewControllers : [UINavigationController]! = [mainNavViewController, userProfileNavViewController]
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        childViewControllersSetup()
        tabBarSetup()
        tabBarLayout()

        layoutSetup()
    }
    
    lazy var bottomBarViews : [UIView] = [bottomBarView, tabBar]
    
    func childViewControllersSetup() {
        let mainTableViewController = DishTableViewController()

        self.mainNavViewController = MainNavgationController(rootViewController: mainTableViewController)
        mainNavViewController.mainDishViewController = mainTableViewController
        
        let userProfileViewController = UserProfileViewController()
        let userProfileNavViewController = UINavigationController(rootViewController: userProfileViewController)
        self.userProfileNavViewController = userProfileNavViewController
    }
    
    func tabBarLayout() {
        self.view.addSubview(bottomBarView)
        self.view.addSubview(tabBar)
        self.view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            
            bottomBarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),

        ])
        self.view.layoutIfNeeded()
        NSLayoutConstraint.activate([

            tabBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            bottomBarView.topAnchor.constraint(equalTo: tabBar.topAnchor)
        ])
        self.view.layoutIfNeeded()
        MainTabBarViewController.bottomBarFrame = self.view.convert(bottomBarView.frame, to: nil)
        bottomBarView.backgroundColor = .themeColor
        
    
    }
    
    func layoutSetup() {
        self.view.addSubview(mainNavViewController.view)
        self.view.addSubview(bottomBarView)

        self.view.addSubview(tabBar)

    }
    
    func tabBarSetup() {
        tabBar.isTranslucent = false
        tabBar.standardAppearance.configureWithOpaqueBackground()
        tabBar.scrollEdgeAppearance?.configureWithOpaqueBackground()
       // tabBar
        tabBar.selectedItem?.isEnabled = true
        tabBar.barStyle = .default
        

        tabBar.barTintColor = .themeColor
        let normalConfig = UIImage.SymbolConfiguration(font: .weightSystemSizeFont(systemFontStyle: .title2, weight: .medium))
        let selectedConfig = UIImage.SymbolConfiguration(font: .weightSystemSizeFont(systemFontStyle: .title2, weight: .medium))
        
        let itemImages : [UIImage] = [ UIImage(systemName: "house")!, UIImage(systemName: "person.circle.fill")!]
        
        let items = viewControllers.enumerated().compactMap { (index, nav) in
            let image = itemImages[index]
            let item = UITabBarItem(title: nil, image: image.withConfiguration(normalConfig).withTintColor(.secondaryLabelColor, renderingMode: .alwaysOriginal), selectedImage: image.withConfiguration(selectedConfig).withTintColor(.white, renderingMode: .alwaysOriginal))
            item.tag = index
            return item
            
        }
        tabBar.setItems(items, animated: false)
        tabBar.selectedItem = tabBar.items?.first
        tabBar.delegate = self
    }
    
    func showViewController(at index: Int) {
        let selectedViewController = viewControllers[index]
        
        currentIndex = index
        view.addSubview(selectedViewController.view)
        selectedViewController.didMove(toParent: self)
        for (i, viewController) in viewControllers.enumerated() {
            if i != index {
                viewController.view.removeFromSuperview()
                viewController.removeFromParent()
            }
            
        }
        bottomBarViews.forEach() {
            view.addSubview($0)
        }
        self.tabBar.selectedItem = tabBar.items?[index]
        
    }

}

extension MainTabBarViewController  {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        showViewController(at: item.tag)
    }
}

#Preview {
    let vc = MainTabBarViewController()
    return vc
}
