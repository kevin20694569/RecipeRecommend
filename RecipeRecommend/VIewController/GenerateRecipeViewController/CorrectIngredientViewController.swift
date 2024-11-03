import UIKit

class CorrectIngredientViewController : UIViewController, UICollectionViewDelegateFlowLayout, IngredientAddButtonHeaderViewDelegate, KeyBoardControllerDelegate, CheckingIngredientsViewDelegate {
    
    
    
    var collectionView : UICollectionView! = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    lazy var keyboardController : KeyBoardController! = KeyBoardController(view: self.view, delegate: self)
    
    var photoInputedIngredients : [PhotoInputedIngredient]?
    
    var photoOutputedIngredients : [Ingredient] = []
    
    var textInputIngredients : [Ingredient] = []
    
    var activeTextField : UITextField?
    
    var activeTextView : UITextView?
    
    var ingredientCellSpacing : CGFloat! = 12
    
    var editModeEnable : Bool = false
    
    var recognizeResults : [[RecognizeImageJson]]?
    
    var user_id : String {SessionManager.shared.user_id!}
    
    let checkingView = CheckingIngredientsView()


    
    let photoInputedIndexPath : IndexPath = IndexPath(row: 0, section: 1)
    
    lazy var rightButtonItem : UIBarButtonItem! =  UIBarButtonItem(title: "下一步", style: .done , target: self, action: #selector(rightButtonItemTapped ( _ : )))
    
    
    @objc func rightButtonItemTapped( _ barButtonItem : UIBarButtonItem) {
        
        showCheckingIngredientsView()
       // generateRecommendRecipes()
        //showDishGeneratedOptionViewController()
    }
    
    func showCheckingIngredientsView() {
        guard checkingView.layer.opacity == 0 else {
            return
        }
        let validIngredients  = outputCurrentValidIngredients()
        checkingView.configure(ingredients: validIngredients)
        view.subviews.forEach() {
            $0.isUserInteractionEnabled = false
        }
        navigationController?.navigationBar.isUserInteractionEnabled = false
        checkingView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.2, animations: {
            self.checkingView.layer.opacity = 1
        })
       
    }
    
