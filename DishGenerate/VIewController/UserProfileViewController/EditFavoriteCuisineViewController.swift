

import UIKit

class EditFavoriteCuisineViewController : UIViewController, KeyBoardControllerDelegate, EditCuisineCellDelegate {

    
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardShown(notification: Notification) {
        self.keyboardController.keyboardShown(notification: notification, activeTextField: self.activeTextField, activeTextView: self.activeTextView)
    }
    @objc func keyboardHidden(notification: Notification) {
        self.keyboardController.keyboardHidden(notification: notification, activeTextField: self.activeTextField, activeTextView: self.activeTextView)
    }
    
    
    var activeTextField: UITextField?
    
    var activeTextView: UITextView?
    
    var collectionView : UICollectionView! = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    var rightButtonItem : UIBarButtonItem!
    
    lazy var keyboardController : KeyBoardController! = KeyBoardController(view: self.view, delegate: self)
    
    var cuisines : [Cuisine] = []
    
    var cuisineEditModeEnable : Bool! = false
    
    var cuisinesChanged : Bool! = false { didSet {
        rightButtonItem.isEnabled = cuisinesChanged
    }}
    
    var initCuisines : [Cuisine] = []
    
    init(cuisines : [Cuisine]) {
        super.init(nibName: nil, bundle: nil)
        initCuisines = cuisines.compactMap() { cuisine in
            return cuisine.copy() as? Cuisine
        }
        self.cuisines = cuisines
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        navItemSetup()
        registerKeyboardNotification()
        registerCell()
        registerCollectionHeaderView()
        collcectionViewSetup()
        initLayout()
    }
    
    func viewSetup() {
        view.backgroundColor = .primaryBackground
    }

