import UIKit

class DetectedPhotoCollectionCell : UICollectionViewCell {
    
    var leftButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var rightButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var stackView : UIStackView! = UIStackView()
    
    var photoInputedIngredient : PhotoInputedIngredient!
    
    weak var delegate : DetectedPhotoCollectionCellDelegate?
    
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
    
    func configure(ingredient : PhotoInputedIngredient) {
        self.photoInputedIngredient = ingredient
        imageView.image = ingredient.image
    }
    
    
    func initLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(stackView)
        contentView.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        
        ])
    }
    
    func stackViewLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        
            
        ])
        
    }
    
    func stackViewSetup() {
        stackView.axis = .horizontal
        stackView.spacing = 4
        [leftButton, rightButton].forEach() {
            stackView.addArrangedSubview($0)
        }
        
    }
    
    func buttonSetup() {
        let attributes = AttributeContainer([.font : UIFont.weightSystemSizeFont(systemFontStyle: .title1, weight: .medium)])
        let insetFloat : CGFloat = 4
        let insets = NSDirectionalEdgeInsets(top: insetFloat, leading: insetFloat * 2, bottom: insetFloat , trailing: insetFloat * 2)
        var leftConfig = UIButton.Configuration.filled()
        let leftAttString = AttributedString("LEFT", attributes: attributes)
        leftConfig.attributedTitle = leftAttString
        leftConfig.contentInsets = insets
        leftConfig.baseBackgroundColor = .grayTheme
        
        leftButton.configuration = leftConfig
        leftButton.addTarget(self, action: #selector(selectButtonTapped ( _ :)), for: .touchUpInside)
        
        var rightConfig = UIButton.Configuration.filled()
        let rigthAttString = AttributedString("RIGHT", attributes: attributes)
        rightConfig.contentInsets = insets
        rightConfig.attributedTitle = rigthAttString
        rightConfig.baseBackgroundColor = .grayTheme
        rightButton.configuration = rightConfig
        
        
        rightButton.addTarget(self, action: #selector(selectButtonTapped ( _ :)), for: .touchUpInside)
    }
    

    
    @objc func selectButtonTapped( _ button : UIButton) {
        if button == leftButton {
            selectButton(side: .left)
        } else {
            selectButton(side: .right)
        }
    }
    
    
    func selectButton( side : Side) {
        if side == .left {
            if leftButton.configuration?.baseBackgroundColor == .orangeTheme {
                leftButton.configuration?.baseBackgroundColor = .grayTheme
                photoInputedIngredient.buttonSide = nil
                delegate?.deleteIngredient()
            } else {
                leftButton.configuration?.baseBackgroundColor = .orangeTheme
                rightButton.configuration?.baseBackgroundColor = .grayTheme
                photoInputedIngredient.buttonSide = side
                delegate?.insertNewIngredient()
            }
        }
        if side == .right {
            
            if rightButton.configuration?.baseBackgroundColor == .orangeTheme {
                rightButton.configuration?.baseBackgroundColor = .grayTheme
                photoInputedIngredient.buttonSide = nil
                delegate?.deleteIngredient()
            } else {
                rightButton.configuration?.baseBackgroundColor = .orangeTheme
                leftButton.configuration?.baseBackgroundColor = .grayTheme
                photoInputedIngredient.buttonSide = side
                delegate?.insertNewIngredient()
            }

        }
    }
    
    func imageViewSetup() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
    }
}
