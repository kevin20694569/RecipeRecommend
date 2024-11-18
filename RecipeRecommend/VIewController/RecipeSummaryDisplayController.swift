import UIKit

class RecipeSummaryDisplayController : UIViewController, UITableViewDelegate, UITableViewDataSource, RecipeDelegate, RecipeStatusControll {

    
    
    var user_id : String { SessionManager.shared.user_id }
    func configureRecipeLikedStatus(recipe : Recipe) {
        guard let index = self.recipes.firstIndex(of: recipe) else {
            return
        }
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? SummaryRecipeTableCell else {
            return
        }
        cell.configure(recipe: recipe)
    }
    
    var recommendRecipePreference : RecommendRecipePreference?
    
    
    func reloadRecipe(recipe: Recipe) {
        guard let index = recipes.firstIndex(where: { oldDish in
            recipe.id == oldDish.id
        }) else {
            return
        }
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? RecipeDelegate  {
            
            cell.reloadRecipe(recipe: recipe)
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
    
    func getRecipesByPreferencID(preference_id : String) async {
        do {
            let newRecipes = try await RecipeManager.shared.getRecipesByPreferencID(preference_id: preference_id)
            self.recipes.insert(contentsOf: newRecipes, at: recipes.count)
            self.tableView.reloadData()
            if newRecipes.count > 1 {
                tableView.isScrollEnabled = true
            }
        } catch {
            tableView.refreshControl?.endRefreshing()
            print("getRecipesByPreferencIDError", error)
        }
    }
    

    

    var recipes : [Recipe]! = []
    
    var preference_id : String!
    
    weak var reloadDishDelegate : RecipeDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dish = recipes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryRecipeTableCell", for: indexPath) as! SummaryRecipeTableCell
        cell.summaryDishTableCellDelegate = self
        cell.configure(recipe: dish)
        return cell
    }
    
    var navBarRightButton : UIButton! = UIButton()
    
    @objc func navBarightButtonTapped(_ button : UIButton) {
        showInputPhotoIngredientViewController()
    }
    
    func showInputPhotoIngredientViewController() {
        let controller = InputPhotoIngredientViewController()
        self.show(controller, sender: nil)
        navigationController?.isNavigationBarHidden = false
    }
    
    var tableView : UITableView! = UITableView()
    
    
    init(dishes : [Recipe], preference : RecommendRecipePreference? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.recipes = dishes
        self.recommendRecipePreference = preference
    }
    
    
    init(preference_id : String, showRightBarButtonItem : Bool,  preference : RecommendRecipePreference? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.preference_id = preference_id
        self.recommendRecipePreference = preference
        if !showRightBarButtonItem {
            self.navBarRightButton.isHidden = true
        }
        
        Task {
            tableView.refreshControl?.beginRefreshing()
            await getRecipesByPreferencID(preference_id: preference_id)
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleReloadDishNotification(_:)), name: .reloadDishNotification, object: nil)
        navigationItem.title = "AI推薦食譜"

        registerCell()
        buttonSetup()
        viewSetup()
        tableViewSetup()
        initLayout()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TapGestureHelper.shared.shouldAddTapGestureInWindow(view:  self.view)

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarSetup()
    }
    
    func viewSetup() {
        self.view.backgroundColor = .primaryBackground
    }
    
    
    func navBarSetup() {
        self.navigationController?.navigationBar.standardAppearance.configureWithTransparentBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance?.configureWithTransparentBackground()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.navBarRightButton)
    }

    
    func initLayout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -MainTabBarViewController.tabBarFrame.height),
        ])
    }
    
    func buttonSetup() {

        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "menucard")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: .weightSystemSizeFont(systemFontStyle: .body, weight: .medium))
        navBarRightButton.configuration = config

        self.navBarRightButton.addTarget(self, action: #selector(navBarightButtonTapped ( _ :)), for: .touchUpInside)
    }
    
    func tableViewSetup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.delaysContentTouches = false
        tableView.allowsSelection = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.backgroundColor = .primaryBackground
        
        if self.recipes.count < 2 {
            self.tableView.isScrollEnabled = false
            tableView.separatorStyle = .none
        }
    }
    
    func registerCell() {
        tableView.register(SummaryRecipeTableCell.self, forCellReuseIdentifier: "SummaryRecipeTableCell")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? SummaryRecipeTableCell {
            if cell.tagCollectionView.visibleCells.count > 0 {
                let firstIndexPath : IndexPath = IndexPath(row: 0, section: 0)
                cell.tagCollectionView.scrollToItem(at: firstIndexPath, at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? SummaryRecipeTableCell {
            
            cell.tagCollectionView.reloadSections([0])
        }
        
    }
    
}

extension RecipeSummaryDisplayController : SummaryRecipeTableCellDelegate {

    func configureLikedHeart(recipe : Recipe) {
        
    }
    
    func showRecipeDetailViewController(recipe : Recipe) {
        guard let steps = recipe.steps,
              let ingredients = recipe.ingredients else {
            return
        }
        
        let controller = RecipeDetailViewController(recipe: recipe, preference: self.recommendRecipePreference)
        controller.recipeStatusDelegate = self
        self.show(controller, sender: nil)

    }
    
}




