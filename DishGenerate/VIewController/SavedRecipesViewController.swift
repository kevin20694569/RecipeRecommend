import UIKit

enum SaveDishDisplayStatus {
    case liked, collect
    
    var title : String {
        switch self {
        case .liked :
            return "喜歡"
        case .collect :
            return "收藏"
        }
    }
}

class SavedRecipesViewController : UIViewController, ShowRecipeViewControllerDelegate  {
    
    func reloadRecipe(recipe: Recipe) {
        
    }
    
    
    var collectionView : UICollectionView! = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    var titleView : UIView! = UIView()
    
    var titleButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var displayStatus : SaveDishDisplayStatus! = .liked
    
    var collectedDishes : [Recipe] = Recipe.examples
    
    var likedDishes : [Recipe] = Recipe.examples
    
    var buttonAttributes : AttributeContainer = AttributeContainer([.font : UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium), .foregroundColor : UIColor.primaryLabel])
    
    func viewSetup() {
        view.backgroundColor = .primaryBackground
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    func buttonSetup() {
        let attString = AttributedString(self.displayStatus.title, attributes: buttonAttributes)

        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .clear
        config.attributedTitle = attString
        config.image = UIImage(systemName: "arrowtriangle.down.fill")?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: UIFont.weightSystemSizeFont(systemFontStyle: .footnote, weight: .medium))
        config.imagePlacement = .trailing
        config.imagePadding = 8
        titleButton.configuration = config
        let menu = UIMenu(options: .singleSelection, children: [
            UIAction(title: "喜歡", image : UIImage(systemName: "heart.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal), state : .on, handler: { action in
                self.menuActionTriggerd(status: .liked)
                
                
            }),
            UIAction(title: "收藏",image : UIImage(systemName: "star.fill")?.withTintColor(.yelloTheme, renderingMode: .alwaysOriginal), handler: { action in
                self.menuActionTriggerd(status: .collect)
            })
        
        ])
        
        menu.preferredElementSize = .large

        titleButton.showsMenuAsPrimaryAction = true
        titleButton.menu = menu
    }
    
    func menuActionTriggerd(status : SaveDishDisplayStatus) {
        self.displayStatus = status

        let attString = AttributedString(status.title, attributes: buttonAttributes)
        titleButton.configuration?.attributedTitle = attString
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        registerCell()
        navItemSetup()
        buttonSetup()
        collectionViewSetup()
        
        initLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarSetup()
        
    }
    
    func navBarSetup() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func navItemSetup() {
        self.navigationItem.backButtonTitle = ""
    }
    
    func collectionViewSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let flow = UICollectionViewFlowLayout()
        self.collectionView.collectionViewLayout = flow
    }
    
    
    func initLayout() {
        [collectionView, titleView, titleButton].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        let screenBounds = UIScreen.main.bounds
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleView.heightAnchor.constraint(equalToConstant: screenBounds.height * 0.08),
            
            titleButton.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 20),
            titleButton.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            
            
            collectionView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
        ])
    }
    
    func registerCell() {
        collectionView.register(SavedDishCell.self, forCellWithReuseIdentifier: "SavedDishCell")
    }
}

extension SavedRecipesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch displayStatus {
        case .liked :
            return likedDishes.count
        case .collect :
            return collectedDishes.count
        default :
            break
        }
        return likedDishes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var dishes = self.likedDishes
        if displayStatus == .collect {
            dishes = collectedDishes
        }
        let dish = dishes[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedDishCell", for: indexPath) as! SavedDishCell
        
        cell.configure(dish: dish)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = view.bounds
        return CGSize(width: (bounds.width - 6)  / 3, height: bounds.height * 0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.visibleCells.forEach() {
            $0.isSelected = false
        }
        var dishes = self.likedDishes
        if displayStatus == .collect {
            dishes = collectedDishes
        }
        let dish = dishes[indexPath.row]
        showRecipeDetailViewController(dish: dish)
    }
    
    
}
