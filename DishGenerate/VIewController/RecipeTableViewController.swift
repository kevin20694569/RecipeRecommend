import UIKit

enum insertFuncToArray {
    case unshift, push
}

enum DisplayRecipeStatus {
    case Liked
    case Search
}
 

class RecipeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, ShowRecipeViewControllerDelegate {
    
    func reloadRecipe(recipe: Recipe) {
        guard let index = recipes.firstIndex(where: { oldDish in
            recipe.id == oldDish.id
        }) else {
            return
        }
        recipes[index] = recipe
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? RecipeDelegate  {
            cell.reloadRecipe(recipe: recipe)
        }
    }
    
    var status : DisplayRecipeStatus = .Liked
    
    var user_id : String {SessionManager.shared.user_id!}
    
    var isLoadingNewDishes : Bool = false
    
    var searchRecipes : [Recipe] = []
    
    var searchBarIsEditing : Bool = false
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBarIsEditing = true
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text,
           query.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            Task {
                do {
                    let newRecipes = try await RecipeManager.shared.searchRecipesInLikedByQuery(query: query)
                    tableView.beginUpdates()
                    searchRecipes.removeAll()
                    searchRecipes.insert(contentsOf: newRecipes, at: searchRecipes.count)
                    status = .Search
                    tableView.reloadSections([0], with: .automatic)
                    tableView.endUpdates()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarIsEditing = false
        guard status != .Liked else {
            return
        }
        if searchBar.text == nil || searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  {
            Task {
                status = .Liked
                await self.reloadTableView()
            }
        }
        
    }
    
    @objc func handleReloadDishNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo, let dish = userInfo["recipe"] as? Recipe  {
            reloadRecipe(recipe: dish)
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
    

    
    var buttonStatus : DishGenerateStatus! = DishGenerateStatus.none
    
    var generatedDishes : [Recipe]?//= Dish.examples
    
    var generatedPreference : DishPreference?
    
    var generatedRecipesIsAppended : Bool = false
    
    var recipes : [Recipe] = []
    
    var searchBar : UISearchBar! = UISearchBar()
    
    var searchBarRightButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var previousOffsetY : CGFloat! = 0

    init() {
        super.init(nibName: nil, bundle: nil)
        tableViewSetup()
        layoutSetup()
        Task {
            await reloadTableView()
        }

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
        
        
        if generatedDishes != nil {
            changeButtonStatus(status: .already)
        }

    }

    
    

    
    func insertNewRecipes(newRecipes : [Recipe], insertFunc: insertFuncToArray ) {
        
        let newIndexPaths = (recipes.count...recipes.count + newRecipes.count - 1).compactMap { index in
            return IndexPath(row: index, section: 0)
        }
        if insertFunc == .unshift {
            self.recipes.insert(contentsOf: newRecipes, at: 0)
        } else {
            self.recipes.insert(contentsOf: newRecipes, at: self.recipes.count)
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: newIndexPaths, with: .automatic)
        tableView.endUpdates()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TapGestureHelper.shared.shouldAddTapGestureInWindow(view: self.view)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: MainTabBarViewController.bottomBarFrame.height + 16, right: 0)
            
        
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
        

        tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: MainTabBarViewController.bottomBarFrame.height, right: 0)
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
        defer {
            tableView.refreshControl?.endRefreshing()
        }
        do {
            let newRecipes = try await RecipeManager.shared.getLikedRecipesByDateThresold(dateThresold: "")
            tableView.beginUpdates()
            self.recipes.removeAll()
            self.recipes.append(contentsOf: newRecipes)
            tableView.refreshControl?.endRefreshing()
            tableView.reloadSections([0], with: .automatic)
            tableView.endUpdates()
        } catch {
            print("reloadTableViewError", error)
        }
    }
    

    

    
    
    func registerCells() {
        tableView.register(RecipeSnapshotCell.self, forCellReuseIdentifier: "DishSnapshotCell")
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
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
           

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
            showRecipeSummaryDisplayController(recipes: dishes)
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
                self.searchBarAnchorConstaint.constant = 0
                
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
        var recipe : Recipe
        let row = indexPath.row
        if status == .Liked {
            recipe = recipes[row]
        } else {
            recipe = searchRecipes[row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishSnapshotCell", for: indexPath) as! RecipeSnapshotCell
        cell.configure(recipe: recipe)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return status == .Liked ? recipes.count : searchRecipes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard !searchBarIsEditing else {
            return
        }
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        var recipe : Recipe
        switch self.status {
        case .Liked:
            recipe = recipes[indexPath.row]
        case .Search:
            recipe = self.searchRecipes[indexPath.row]
        }
        showRecipeDetailViewController(recipe: recipe)
    }
    

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !isLoadingNewDishes else {
            return
        }
       /* guard let created_time = self.recipes.last?.created_Time else {
            return
        }
        if self.recipes.count - indexPath.row == 12 {
            isLoadingNewDishes = true
            
            Task {
                let newDishes = try await RecipeManager.shared.getDishesOrderByCreatedTime(user_id: self.user_id, beforeTime: created_time)
                
                insertNewRecipes(newDishes: newDishes, insertFunc: .push)
                isLoadingNewDishes = false
            }
        }*/
    }
}

