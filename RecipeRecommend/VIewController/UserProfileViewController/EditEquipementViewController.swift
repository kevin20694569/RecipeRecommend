import UIKit

class EditUserDefaultManager {
    
    static let shared : EditUserDefaultManager = EditUserDefaultManager()
    
    func setEquipments(equipements : [Equipment]) throws {
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(equipements)
        UserDefaults.standard.set(encodedData, forKey: "equipments")
    }
    
    func getEquipments() -> [Equipment] {
        let decoder = JSONDecoder()
        
        guard let data = UserDefaults.standard.data(forKey: "equipments") else {
            return Equipment.examples
        }
        guard let equipments = try? decoder.decode([Equipment].self, from: data) else {
            return Equipment.examples
        }
        return equipments
    }
    
    func setCuisines(cuisines : [Cuisine]) throws {
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(cuisines)
        UserDefaults.standard.set(encodedData, forKey: "cuisines")
    }
    
    func getCuisines() -> [Cuisine] {
        let decoder = JSONDecoder()
        
        guard let data = UserDefaults.standard.data(forKey: "cuisines") else {
            return Cuisine.examples
        }
        guard let cuisines = try? decoder.decode([Cuisine].self, from: data) else {
            return Cuisine.examples
        }
        return cuisines
    }
}

class EditEquipementViewController : UIViewController, KeyBoardControllerDelegate, EditEquipmentCellDelegate {
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
    
    var equipments : [Equipment] = []
    
    var equipmentEditModeEnable : Bool! = false
    
    var equipmentsChanged : Bool! = false { didSet {
        rightButtonItem.isEnabled = equipmentsChanged
    }}
    
    var initEquipments : [Equipment] = []
    
    init(equipments : [Equipment]) {
        super.init(nibName: nil, bundle: nil)
        if let equipments = try? EditUserDefaultManager.shared.getEquipments() {
            initEquipments = equipments.compactMap() { equipment in
                return equipment.copy() as? Equipment
            }
            self.equipments = equipments
            return
        }
        initEquipments = equipments.compactMap() { equipment in
            return equipment.copy() as? Equipment
        }
        self.equipments = equipments
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TapGestureHelper.shared.shouldAddTapGestureInWindow(view: self.view)

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
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -MainTabBarViewController.tabBarFrame.height),
        ])
    }
    
    func collcectionViewSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delaysContentTouches = false
        collectionView.backgroundColor = .primaryBackground
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        let flow = UICollectionViewFlowLayout()
        flow.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        collectionView.collectionViewLayout = flow

    }
    
    func deleteEquipment(equipment: Equipment) {
        guard let index = equipments.firstIndex(of: equipment) else {
            self.equipmentEditModeEnable = false
            return
        }
        
        
        let needReloadIndexPaths = (index...equipments.count ).compactMap { index in
            return IndexPath(row: index, section: 0)
        }

        equipments.remove(at: index)
        let deletedIndexPath = IndexPath(row: index, section: 0)
        collectionView.deleteItems(at: [deletedIndexPath])
        collectionView.reloadItems(at: needReloadIndexPaths)
        if equipments.count <= Equipment.examples.count {
            self.equipmentEditModeEnable = false
        }
        detectEquipmentsChanged()
        
        
    }
    
    func detectEquipmentsChanged() {
        let validEquipments = self.equipments.filter { equipment in
            return equipment.name != nil && equipment.name != ""
        }
        
        equipmentsChanged = !(validEquipments == initEquipments)

    }
    
    func addEquipmentCell(equipment: Equipment) {
        self.equipments.append(equipment)
        let indexPath = IndexPath(row: equipments.count - 1, section: 0)
        collectionView.insertItems(at: [indexPath])
        detectEquipmentsChanged()
    }
    
    func navItemSetup() {
        rightButtonItem = UIBarButtonItem(title: "儲存", style: .plain, target: self, action: #selector(rightButtonItemTapped ( _ : )))
        self.navigationItem.rightBarButtonItem = rightButtonItem
        rightButtonItem.isEnabled = false
    }

    
    @objc func rightButtonItemTapped(_ buttonItem : UIBarButtonItem) {
        do {
            try EditUserDefaultManager.shared.setEquipments(equipements: self.equipments)
            self.navigationController?.popViewController(animated: true)
        } catch {
            print(error)
        }


    }
    
    func registerCell() {
        
        collectionView.register(ButtonCenterCollectionCell.self, forCellWithReuseIdentifier: "ButtonCenterCollectionCell")
        
        collectionView.register(ButtonLeadingCollectionCell.self, forCellWithReuseIdentifier: "ButtonLeadingCollectionCell")
        
        collectionView.register(ButtonTrailngCollectionCell.self, forCellWithReuseIdentifier: "ButtonTrailngCollectionCell")
        
        collectionView.register(EquipmentTextFieldCenterCollectionCell.self, forCellWithReuseIdentifier: "EquipmentTextFieldCenterCollectionCell")
        
        collectionView.register(EquipmentTextFieldLeadingCollectionCell.self, forCellWithReuseIdentifier: "EquipmentTextFieldLeadingCollectionCell")
        
        collectionView.register(EquipmentTextFieldTrailingCollectionCell.self, forCellWithReuseIdentifier: "EquipmentTextFieldTrailingCollectionCell")
        
    }
    
    func registerCollectionHeaderView() {
        collectionView.register(AddButtonHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "AddButtonHeaderView")
        
        
    }
}

