
import UIKit

class DishDetailViewController : UIViewController{
    
    var dish : Dish!
    var steps : [Step]!
    
    var ingredients : [Ingredient]!
    
    var tableView : UITableView! = UITableView()
    
    var rightBarButton : UIButton! = UIButton()
    
    init(dish : Dish, steps : [Step]!, ingredients : [Ingredient]!) {
        super.init(nibName: nil, bundle: nil)
        self.dish = dish
        self.steps = steps
        self.ingredients = ingredients
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
        config.image = UIImage(systemName: "star")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium))
        rightBarButton.configuration = config
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.rightBarButton)
        rightBarButton.addTarget(self, action: #selector(rightBarButtonTapped ( _ :)), for: .touchUpInside)
    }
    
    @objc func rightBarButtonTapped(_ button : UIButton) {
        collectDish(!dish.collected)
    }
    
    
    func configureButtonStyle(collected : Bool) {
        if collected {
            rightBarButton.configuration?.baseForegroundColor = .yelloTheme
            rightBarButton.configuration?.image = UIImage(systemName: "star.fill")
        } else {
            rightBarButton.configuration?.baseForegroundColor = .primaryLabel
            rightBarButton.configuration?.image = UIImage(systemName: "star")
        }

    }
    
    func navBarStyleSetup() {
        self.navigationController?.navigationBar.standardAppearance.configureWithOpaqueBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance?.configureWithOpaqueBackground()
    }
    
    func collectDish(_ bool : Bool) {
        dish.collected = bool
        configureButtonStyle(collected: dish.collected)
    }

    func registerCell() {
        tableView.register(DishDetailSummaryCell.self, forCellReuseIdentifier: "DishDetailSummaryCell")
        tableView.register(StepIngredientCell.self, forCellReuseIdentifier: "StepIngredientCell")
        tableView.register(DishDetailStepCell.self, forCellReuseIdentifier: "DishDetailStepCell")
        
        //tableView.reg
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DishDetailViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return dish.ingredients?.count ?? 0
        }
        return dish.steps?.count ?? 0
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {

            let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailSummaryCell", for: indexPath) as! DishDetailSummaryCell
            cell.configure(dish : self.dish)
            return cell
        }

        if section == 1 {
            let bounds = UIScreen.main.bounds
            let ingredient = ingredients[row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "StepIngredientCell", for: indexPath) as! StepIngredientCell
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
        
        if section == 2 {
            let step = steps[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailStepCell", for: indexPath) as! DishDetailStepCell
            cell.configure(step : step)
            if row == steps.count - 1 {
                let bounds = UIScreen.main.bounds
                cell.separatorInset = UIEdgeInsets(top: 0, left: bounds.width / 2 , bottom: 0, right: bounds.width / 2)
            } else {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            }
            return cell
        }
        return UITableViewCell()
    }
    

    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }
        if section == 1 {
            return 20
        }
        return 0

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

class DishDetailSummaryCell : UITableViewCell {
    
    var dish : Dish!

    var dishImageView : UIImageView! = UIImageView()
    
    var titleLabel : UILabel = UILabel()
    
    var complexityStackView : UIStackView! = UIStackView()
    
    var costTimeLabel : UILabel = UILabel()
    
    var complexityLabel : UILabel = UILabel()
    

    
    var summaryLabel : UILabel! = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        imageViewSetup()
        labeltSetup()
        stackViewSetup()
        initLayout()
        cellSetup()
    }
    
    func imageViewSetup() {
        dishImageView.contentMode = .scaleAspectFill
        dishImageView.clipsToBounds = true
        dishImageView.layer.cornerRadius = 16
    }
    
    func labeltSetup() {
        titleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)
        titleLabel.numberOfLines = 0
        summaryLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
        summaryLabel.numberOfLines = 0
    }
    func stackViewSetup() {
        complexityStackView.axis = .horizontal
        complexityStackView.spacing = 4
        let starImageView = UIImageView(image: UIImage(systemName: "star.fill")?.withTintColor(.yelloTheme  , renderingMode: .alwaysOriginal))
        complexityStackView.addArrangedSubview(starImageView)
        complexityStackView.addArrangedSubview(complexityLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        
        contentView.addSubview(dishImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(summaryLabel)
        contentView.addSubview(complexityStackView)
        contentView.addSubview(costTimeLabel)
        contentView.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        imageViewLayout()
        stackViewLayout()
        labelLayout()
        
    }
    
    func cellSetup() {
        let screenBounds = UIScreen.main.bounds
        self.separatorInset = UIEdgeInsets(top: 0, left: screenBounds.width / 2, bottom: 0, right: screenBounds.width / 2)
    }
    
    func labelLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: dishImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: dishImageView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: dishImageView.trailingAnchor, constant: -20),
            
            summaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            summaryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            summaryLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            costTimeLabel.centerYAnchor.constraint(equalTo: complexityStackView.centerYAnchor),
            costTimeLabel.trailingAnchor.constraint(equalTo: dishImageView.trailingAnchor, constant: -20),
        ])
    }
    

    
    func stackViewLayout() {
        let screenBounds = UIScreen.main.bounds
        NSLayoutConstraint.activate([
            complexityStackView.leadingAnchor.constraint(equalTo: summaryLabel.leadingAnchor),
            complexityStackView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 20),
            dishImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            complexityStackView.bottomAnchor.constraint(equalTo:  contentView.bottomAnchor, constant: -20),
        ])
    }
    
    func imageViewLayout() {
        let screenBounds = UIScreen.main.bounds
        NSLayoutConstraint.activate([
            dishImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dishImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            dishImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            //dishImageView.bottomAnchor.constraint(equalTo:  contentView.bottomAnchor, constant: -20),
            dishImageView.heightAnchor.constraint(equalToConstant: screenBounds.height * 0.3)
        ])
    }
    
    func configure(dish : Dish) {
        self.dish = dish
        self.titleLabel.text = dish.name
        summaryLabel.text = dish.summary
        costTimeLabel.text = dish.costTime
        complexityLabel.text = dish.complexity.description
        Task {
            dishImageView.image = await dish.getImage()
        }
    }
}



 

