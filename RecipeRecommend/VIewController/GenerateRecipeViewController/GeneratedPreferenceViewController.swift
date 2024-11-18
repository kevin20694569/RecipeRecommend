import UIKit



class GeneratedPreferenceViewController : RecipeRecommendOptionViewController, IngredientCellDelegate, IngredientAddButtonHeaderViewDelegate, ButtonSideCollectionCellDelegate {
    func highlight(cell: UICollectionViewCell) {
        self.rightButtonItem.isEnabled = generatePreferenceIsReady()
    }
    
    
    var initIngredientsCount : Int = 0
    
    var ingredientEditModeEnable : Bool = false
    
    
    var generateRecipePreference :  GenerateRecipePreference!
    
    var generatingBlurView : LoadingBlurView = LoadingBlurView(frame: .zero, style: .userInterfaceStyle)
    
  
    
    
    override var temperatureSection : Int {
        return 3
    }
    
    
    override var additionalTextSection : Int { 4 }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(ingredients : [Ingredient] = [], reference_recipe_id : String) {
        super.init(ingredients: ingredients)
        self.ingredients = ingredients
        self.initIngredientsCount = ingredients.count
        
        self.generateRecipePreference = GenerateRecipePreference(generated_recipe_id: "", reference_recipe_id: reference_recipe_id, user_id: self.user_id, temperature: 0.5)
    }
    
    
    override func editModeToggleTo(type: AddButtonHeaderViewType) {
        super.editModeToggleTo(type: type)
        if type == .ingredient {
            ingredientEditModeEnable.toggle()
            
            self.collectionView.visibleCells.forEach() {
                guard let indexPath = self.collectionView.indexPath(for: $0),
                      indexPath.section == ingredientsSection else {
                    return
                }
                if let cell = $0 as? HorizontalBackgroundAnchorSideCell {
                    cell.editModeToggleTo(enable: ingredientEditModeEnable)
                }
            }
        }
        
    }
    
    
    override func initLayout() {
        super.initLayout()
        generatingBlurView.layer.opacity = 0
        view.addSubview(generatingBlurView)
        generatingBlurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            generatingBlurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            generatingBlurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            generatingBlurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            generatingBlurView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }
    
    func setupLoadingView() {
        self.generatingBlurView.configure(title: "正在生成一則新食譜...", start_generating:  false)
    }
    
    
    
    
    func insertNewIngredient(ingredient: Ingredient, section: InputIngredientSection) {
        
        ingredients.append(ingredient)
        let insertedIndexPath = IndexPath(row: ingredients.count - 1, section: ingredientsSection)
        collectionView.insertItems(at: [insertedIndexPath])
        
    }
    
    func showLoadingView() {
        
        guard generatingBlurView.layer.opacity == 0 else {
            return
        }
        navigationController?.navigationBar.isUserInteractionEnabled = false

        UIView.animate(withDuration: 0.2) {
            self.generatingBlurView.layer.opacity = 1
        } completion: { Bool in
            
        }

    }
    
    func dismissLoadingView() {
        guard generatingBlurView.layer.opacity == 1 else {
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            self.generatingBlurView.layer.opacity = 0
        } completion: { Bool in
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
        }
    }
    
    override func generateRecommendRecipes()  {
        
        generateRecipePreference.equipments = outputCurrentValidEquipments()
        generateRecipePreference.cuisine = outputCurrentValidCuisines()
        generateRecipePreference.ingredients = outputCurrentValidIngredients()
        
        
        
        Task {
            do {
                generatingBlurView.configure(title: "正在生成一則新食譜...", start_generating: true)
                generatingBlurView.triggerRefreshControll()
                
                showLoadingView()
                
                let (_, recipe) = try await RecipeManager.shared.generateRecipe(user_id: self.user_id, preference: generateRecipePreference)
                generatingBlurView.configure(title: "生成完成！", start_generating: false)
                navigationController?.popViewController(animated: true)
                if let recipeDetailViewController = navigationController?.viewControllers.last as? RecipeDetailViewController {
                    recipeDetailViewController.history_generated_recipes.insert(recipe, at: 0)
                    
                    recipeDetailViewController.showGeneratedRecipesViewController(history_generated_recipes: recipeDetailViewController.history_generated_recipes)
                    recipeDetailViewController.enableShowGeneratedRecipesLabel(enable: true, animated: true)
                }
                
            } catch {
                print("getRecommendRecipesError", error)
                generatingBlurView.configure(title: "生成錯誤，請重新生成", start_generating: false)
                generatingBlurView.errorImageView.isHidden = false  
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                dismissLoadingView()
            }
            
            
        }
    }
    
