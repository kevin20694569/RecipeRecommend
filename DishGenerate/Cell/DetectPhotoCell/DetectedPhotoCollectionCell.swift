import UIKit

class DetectedPhotoCollectionCell : UICollectionViewCell {
    
    var leftButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var rightButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var stackView : UIStackView! = UIStackView()
    
    var photoInputedIngredient : PhotoInputedIngredient!
    
    var currentOutputedIngredient : Ingredient?
    
    var buttonSide : Side?
    
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
    
    func configure(inputedIngredient : PhotoInputedIngredient, outputedIngredient : Ingredient?) {
        self.photoInputedIngredient = inputedIngredient
        self.currentOutputedIngredient = outputedIngredient
        imageView.image = inputedIngredient.image
        self.buttonSide = inputedIngredient.buttonSide
        if inputedIngredient.buttonSide == .left {
            leftButton.configuration?.baseBackgroundColor = .orangeTheme
            rightButton.configuration?.baseBackgroundColor = .grayTheme
        } else if inputedIngredient.buttonSide == .right {
            rightButton.configuration?.baseBackgroundColor = .orangeTheme
            leftButton.configuration?.baseBackgroundColor = .grayTheme
        } else {
            rightButton.configuration?.baseBackgroundColor = .grayTheme
            leftButton.configuration?.baseBackgroundColor = .grayTheme
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
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        
            
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
        if side == .left && self.buttonSide != .left {
            leftButton.configuration?.baseBackgroundColor = .orangeTheme
            rightButton.configuration?.baseBackgroundColor = .grayTheme
            photoInputedIngredient.buttonSide = side
           
            if let title = leftButton.configuration?.title {
                let outputedIngredient = Ingredient(name: title)
                self.currentOutputedIngredient = outputedIngredient
                delegate?.insertNewIngredient(ingredient: outputedIngredient, section: .Photo)
            }
            
        } else if side == .right && self.buttonSide != .right {
            rightButton.configuration?.baseBackgroundColor = .orangeTheme
            leftButton.configuration?.baseBackgroundColor = .grayTheme
            photoInputedIngredient.buttonSide = side
            if let title = rightButton.configuration?.title {
                let outputedIngredient = Ingredient(name: title)
                self.currentOutputedIngredient = outputedIngredient
                delegate?.insertNewIngredient(ingredient: outputedIngredient, section: .Photo)
            }
        } else {
            rightButton.configuration?.baseBackgroundColor = .grayTheme
            leftButton.configuration?.baseBackgroundColor = .grayTheme

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