extension EditEquipementViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return equipments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let section = indexPath.section
        let equipment = equipments[row]
        var isDefaultModel = row <= Equipment.examples.count - 1
        switch row  % 3 {
        case 0 :
            if isDefaultModel {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonTrailngCollectionCell", for: indexPath) as! ButtonTrailngCollectionCell
                cell.buttonSideCollectionCellDelegate = self
                cell.configure(title: equipment.name ?? "", isSelected: equipment.isSelected, model: equipment)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EquipmentTextFieldTrailingCollectionCell", for: indexPath) as! EquipmentTextFieldTrailingCollectionCell
                cell.textfieldDelegate = self
                cell.editEquipmentCellDelegate = self
                cell.textField.tag = Int(String(section) + String(row))!
                cell.configure(equipment: equipment)
                
                return cell
            }
            
        case 1 :
            if isDefaultModel {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCenterCollectionCell", for: indexPath) as! ButtonCenterCollectionCell
                cell.buttonSideCollectionCellDelegate = self
                cell.configure(title: equipment.name ?? "", isSelected: equipment.isSelected, model: equipment)
                return cell
            }  else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EquipmentTextFieldCenterCollectionCell", for: indexPath) as! EquipmentTextFieldCenterCollectionCell
                cell.textfieldDelegate = self
                cell.editEquipmentCellDelegate = self
                cell.textField.tag = Int(String(section) + String(row))!
                cell.configure(equipment: equipment)
                return cell
            }
            
        default:
            if isDefaultModel {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonLeadingCollectionCell", for: indexPath) as! ButtonLeadingCollectionCell
                cell.buttonSideCollectionCellDelegate = self
                cell.configure(title: equipment.name ?? "", isSelected: equipment.isSelected, model: equipment)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EquipmentTextFieldLeadingCollectionCell", for: indexPath) as! EquipmentTextFieldLeadingCollectionCell
                cell.textfieldDelegate = self
                cell.editEquipmentCellDelegate = self
                cell.textField.tag = Int(String(section) + String(row))!
                cell.configure(equipment: equipment)
                return cell
            }
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextFieldCenterCollectionCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AddButtonHeaderView", for: indexPath) as! AddButtonHeaderView
        view.editEquipmentCellDelegate = self
        view.configure(title: "擁有的設備", subTitle: "(可多選)", type: .equipment)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let lineHeight = UIFont.weightSystemSizeFont(systemFontStyle: .headline, weight: .medium).lineHeight
        let verInset : CGFloat = bounds.height * 0.015
        return CGSize(width: bounds.width / 3 - 1, height: lineHeight + verInset * 2 )
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return view.bounds.height * 0.02
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenBounds = UIScreen.main.bounds
        let titleFont = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .bold)
        return CGSize(width: screenBounds.width, height: titleFont.lineHeight + screenBounds.height * 0.03 )
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? EquipmentTextFieldCollectionCell {
            cell.editModeToggleTo(enable: self.equipmentEditModeEnable )
        }
    }
    
    
    
    
    
}

extension EditEquipementViewController : UITextFieldDelegate, AddButtonHeaderViewDelegate, UICollectionViewDelegateFlowLayout, ButtonSideCollectionCellDelegate {
    func highlight(cell : UICollectionViewCell) {
        detectEquipmentsChanged()
    }
    
    func editModeToggleTo(type: AddButtonHeaderViewType) {
        guard type == .equipment else {
            return
        }
        guard self.equipments.count > Equipment.examples.count else {
            return
        }
        self.equipmentEditModeEnable.toggle()

        self.collectionView.visibleCells.forEach() {
            if let cell = $0 as? EquipmentTextFieldCollectionCell {
                cell.editModeToggleTo(enable: self.equipmentEditModeEnable)
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
                if let cell = cell as? EquipmentTextFieldCollectionCell {
                    if cell.textField.tag == textField.tag {
                        cell.equipment.name = updatedText
                        detectEquipmentsChanged()
                        break
                    }
                }
            }
        }
        
        return true
    }
}
