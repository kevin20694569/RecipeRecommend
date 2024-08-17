import UIKit

protocol DishPreferenceCell {
    var preference : DishPreference! { get set }
}


class RecipeGeneratedOptionViewController : UIViewController, GenerateOptionCellDelegate, UITextFieldDelegate, UITextViewDelegate, AddButtonHeaderViewDelegate, OptionGeneratedAddButtonHeaderViewDelegate, KeyBoardControllerDelegate {

    var user_id : String = SessionManager.user_id
    
    lazy var preference : DishPreference = DishPreference(id: UUID().uuidString, user_id: self.user_id, ingredients: self.ingrdients, cuisine: self.cuisines, complexity: self.complexity, timeLimit: 20, equipments: self.equipments, temperature: self.temperature)
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func editModeToggleTo(type: AddButtonHeaderViewType) {

        switch type {
        case .equipment :
            guard self.equipments.count > Equipment.examples.count else {
                return
            }
            self.equipmentEditModeEnable.toggle()
            
            self.collectionView.visibleCells.forEach() {
                if let cell = $0 as? EquipmentTextFieldCollectionCell {
                    cell.editModeToggleTo(enable: self.equipmentEditModeEnable)
                }
            }
        case .cuisine :
            guard self.cuisines.count > Cuisine.examples.count else {
                return
            }
            self.cuisineEditModeEnable.toggle()
           
            self.collectionView.visibleCells.forEach() {
                if let cell = $0 as? CuisineTextFieldCollectionCell {
                    cell.editModeToggleTo(enable: self.cuisineEditModeEnable)
                }
            }
        default :
            break
        }
        
    }
    
    var cuisineEditModeEnable : Bool! = false
    
    var equipmentEditModeEnable: Bool! = false
    
    var activeTextField : UITextField?
    var activeTextView : UITextView?
    
    var indicatorSection : Int = 0
    var equipmentSection : Int = 1
    

    
    lazy var keyboardController : KeyBoardController! = KeyBoardController(view: self.view, delegate: self)
    
    
    func deleteEquipment(equipment: Equipment) {
        guard let index = equipments.firstIndex(of: equipment) else {
            self.equipmentEditModeEnable = false
            return
        }
        
        let section = equipmentSection
        let needReloadIndexPaths = (index...equipments.count ).compactMap { index in
            return IndexPath(row: index, section: section)
        }
        equipments.remove(at: index)
        let deletedIndexPath = IndexPath(row: index, section: section)
        collectionView.deleteItems(at: [deletedIndexPath])
        collectionView.reloadItems(at: needReloadIndexPaths)
        if equipments.count <= Equipment.examples.count {
            self.equipmentEditModeEnable = false
        }
    }
    
    func deleteCuisine(cuisine: Cuisine) {
        guard let index = self.cuisines.firstIndex(of: cuisine) else {
            self.cuisineEditModeEnable = false
            return
        }
        let section = cuisineSection
        let needReloadIndexPaths = (index...cuisines.count ).compactMap { index in
            return IndexPath(row: index, section: section)
        }
        cuisines.remove(at: index)
        let deletedIndexPath = IndexPath(row: index, section: section)
        collectionView.deleteItems(at: [deletedIndexPath])
        collectionView.reloadItems(at: needReloadIndexPaths)
        if cuisines.count <= Cuisine.examples.count {
            self.cuisineEditModeEnable = false
        }
        
    }
    
    func addEquipmentCell(equipment: Equipment) {
        self.equipments.append(equipment)
        let indexPath = IndexPath(row: equipments.count - 1, section: equipmentSection)
        collectionView.insertItems(at: [indexPath])
    }
    
    func addCuisineCell(cuisine: Cuisine) {

        self.cuisines.append(cuisine)
        let indexPath = IndexPath(row: cuisines.count - 1, section: cuisineSection)
        collectionView.insertItems(at: [indexPath])
    }
    
    
    var equipments : [Equipment] = EditUserDefaultManager.shared.getEquipments()
    
    var markEquipments : [Equipment] {
        return equipments.filter { equipment in
            return equipment.name != "" && equipment.isSelected
        }
    }
    
    var cuisines : [Cuisine] =  EditUserDefaultManager.shared.getCuisines()
    
    var markCuisines : [Cuisine] {
        return cuisines.filter { cuisine in
            return cuisine.name != "" && cuisine.isSelected
        }
    }
    
