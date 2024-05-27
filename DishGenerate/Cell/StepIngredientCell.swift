import UIKit

class StepIngredientCell : UITableViewCell {
    
    var ingredient : Ingredient!
    
    var background : UIView! = UIView()
    var quantityLabel : UILabel! = UILabel()
    var nameLabel : UILabel! = UILabel()
    
    func configure(ingredient : Ingredient) {
        self.ingredient = ingredient
        nameLabel.text = ingredient.name
        quantityLabel.text = ingredient.quantity
    }
    
    func configureCorners(topCornerMask : Bool?) {
        guard let topCornerMask = topCornerMask else {
            background.layer.maskedCorners = []
            return
        }
        background.layer.maskedCorners = topCornerMask ? [.layerMinXMinYCorner, .layerMaxXMinYCorner] : [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    
    func initLayout() {
        [background, nameLabel, quantityLabel].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: 14),
            nameLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -14),
            nameLabel.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            
            quantityLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -20),
            quantityLabel.centerYAnchor.constraint(equalTo: background.centerYAnchor),
        ])
        
    }
    
    func separatorSetup() {
        let bounds = UIScreen.main.bounds
        separatorInset = UIEdgeInsets(top: 0, left: bounds.width, bottom: 0, right: bounds.width)
    }

    
    func backgroundSetup() {
        background.backgroundColor = UIColor.thirdaryBackground
        background.clipsToBounds = true
        background.layer.cornerRadius = 20
    }

    
    func labelSetup() {
        quantityLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
        quantityLabel.numberOfLines = 0
        nameLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
        nameLabel.clipsToBounds = true
    
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundSetup()
        labelSetup()
        separatorSetup()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
