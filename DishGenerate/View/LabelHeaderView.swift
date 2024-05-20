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
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
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
        addSubview(subTextLabel)
        subTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTextLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 6),
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



protocol AddButtonHeaderViewDelegate : AddTextIngrdientCellDelegate {

}

enum AddButtonHeaderViewType {
    case ingredient, equipment, cuisine
}



class AddButtonHeaderView : SubLabelTitleLabelHeaderView  {
    var addButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    weak var addTextIngrdientCellDelegate : AddTextIngrdientCellDelegate?
    
    weak var generateOptionCellDelegate : GenerateOptionCellDelegate?
    
    var type : AddButtonHeaderViewType! = .equipment
    
    override func initLayout() {
        super.initLayout()
        addButtonLayout()
    }
    
    func configure(title: String?, subTitle : String?, type : AddButtonHeaderViewType ) {
        super.configure(title: title, subTitle: subTitle)
        self.type = type
    }
    
    func addButtonLayout() {
        addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: subTextLabel.trailingAnchor),
            addButton.centerYAnchor.constraint(equalTo: subTextLabel.centerYAnchor),
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
        config.image = UIImage(systemName: "plus.circle.fill")?.withTintColor(.tintColor, renderingMode: .alwaysOriginal)
        config.baseForegroundColor = .themeColor
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: .weightSystemSizeFont(systemFontStyle: .title1, weight: .medium))
        config.background.imageContentMode = .scaleAspectFit
        config.background.backgroundColor = .clear
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
        addButton.addTarget(self, action: #selector(buttonTapped ( _ : )), for: .touchUpInside)
        
    }
    
    @objc func buttonTapped( _ button : UIButton) {
        switch type {
        case .ingredient :
            addTextIngrdientCellDelegate?.insertNewIngredient(ingredient: Ingredient(),section: .Text)
        case .equipment :
            generateOptionCellDelegate?.addEquipmentCell(equipment: Equipment())
        case .cuisine :
            generateOptionCellDelegate?.addCuisineCell(cuisine: Cuisine())

        case .none:
            break
        }
        
        
    }
}
