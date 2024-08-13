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
        
        NSLayoutConstraint.activate([
            
            nameLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: 14),
            nameLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -14),
            nameLabel.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            
            quantityLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -20),
            quantityLabel.centerYAnchor.constraint(equalTo: background.centerYAnchor),
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
        quantityLabel.textColor = .thirdaryLabel
        nameLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
        nameLabel.clipsToBounds = true
        nameLabel.textColor = .thirdaryLabel
    
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
