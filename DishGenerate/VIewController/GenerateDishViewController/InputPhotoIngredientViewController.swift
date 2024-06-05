import UIKit

class InputPhotoIngredientViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var nextTapButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var cameraInputTableCell : InputPhotoIngredientTableCell {
        return tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! InputPhotoIngredientTableCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let bounds = UIScreen.main.bounds
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IndicatorTableCell", for: indexPath) as! IndicatorTableCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: bounds.width / 2, bottom: 0, right: bounds.width / 2)
            cell.configure(highlightIndex: 0)
            return cell
        }
        if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputPhotoIngredientTableCell", for: indexPath)
            cell.separatorInset = UIEdgeInsets(top: 0, left: bounds.width / 2, bottom: 0, right: bounds.width / 2)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionViewTableCell", for: indexPath)
        return cell
    }
   
    var tableView : UITableView! = UITableView()
    
    func registerCell() {
        tableView.register(CollectionViewTableCell.self, forCellReuseIdentifier: "CollectionViewTableCell")
        tableView.register(StepCollectionViewTableCell.self, forCellReuseIdentifier: "StepCollectionViewTableCell")
        
        tableView.register(IndicatorTableCell.self, forCellReuseIdentifier: "IndicatorTableCell")
        tableView.register(InputPhotoIngredientTableCell.self, forCellReuseIdentifier: "InputPhotoIngredientTableCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetup()
        initLayout()
        buttonLayout()
        registerCell()
        navItemSetup()
        
        tableViewSetup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarSetup()
    }
    
    
    
    func navItemSetup() {
        
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backButtonTitle = ""
        let barButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = barButtonItem
    }
    
    func navBarSetup() {
        self.navigationController?.navigationBar.standardAppearance.configureWithOpaqueBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance?.configureWithOpaqueBackground()
        
    }
    
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.delaysContentTouches = false
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let bounds = UIScreen.main.bounds
        let section = indexPath.section
        
        if section == 0 {
            return bounds.height * 0.08 
        }
        if section == 1 {
            return UITableView.automaticDimension
        }
        return bounds.height * 0.4
    }
    
    
    
    func initLayout() {
        self.view.addSubview(tableView)
        self.view.addSubview(nextTapButton)
        
        view.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
        self.view.backgroundColor = .systemBackground
    }
    
    func buttonLayout() {
        NSLayoutConstraint.activate([
            nextTapButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            nextTapButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24 + -MainTabBarViewController.bottomBarFrame.height),
            
            nextTapButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            nextTapButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
        ])
        
    }
    
    func buttonSetup() {
        var nextTapConfig = UIButton.Configuration.filled()
        let attributedString = AttributedString("下一步", attributes: AttributeContainer([.font : UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)]) )
        let inset : CGFloat = 10
        nextTapConfig.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset * 2, bottom: inset, trailing: inset * 2)
        nextTapConfig.attributedTitle = attributedString
        nextTapConfig.baseBackgroundColor = .orangeTheme
        nextTapButton.configuration = nextTapConfig
        nextTapButton.clipsToBounds = true
        nextTapButton.layer.cornerRadius = 16
        
        nextTapButton.addTarget(self, action: #selector(nextTapButtonTapped ( _ :)), for: .touchUpInside)
    }
    
    @objc func nextTapButtonTapped( _ button : UIButton) {
        showCorrectIngredientViewController()
    }
    
    func showCorrectIngredientViewController() {
        //let staticTitles : [(String, String)] = [("牛肉片", "豬肉片"), ("雞肉", "豬肉"), ("空心菜", "水蓮" )]
        let staticTitles : [(String, String)] = [("牛番茄", "蓮霧"), ("雞蛋", "鱈魚丸"), ("空心菜", "水蓮" )]
        let photoInputedIngredients = cameraInputTableCell.images.enumerated().compactMap { (index, image) in
            let titles = staticTitles[index]
            if let image = image {
                return PhotoInputedIngredient(image: image, leftTitle: titles.0, rightTitle: titles.1)
            }
            return nil
        }
        
        let controller = CorrectIngredientViewController(photoInputedIngredients: photoInputedIngredients)
        show(controller, sender: nil)
        
    }
}
