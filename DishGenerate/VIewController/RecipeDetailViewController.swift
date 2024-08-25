
import UIKit

enum StepStatus  {
    case all, text, image
}

class RecipeDetailViewController : UIViewController, RecipeStatusControll {
    
    var recipe : Recipe!
    var steps : [Step]!
    
    var ingredients : [Ingredient]!
    
    var tableView : UITableView! = UITableView()
    
    var rightBarButton : UIButton! = UIButton()
    

    
    weak var recipeStatusDelegate : RecipeStatusControll?
    
    init(recipe : Recipe, steps : [Step]!, ingredients : [Ingredient]!) {
        super.init(nibName: nil, bundle: nil)
        self.recipe = recipe
        self.steps = steps
        self.ingredients = ingredients
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await markAsBrowsed()
        }
        registerCell()
        buttonSetup()
        viewSetup()
        tableViewSetup()
        initLayout()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TapGestureHelper.shared.shouldAddTapGestureInWindow(view:  self.view)
        let bottomInset = MainTabBarViewController.bottomBarFrame.height - self.view.safeAreaInsets.bottom
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        self.tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
    }
    
    func markAsBrowsed() async {
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
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: MainTabBarViewController.bottomBarFrame.height, right: 0 )
        tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: MainTabBarViewController.bottomBarFrame.height, right: 0 )
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func viewSetup() {
        self.view.backgroundColor = .primaryBackground
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
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        
        ])
    }

    func buttonSetup() {
        /*var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .themeColor
        config.image = UIImage(systemName: "waterbottle")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .medium))
        rightBarButton.configuration = config*/
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .primaryLabel
        config.image = UIImage(systemName: "heart")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium))
        rightBarButton.configuration = config
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.rightBarButton)
        rightBarButton.addTarget(self, action: #selector(rightBarButtonTapped ( _ :)), for: .touchUpInside)
    }
    
    @objc func rightBarButtonTapped(_ button : UIButton) {
        recipe.liked.toggle()
        configureRecipeLikedStatus(liked: recipe.liked)
        recipeStatusDelegate?.configureRecipeLikedStatus(recipe: recipe)
        Task {
            try await RecipeManager.shared.markAsLiked(recipe_id: self.recipe.id, like: recipe.liked)
        }
    }
    
    
    func configureRecipeLikedStatus(liked : Bool) {
        if liked {
            rightBarButton.configuration?.baseForegroundColor = .systemRed
            rightBarButton.configuration?.image = UIImage(systemName: "heart.fill")
        
        } else {
            rightBarButton.configuration?.baseForegroundColor = .primaryLabel
            rightBarButton.configuration?.image = UIImage(systemName: "heart")
        }

    }
    
    func navBarStyleSetup() {
        self.navigationController?.navigationBar.standardAppearance.configureWithOpaqueBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance?.configureWithOpaqueBackground()
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





 

