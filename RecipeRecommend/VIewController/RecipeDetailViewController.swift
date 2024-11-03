
import UIKit

enum StepStatus  {
    case all, text, image
}

class RecipeDetailViewController : UIViewController, RecipeStatusControll {
    
    var user_id : String { SessionManager.shared.user_id}
    
    var recipe : Recipe!
    
    var reference_recipe : Recipe?
    
    var steps : [Step]!
    
    var ingredients : [Ingredient]!
    
    var preference : RecommendRecipePreference?
    
    var tableView : UITableView! = UITableView()
    
    var heartButton : UIButton! = UIButton()
    
    var rightBarButton : UIButton = UIButton()
    
    var history_generated_recipes : [Recipe] = []

    weak var recipeStatusDelegate : RecipeStatusControll?
    
    init(recipe : Recipe, preference : RecommendRecipePreference? = nil ) {
        super.init(nibName: nil, bundle: nil)
        
        self.recipe = recipe
        self.steps = recipe.steps
        self.ingredients = recipe.ingredients
        self.preference = preference

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetup()
        Task {
            await markAsBrowsed()
            if recipe.is_generated {
                guard let referecne_recipe_id = self.recipe.reference_recipe_id else {
                    return
                }
                await getReferencedRecipe(reference_recipe_id: referecne_recipe_id)
            } else {
                await getGeneratedRecipes(recipe_id: self.recipe.id)
            }
        }
        registerCell()
        
        viewSetup()
        tableViewSetup()
        initLayout()
        navItemSetup()
    }
    
    func getGeneratedRecipes(recipe_id : String, dateThreshold : String? = nil) async {
        do {
            let recipes = try await RecipeManager.shared.getGeneratedRecipesByReferenceRecipeID(reference_recipe_id: recipe_id, user_id: self.user_id, dateThreshold: dateThreshold)
            
            history_generated_recipes.insert(contentsOf: recipes, at: history_generated_recipes.count)
        } catch {
            print(error)
        }
    }
    
    func getReferencedRecipe(reference_recipe_id : String) async {
        do {
            let recipe = try await RecipeManager.shared.getRecipeByRecipeID(recipe_id: reference_recipe_id)
            self.reference_recipe = recipe
            self.rightBarButton.isEnabled = true
        } catch {
            print(error)
        }
    }
    
    func navItemSetup() {
        self.navigationItem.backButtonTitle = ""
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TapGestureHelper.shared.shouldAddTapGestureInWindow(view:  self.view)
    }
    
