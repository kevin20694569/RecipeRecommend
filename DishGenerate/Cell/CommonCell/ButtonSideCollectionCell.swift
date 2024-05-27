import UIKit
class ButtonSideCollectionCell : UICollectionViewCell, HorizontalButtonAnchorSideCell {
    
    var button : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var anchorSide : HorizontalAnchorSide! = .center
    

    var model : (any SelectedModel)!

    var deSelectAttributed = AttributeContainer([
        .font : UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .regular),
        .foregroundColor : UIColor.black
    ])
    
    var selectAttributed = AttributeContainer([
        .font : UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium),
        .foregroundColor : UIColor.white
    ])
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buttonSetup()
        initLayout()
    }
    
    func initLayout() {

        contentView.addSubview(button)
        contentView.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let constant : CGFloat = 8
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),

        ])
    }
    
    func configure(title : String, isSelected : Bool, model : any SelectedModel) {
        self.model = model
        highlight(title : title, selected: isSelected  )
    }
    
    func highlight(title : String ,selected : Bool) {
        if selected {
            button.configuration?.attributedTitle = AttributedString(title, attributes: selectAttributed)
            button.configuration?.baseForegroundColor = .primaryBackground
            button.configuration?.baseBackgroundColor = .themeColor
        } else {
            button.configuration?.attributedTitle = AttributedString(title, attributes: deSelectAttributed)
            button.configuration?.baseForegroundColor = .primaryLabel
            button.configuration?.baseBackgroundColor = .thirdaryBackground
        }
    }
    
    @objc func buttonTapped( _ button : UIButton) {
        model.isSelected.toggle()
        highlight(title: self.model.name, selected: model.isSelected)
    }
    

    
    func buttonSetup() {
        var config = UIButton.Configuration.filled()
        let attrString = AttributedString("", attributes: deSelectAttributed)
        config.attributedTitle = attrString
        button.configuration = config
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(buttonTapped ( _ : )), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ButtonCenterCollectionCell : ButtonSideCollectionCell {
    
    override func initLayout() {
        super.initLayout()
        
        backgroundCenterAnchor.isActive = true
    }
    
}
class ButtonLeadingCollectionCell : ButtonSideCollectionCell {
    
    override func initLayout() {
        super.initLayout()
        
        backgroundLeadingAnchor.isActive = true
    }
    
}
class ButtonTrailngCollectionCell : ButtonSideCollectionCell {
    
    override func initLayout() {
        super.initLayout()
        
        backgroundTrailingAnchor.isActive = true
    }
    
}
