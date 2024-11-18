import UIKit

class TextFieldSideCollectionCell : UICollectionViewCell, HorizontalBackgroundAnchorSideCell {
    var anchorSide: HorizontalAnchorSide! = .center
    
    weak var textfieldDelegate : UITextFieldDelegate?
    

    var model  : (any Equatable)?
    var textField : UITextField! = UITextField()
    var background : UIView! = UIView()
    
    lazy var deleteSelfGesture : UITapGestureRecognizer! =  {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(deleteSelfGesureTrigger ( _ :)))
        gesture.isEnabled = false
        gesture.cancelsTouchesInView = false
        return gesture
    }()
    
    @objc func deleteSelfGesureTrigger( _ gesture : UITapGestureRecognizer) {
        
    }
    func gestureSetup() {
        self.background.addGestureRecognizer(deleteSelfGesture)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundSetup()
        gestureSetup()
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
    
    func editModeToggleTo(enable: Bool) {
        self.deleteSelfGesture.isEnabled = enable
        self.textField.isEnabled = !enable
        if enable {
            
            UIView.animate(withDuration: 0.2) {
                self.background.backgroundColor = .systemRed
            }
            
        } else {
            UIView.animate(withDuration: 0.2) {
                self.background.backgroundColor = .color950
            }
        }
    }
    
    func configure(title : String, model : any Equatable) {
        self.model = model
        textField.text = title
    }
    
    func backgroundSetup() {
        self.background.backgroundColor = .color950
        background.clipsToBounds = true
        background.layer.cornerRadius = 12
        backgroundColor = .clear
    }

    
    func textFieldSetup() {
        textField.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
        textField.textColor = .primaryBackground
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