    func initLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func collcectionViewSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delaysContentTouches = false
        let flow = UICollectionViewFlowLayout()
        flow.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        collectionView.collectionViewLayout = flow
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: MainTabBarViewController.bottomBarFrame.height + 20, right: 0)
        collectionView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: MainTabBarViewController.bottomBarFrame.height , right: 0)
    }
    
    func detectEquipmentsChanged() {
        let validEquipments = self.cuisines.filter { equipment in
            return equipment.name != nil && equipment.name != ""
        }
        cuisinesChanged = !(validEquipments == initCuisines)
    }

    
    func addCuisineCell(cuisine: Cuisine) {
        self.cuisines.append(cuisine)
        let indexPath = IndexPath(row: cuisines.count - 1, section: 0)
        collectionView.insertItems(at: [indexPath])
        detectEquipmentsChanged()
    }
    
    func deleteCuisine(cuisine: Cuisine) {
        guard let index = cuisines.firstIndex(of: cuisine) else {
            self.cuisineEditModeEnable = false
            return
        }
        
        
        let needReloadIndexPaths = (index...cuisines.count ).compactMap { index in
            return IndexPath(row: index, section: 0)
        }
        cuisines.remove(at: index)
        let deletedIndexPath = IndexPath(row: index, section: 0)
        collectionView.deleteItems(at: [deletedIndexPath])
        collectionView.reloadItems(at: needReloadIndexPaths)
        if cuisines.count <= Cuisine.examples.count {
            self.cuisineEditModeEnable = false
        }
        detectEquipmentsChanged()
    }
    
    func navItemSetup() {
        rightButtonItem = UIBarButtonItem(title: "儲存", style: .plain, target: self, action: #selector(rightButtonItemTapped ( _ : )))
        self.navigationItem.rightBarButtonItem = rightButtonItem
        rightButtonItem.isEnabled = false
    }

    
    @objc func rightButtonItemTapped(_ buttonItem : UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func registerCell() {
        
        collectionView.register(ButtonCenterCollectionCell.self, forCellWithReuseIdentifier: "ButtonCenterCollectionCell")
        
        collectionView.register(ButtonLeadingCollectionCell.self, forCellWithReuseIdentifier: "ButtonLeadingCollectionCell")
        
        collectionView.register(ButtonTrailngCollectionCell.self, forCellWithReuseIdentifier: "ButtonTrailngCollectionCell")
        
        collectionView.register(CuisineTextFieldCenterCollectionCell.self, forCellWithReuseIdentifier: "CuisineTextFieldCenterCollectionCell")
        
        collectionView.register(CuisineTextFieldLeadingCollectionCell.self, forCellWithReuseIdentifier: "CuisineTextFieldLeadingCollectionCell")
        
        collectionView.register(CuisineTextFieldTrailingCollectionCell.self, forCellWithReuseIdentifier: "CuisineTextFieldTrailingCollectionCell")
        
    }
    
    func registerCollectionHeaderView() {
        collectionView.register(AddButtonHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "AddButtonHeaderView")
        
        
    }
}

extension EditFavoriteCuisineViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cuisines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let section = indexPath.section
        let cuisine = cuisines[row]
        var isDefaultModel = row <= Cuisine.examples.count - 1
        switch row  % 3 {
        case 0 :
            if isDefaultModel {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonTrailngCollectionCell", for: indexPath) as! ButtonTrailngCollectionCell
                cell.buttonSideCollectionCellDelegate = self
                cell.configure(title: cuisine.name, isSelected: cuisine.isSelected, model: cuisine)
                return cell
            } else {
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
                cell.buttonSideCollectionCellDelegate = self
                cell.configure(title: cuisine.name, isSelected: cuisine.isSelected, model: cuisine)
                return cell
            }  else {
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
                cell.buttonSideCollectionCellDelegate = self
                cell.configure(title: cuisine.name, isSelected: cuisine.isSelected, model: cuisine)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuisineTextFieldLeadingCollectionCell", for: indexPath) as! CuisineTextFieldLeadingCollectionCell
                cell.textfieldDelegate = self
                cell.editCuisineCellDelegate = self
                cell.textField.tag = Int(String(section) + String(row))!
                cell.configure(cuisine: cuisine)
                return cell
            }
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextFieldCenterCollectionCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AddButtonHeaderView", for: indexPath) as! AddButtonHeaderView
        view.editCuisineCellDelegate = self
        view.configure(title: "指定菜式", subTitle: "(可多選)", type: .cuisine)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let lineHeight = UIFont.weightSystemSizeFont(systemFontStyle: .headline, weight: .medium).lineHeight
        let verInset : CGFloat = 8
        return CGSize(width: bounds.width / 3 - 1, height: lineHeight + verInset * 2 )
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenBounds = UIScreen.main.bounds
        let titleFont = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .bold)
        return CGSize(width: screenBounds.width, height: titleFont.lineHeight + 20 )
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? EquipmentTextFieldCollectionCell {
            cell.editModeToggleTo(enable: self.cuisineEditModeEnable )
        }
    }
    
    
    
    
    
}

extension EditFavoriteCuisineViewController : UITextFieldDelegate, AddButtonHeaderViewDelegate, UICollectionViewDelegateFlowLayout, ButtonSideCollectionCellDelegate {
    func highlight(cell : UICollectionViewCell) {
        detectEquipmentsChanged()
    }
    
    func editModeToggleTo(type: AddButtonHeaderViewType) {
        guard type == .cuisine else {
            return
        }
        guard self.cuisines.count > Equipment.examples.count else {
            return
        }
        self.cuisineEditModeEnable.toggle()

        self.collectionView.visibleCells.forEach() {
            if let cell = $0 as? EquipmentTextFieldCollectionCell {
                cell.editModeToggleTo(enable: self.cuisineEditModeEnable)
            }
        }
    }
    
    
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {

            let updatedText = text.replacingCharacters(in: range, with: string)
            for cell in collectionView.visibleCells {
                if let cell = cell as? CuisineTextFieldCollectionCell {
                    if cell.textField.tag == textField.tag {
                        cell.cuisine.name = updatedText
                        detectEquipmentsChanged()
                        break
                    }
                }
            }
        }
        
        return true
    }
}

