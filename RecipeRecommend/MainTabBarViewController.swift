import UIKit

class MainTabBarViewController : UIViewController, UITabBarDelegate {
    
    static var shared : MainTabBarViewController! = MainTabBarViewController()
    
    var mainNavViewController : MainNavgationController!
    
    var userProfileNavViewController : UserProfileNavViewController!
    
   // var savedDishesNavViewController : UINavigationController!
    
    var preferenceNavViewController : UINavigationController!
    
    static var bottomBarFrame : CGRect! = .zero
    
    var currentIndex : Int! = 0
    
    var tabBar : UITabBar! = UITabBar()
    
    var bottomBarView : UIView! = UIView()
    
    lazy var viewControllers : [UINavigationController] = []
    
    var itemImages : [UIImage] = [ UIImage(systemName: "rectangle.and.pencil.and.ellipsis.rtl")!  ,UIImage(systemName: "house")!,  UIImage(systemName: "person.circle")!]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarLayout()
        childViewControllersSetup()
        layoutSetup()
        tabBarSetup()
        MainTabBarViewController.bottomBarFrame = self.view.convert(bottomBarView.frame, to: nil)
        self.view.backgroundColor = .primaryBackground
    }
    
    static var tabBarFrame : CGRect = .zero
    
    
    lazy var bottomBarViews : [UIView] = [bottomBarView, tabBar]
    
    func childViewControllersSetup() {
        self.preferenceNavViewController = UINavigationController(rootViewController: DisplayPreferenceViewController())
        let mainTableViewController = RecipeTableViewController()
        

        self.mainNavViewController = MainNavgationController(rootViewController: mainTableViewController)
        mainNavViewController.mainRecipeViewController = mainTableViewController
        
        let userProfileViewController = UserProfileViewController()
        let userProfileNavViewController = UserProfileNavViewController(rootViewController: userProfileViewController)
        self.userProfileNavViewController = userProfileNavViewController
        viewControllers.insert(contentsOf: [preferenceNavViewController, mainNavViewController, userProfileNavViewController], at: 0)
        

       
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
            bottomBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)

        ])
        self.view.layoutIfNeeded()
        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),

            bottomBarView.topAnchor.constraint(equalTo: tabBar.topAnchor)
        ])
        self.view.layoutIfNeeded()
        
        bottomBarView.backgroundColor = .themeColor

        
        MainTabBarViewController.tabBarFrame = self.view.convert(tabBar.frame, to: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func layoutSetup() {
        showViewController(at: 1)
        self.view.addSubview(bottomBarView)
        self.view.addSubview(tabBar)
        
    }
    
    func tabBarSetup() {
        tabBar.isTranslucent = false
        tabBar.standardAppearance.configureWithOpaqueBackground()
        tabBar.scrollEdgeAppearance?.configureWithOpaqueBackground()
        tabBar.selectedItem?.isEnabled = true

        tabBar.barStyle = .default

        tabBar.barTintColor = .themeColor

        //tabBar.barTintColor = .clear
        let normalConfig = UIImage.SymbolConfiguration(font: .weightSystemSizeFont(systemFontStyle: .title2, weight: .bold))
        let selectedConfig = UIImage.SymbolConfiguration(font: .weightSystemSizeFont(systemFontStyle: .title2, weight: .bold))
        
        let items = viewControllers.enumerated().compactMap { (index, nav) in
            let image = itemImages[index]
            print(UIColor.color950)
            let item = UITabBarItem(title: nil, image: image.withConfiguration(normalConfig).withTintColor(.primaryLabel, renderingMode: .alwaysOriginal), selectedImage: image.withConfiguration(selectedConfig).withTintColor(.primaryBackground, renderingMode: .alwaysOriginal))
            item.tag = index
            return item
        }
        tabBar.setItems(items, animated: false)
        tabBar.selectedItem = tabBar.items?[1]
        tabBar.delegate = self

 
        MainTabBarViewController.tabBarFrame = self.view.convert(tabBar.frame, to: nil)
    }
    
    
    
    func showViewController(at index: Int) {
        let selectedViewController = viewControllers[index]
        if currentIndex == index {
            selectedViewController.popToRootViewController(animated: true)
            return
        }
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
    
    func getTopViewController() -> UIViewController? {
        guard !viewControllers.isEmpty else {
            return nil
        }
        var topController : UIViewController = viewControllers[self.currentIndex]

        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }

        return topController
    }
}


extension MainTabBarViewController  {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        showViewController(at: item.tag)
    }
}

extension UIColor {
    // 初始化方法，接受 HEX 色碼（格式: #RRGGBB 或 RRGGBB）
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}


