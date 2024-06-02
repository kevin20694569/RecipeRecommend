
import UIKit

class DishDetailViewController : UIViewController{
    
    var dish : Dish!
    
    var tableView : UITableView! = UITableView()
    
    var rightBarButton : UIButton! = UIButton()
    
    init(dish : Dish) {
        super.init(nibName: nil, bundle: nil)
        self.dish = dish
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        buttonSetup()
        viewSetup()
        tableViewSetup()
        initLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarStyleSetup()
    }
    
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.delaysContentTouches = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: MainTabBarViewController.bottomBarFrame.height, right: 0 )
        tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: MainTabBarViewController.bottomBarFrame.height, right: 0 )
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
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .themeColor
        config.image = UIImage(systemName: "waterbottle")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .medium))
        rightBarButton.configuration = config
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.rightBarButton)
    }
    
    
    func navBarStyleSetup() {
        self.navigationController?.navigationBar.standardAppearance.configureWithOpaqueBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance?.configureWithOpaqueBackground()
    }
    
    func buttonStatusUpdate(transformIntoStep : Bool) {
        //UIImage(systemName: "paperplane.fill")
    }

    func registerCell() {
        
        tableView.register(StepIngredientCell.self, forCellReuseIdentifier: "StepIngredientCell")
        tableView.register(DishDetailStepCell.self, forCellReuseIdentifier: "DishDetailStepCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DishDetailViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return dish.steps.count
             
        }
        return dish.ingredients.count
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        if section == 1 {
            let step = dish.steps[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailStepCell", for: indexPath) as! DishDetailStepCell
            cell.configure(step : step)
            if row == self.dish.steps.count - 1 {
                let bounds = UIScreen.main.bounds
                cell.separatorInset = UIEdgeInsets(top: 0, left: bounds.width / 2 , bottom: 0, right: bounds.width / 2)
            } else {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            }
            return cell
        }
        let bounds = UIScreen.main.bounds
        let ingredient = dish.ingredients[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "StepIngredientCell", for: indexPath) as! StepIngredientCell
        cell.configure(ingredient: ingredient)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        if row == 0 {
            cell.configureCorners(topCornerMask: true)
            
        } else if row == dish.ingredients.count - 1 {
            cell.configureCorners(topCornerMask: false)
            cell.separatorInset = UIEdgeInsets(top: 0, left: bounds.width / 2, bottom: 0, right: bounds.width / 2)
        } else {
            cell.configureCorners(topCornerMask: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        if section == 1 {
            return 20
        }
        return 0

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}



 

