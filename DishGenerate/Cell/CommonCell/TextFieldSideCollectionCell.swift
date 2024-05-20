import UIKit

class TextFieldSideCollectionCell : UICollectionViewCell, HorizontalBackgroundAnchorSideCell {
    
    
    var model  : SelectedModel!
    var textField : UITextField! = UITextField()
    var background : UIView! = UIView()
    
    
    var anchorSide : HorizontalAnchorSide! = .center
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundSetup()
        textFieldSetup()
        initLayout()
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
            background.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            
            
            textField.topAnchor.constraint(equalTo: background.topAnchor, constant: constant),
            textField.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -constant),
            textField.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: constant),
            textField.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -constant),
        ])
    }
    
    func configure(title : String, model : SelectedModel) {
        self.model = model
        textField.text = title
    }
    
    func backgroundSetup() {
        background.backgroundColor = .themeColor
        background.clipsToBounds = true
        background.layer.cornerRadius = 12
    }
    

    
    func textFieldSetup() {
        textField.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
        textField.textColor = .backgroundPrimary
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TextFieldCenterCollectionCell : TextFieldSideCollectionCell {
    
    override func initLayout() {
        super.initLayout()
        
        backgroundCenterAnchor.isActive = true
    }
    
}
class TextFieldLeadingCollectionCell : TextFieldSideCollectionCell {
    
    override func initLayout() {
        super.initLayout()
        
        backgroundLeadingAnchor.isActive = true
    }
    
}
class TextFieldTrailngCollectionCell : TextFieldSideCollectionCell {
    
    override func initLayout() {
        super.initLayout()
        
        backgroundTrailingAnchor.isActive = true
    }
    
}