    func deleteIngredient(ingredient : Ingredient, section: InputIngredientSection) {
        var needReloadIndexPaths : [IndexPath] = []
        
        guard let index = ingredients.firstIndex(of: ingredient) else {
            self.ingredientEditModeEnable = false
            return
        }
        
        needReloadIndexPaths = (index...ingredients.count).compactMap { index in
            return IndexPath(row: index, section: ingredientsSection)
        }
        ingredients.remove(at: index)
        let deletedIndexPath = IndexPath(row: index, section: ingredientsSection)
        collectionView.deleteItems(at: [deletedIndexPath])
        collectionView.reloadItems(at: needReloadIndexPaths)

        let ingredients = outputCurrentValidIngredients()
        if ingredients.count <= initIngredientsCount {
            self.ingredientEditModeEnable = false
        }
        rightButtonItem.isEnabled = ingredients.count > 0
    }
    
    
    
    func outputCurrentValidIngredients() -> [Ingredient] {
        var results : [Ingredient] = []
        if initIngredientsCount > 0 {
          
            for index in 0...initIngredientsCount - 1 {
                if ingredients[index].isSelected {
                    results.append(ingredients[index])
                }
            }
        }
        if ingredients.count > initIngredientsCount {
            for index in initIngredientsCount...ingredients.count - 1 {
                let ingredient = ingredients[index]
                if  ingredient.name != nil && ingredient.name != "" {
                    results.append(ingredient)
                }
            }
        }
        
        return results
    }
    
    func outputCurrentValidCuisines() -> [Cuisine] {
        var results : [Cuisine] = []
        
        for (index, cuisine) in self.cuisines.enumerated() {
            if index < Cuisine.examples.count {
                if cuisine.isSelected {
                    results.append(cuisine)
                }
                continue
            }
            
            if  cuisine.name != nil && cuisine.name != "" {
                results.append(cuisine)
            }
        }
        
        return results
    }
    func outputCurrentValidEquipments() -> [Equipment] {
        var results : [Equipment] = []
        
        for (index, equipment) in self.equipments.enumerated() {
            if index < Equipment.examples.count {
                if equipment.isSelected {
                    results.append(equipment)
                }
                continue
            }
            
            if  equipment.name != nil && equipment.name != "" {
                results.append(equipment)
            }
        }
        
        return results
    }
    
    
    func generatePreferenceIsReady() -> Bool {
        let validIngredients = outputCurrentValidIngredients()
        let validCuisines = outputCurrentValidCuisines()
        let validEquipments = outputCurrentValidEquipments()
        let validAdditionalText =  generateRecipePreference.additionalText?.trimmingCharacters(in: .whitespacesAndNewlines) != nil && generateRecipePreference.additionalText?.trimmingCharacters(in: .whitespacesAndNewlines) != ""
        
        return validIngredients.count > 0 || validCuisines.count > 0 || validEquipments.count > 0 || validAdditionalText
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated : Bool) {
        super.viewWillAppear(animated)
        self.rightButtonItem.isEnabled = generatePreferenceIsReady()
    }
    
    
    
    override func navItemSetup() {
        super.navItemSetup()
        self.navigationItem.title = "生成新的參考食譜"
        rightButtonItem.isEnabled = false
    }
    
    var ingredientsSection : Int = 0
    
    override func registerCell() {
        super.registerCell()
        collectionView.register(IngredientTextFieldLeadingCollectionCell.self, forCellWithReuseIdentifier: "IngredientTextFieldLeadingCollectionCell")
        collectionView.register(IngredientTextFieldCenterCollectionCell.self, forCellWithReuseIdentifier: "IngredientTextFieldCenterCollectionCell")
        collectionView.register(IngredientTextFieldTrailingCollectionCell.self, forCellWithReuseIdentifier: "IngredientTextFieldTrailingCollectionCell")
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case ingredientsSection :
            return ingredients.count
        case equipmentSection :
            return equipments.count
            
        case cuisineSection :
            return cuisines.count
        default :
            return 1
        }
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        
        