    func dismissView() {
        guard checkingView.layer.opacity == 1 else {
            return
        }
        view.subviews.forEach() {
            $0.isUserInteractionEnabled = true
        }
        navigationController?.navigationBar.isUserInteractionEnabled = true
        checkingView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2, animations: {
            self.checkingView.layer.opacity = 0
        })
    }
    
    func layoutCheckingView() {
        checkingView.delegate = self
        checkingView.layer.opacity = 0
        NSLayoutConstraint.activate([
            
            checkingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.1),
            checkingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.1),
            checkingView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            checkingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
        ])
    }
    
    func generateRecommendRecipes()  {
        let validIngredients  = outputCurrentValidIngredients()
        let preference = RecommendRecipePreference(id: UUID().uuidString, user_id: self.user_id, ingredients: validIngredients)
        if let nav = navigationController as? MainNavgationController {
            if let mainTableController = nav.mainRecipeViewController {
                mainTableController.recommendedPreference = preference
                mainTableController.changeButtonStatus(status: .isGenerating)
                
                
                Task {
                    let viewControllers = nav.popToRootViewController(animated: true)
                    
                    mainTableController.lastGeneratedViewControllers = viewControllers
                    do {
                        
                        
                        let (preference, recipes) = try await RecipeManager.shared.getRecommendRecipes(user_id: self.user_id, preference: preference)
                        mainTableController.recommendedRecipes = recipes
                        mainTableController.recommendedPreference = preference
                        mainTableController.changeButtonStatus(status: .already)
                        
                    } catch {
                       // try? await Task.sleep(nanoseconds: 1000000000)
                        mainTableController.changeButtonStatus(status: .error)
                        print("getRecommendRecipesError", error)
                    }
                    

                }
                
                
            }
        }
    }
    
    func outputCurrentValidIngredients() -> [Ingredient] {
        var ingredients : [Ingredient] = self.photoOutputedIngredients.filter { ingredient in
            return ingredient.name != nil && ingredient.name != ""
        }
        let textOuputed = self.textInputIngredients.filter { ingredient in
            return ingredient.name != nil && ingredient.name != ""
        }
        ingredients += textOuputed
        
        return ingredients
    }
    
    func showDishGeneratedOptionViewController() {
        let ingredients = outputCurrentValidIngredients()
        let controller = RecipeGeneratedOptionViewController(ingredients: ingredients)
        show(controller, sender: nil)
    }
    
    init(photoInputedIngredients : [PhotoInputedIngredient]?) {
        super.init(nibName: nil, bundle: nil)
        self.photoInputedIngredients = photoInputedIngredients
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        Task {
            await recognizeImages()
        }
        initLayout()
        registerCell()
        registerCollectionHeaderView()
        collectionViewSetup()
        view.backgroundColor = .primaryBackground
        
    }
    
    func recognizeImages() async  {
        do {
            guard let ingredients = photoInputedIngredients,
                  ingredients.count > 0 else {
                return
            }
            let images : [UIImage] = ingredients.map { ingredient in
                return ingredient.image
            }
            let recognizeResults = try await RecognizeImageManager.shared.recognizeImages(images: images, user_id: user_id)
            ingredients.enumerated().forEach() { index, ingredient in
                ingredient.leftPropablyTitle = ingredient.getTranslatedName(key: recognizeResults[index][0].name)
                ingredient.rightPropablyTitle = ingredient.getTranslatedName(key: recognizeResults[index][1].name)
            }
            if let cell = self.collectionView.cellForItem(at: photoInputedIndexPath) as? DetectedPhotoCollectionViewCollectionCell  {
                for (index, ingredient) in ingredients.enumerated() {
                    let indexPath = IndexPath(row: index, section: 0)
                    if let collectionCell = cell.collectionView.cellForItem(at: indexPath) as? DetectedPhotoCollectionCell {
                        collectionCell.configure(inputedIngredient: ingredient, outputedIngredient: ingredient.outputedIngredient)
                    }
                }
            }
        } catch {
            print(error)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarSetup()
        let ingredients = outputCurrentValidIngredients()
        rightButtonItem.isEnabled = ingredients.count > 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TapGestureHelper.shared.shouldAddTapGestureInWindow(view: self.view)
    }
    
    func initLayout() {
        [collectionView, checkingView].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -MainTabBarViewController.tabBarFrame.height),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        layoutCheckingView()
        view.backgroundColor = .systemBackground
    }
    
    func navBarSetup() {
        self.navigationController?.navigationBar.standardAppearance.configureWithTransparentBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance?.configureWithTransparentBackground()
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backButtonTitle = ""
     //   rightButtonItem.isEnabled = false
     
        navigationItem.setRightBarButton(self.rightButtonItem, animated: false)
    }
    
    func navItemSetup() {
        self.navigationItem.backButtonTitle = ""
    }
    
    
    func collectionViewSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delaysContentTouches = false
        collectionView.allowsSelection = true
        collectionView.backgroundColor = .primaryBackground
        collectionView.showsVerticalScrollIndicator = false
        
        let flow = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = flow
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
        
        
    }
    
    func registerCell() {
        collectionView.register(IndicatorCollectionCell.self, forCellWithReuseIdentifier:   "IndicatorCollectionCell")
        collectionView.register(DetectedPhotoCollectionViewCollectionCell.self, forCellWithReuseIdentifier: "DetectedPhotoCollectionViewCollectionCell")

        
        collectionView.register(AddTextIngredientCollectionCell.self, forCellWithReuseIdentifier: "AddTextIngredientCollectionCell")
        

        
        collectionView.register(IngredientTitleLabelCenterCollectionCell.self, forCellWithReuseIdentifier: "IngredientTitleLabelCenterCollectionCell")
        
        collectionView.register(IngredientTitleLabelLeadingCollectionCell.self, forCellWithReuseIdentifier: "IngredientTitleLabelLeadingCollectionCell")
        
        collectionView.register(IngredientTitleLabelTrailingCollectionCell.self, forCellWithReuseIdentifier: "IngredientTitleLabelTrailingCollectionCell")
        
        
        collectionView.register(IngredientTextFieldCenterCollectionCell.self, forCellWithReuseIdentifier: "IngredientTextFieldCenterCollectionCell")
        
        collectionView.register(IngredientTextFieldLeadingCollectionCell.self, forCellWithReuseIdentifier: "IngredientTextFieldLeadingCollectionCell")
        
        collectionView.register(IngredientTextFieldTrailingCollectionCell.self, forCellWithReuseIdentifier: "IngredientTextFieldTrailingCollectionCell")
        
        
        
        
    }
    func registerCollectionHeaderView() {
        collectionView.register(LabelHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "LabelHeaderView")
        
        collectionView.register(AddButtonHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "AddButtonHeaderView")
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}

