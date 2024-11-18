import UIKit

class LabelHeaderView : UICollectionReusableView {
    var titleLabel : UILabel! = UILabel()
    
    
    func configure(title : String) {
        self.titleLabel.text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        labelSetup()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        self.addSubview(titleLabel)
        subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        titleLabelLayout()
    }
    
    func titleLabelLayout() {
        let bounds = UIScreen.main.bounds
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: bounds.width * 0.04),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    func labelSetup() {
        titleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .bold)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .left
    }
}

class SubLabelTitleLabelHeaderView : LabelHeaderView {
    var subTextLabel : UILabel! = UILabel()
    
    
    override func initLayout() {
        super.initLayout()

        subTitleLabelLayout()

    }
    
    func subTitleLabelLayout() {
        let bounds = UIScreen.main.bounds
        addSubview(subTextLabel)
  
        subTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTextLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: bounds.width * 0.02),
            subTextLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
    }
    
    func configure(title : String?, subTitle : String?) {
        self.titleLabel.text = title
        self.subTextLabel.text = subTitle
    }
    
    override func labelSetup() {
        super.labelSetup()
        subTextLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .footnote, weight: .medium)
        subTextLabel.textColor = .secondaryLabelColor
    }
    
}





enum AddButtonHeaderViewType {
    case ingredient, equipment, cuisine
}



class AddButtonHeaderView : SubLabelTitleLabelHeaderView  {
    var addButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    weak var ingredientAddButtonHeaderViewDelegate : IngredientAddButtonHeaderViewDelegate?
    
    weak var optionGeneratedAddButtonHeaderViewDelegate : OptionGeneratedAddButtonHeaderViewDelegate?
    
    weak var editEquipmentCellDelegate : EditEquipmentCellDelegate?
    
    weak var editCuisineCellDelegate : EditCuisineCellDelegate?
    
    var type : AddButtonHeaderViewType! = .equipment
    
    var editButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    override func initLayout() {
        super.initLayout()
        addButtonLayout()
    }
    
    func configure(title: String?, subTitle : String?, type : AddButtonHeaderViewType ) {
        super.configure(title: title, subTitle: subTitle)
        self.type = type
    }
    
    func addButtonLayout() {
        let bounds = UIScreen.main.bounds
        addSubview(addButton)
        addSubview(editButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: subTextLabel.trailingAnchor),
            addButton.centerYAnchor.constraint(equalTo: subTextLabel.centerYAnchor),
            
            editButton.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -bounds.width * 0.04)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttonSetup() {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "plus.circle.fill")?.withTintColor(.primaryLabel, renderingMode: .alwaysOriginal)
        config.baseForegroundColor = .themeColor
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: .weightSystemSizeFont(systemFontStyle: .title1, weight: .medium))
        config.baseBackgroundColor = .clear
        addButton.configuration  = config
        addButton.isEnabled = true
        addButton.configurationUpdateHandler = { sender in
            switch sender.state {
            case .normal:
                UIView.animate(withDuration: 0.2, animations: {
                    self.addButton.configuration?.image = config.image?.withTintColor(.tintColor, renderingMode: .alwaysOriginal)
                    sender.alpha = 1
                })
                
            case .disabled :
                UIView.animate(withDuration: 0.2, animations: {
                    self.addButton.configuration?.image = config.image?.withTintColor(.secondaryBackgroundColor, renderingMode: .alwaysOriginal)
                    sender.alpha = 0.6
                })
            default:
                break
            }
        }
        addButton.addTarget(self, action: #selector(addButtonTapped ( _ : )), for: .touchUpInside)
        
        
        var editConfig = UIButton.Configuration.filled()
        editConfig.image = UIImage(systemName: "square.and.pencil")?.withTintColor(.primaryLabel, renderingMode: .alwaysOriginal)
        editConfig.baseBackgroundColor = .clear
        editConfig.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: .weightSystemSizeFont(systemFontStyle: .title3, weight: .medium))
        editButton.configuration  = editConfig
        editButton.addTarget(self, action: #selector(editButtonTapped ( _ : )), for: .touchUpInside)
        
    }
    
    @objc func addButtonTapped( _ button : UIButton) {
        switch type {
        case .ingredient :
            ingredientAddButtonHeaderViewDelegate?.insertNewIngredient(ingredient: Ingredient(),section: .Text)
        case .equipment :
            if let delegate = optionGeneratedAddButtonHeaderViewDelegate {
                delegate.addEquipmentCell(equipment: Equipment(isSelected: true))
                return
            }
            if let delegate = editEquipmentCellDelegate {
                delegate.addEquipmentCell(equipment: Equipment(isSelected: true))
                return
            }
        case .cuisine :
            if let delegate = optionGeneratedAddButtonHeaderViewDelegate {
                delegate.addCuisineCell(cuisine: Cuisine(isSelected: true))
                return
            }

            if let delegate = editCuisineCellDelegate {
                delegate.addCuisineCell(cuisine: Cuisine(isSelected: true))
                return
            }
        case .none:
            break
        }
        
        
    }
    
    
    @objc func editButtonTapped( _ button : UIButton) {
        if let delegate = ingredientAddButtonHeaderViewDelegate {
            delegate.editModeToggleTo(type: self.type)
            return
        }
        if let delegate = optionGeneratedAddButtonHeaderViewDelegate {
            delegate.editModeToggleTo(type: self.type)
            return
        }
        if let delegate = self.editEquipmentCellDelegate {
            delegate.editModeToggleTo(type: self.type)
        }
        if let delegate = self.editCuisineCellDelegate {
            delegate.editModeToggleTo(type: self.type)
        }
    }
}
