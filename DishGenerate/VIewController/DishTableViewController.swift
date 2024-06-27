import UIKit
 

class DishTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, ReloadDishDelegate {
    func reloadDish(dish: Dish) {
        guard let index = dishes.firstIndex(of: dish) else {
            return
        }
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? ReloadDishDelegate  {
            cell.reloadDish(dish: dish)
        }
    }
    
    
    var user_id : String = Environment.user_id
    
    var isLoadingNewDishes : Bool = false
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    @objc func handleReloadDishNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo, let dish = userInfo["dish"] as? Dish  {
            reloadDish(dish: dish)
        }
    }
    

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func showInputPhotoIngredientViewController() {
        let controller = InputPhotoIngredientViewController()
        self.show(controller, sender: nil)
        navigationController?.isNavigationBarHidden = false
    }
    
    func showDishDetailViewController(dish : Dish) {
        guard let steps = dish.steps,
              let ingredients = dish.ingredients else {
            return
        }
        let controller = DishDetailViewController(dish: dish, steps: steps, ingredients: ingredients)
        show(controller, sender: nil)
        navigationController?.isNavigationBarHidden = false
    }
    
    func showDishSummaryDisplayController(newDishes : [Dish]) {
        let controller = DishSummaryDisplayController(dishes: newDishes)
        controller.reloadDishDelegate = self

        show(controller, sender: nil)
        navigationController?.isNavigationBarHidden = false

    }
    
    var buttonStatus : DishGenerateStatus! = DishGenerateStatus.none
    
    var generatedDishes : [Dish]?
    
    var dishes : [Dish] = Dish.examples
    
    var searchBar : UISearchBar! = UISearchBar()
    
    var searchBarRightButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var previousOffsetY : CGFloat! = 0

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tableView : UITableView! = UITableView()
    
    var searchBarAnchorConstaint : NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleReloadDishNotification(_:)), name: .reloadDishNotification, object: nil)
        generateButtonSetup()
        tabBarSetup()
        registerCells()
        searchBarSetup()
        navSetup()
        layoutSetup()
        tableViewSetup()
        
        Task {
            //await reloadTableView()
        }
    }
    
    func getDishesOrderByCreatedTime(beforeTimeStamp : String) async {
        do {
            let newDishes = try await DishManager.shared.getDishesOrderByCreatedTime(user_id: self.user_id, beforeTime: beforeTimeStamp)
            insertNewDishes(newDishes : newDishes)
        } catch {
            print("getDishesOrderByCreatedTimeError", error.localizedDescription)
        }
    }
    
    func insertNewDishes(newDishes : [Dish]) {
        let newIndePaths = (dishes.count...dishes.count + newDishes.count - 1).compactMap { index in
            return IndexPath(row: index, section: 0)
        }
        self.dishes.insert(contentsOf: newDishes, at: self.dishes.count)
        tableView.beginUpdates()
        tableView.insertRows(at: newIndePaths, with: .automatic)
        tableView.endUpdates()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TapGestureHelper.shared.shouldAddTapGestureInWindow(view: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarSetup()
    }
    
    func tabBarSetup() {
        let font = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)
        let config = UIImage.SymbolConfiguration(font: font)

        self.tabBarItem = UITabBarItem(title: nil, image:UIImage(systemName: "house")?.withConfiguration(config), selectedImage: UIImage(systemName: "house")?.withConfiguration(config).withTintColor(.themeColor, renderingMode: .alwaysOriginal))
    }
    
    
    func navBarSetup() {
        self.navigationController?.navigationBar.standardAppearance.configureWithTransparentBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance?.configureWithTransparentBackground()
        navigationController?.isNavigationBarHidden = true
    }
    
    func tableViewSetup() {
       
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delaysContentTouches = false
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControllerTriggered( _: )), for: .valueChanged)

    }
    
    @objc func refreshControllerTriggered(_ refreshController : UIRefreshControl) {

        Task {
            await reloadTableView()
        }
    }
    
    func reloadTableView() async {
        do {
            self.dishes.removeAll()
            self.tableView.reloadSections([0], with: .automatic)
            let newDishes = try await DishManager.shared.getDishesOrderByCreatedTime(user_id: self.user_id, beforeTime: "")
            self.insertNewDishes(newDishes: newDishes)
            tableView.refreshControl?.endRefreshing()
            
        } catch {
            print("reloadTableViewErroR", error)
        }
    }
    

    
    
    func registerCells() {
        tableView.register(DishSnapshotCell.self, forCellReuseIdentifier: "DishSnapshotCell")
    }
    
    func navSetup() {
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backButtonTitle = ""
        let barButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = barButtonItem
    }
    
    func layoutSetup() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(searchBar)
        self.view.addSubview(searchBarRightButton)
        self.view.addSubview(tableView)
        self.view.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        searchBarAnchorConstaint = searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        NSLayoutConstraint.activate([
            
           
            
            searchBarAnchorConstaint,
            
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            
            searchBarRightButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            searchBarRightButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            searchBarRightButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -MainTabBarViewController.bottomBarFrame.height),
           

        ])

    }
    
    func generateButtonSetup() {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "menucard")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: .weightSystemSizeFont(systemFontStyle: .title2, weight: .medium))
        searchBarRightButton.configuration = config
        searchBarRightButton.clipsToBounds = true
        searchBarRightButton.layer.cornerRadius = 8
        searchBarRightButton.addTarget(self, action: #selector(searchBarRightButtonTapped ( _ : )), for: .touchUpInside)
    }
    
    
    func changeButtonStatus(status : DishGenerateStatus) {
        buttonStatus = status
        
        switch status {
        case .none :
            var config = UIButton.Configuration.filled()
            config.image = UIImage(systemName: "menucard")
            config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: .weightSystemSizeFont(systemFontStyle: .title2, weight: .medium))
            searchBarRightButton.configuration = config
        case .isGenerating :
            searchBarRightButton.configuration?.image = UIImage(systemName: "arrow.down.circle.dotted")
            searchBarRightButton.configuration?.baseBackgroundColor = .orangeTheme
            let imageView = searchBarRightButton.imageView
            imageView?.translatesAutoresizingMaskIntoConstraints = true
            let rotation = CABasicAnimation(keyPath: "transform.rotation")
            rotation.fromValue = 0
            rotation.toValue = CGFloat.pi * 2
            rotation.duration = 1
            rotation.repeatCount = Float.infinity
            imageView?.layer.add(rotation, forKey: "rotate")
        case .already :
            searchBarRightButton.imageView?.layer.removeAllAnimations()
            searchBarRightButton.configuration?.baseBackgroundColor = .systemGreen
            searchBarRightButton.configuration?.image = UIImage(systemName: "checkmark")
        case .error :
            searchBarRightButton.imageView?.layer.removeAllAnimations()
            searchBarRightButton.configuration?.baseBackgroundColor = .systemRed
            searchBarRightButton.configuration?.image = UIImage(systemName: "exclamationmark.triangle.fill")
        }
        
    }
    
    @objc func searchBarRightButtonTapped( _ sender : UIButton) {
        guard buttonStatus != .isGenerating else {
            return
        }
        if let dishes = generatedDishes  {
            showDishSummaryDisplayController(newDishes: dishes)
        } else {
            showInputPhotoIngredientViewController()
        }
        
    }
    

    
    func searchBarSetup() {
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let offsetY = scrollView.contentOffset.y
        let tableViewHeight = scrollView.bounds.size.height
        if offsetY > contentHeight - tableViewHeight {
            return
        }
        let diffY = scrollView.contentOffset.y - previousOffsetY
        var newConstant: CGFloat = searchBarAnchorConstaint.constant - diffY
       
        if scrollView.contentOffset.y <= 0 {
            UIView.animate(withDuration: 0.1, animations: {
          //      self.searchBarAnchorConstaint.constant = 0
            })
            
            return
        }
        var frame =  CGRect(x: 0, y: view.frame.minY , width: 0, height: searchBar.bounds.height)
        
        if let navigationController = navigationController,
            let navBarFrame = navigationController.navigationBar.superview?.convert(navigationController.navigationBar.frame, to: self.view) {
            frame = navBarFrame
        }
    
        if diffY < 0 {
            newConstant = min( 0  ,newConstant)
        } else if diffY > 0 {
            newConstant = max( -frame.maxY ,newConstant)
        }
        let persent : Float =  Float(1 - abs(newConstant / frame.maxY))

        [searchBar, searchBarRightButton].forEach( ) {
            $0.layer.opacity = persent
        }
        searchBarAnchorConstaint.constant = newConstant
        previousOffsetY = scrollView.contentOffset.y
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dish = dishes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishSnapshotCell", for: indexPath) as! DishSnapshotCell
        cell.configure(dish: dish)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        let dish = dishes[indexPath.row]
        let status = dish.status
        if status == .already {
             showDishDetailViewController(dish: dish)
        } else {
            showDishSummaryDisplayController(newDishes: [dish])
        }
    }
    

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.isSelected = false
        guard !isLoadingNewDishes else {
            return
        }
        guard let created_time = self.dishes.last?.created_Time else {
            return
        }
        if self.dishes.count - indexPath.row == 1 {
            isLoadingNewDishes = true
            
            Task {
                await getDishesOrderByCreatedTime(beforeTimeStamp: created_time )
                isLoadingNewDishes = false
            }
        }
    }
}

