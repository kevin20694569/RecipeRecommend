import UIKit

class DishSummaryDisplayController : UIViewController, UITableViewDelegate, UITableViewDataSource, DishDelegate {
    
    func reloadDish(dish: Dish) {
        guard let index = dishes.firstIndex(where: { oldDish in
            dish.id == oldDish.id
        }) else {
            return
        }
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? DishDelegate  {
            
            cell.reloadDish(dish: dish)
        }
    }
    
    @objc func handleReloadDishNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo, let dish = userInfo["dish"] as? Dish  {
            reloadDish(dish: dish)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    

    var dishes : [Dish]! = []
    
    weak var reloadDishDelegate : DishDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dish = dishes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryDishTableCell", for: indexPath) as! SummaryDishTableCell
        cell.summaryDishTableCellDelegate = self
        cell.configure(dish: dish)
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
    
    
    init(dishes : [Dish]) {
        super.init(nibName: nil, bundle: nil)
        self.dishes = dishes
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleReloadDishNotification(_:)), name: .reloadDishNotification, object: nil)

        registerCell()
        buttonSetup()
        viewSetup()
        tableViewSetup()
        initLayout()
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarSetup()
    }
    
    func viewSetup() {
        self.view.backgroundColor = .primaryBackground
    }
    
    
    func navBarSetup() {
        self.navigationController?.navigationBar.standardAppearance.configureWithOpaqueBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance?.configureWithOpaqueBackground()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", image: nil, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.navBarRightButton)
    }

    
    func initLayout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: MainTabBarViewController.bottomBarFrame.height, right: 0 )
        tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: MainTabBarViewController.bottomBarFrame.height, right: 0 )
        
        if self.dishes.count < 2 {
            self.tableView.isScrollEnabled = false
            tableView.separatorStyle = .none
        }
    }
    
    func registerCell() {
        tableView.register(SummaryDishTableCell.self, forCellReuseIdentifier: "SummaryDishTableCell")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension DishSummaryDisplayController : SummaryDishTableCellDelegate {
}