    var complexitySection : Int = 2
    var complexity : Complexity {
        let indexPath = IndexPath(row: 0, section: complexitySection)
        if let cell = self.collectionView.cellForItem(at: indexPath) as? DifficultSliderCollectionCell {
            return cell.complexity
             
        }
        return Complexity(rawValue: "簡單")!
        
    }
    var temperatureSection : Int = 3
    var temperature : Double {
        let indexPath = IndexPath(row: 0, section: complexitySection)
        if let cell = self.collectionView.cellForItem(at: indexPath) as? TemperatureSliderCollectionCell {
            
            return Double(cell.currentValue)
        }
        return 0
    }
    
    var costTimeSection : Int = 4
    
    var costTime : Int {
        let indexPath = IndexPath(row: 0, section: costTimeSection)
        if let cell = self.collectionView.cellForItem(at: indexPath) as? TimeSliderCollectionCell {
            return  Int(cell.currentValue)
            
        }
        return 30
    }
    var cuisineSection : Int = 5
    
    var additionalTextSection : Int = 6
    

    
    var ingrdients : [Ingredient] = []
    
    var options : [(title : String?, subTitle : String?)] = [(nil, nil),
                                                           //  ("份量人數", nil),
                                                             ("擁有的設備", "(可多選)"),
                                                             ("難易程度", nil),
                                                             ("創意程度", nil),
                                                             ("製作時間", nil),
                                                             ("指定菜式", "(可多選)"),
                                                             //(nil, nil),
                                                             ("其他補充", "(如素食、過敏原、忌口...等等)")]
    