        if section == equipmentSection || section == cuisineSection || section == ingredientsSection {
            let row = indexPath.row
            var title : String = ""
            var isSelected : Bool = false
            var model : (any SelectedModel)!
            var isDefaultModel : Bool = true
            
            
            if section == equipmentSection {
                model = equipments[row]
                title = model.name ?? ""
                isSelected = model.isSelected
                isDefaultModel = row < Equipment.examples.count
            }
            
            if section == cuisineSection {
                model = cuisines[row]
                title = model.name ?? ""
                isSelected = model.isSelected
                isDefaultModel = row < Cuisine.examples.count
            }
            
            if section == ingredientsSection {
                model = ingredients[row]
                title = model.name ?? ""
                isSelected = model.isSelected
                isDefaultModel = row < self.initIngredientsCount
            }
            
            
            
            switch row  % 3 {
            case 0 :
                if isDefaultModel {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonTrailngCollectionCell", for: indexPath) as! ButtonTrailngCollectionCell
                    cell.buttonSideCollectionCellDelegate = self
                    cell.configure(title: title, isSelected: isSelected, model: model)
                    return cell
                } else if let equipment = model as? Equipment {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EquipmentTextFieldTrailingCollectionCell", for: indexPath) as! EquipmentTextFieldTrailingCollectionCell
                    cell.textfieldDelegate = self
                    cell.editEquipmentCellDelegate = self
                    cell.textField.tag = Int(String(section) + String(row))!
                    cell.configure(equipment: equipment)
                    return cell
                } else if let cuisine = model as? Cuisine {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuisineTextFieldTrailingCollectionCell", for: indexPath) as! CuisineTextFieldTrailingCollectionCell
                    cell.textfieldDelegate = self
                    cell.editCuisineCellDelegate = self
                    cell.textField.tag = Int(String(section) + String(row))!
                    cell.configure(cuisine: cuisine)
                    return cell
                } else if let ingredient = model as? Ingredient {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientTextFieldTrailingCollectionCell", for: indexPath) as! IngredientTextFieldTrailingCollectionCell
                    cell.textfieldDelegate = self
                    cell.ingredientCellDelegate = self
                    cell.textField.tag = Int(String(section) +  String(row))!
                    cell.configure(ingredient: ingredient)
                    return cell
                }
            case 1 :
                if isDefaultModel {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCenterCollectionCell", for: indexPath) as! ButtonCenterCollectionCell
                    cell.buttonSideCollectionCellDelegate = self
                    
                    cell.configure(title: title, isSelected: isSelected, model: model)
                    return cell
                } else if let equipment = model as? Equipment {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EquipmentTextFieldCenterCollectionCell", for: indexPath) as! EquipmentTextFieldCenterCollectionCell
                    cell.textfieldDelegate = self
                    cell.editEquipmentCellDelegate = self
                    cell.textField.tag = Int(String(section) + String(row))!
                    cell.configure(equipment: equipment)
                    return cell
                } else if let cuisine = model as? Cuisine {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuisineTextFieldCenterCollectionCell", for: indexPath) as! CuisineTextFieldCenterCollectionCell
                    cell.textfieldDelegate = self
                    cell.editCuisineCellDelegate = self
                    cell.textField.tag = Int(String(section) + String(row))!
                    cell.configure(cuisine: cuisine)
                    return cell
                } else if let ingredient = model as? Ingredient {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientTextFieldCenterCollectionCell", for: indexPath) as! IngredientTextFieldCenterCollectionCell
                    cell.textfieldDelegate = self
                    cell.ingredientCellDelegate = self
                    cell.textField.tag = Int(String(section) +  String(row))!
                    cell.configure(ingredient: ingredient)
                    return cell
                }
            default:
                if isDefaultModel {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonLeadingCollectionCell", for: indexPath) as! ButtonLeadingCollectionCell
                    cell.buttonSideCollectionCellDelegate = self
                    cell.configure(title: title, isSelected:  isSelected, model: model)
                    return cell
                } else if let equipment = model as? Equipment {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EquipmentTextFieldLeadingCollectionCell", for: indexPath) as! EquipmentTextFieldLeadingCollectionCell
                    cell.textfieldDelegate = self
                    cell.editEquipmentCellDelegate = self
                    cell.textField.tag = Int(String(section) + String(row))!
                    cell.configure(equipment: equipment)
                    return cell
                } else if let cuisine = model as? Cuisine {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuisineTextFieldLeadingCollectionCell", for: indexPath) as! CuisineTextFieldLeadingCollectionCell
                    cell.textfieldDelegate = self
                    cell.editCuisineCellDelegate = self
                    cell.textField.tag = Int(String(section) + String(row))!
                    cell.configure(cuisine: cuisine)
                    return cell
                } else if let ingredient = model as? Ingredient {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientTextFieldLeadingCollectionCell", for: indexPath) as! IngredientTextFieldLeadingCollectionCell
                    cell.textfieldDelegate = self
                    cell.ingredientCellDelegate = self
                    cell.textField.tag = Int(String(section) +  String(row))!
                    cell.configure(ingredient: ingredient)
                    return cell
                }
                
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextFieldCenterCollectionCell", for: indexPath) as! TextFieldCenterCollectionCell
            cell.configure(title: title, model: model)
            return cell
            
        }
        
        if section == temperatureSection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemperatureSliderCollectionCell", for: indexPath) as! TemperatureSliderCollectionCell
            let titleArray =  ["穩定", "適中", "放飛"]
            cell.generateRecipePreference = self.generateRecipePreference
            cell.configure(titleArray: titleArray, value: generateRecipePreference.temperature)
            
            return cell
        }
        
