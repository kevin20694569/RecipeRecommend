import UIKit

class CorrectIngredientViewController : UIViewController, UICollectionViewDelegateFlowLayout {
    
    var collectionView : UICollectionView! = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    lazy var keyboardController : KeyBoardController! = KeyBoardController(mainView: self.view)
    
    var photoInputedIngredients : [PhotoInputedIngredient] = []
    
    var photoOutputedIngredients : [Ingredient] = []
    
    var textInputIngredients : [Ingredient] = []
    
    var activeTextField : UITextField?
    
    var activeTextView : UITextView?
    
    var ingredientCellSpacing : CGFloat! = 12
    
    lazy var rightButtonItem : UIBarButtonItem! =  UIBarButtonItem(title: "下一步", image: nil, target: self, action: #selector(rightButtonItemTapped ( _ : )))
    
    @objc func rightButtonItemTapped( _ barButtonItem : UIBarButtonItem) {
        showDishGeneratedOptionViewController()
    }
    
    func showDishGeneratedOptionViewController() {
        
    }
    
    init(photoInputedIngredients : [PhotoInputedIngredient]) {
        super.init(nibName: nil, bundle: nil)
        self.photoInputedIngredients = photoInputedIngredients
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        initLayout()
        registerCell()
        registerCollectionHeaderView()
        collectionViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TapGestureHelper.shared.shouldAddTapGestureInWindow(view: self.view)
    }
    
    func initLayout() {
        view.addSubview(collectionView)
        view.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        view.backgroundColor = .systemBackground
    }
    
    func navBarSetup() {
        self.navigationController?.navigationBar.standardAppearance.configureWithOpaqueBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance?.configureWithOpaqueBackground()
        navigationItem.setRightBarButton(self.rightButtonItem, animated: false)
    }
    
    
    func collectionViewSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: MainTabBarViewController.bottomBarFrame.height + 32, right: 0)
        let flow = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = flow
    }
    
    func registerCell() {
        collectionView.register(IndicatorCollectionCell.self, forCellWithReuseIdentifier:   "IndicatorCollectionCell")
        collectionView.register(DetectedPhotoCollectionViewCollectionCell.self, forCellWithReuseIdentifier: "DetectedPhotoCollectionViewCollectionCell")
        collectionView.register(IngredientTitleLabelCollectionCell.self, forCellWithReuseIdentifier: "IngredientTitleLabelCollectionCell")
        
        collectionView.register(AddTextIngredientCollectionCell.self, forCellWithReuseIdentifier: "AddTextIngredientCollectionCell")
        
        collectionView.register(IngredientTextFieldCollectionCell.self, forCellWithReuseIdentifier: "IngredientTextFieldCollectionCell")
        
    }
    func registerCollectionHeaderView() {
        collectionView.register(LabelHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "LabelHeaderView")
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    

    
}

extension CorrectIngredientViewController : DetectedPhotoCollectionCellDelegate, AddTextIngrdientCollectionCellDelegate {
    func insertNewIngredient(ingredient: Ingredient, section: InputIngredientSection) {
        if section == .Photo {
            photoOutputedIngredients.append(ingredient)
            let insertedIndexPath = IndexPath(row: photoOutputedIngredients.count - 1, section: 2)
            collectionView.insertItems(at: [insertedIndexPath])
        } else {
            textInputIngredients.append(ingredient)
            let insertedIndexPath = IndexPath(row: textInputIngredients.count - 1, section: 3)
            collectionView.insertItems(at: [insertedIndexPath])
        }
    }
    
    func deleteIngredient(ingredient : Ingredient, section: InputIngredientSection) {
        if section == .Photo {
            guard let index = photoOutputedIngredients.firstIndex(of: ingredient) else {
                return
            }
            photoOutputedIngredients.remove(at: index)
            let deletedIndexPath = IndexPath(row: index, section: 2)
            collectionView.deleteItems(at: [deletedIndexPath])
        } else {
            guard let index = textInputIngredients.firstIndex(of: ingredient) else {
                return
            }
            textInputIngredients.remove(at: index)
            let deletedIndexPath = IndexPath(row: index, section: 2)
            collectionView.deleteItems(at: [deletedIndexPath])
        }
        
    }
}

extension CorrectIngredientViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section <= 1 {
            return 1
        }
        if section == 2 {
            return photoOutputedIngredients.count
        }
        return self.textInputIngredients.count + 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let section = indexPath.section
        
        if section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IndicatorCollectionCell", for: indexPath) as! IndicatorCollectionCell
            cell.configure(highlightIndex: 1)
            return cell
        }
        
        if section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetectedPhotoCollectionViewCollectionCell", for: indexPath) as! DetectedPhotoCollectionViewCollectionCell
            cell.delegate = self
            cell.configure(photoInputedIngredients: self.photoInputedIngredients)
            return cell
        }
        
        if section == 2 {
            let ingredient = self.photoOutputedIngredients[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientTitleLabelCollectionCell", for: indexPath) as! IngredientTitleLabelCollectionCell
            
            cell.configure(ingredient: ingredient)
            return cell
        }
        
        if section == 3 {
            let row = indexPath.row
            if row != textInputIngredients.count {
                let ingredient = self.textInputIngredients[row]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientTextFieldCollectionCell", for: indexPath) as! IngredientTextFieldCollectionCell
                cell.textfieldDelegate = self
                cell.configure(ingredient: ingredient)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddTextIngredientCollectionCell", for: indexPath) as! AddTextIngredientCollectionCell
                cell.addTextIngrdientCollectionCellDelegate = self
                cell.configure(buttonEnable: true)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section >= 2 {
            return ingredientCellSpacing
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section >= 2 {
            return ingredientCellSpacing
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section >= 2 {
            return CGSize(width: view.bounds.width, height: view.bounds.height * 0.08)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        let screenBounds = UIScreen.main.bounds
        if section == 0 {
            return CGSize(width: view.bounds.width, height: screenBounds.height * 0.08)
        }
        if section == 1 {
            return CGSize(width: view.bounds.width, height: screenBounds.height * 0.38)
        }
        let size = UIFont.preferredFont(forTextStyle: .title3)
        return CGSize(width: (view.bounds.width - 3 * self.ingredientCellSpacing) / 3, height: size.lineHeight + 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 2 {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LabelHeaderView", for: indexPath) as! LabelHeaderView
            headerView.configure(title: "照片輸入食材")
            return headerView
        }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LabelHeaderView", for: indexPath) as! LabelHeaderView
        headerView.configure(title: "手動輸入食材")
        return headerView
    }
}

extension CorrectIngredientViewController :  UITextFieldDelegate {
    @objc func keyboardShown(notification: Notification) {
        self.keyboardController.keyboardShown(notification: notification, activeTextField: self.activeTextField, activeTextView: self.activeTextView)
    }
    @objc func keyboardHidden(notification: Notification) {
        self.keyboardController.keyboardHidden(notification: notification, activeTextField: self.activeTextField, activeTextView: self.activeTextView)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
}
