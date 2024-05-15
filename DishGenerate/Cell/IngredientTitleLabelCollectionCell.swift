

import UIKit

class IngredientTitleLabelCollectionCell : UICollectionViewCell {
    
    var titleLabel : UILabel! = UILabel()
    
    var background : UIView! = UIView()
    
    var ingredient : Ingredient!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundSetup()
        labelSetup()
        
        initLayout()
    }
    
    func configure(ingredient : Ingredient) {
        self.ingredient = ingredient
        titleLabel.text = ingredient.name
    }
    
    func initLayout() {
        contentView.addSubview(background)
        contentView.addSubview(titleLabel)
        contentView.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let constant : CGFloat = 8
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constant),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -constant),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constant),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constant),
        ])
        
    }
    
    func backgroundSetup() {
        background.backgroundColor = .tintColor
        background.clipsToBounds = true
        background.layer.cornerRadius = 12
    }
    

    
    func labelSetup() {
        titleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class IngredientTextFieldCollectionCell : UICollectionViewCell {
    
    var textField : UITextField! = UITextField()
    
    var background : UIView! = UIView()
    
    var ingredient : Ingredient!
    
    weak var textfieldDelegate : UITextFieldDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundSetup()
        fieldSetup()
        
        initLayout()
    }
    
    func configure(ingredient : Ingredient) {
        self.ingredient = ingredient
        textField.text = ingredient.name
        textField.delegate = textfieldDelegate
    }
    
    func initLayout() {
        contentView.addSubview(background)
        contentView.addSubview(textField)
        contentView.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let constant : CGFloat = 8
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            textField.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constant),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -constant),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constant),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constant),
        ])
        
    }
    
    func backgroundSetup() {
        background.backgroundColor = .tintColor
        background.clipsToBounds = true
        background.layer.cornerRadius = 12
    }
    

    
    func fieldSetup() {
        textField.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
        textField.textColor = .label
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