extension CorrectIngredientViewController : DetectedPhotoCollectionCellDelegate, AddButtonHeaderViewDelegate {
    
    func editModeToggleTo(type : AddButtonHeaderViewType) {
        guard self.textInputIngredients.count > 0 else {
            return
        }
        switch type {
        case .ingredient :
            editModeEnable.toggle()
            
            self.collectionView.visibleCells.forEach() {
                guard let indexPath = self.collectionView.indexPath(for: $0),
                      indexPath.section == 3 else {
                    return
                }
                if let cell = $0 as? HorizontalBackgroundAnchorSideCell {
                    cell.editModeToggleTo(enable: editModeEnable)
                }
            }
        default :
            break
        }
    }
    
    func insertNewIngredient(ingredient: Ingredient, section: InputIngredientSection) {
        if section == .Photo {
            photoOutputedIngredients.append(ingredient)
            let insertedIndexPath = IndexPath(row: photoOutputedIngredients.count - 1, section: 2)
            collectionView.insertItems(at: [insertedIndexPath])
            let ingredients = outputCurrentValidIngredients()
            rightButtonItem.isEnabled = ingredients.count > 0
        } else {
            textInputIngredients.append(ingredient)
            let insertedIndexPath = IndexPath(row: textInputIngredients.count - 1, section: 3)
            collectionView.insertItems(at: [insertedIndexPath])
        }
    }
    
    func deleteIngredient(ingredient : Ingredient, section: InputIngredientSection) {
        var sectionIndex : Int = 3
        var needReloadIndexPaths : [IndexPath] = []
        if section == .Photo {
            guard let index = photoOutputedIngredients.firstIndex(of: ingredient) else {
                return
            }
            sectionIndex = 2
            
            
            needReloadIndexPaths = (index...photoOutputedIngredients.count ).compactMap { index in
                return IndexPath(row: index, section: 2)
            }
            photoOutputedIngredients.remove(at: index)
            let deletedIndexPath = IndexPath(row: index, section: 2)
            collectionView.deleteItems(at: [deletedIndexPath])
            collectionView.reloadItems(at: needReloadIndexPaths)
            let ingredients = outputCurrentValidIngredients()
            rightButtonItem.isEnabled = ingredients.count > 0
        } else {
            guard let index = textInputIngredients.firstIndex(of: ingredient) else {
                self.editModeEnable = false
                return
            }

            needReloadIndexPaths = (index...textInputIngredients.count ).compactMap { index in
                return IndexPath(row: index, section: 3)
            }
            textInputIngredients.remove(at: index)
            let deletedIndexPath = IndexPath(row: index, section: 3)
            collectionView.deleteItems(at: [deletedIndexPath])
            collectionView.reloadItems(at: needReloadIndexPaths)
            if textInputIngredients.count < 1 {
                self.editModeEnable = false
            }
            let ingredients = outputCurrentValidIngredients()
            rightButtonItem.isEnabled = ingredients.count > 0
        }
        
        
    }
}

