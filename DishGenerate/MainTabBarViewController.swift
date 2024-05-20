import UIKit

class MainTabBarViewController : UIViewController {
    
    static let shared : MainTabBarViewController! = MainTabBarViewController()
    
    var mainNavViewController : MainNavgationController!
    
    static var bottomBarFrame : CGRect! = .zero
    
    var currentIndex : Int! = 0
    
    var tabBar : UITabBar! = UITabBar()
    
    var bottomBarView : UIView! = UIView()
    
    var viewControllers : [UINavigationController]! = []
    
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
    
    func childViewControllersSetup() {
        let mainTableViewController = DishTableViewController()
        self.mainNavViewController = MainNavgationController(rootViewController: mainTableViewController)
    }
    
    func tabBarLayout() {
        self.view.addSubview(bottomBarView)
        self.view.addSubview(tabBar)
        bottomBarView.backgroundColor = .tintColor
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
            bottomBarView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -tabBar.bounds.height),
            tabBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 40)
        ])
        self.view.layoutIfNeeded()
        MainTabBarViewController.bottomBarFrame = self.view.convert(bottomBarView.frame, to: nil)

        
    
    }
    
    func layoutSetup() {
        self.view.addSubview(mainNavViewController.view)
        self.view.addSubview(bottomBarView)
        self.view.addSubview(tabBar)
        
  
        self.view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            mainNavViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            mainNavViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mainNavViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainNavViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        
        ])

    }
    
    func tabBarSetup() {
        tabBar.isTranslucent = false
        tabBar.standardAppearance.configureWithOpaqueBackground()
        tabBar.scrollEdgeAppearance?.configureWithOpaqueBackground()
       // tabBar
    

        tabBar.selectedItem?.isEnabled = true
        tabBar.barStyle = .default
        
        tabBar.backgroundColor = .tintColor
        tabBar.barTintColor = .tintColor
        //tabBar.barTintColor = .tintColor
        let normalConfig = UIImage.SymbolConfiguration(font: .weightSystemSizeFont(systemFontStyle: .title2, weight: .medium))
        let selectedConfig = UIImage.SymbolConfiguration(font: .weightSystemSizeFont(systemFontStyle: .title2, weight: .medium))
        let mainDishTableViewItem = UITabBarItem(title: nil, image: UIImage(systemName: "house")!.withConfiguration(normalConfig).withTintColor(.secondaryLabelColor, renderingMode: .alwaysOriginal), selectedImage: UIImage(systemName: "house")!.withConfiguration(selectedConfig).withTintColor(.white, renderingMode: .alwaysOriginal))
        
        tabBar.setItems([mainDishTableViewItem], animated: false)
        tabBar.selectedItem = mainDishTableViewItem
    }
    
    @objc func tabBarButtonTapped(_ sender: UIButton) {
        // 在按鈕點擊時切換到相應的視圖
        if let index = tabBar.subviews.firstIndex(of: sender) {
            showViewController(at: index)
        }
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
        
        self.tabBar.selectedItem = tabBar.items?[index]
        
    }
    
    

}

#Preview {
    let vc = MainTabBarViewController()
    return vc
}
