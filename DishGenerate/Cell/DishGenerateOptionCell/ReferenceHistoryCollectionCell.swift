

import UIKit

class ReferenceHistoryCollectionCell : UICollectionViewCell {
    
    var titleLabel : UILabel! = UILabel()
    
    lazy var buttonStackView : UIStackView! = UIStackView(arrangedSubviews: [leftButton, rightButton])
    
    var leftButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    var rightButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
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
        labelSetup()
        buttonStackViewSetup()
        buttonSetup()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(enable : Bool) {
        updateButtonStatus(enable: enable)
    }
    
    
    func labelSetup() {
        titleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)
        titleLabel.text = "採用以往喜好"
    }
    
    func initLayout() {
        [titleLabel, buttonStackView].forEach() { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
        }
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant:  20),
            buttonStackView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        
        ])
    }
    
    func buttonStackViewSetup() {
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 12
        buttonStackView.alignment  = .fill
        buttonStackView.distribution = .fillEqually
    }
    
    func buttonSetup() {
        var leftConfig = UIButton.Configuration.filled()
        leftConfig.attributedTitle = AttributedString("否", attributes: selectAttributed)
        leftButton.configuration = leftConfig
        var rightConfig = UIButton.Configuration.filled()
        rightConfig.attributedTitle = AttributedString("是", attributes: deSelectAttributed   )
        rightButton.configuration = rightConfig
        
        
        leftButton.addTarget(self, action: #selector(leftButtonTapped(_ : )), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonTapped(_ : )), for: .touchUpInside)
        updateButtonStatus(enable: false)
    }
    
    func updateButtonStatus(enable : Bool) {
        let highlightButton = enable ? rightButton : leftButton
        let denyButton = highlightButton == rightButton ? leftButton : rightButton
        
        if let title = highlightButton?.configuration?.title {
            highlightButton?.configuration?.attributedTitle =  AttributedString(title, attributes: selectAttributed )
            highlightButton?.configuration?.baseBackgroundColor = .themeColor
        }
        if let title = denyButton?.configuration?.title {
            denyButton?.configuration?.attributedTitle =  AttributedString(title, attributes: deSelectAttributed )
            denyButton?.configuration?.baseBackgroundColor = .thirdaryBackground
        }
    }
    
    @objc func leftButtonTapped(_ button : UIButton) {
        updateButtonStatus(enable: false)
    }
    
    @objc func rightButtonTapped(_ button : UIButton) {
        updateButtonStatus(enable: true)
    }
    
}
