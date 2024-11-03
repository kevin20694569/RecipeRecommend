import UIKit

protocol CheckingIngredientsViewDelegate : UIViewController {
    func dismissView()
    func generateRecommendRecipes()
    
}

class CheckingIngredientsView : UIView {
    
    
    var titleLabel : UILabel = UILabel()
    var mainTextView : UITextView = UITextView()
    
    var leftButton : ZoomAnimatedButton = ZoomAnimatedButton()
    var rightButton : ZoomAnimatedButton = ZoomAnimatedButton()
    
    var backgroundBlurView : UIVisualEffectView = UIVisualEffectView(frame: .zero, style: .userInterfaceStyle)
    
    var buttonStackView : UIStackView = UIStackView()
    
    weak var delegate : CheckingIngredientsViewDelegate?
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        clipsToBounds = true
        layer.cornerRadius = 32
        blurViewSetup()
        buttonSetup()
        stackViewSetup()
        textViewSetup()
        labelSetup()
        
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(ingredients : [Ingredient]) {

        var nameArray : [String] = []
        for ingredient in ingredients {
            guard let name = ingredient.name else {
                continue
            }
            nameArray.append(name)
        }
        var ingredientsString = nameArray.joined(separator: "、")
        
        mainTextView.text = ingredientsString
        
    }
    
    func textViewLayout() {
        let screenBounds = UIScreen.main.bounds
        NSLayoutConstraint.activate([
            mainTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            mainTextView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenBounds.width * 0.1),
            mainTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenBounds.width * 0.1),
            
            mainTextView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -32)
        ])
    }
    
    func initLayout() {
        [backgroundBlurView, titleLabel, mainTextView, buttonStackView].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        blurViewLayout()
        stackViewLayout()
        textViewLayout()
        labelLayout()
            
        
        
    }
    func textViewSetup() {
        mainTextView.backgroundColor = .clear
        mainTextView.textColor = .primaryLabel
        
        mainTextView.font = UIFont.weightSystemSizeFont(systemFontStyle: .title1, weight: .medium)
        mainTextView.textAlignment = .center
        mainTextView.isEditable = false

    }
    
    func labelSetup() {
        titleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)
        titleLabel.text = "以下為你所輸入的食材："
        titleLabel.textAlignment = .center
    }
    
    func labelLayout() {
        let screenBounds = UIScreen.main.bounds
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenBounds.width * 0.1),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenBounds.width * 0.1),

        ])
    }
    
    func stackViewLayout() {
        let screenBounds = UIScreen.main.bounds
        NSLayoutConstraint.activate([
            buttonStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenBounds.width * 0.06),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenBounds.width * 0.06),
            buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
            
        ])
        
    }
    
    func blurViewLayout() {
        NSLayoutConstraint.activate([
            
            backgroundBlurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundBlurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundBlurView.topAnchor.constraint(equalTo: topAnchor),
            backgroundBlurView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func blurViewSetup() {
        backgroundBlurView.layer.cornerRadius = 32
        backgroundBlurView.clipsToBounds = true
    }
    
    func stackViewSetup() {
        [leftButton, rightButton].forEach() {
            buttonStackView.addArrangedSubview($0)
        }
        buttonStackView.spacing = 20
        buttonStackView.alignment = .fill
        buttonStackView.axis = .horizontal
    }
    
    func buttonSetup() {
        var config = UIButton.Configuration.filled()
        var attString = AttributedString("確認", attributes: .init([.font : UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium), .foregroundColor : UIColor.primaryBackground]))
        config.baseBackgroundColor = .primaryLabel
        config.attributedTitle = attString
    
        leftButton.configuration = config
        leftButton.addTarget(self, action: #selector(leftButtonTapped ( _ :)), for: .touchUpInside)
        config = UIButton.Configuration.filled()
        attString = AttributedString("取消", attributes: .init([.font : UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium), .foregroundColor : UIColor.primaryLabel ]))
        config.baseBackgroundColor = .primaryBackground
        config.attributedTitle = attString
        rightButton.configuration = config
        rightButton.addTarget(self, action: #selector(rightButtonTapped ( _ :)), for: .touchUpInside)
    }
    
    @objc func leftButtonTapped( _ button : UIButton) {
        delegate?.dismissView()
        delegate?.generateRecommendRecipes()
    }
    
    @objc func rightButtonTapped( _ button : UIButton) {
        delegate?.dismissView()
    }
}