        if section == additionalTextSection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddtionalTextCollectionCell", for: indexPath) as! AddtionalTextCollectionCell
            cell.textViewDelegate = self
            cell.configure(text: generateRecipePreference.additionalText)
            return cell
        }
        return UICollectionViewCell()
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        let section = indexPath.section
        let option = options[section]
        
        if section == ingredientsSection {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AddButtonHeaderView", for: indexPath) as! AddButtonHeaderView
            headerView.ingredientAddButtonHeaderViewDelegate = self
            headerView.configure(title: "手動輸入食材", subTitle: nil, type: .ingredient)
            return headerView
        }
        
        if section == equipmentSection {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AddButtonHeaderView", for: indexPath) as! AddButtonHeaderView
            view.optionGeneratedAddButtonHeaderViewDelegate = self
            
            view.configure(title: option.title, subTitle: option.subTitle, type: .equipment)
            return view
        }
        
        if section == cuisineSection {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AddButtonHeaderView", for: indexPath) as! AddButtonHeaderView
            view.optionGeneratedAddButtonHeaderViewDelegate = self
            view.configure(title: option.title, subTitle: option.subTitle, type: .cuisine)
            return view
        }
        
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SubLabelTitleLabelHeaderView", for: indexPath) as! SubLabelTitleLabelHeaderView
        view.configure(title: option.title, subTitle: option.subTitle)
        return view
    }
    

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        let screenBounds = UIScreen.main.bounds
        if section == equipmentSection || section == cuisineSection || section == ingredientsSection {
            let lineHeight = UIFont.weightSystemSizeFont(systemFontStyle: .headline, weight: .medium).lineHeight
            let verInset : CGFloat = screenBounds.height * 0.015
            return CGSize(width: view.bounds.width / 3 - 1, height: lineHeight + verInset * 2 )
        }
        if section == additionalTextSection {
            return CGSize(width: screenBounds.width, height: screenBounds.height * 0.15)
        }
        return CGSize(width: screenBounds.width, height: screenBounds.height * 0.08)
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenBounds = UIScreen.main.bounds
        let titleFont = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .bold)
        if section >= equipmentSection && section <= cuisineSection || section == additionalTextSection || section == ingredientsSection || section == temperatureSection {
            return CGSize(width: screenBounds.width, height: titleFont.lineHeight + screenBounds.height * 0.03 )
        }
        return CGSize(width: screenBounds.width, height: 0)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == equipmentSection  || section == cuisineSection || section == ingredientsSection {
            return view.bounds.height * 0.02
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? EquipmentTextFieldCollectionCell {
            cell.editModeToggleTo(enable: self.equipmentEditModeEnable )
        }
        if let cell = cell as? CuisineTextFieldCollectionCell {
            cell.editModeToggleTo(enable: self.cuisineEditModeEnable )
        }
        if let cell = cell as? IngredientTextFieldCollectionCell {
            cell.editModeToggleTo(enable: self.ingredientEditModeEnable)
        }
    }
    
    override func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let textViewText = textView.text as NSString? {
            
            let updatedText = textViewText.replacingCharacters(in: range, with: text)
            generateRecipePreference.additionalText = updatedText
        }
        rightButtonItem.isEnabled =  generatePreferenceIsReady()
        return true
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            
            let updatedText = text.replacingCharacters(in: range, with: string)
            for cell in collectionView.visibleCells {
                if let cell = cell as? IngredientTextFieldCollectionCell {
                    if cell.textField.tag == textField.tag {
                        cell.ingredient.name = updatedText
                        rightButtonItem.isEnabled = outputCurrentValidIngredients().count > 0
                        break
                    }
                }
                if let cell = cell as? EquipmentTextFieldCollectionCell {
                    if cell.textField.tag == textField.tag {
                        cell.equipment.name = updatedText
                        break
                    }
                }
                
                if let cell = cell as? CuisineTextFieldCollectionCell {
                    if cell.textField.tag == textField.tag {
                        cell.cuisine.name = updatedText
                        break
                    }
                }
            }
            rightButtonItem.isEnabled =  generatePreferenceIsReady()
        }
        return true
    }
}

