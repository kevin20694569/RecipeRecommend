import UIKit
class RecipeDetailIngredientCell : GroupCornerBackgroundTableCell {
    
    var ingredient : Ingredient!

    var quantityLabel : UILabel! = UILabel()
    var nameLabel : UILabel! = UILabel()
    
    func configure(ingredient : Ingredient) {
        self.ingredient = ingredient
        nameLabel.text = ingredient.name
        quantityLabel.text = ingredient.quantityDescription
    }
    
    func initLayout() {
        [nameLabel, quantityLabel].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        let bounds = UIScreen.main.bounds
        
        
        
        NSLayoutConstraint.activate([
            
            nameLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: bounds.width * 0.04),
            nameLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: bounds.height * 0.01),
            nameLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -bounds.height * 0.01),
            nameLabel.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            
            nameLabel.widthAnchor.constraint(lessThanOrEqualTo: background.widthAnchor, multiplier: 0.4),

            
            quantityLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -bounds.width * 0.04),
            quantityLabel.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            quantityLabel.widthAnchor.constraint(lessThanOrEqualTo: background.widthAnchor, multiplier: 0.4),
            quantityLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: bounds.height * 0.01),
            quantityLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -bounds.height * 0.01),
        ])
        
    }
    
    override func cellSetup() {
        super.cellSetup()
        let bounds = UIScreen.main.bounds
        separatorInset = UIEdgeInsets(top: 0, left: bounds.width / 2, bottom: 0, right: bounds.width / 2)
    }
    
    override func cellTapGestureSetup() {
        super.cellTapGestureSetup()
        cellTapGesture.isEnabled = false
    }
    
    func labelSetup() {
        quantityLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
        quantityLabel.numberOfLines = 0
        quantityLabel.adjustsFontSizeToFitWidth = true
        quantityLabel.textColor = .primaryLabel
        quantityLabel.textAlignment = .natural
        nameLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
        nameLabel.clipsToBounds = true
        nameLabel.textColor = .primaryLabel
        nameLabel.numberOfLines = 0
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textAlignment = .right
    
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundSetup()
        labelSetup()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