    var collectionView : UICollectionView! = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    init(ingredients : [Ingredient] ) {
        super.init(nibName: nil, bundle: nil)
        self.ingrdients = ingredients
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var rightButtonItem : UIBarButtonItem! =  UIBarButtonItem(title: "生成", image: nil, target: self, action: #selector(rightButtonItemTapped ( _ : )))
    
    @objc func rightButtonItemTapped( _ barButtonItem : UIBarButtonItem) {
        generateRecommendRecipes()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotification()
        registerCell()
        registerCollectionHeaderView()
        collcectionViewSetup()
        navItemSetup()
        initLayout()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TapGestureHelper.shared.shouldAddTapGestureInWindow(view:  self.view)
    }
    
    func initLayout() {
        view.addSubview(collectionView)
        view.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        self.view.backgroundColor = .primaryBackground
        
    }
    
    func navItemSetup() {
        navigationItem.setRightBarButton(self.rightButtonItem, animated: false)
    }
    
    func collcectionViewSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delaysContentTouches = false
        let flow = UICollectionViewFlowLayout()
        flow.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        collectionView.collectionViewLayout = flow
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: MainTabBarViewController.bottomBarFrame.height + 20, right: 0)
        collectionView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: MainTabBarViewController.bottomBarFrame.height , right: 0)
    }
    
    func generateRecommendRecipes()  {
        
        preference.equipments = self.equipments
        preference.cuisine = self.cuisines
        preference.ingredients = self.ingrdients
        
        if let nav = navigationController as? MainNavgationController,
           let mainTableController = nav.mainDishViewController {
            mainTableController.changeButtonStatus(status: .isGenerating)
            Task {
                do {
                    
                    let (preference, recipes) = try await RecipeManager.shared.getRecommendRecipes(user_id: self.user_id, preference: preference)
                    mainTableController.generatedDishes = recipes
                    mainTableController.generatedPreference = preference
                    mainTableController.changeButtonStatus(status: .already)
                    
                } catch {
                    mainTableController.changeButtonStatus(status: .none)
                    print("getRecommendRecipesError", error)
                }
            }
        }
        
        navigationController?.popToRootViewController(animated: true)
        
        
    }
    
    func registerCell() {
        collectionView.register(IndicatorCollectionCell.self, forCellWithReuseIdentifier: "IndicatorCollectionCell")
        
        collectionView.register(QuantityCollectionCell.self, forCellWithReuseIdentifier: "QuantityCollectionCell")
        
        collectionView.register(TitleLabelSideCollectionCell.self, forCellWithReuseIdentifier: "TitleLabelSideCollectionCell")
        
        collectionView.register(DifficultSliderCollectionCell.self, forCellWithReuseIdentifier: "DifficultSliderCollectionCell")
        
        collectionView.register(TemperatureSliderCollectionCell.self, forCellWithReuseIdentifier: "TemperatureSliderCollectionCell")
        
        collectionView.register(TimeSliderCollectionCell.self, forCellWithReuseIdentifier: "TimeSliderCollectionCell")
        
        
        collectionView.register(ReferenceHistoryCollectionCell.self, forCellWithReuseIdentifier: "ReferenceHistoryCollectionCell")

        collectionView.register(AddtionalTextCollectionCell.self, forCellWithReuseIdentifier: "AddtionalTextCollectionCell")
        
        collectionView.register(TitleLabelCenterCollectionCell.self, forCellWithReuseIdentifier: "TitleLabelCenterCollectionCell")
        
        collectionView.register(TitleLabelLeadingCollectionCell.self, forCellWithReuseIdentifier: "TitleLabelLeadingCollectionCell")
        
        collectionView.register(TitleLabelTrailngCollectionCell.self, forCellWithReuseIdentifier: "TitleLabelTrailngCollectionCell")
        
        collectionView.register(ButtonCenterCollectionCell.self, forCellWithReuseIdentifier: "ButtonCenterCollectionCell")
        
        collectionView.register(ButtonLeadingCollectionCell.self, forCellWithReuseIdentifier: "ButtonLeadingCollectionCell")
        
        collectionView.register(ButtonTrailngCollectionCell.self, forCellWithReuseIdentifier: "ButtonTrailngCollectionCell")
        
        collectionView.register(TextFieldCenterCollectionCell.self, forCellWithReuseIdentifier: "TextFieldCenterCollectionCell")
        
        collectionView.register(TextFieldLeadingCollectionCell.self, forCellWithReuseIdentifier: "TextFieldLeadingCollectionCell")
        
        collectionView.register(TextFieldTrailngCollectionCell.self, forCellWithReuseIdentifier: "TextFieldTrailngCollectionCell")
        
        collectionView.register(EquipmentTextFieldCenterCollectionCell.self, forCellWithReuseIdentifier: "EquipmentTextFieldCenterCollectionCell")
        
        collectionView.register(EquipmentTextFieldLeadingCollectionCell.self, forCellWithReuseIdentifier: "EquipmentTextFieldLeadingCollectionCell")
        
        collectionView.register(EquipmentTextFieldTrailingCollectionCell.self, forCellWithReuseIdentifier: "EquipmentTextFieldTrailingCollectionCell")
        
        collectionView.register(CuisineTextFieldCenterCollectionCell.self, forCellWithReuseIdentifier: "CuisineTextFieldCenterCollectionCell")
        
        collectionView.register(CuisineTextFieldLeadingCollectionCell.self, forCellWithReuseIdentifier: "CuisineTextFieldLeadingCollectionCell")
        
        collectionView.register(CuisineTextFieldTrailingCollectionCell.self, forCellWithReuseIdentifier: "CuisineTextFieldTrailingCollectionCell")

        
          
        
    }
    
    func registerCollectionHeaderView() {
        collectionView.register(SubLabelTitleLabelHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SubLabelTitleLabelHeaderView")
        
        collectionView.register(AddButtonHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "AddButtonHeaderView")
        
        
    }
    
}

extension RecipeGeneratedOptionViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case equipmentSection :
            return equipments.count
        
        case cuisineSection :
            return cuisines.count
        default :
            return 1
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        if section == indicatorSection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IndicatorCollectionCell", for: indexPath) as! IndicatorCollectionCell
            cell.configure(highlightIndex: 2)
        
            return cell
        }
      /*  if section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuantityCollectionCell", for: indexPath) as! QuantityCollectionCell
            cell.deleagate = self
            return cell
        }*/
        if section == equipmentSection || section == cuisineSection {
            let row = indexPath.row
            var title : String = ""
            var isSelected : Bool = false
            var model : (any SelectedModel)!
            var isDefaultModel : Bool = true
        
            if section == equipmentSection {
                model = equipments[row]
                title = model.name
                isSelected = model.isSelected
                isDefaultModel = row <= Equipment.examples.count - 1
            }
            
            if section == cuisineSection {
                model = cuisines[row]
                title = model.name
                isSelected = model.isSelected
                isDefaultModel = row <= Cuisine.examples.count - 1
            }
           
        
            
            switch row  % 3 {
            case 0 :
                if isDefaultModel {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonTrailngCollectionCell", for: indexPath) as! ButtonTrailngCollectionCell
                    
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
                }
            case 1 :
                if isDefaultModel {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCenterCollectionCell", for: indexPath) as! ButtonCenterCollectionCell

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
                }
            default:
                if isDefaultModel {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonLeadingCollectionCell", for: indexPath) as! ButtonLeadingCollectionCell
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
                }
                
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextFieldCenterCollectionCell", for: indexPath) as! TextFieldCenterCollectionCell
            
            cell.configure(title: title, model: model)
            return cell

        }
        
        if section == complexitySection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DifficultSliderCollectionCell", for: indexPath) as! DifficultSliderCollectionCell
            let titleArray = ["簡單", "普通", "困難"]
            cell.preference = self.preference
            cell.configure(titleArray: titleArray)
            return cell
        }
        if section == temperatureSection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemperatureSliderCollectionCell", for: indexPath) as! TemperatureSliderCollectionCell
            let titleArray =  ["穩定", "適中", "放飛"]
            cell.preference = self.preference
            cell.configure(titleArray: titleArray)
            return cell
        }
        
        if section == costTimeSection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSliderCollectionCell", for: indexPath) as! TimeSliderCollectionCell
            let titleArray =  ["20分鐘", "40分鐘", "1小時"]
            cell.preference = self.preference
            cell.configure(titleArray: titleArray)
            return cell
        }
        
       /* if section == 6 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReferenceHistoryCollectionCell", for: indexPath) as! ReferenceHistoryCollectionCell
            return cell
        }*/
        
        if section == additionalTextSection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddtionalTextCollectionCell", for: indexPath) as! AddtionalTextCollectionCell
            cell.textViewDelegate = self
            cell.configure()
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        let screenBounds = UIScreen.main.bounds
        if section == indicatorSection {
            return CGSize(width: screenBounds.width, height: screenBounds.height * 0.08)
        }
     /*   if section == 1 {
            let font = UIFont.preferredFont(forTextStyle: .title3)
            return CGSize(width: screenBounds.width, height: font.lineHeight + 20)
        }*/
        if section == equipmentSection || section == cuisineSection {
            let lineHeight = UIFont.weightSystemSizeFont(systemFontStyle: .headline, weight: .medium).lineHeight
            let verInset : CGFloat = 8
            return CGSize(width: view.bounds.width / 3 - 1, height: lineHeight + verInset * 2 )
        }
        if section == additionalTextSection {
            return CGSize(width: screenBounds.width, height: screenBounds.height * 0.15)
        }
        return CGSize(width: screenBounds.width, height: screenBounds.height * 0.08)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        let section = indexPath.section
        let option = options[section]
        
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
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenBounds = UIScreen.main.bounds
        let titleFont = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .bold)
        if section >= equipmentSection && section <= cuisineSection || section == additionalTextSection {
            return CGSize(width: screenBounds.width, height: titleFont.lineHeight + 20 )
        }
        return CGSize(width: screenBounds.width, height: 0)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == equipmentSection  || section == cuisineSection {
            return 12
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? EquipmentTextFieldCollectionCell {
            cell.editModeToggleTo(enable: self.equipmentEditModeEnable )
        }
        if let cell = cell as? CuisineTextFieldCollectionCell {
            cell.editModeToggleTo(enable: self.cuisineEditModeEnable )
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.activeTextView = textView
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let textViewText = textView.text as NSString? {
            
            let updatedText = textViewText.replacingCharacters(in: range, with: text)
            preference.addictionalText = updatedText
        }
        return true
    }
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            
            let updatedText = text.replacingCharacters(in: range, with: string)
            for cell in collectionView.visibleCells {
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
        }
        return true
    }
    
}

extension RecipeGeneratedOptionViewController  {
    @objc func keyboardShown(notification: Notification) {
        self.keyboardController.keyboardShown(notification: notification, activeTextField: self.activeTextField, activeTextView: self.activeTextView)
    }
    @objc func keyboardHidden(notification: Notification) {
        self.keyboardController.keyboardHidden(notification: notification, activeTextField: self.activeTextField, activeTextView: self.activeTextView)
    }
}











                
