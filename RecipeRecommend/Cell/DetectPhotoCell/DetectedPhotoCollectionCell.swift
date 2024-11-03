import UIKit

class DetectedPhotoCollectionCell : UICollectionViewCell {
    
    var leftButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var rightButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var stackView : UIStackView! = UIStackView()
    
    var photoInputedIngredient : PhotoInputedIngredient!
    
    var currentOutputedIngredient : Ingredient?
    
    var buttonSide : Side?
    
    weak var delegate : DetectedPhotoCollectionCellDelegate?
    
    
    var deSelectAttributed = AttributeContainer([
        .font : UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .regular),
        .foregroundColor : UIColor.primaryLabel
    ])
    
    var selectAttributed = AttributeContainer([
        .font : UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .bold),
        .foregroundColor : UIColor.backgroundPrimary
    ])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonSetup()
        imageViewSetup()
        stackViewSetup()

        initLayout()
        stackViewLayout()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    var imageView : UIImageView! = UIImageView()
    
    func configure(inputedIngredient : PhotoInputedIngredient, outputedIngredient : Ingredient?) {
        self.photoInputedIngredient = inputedIngredient
        self.currentOutputedIngredient = outputedIngredient
        imageView.image = inputedIngredient.image
        self.buttonSide = inputedIngredient.buttonSide
        configureButtonTitle(leftTitle: inputedIngredient.leftPropablyTitle, rightTitle: inputedIngredient.rightPropablyTitle, selectSide: inputedIngredient.buttonSide)
    }
    
    func configureButtonTitle(leftTitle : String?, rightTitle : String?, selectSide : Side?) {
        
        if let leftTitle = leftTitle {
            leftButton.configuration?.showsActivityIndicator = false
            let leftAttString = AttributedString(leftTitle, attributes: deSelectAttributed)
            leftButton.configuration?.attributedTitle = leftAttString
            
        }
        if let rightTitle = rightTitle {
            rightButton.configuration?.showsActivityIndicator = false
            let rightAttString = AttributedString(rightTitle, attributes: deSelectAttributed)
            rightButton.configuration?.attributedTitle = rightAttString
        }

        if selectSide == .left {
           
            leftButton.configuration?.attributedTitle = AttributedString( leftButton.configuration!.title!, attributes: selectAttributed)
            leftButton.configuration?.baseBackgroundColor = .primaryLabel
            
            
            rightButton.configuration?.attributedTitle = AttributedString( rightButton.configuration!.title!, attributes: deSelectAttributed)
            rightButton.configuration?.baseBackgroundColor = .thirdaryBackground
            
        } else if selectSide == .right {
            
            rightButton.configuration?.attributedTitle = AttributedString( rightButton.configuration!.title!, attributes: selectAttributed)
            rightButton.configuration?.baseBackgroundColor = .primaryLabel
            
            
            leftButton.configuration?.attributedTitle = AttributedString( leftButton.configuration!.title!, attributes: deSelectAttributed)
            leftButton.configuration?.baseBackgroundColor = .thirdaryBackground
        } else {
            leftButton.configuration?.attributedTitle = AttributedString( leftButton.configuration!.title!, attributes: deSelectAttributed)
            leftButton.configuration?.baseBackgroundColor = .thirdaryBackground
            rightButton.configuration?.attributedTitle = AttributedString( rightButton.configuration!.title!, attributes: deSelectAttributed)
            rightButton.configuration?.baseBackgroundColor = .thirdaryBackground
        }


    }
    
    
    func initLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(stackView)
        contentView.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func stackViewLayout() {
        let font = UIFont.preferredFont(forTextStyle: .title1)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: font.lineHeight  + 8 )
        ])
        
    }
    
    func stackViewSetup() {
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillEqually

        [leftButton, rightButton].forEach() {
            stackView.addArrangedSubview($0)
        }
        
    }
    
    func buttonSetup() {
        
        let insetFloat : CGFloat = 4
        let insets = NSDirectionalEdgeInsets(top: insetFloat, leading: insetFloat * 2, bottom: insetFloat , trailing: insetFloat * 2)
        var leftConfig = UIButton.Configuration.filled()
        let leftAttString = AttributedString("", attributes: deSelectAttributed)
        leftConfig.attributedTitle = leftAttString
        leftConfig.contentInsets = insets
        
        leftConfig.showsActivityIndicator = true
        leftConfig.activityIndicatorColorTransformer = .init({ color in
            return .primaryLabel
        })
    
        leftConfig.baseBackgroundColor = .secondaryBackground
        
        leftButton.configuration = leftConfig
        
        leftButton.titleLabel?.numberOfLines = 1
        leftButton.titleLabel?.adjustsFontSizeToFitWidth = true
        leftButton.addTarget(self, action: #selector(selectButtonTapped ( _ :)), for: .touchUpInside)
        
        var rightConfig = UIButton.Configuration.filled()
        let rigthAttString = AttributedString("", attributes: deSelectAttributed)
        rightConfig.titleLineBreakMode = .byWordWrapping
        rightConfig.contentInsets = insets
        rightConfig.showsActivityIndicator = true
        rightConfig.attributedTitle = rigthAttString
        rightConfig.baseBackgroundColor = .secondaryBackground
        rightConfig.activityIndicatorColorTransformer = .init({ color in
            return .primaryLabel
        })
    
        rightButton.configuration = rightConfig
        rightButton.titleLabel?.numberOfLines = 1
        
        rightButton.titleLabel?.adjustsFontSizeToFitWidth = true
        rightButton.addTarget(self, action: #selector(selectButtonTapped ( _ :)), for: .touchUpInside)
    }
    

    
    @objc func selectButtonTapped( _ button : UIButton) {
        if button == leftButton && self.buttonSide != .left {
            selectButton(side: .left)
        } else if button == rightButton && self.buttonSide != .right  {
            selectButton(side: .right)
        } else {
            selectButton(side : nil)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentOutputedIngredient = nil
        imageView.image = nil
    }
    
    
    func selectButton(side : Side?) {

        if let currentOutputedIngredient = currentOutputedIngredient {
            
            delegate?.deleteIngredient(ingredient: currentOutputedIngredient, section: .Photo)
            self.currentOutputedIngredient = nil
        }
        guard let leftPropablyTitle = photoInputedIngredient.leftPropablyTitle,
              let rightPropablyTitle = photoInputedIngredient.rightPropablyTitle else {
            return
        }
        if side == .left && self.buttonSide != .left {
            
            configureButtonTitle(leftTitle: leftPropablyTitle, rightTitle: rightPropablyTitle, selectSide: .left)
            
            let outputedIngredient = Ingredient(name: leftPropablyTitle)
            self.currentOutputedIngredient = outputedIngredient
            delegate?.insertNewIngredient(ingredient: outputedIngredient, section: .Photo)
            
            
        } else if side == .right && self.buttonSide != .right {
            
            configureButtonTitle(leftTitle: leftPropablyTitle, rightTitle: rightPropablyTitle, selectSide: .right)
            let outputedIngredient = Ingredient(name: rightPropablyTitle)
            self.currentOutputedIngredient = outputedIngredient
            delegate?.insertNewIngredient(ingredient: outputedIngredient, section: .Photo)
            
        } else {
            configureButtonTitle(leftTitle: leftPropablyTitle, rightTitle: rightPropablyTitle, selectSide: nil)
            if let currentOutputedIngredient = currentOutputedIngredient {
                delegate?.deleteIngredient(ingredient: currentOutputedIngredient, section: .Photo)
            }
            self.currentOutputedIngredient = nil
        }
        photoInputedIngredient.outputedIngredient = self.currentOutputedIngredient
        photoInputedIngredient.buttonSide = side
        buttonSide = side
    }
    
    func imageViewSetup() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0.8
        imageView.layer.borderColor = UIColor.secondaryLabelColor.cgColor
    }
}