extension CorrectIngredientViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        if section == 1, let ingredients = photoInputedIngredients {
            if ingredients.count > 0 {
                return 1
            } else {
                return 0
            }
        }
        if section == 2, let ingredients = photoInputedIngredients {
            if ingredients.count > 0 {
                return photoOutputedIngredients.count
            } else {
                return 0
            }
        }
        return self.textInputIngredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? HorizontalBackgroundAnchorSideCell {
            cell.editModeToggleTo(enable: self.editModeEnable )
        }
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
        
        if section == 1, let ingredient = photoInputedIngredients {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetectedPhotoCollectionViewCollectionCell", for: indexPath) as! DetectedPhotoCollectionViewCollectionCell
            cell.delegate = self
            cell.configure(photoInputedIngredients: ingredient)
            return cell
        }
        
        if section == 2 {
            
            
            let row = indexPath.row
            let ingredient = self.photoOutputedIngredients[row]
            switch row % 3 {
            case 0 :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientTitleLabelTrailingCollectionCell", for: indexPath) as! IngredientTitleLabelTrailingCollectionCell
                cell.configure(ingredient: ingredient)
                return cell
                
            case 1 :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientTitleLabelCenterCollectionCell", for: indexPath) as! IngredientTitleLabelCenterCollectionCell
                cell.configure(ingredient: ingredient)
                return cell
            default :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientTitleLabelLeadingCollectionCell", for: indexPath) as! IngredientTitleLabelLeadingCollectionCell
                cell.configure(ingredient: ingredient)
                return cell
                
            }
            
            
        }
        
        if section == 3 {
            let row = indexPath.row
            if row != textInputIngredients.count {
                let ingredient = self.textInputIngredients[row]
                
                switch row % 3 {
                case 0 :
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientTextFieldTrailingCollectionCell", for: indexPath) as! IngredientTextFieldTrailingCollectionCell
                    cell.textfieldDelegate = self
                    cell.ingredientCellDelegate = self
                    cell.textField.tag = Int(String(section) +  String(row))!
                    cell.configure(ingredient: ingredient)
                    return cell
                    
                case 1 :
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientTextFieldCenterCollectionCell", for: indexPath) as! IngredientTextFieldCenterCollectionCell
                    cell.textfieldDelegate = self
                    cell.ingredientCellDelegate = self
                    cell.textField.tag = Int(String(section) +  String(row))!
                    cell.configure(ingredient: ingredient)
                    return cell
                default :
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientTextFieldLeadingCollectionCell", for: indexPath) as! IngredientTextFieldLeadingCollectionCell
                    cell.textfieldDelegate = self
                    cell.ingredientCellDelegate = self
                    cell.textField.tag = Int(String(section) +  String(row))!
                    cell.configure(ingredient: ingredient)
                    return cell
                    
                }
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddTextIngredientCollectionCell", for: indexPath) as! AddTextIngredientCollectionCell
                
                cell.ingredientCellDelegate = self
                cell.configure(buttonEnable: true)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.ingredientCellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenBounds = UIScreen.main.bounds
        let titleFont = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .bold)
        
        if section == 2 , let ingredients = photoInputedIngredients   {
            if ingredients.count > 0 {
                return CGSize(width: screenBounds.width, height: titleFont.lineHeight + 20 )
            }
            
        }
        if section == 3 {
            return CGSize(width: screenBounds.width, height: titleFont.lineHeight + 20 )
        }
        return CGSize(width:0, height: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        let screenBounds = UIScreen.main.bounds
        if section == 0 {
            return CGSize(width: screenBounds.width, height: screenBounds.height * 0.08)
        }
        if section == 1 {
            return CGSize(width: screenBounds.width, height: screenBounds.height * 0.38)
        }
        let lineHeight = UIFont.weightSystemSizeFont(systemFontStyle: .headline, weight: .medium).lineHeight
        let verInset : CGFloat = 8
        return CGSize(width: view.bounds.width / 3 - 1, height: lineHeight + verInset * 2 )
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let ingredient = photoInputedIngredients, ingredient.count > 0 {
            if indexPath.section == 2 {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LabelHeaderView", for: indexPath) as! LabelHeaderView
                headerView.configure(title: "照片輸入食材")
                
                return headerView
            }
            
        }
        if indexPath.section == 3 {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AddButtonHeaderView", for: indexPath) as! AddButtonHeaderView
            headerView.ingredientAddButtonHeaderViewDelegate = self
            headerView.configure(title: "手動輸入食材", subTitle: nil, type: .ingredient)
            return headerView
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LabelHeaderView", for: indexPath) as! LabelHeaderView
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        return view
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let photoInputedIngredients = photoInputedIngredients else {
            return UIEdgeInsets.zero
        }
        
        if section == 0 {
            return UIEdgeInsets.zero
        }
        
        if section == 1 {
            if photoInputedIngredients.isEmpty  {
                return UIEdgeInsets.zero
            }
            return UIEdgeInsets.zero
        }
        if photoInputedIngredients.isEmpty {
            if section == 2 {
                return UIEdgeInsets.zero
            }
        }

        
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
}
    
    


extension CorrectIngredientViewController :  UITextFieldDelegate {
    @objc func keyboardShown(notification: Notification) {
        self.keyboardController.keyboardShown(notification: notification, activeTextField: self.activeTextField, activeTextView: self.activeTextView)
    }
    @objc func keyboardHidden(notification: Notification) {
        self.keyboardController.keyboardHidden(notification: notification, activeTextField: self.activeTextField, activeTextView: self.activeTextView)
    }
    
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {

            let updatedText = text.replacingCharacters(in: range, with: string)
            for cell in collectionView.visibleCells {
                if let cell = cell as? IngredientTextFieldCollectionCell {
                    if cell.textField.tag == textField.tag {

                        cell.ingredient.name = updatedText
                        let ingredients = outputCurrentValidIngredients()
                        rightButtonItem.isEnabled = ingredients.count > 0
                        break
                    }
                }
            }
        }
        
        return true
    }
    
    
    
    
}
