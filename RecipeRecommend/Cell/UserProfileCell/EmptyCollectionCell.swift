import UIKit

class EmptyCollectionCell : UICollectionViewCell {
    
    
    var logoImageView : UIImageView = UIImageView()
    var mainLabel : UILabel  = UILabel()
    var stackView : UIStackView = UIStackView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageViewSetup()
        labelSetup()
        stackViewSetup()
        initLayout()
        isUserInteractionEnabled = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        [stackView].forEach() {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        stackViewLayout()
        imageViewLayout()
        labelLayout()
    }
    
    func stackViewSetup() {
        stackView.axis = .vertical
        stackView.alignment = .center
    }
    
    func stackViewLayout() {
        [logoImageView, mainLabel].forEach() {
            stackView.addArrangedSubview($0)
        }
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func imageViewLayout() {
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 1),
        ])
    }
    
    func labelLayout() {
        NSLayoutConstraint.activate([
            mainLabel.widthAnchor.constraint(equalTo: widthAnchor),
            
        ])
    }
    
    func imageViewSetup() {
        logoImageView.contentMode = .scaleAspectFit
        
    }
    func configure(text : String, image : UIImage = UIImage(named: "app_icon_transparent")!) {
        logoImageView.image = image
        mainLabel.text = text
    }
    
    
    func labelSetup() {
        mainLabel.textColor = .primaryLabel
        mainLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title2 , weight: .medium)
        mainLabel.textAlignment = .center
        
    }
    
    
}