class LoadingBlurView : UIVisualEffectView {
    
    
    var activityIndicatorView : UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    var titleLabel : UILabel = UILabel()
    
    var stackView : UIStackView = UIStackView(frame: .zero)
    
    var errorImageView : UIImageView = UIImageView(frame: .zero)
    

    init(frame : CGRect, style : UIBlurEffect.Style, title : String? = nil ) {
        let blurEffect = UIBlurEffect(style: style)
        super.init(effect: blurEffect)
        
        self.backgroundColor = .clear
        self.effect = blurEffect
        self.frame = frame
        imageViewSetup()
        indicatorViewSetup()
        labelSetup()
        stackViewSetup()
        initLayout()
        
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        
    }
    
    func configure(title : String, start_generating : Bool) {
        if start_generating {
            self.triggerRefreshControll()
        } else {
            self.pauseRefreshControll()
        }
        titleLabel.text = title
    }
    
    func initLayout() {
        
        [stackView, errorImageView].forEach() {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        stackViewLayout()
        imageViewLayout()
       
    }
    
    func imageViewSetup() {
        errorImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        errorImageView.contentMode = .scaleAspectFit
    }
    func imageViewLayout() {
       
        
        NSLayoutConstraint.activate([
            errorImageView.centerXAnchor.constraint(equalTo: activityIndicatorView.centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: activityIndicatorView.centerYAnchor),
            errorImageView.widthAnchor.constraint(equalTo: activityIndicatorView.widthAnchor, multiplier: 1.4),
            errorImageView.heightAnchor.constraint(equalTo: activityIndicatorView.heightAnchor, multiplier: 1.4)
        ])
    }
    
    func stackViewLayout() {
        [activityIndicatorView, titleLabel].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview($0)
            
        }
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ])

    }
    
    func stackViewSetup() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
    
    }
    
    func labelSetup() {
        titleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)
        titleLabel.textColor = .primaryLabel
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
    }
    
    func triggerRefreshControll() {
        activityIndicatorView.layer.opacity = 1
        errorImageView.isHidden = true
        self.activityIndicatorView.startAnimating()
    }
    
    func pauseRefreshControll() {
        activityIndicatorView.layer.opacity = 0
        self.activityIndicatorView.stopAnimating()
        
    }
    
    func indicatorViewSetup() {
        activityIndicatorView.style = .large
        activityIndicatorView.hidesWhenStopped = false
    
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    

}

extension LoadingBlurView {
}