    func markAsBrowsed() async {
        guard !self.recipe.is_generated else {
            return
        }
        try? await RecipeManager.shared.markRecipeBrowsed(recipe_id: self.recipe.id  )
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarStyleSetup()
        configureRecipeLikedStatus(liked: self.recipe.liked)
    }
    
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.delaysContentTouches = false
        tableView.backgroundColor = .primaryBackground
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func viewSetup() {
        self.view.backgroundColor = .primaryBackground
        let label = UILabel()
        label.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
        label.text = recipe.name
        label.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(displayMoreGeneratedRecipesButtonTapped(_ : )))
        label.addGestureRecognizer(gesture)
        self.navigationItem.titleView = label
    }


    
    func initLayout() {
        [tableView].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -MainTabBarViewController.tabBarFrame.height),
            
            
        ])
    }
    
    func buttonSetup() {
        navigationItem.rightBarButtonItem?.isEnabled = recipe.is_generated
        /*
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .clear

        config.baseForegroundColor = .accent
        
        
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium))
       // rightBarButton.configuration = config*/
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: recipe.is_generated ? "原食譜" : "生成", style: .plain, target: self, action: #selector(rightBarButtonTapped (_ :)))
        
      //  rightBarButton.addTarget(self, action: #selector(rightBarButtonTapped ( _ :)), for: .touchUpInside)
        
    }
    
    func showGenerateOptionsViewController() {
        let controller = GeneratedPreferenceViewController(ingredients: preference?.ingredients ?? [], reference_recipe_id: self.recipe.id)
        self.show(controller, sender: nil)
    }
    
    func showGeneratedRecipesViewController(history_generated_recipes : [Recipe]) {
        
        let controller = GeneratedRecipeSummaryDisplayController(dishes: history_generated_recipes)
        self.show(controller, sender: nil)
    }
    
    func showRecipeDetailViewController(recipe : Recipe) {
        let controller = RecipeDetailViewController(recipe: recipe)
        show(controller, sender: nil)
    }

    
    @objc func rightBarButtonTapped(_ button : UIButton) {
        if self.recipe.is_generated {
            guard let recipe = reference_recipe else {
                return
            }
            showRecipeDetailViewController(recipe: recipe)
        } else {
            showGenerateOptionsViewController()
        }
    }
    
    @objc func displayMoreGeneratedRecipesButtonTapped(_ sender : Any) {
        guard history_generated_recipes.count > 0 else {
            return
        }
        showGeneratedRecipesViewController(history_generated_recipes: history_generated_recipes)
        
    }
    
    func configureRecipeLikedStatus(recipe: Recipe) {
        recipeStatusDelegate?.configureRecipeLikedStatus(recipe: recipe)
    }
    
    func navBarStyleSetup() {
        self.navigationController?.navigationBar.standardAppearance.configureWithTransparentBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance?.configureWithTransparentBackground()
    }
    
    func collectDish(_ bool : Bool) {
        recipe.collected = bool
        configureRecipeLikedStatus(liked: recipe.collected)
    }

    func registerCell() {
        tableView.register(RecipeDetailQuantityAdjustCell.self, forCellReuseIdentifier: "RecipeDetailQuantityAdjustCell")
        tableView.register(RecipeDetailSummaryCell.self, forCellReuseIdentifier: "RecipeDetailSummaryCell")
        tableView.register(RecipeDetailIngredientCell.self, forCellReuseIdentifier: "RecipeDetailIngredientCell")
        tableView.register(RecipeStepCell.self, forCellReuseIdentifier: "RecipeStepCell")
        
        tableView.register(RecipeImageStepCell.self, forCellReuseIdentifier: "RecipeImageStepCell")
        
        
        tableView.register(RecipeTextStepCell.self, forCellReuseIdentifier: "RecipeTextStepCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        guard let ingredients = self.recipe.ingredients else {
            return
        }
        ingredients.forEach() {
            $0.multiplication = 1
        }
    }
}

extension RecipeDetailViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
     /*   if section == 1 {
            return 1
        }*/
        if section == 1 {
            return ingredients.count
        }
        return steps.count
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {

            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetailSummaryCell", for: indexPath) as! RecipeDetailSummaryCell
            cell.recipeStatusDelegate = self
            cell.configure(dish : self.recipe)
            return cell
        }

        
        if section == 1 {
            
            let bounds = UIScreen.main.bounds
            let ingredient = ingredients[row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetailIngredientCell", for: indexPath) as! RecipeDetailIngredientCell
            cell.configure(ingredient: ingredient)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            if row == 0 {
                cell.configureCorners(topCornerMask: true)
                
            } else if row == ingredients.count - 1 {
                cell.configureCorners(topCornerMask: false)
                cell.separatorInset = UIEdgeInsets(top: 0, left: bounds.width / 2, bottom: 0, right: bounds.width / 2)
            } else {
                cell.configureCorners(topCornerMask: nil)
            }
            return cell

        }
        
        
        
        let step = steps[indexPath.row]
        
        var cell : UITableViewCell!
        
        switch step.status {
        case .image :
            cell = tableView.dequeueReusableCell(withIdentifier: "RecipeImageStepCell", for: indexPath) as! RecipeImageStepCell
        case .text :
            cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTextStepCell", for: indexPath) as! RecipeTextStepCell

        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "RecipeStepCell", for: indexPath) as! RecipeStepCell
            break
            
        }
        

        if let cell = cell as? RecipeStepCell {
            cell.configure(step : step)
        }
        
        if row == steps.count - 1 {
            let bounds = UIScreen.main.bounds
            cell.separatorInset = UIEdgeInsets(top: 0, left: bounds.width / 2 , bottom: 0, right: bounds.width / 2)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}



extension RecipeDetailViewController : DishDetailQuantityAdjustCellDelegate {
    func quantityTriggered(to: Int) {
        guard let ingredients = recipe.ingredients else {
            return
        }
        
        for ingredient in ingredients {
            ingredient.multiplication = Double(to)
            if let index = ingredients.firstIndex(of: ingredient) {
                let indexPath = IndexPath(row: index, section: 2)
                if let cell = tableView.cellForRow(at: indexPath) as? RecipeDetailIngredientCell {
                    cell.quantityLabel.text = ingredient.quantityDescription
                    cell.quantityLabel.layoutIfNeeded()
                }
            }
            
        }
    }
    
    
}





 

