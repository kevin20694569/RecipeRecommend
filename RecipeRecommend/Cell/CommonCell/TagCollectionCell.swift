
import UIKit
class TagCollectionCell : UICollectionViewCell {
    
    
    var titleLabel : UILabel = UILabel()
    
    var mainView : UIView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainViewSetup()
        labelSetup()
        initLayout()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        [mainView, titleLabel].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        mainViewLayout()
        titleLabelLayout()
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    func labelSetup() {
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .primaryLabel
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .medium)
    }
    
    func mainViewSetup() {
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 16
        mainView.backgroundColor = .thirdaryBackground
        
    }
    
    func mainViewLayout() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: topAnchor),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func titleLabelLayout() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            titleLabel.topAnchor.constraint(equalTo: mainView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
        ])
    }
    
    func configure(tagText : String) {
        titleLabel.text = tagText
    }
    
    
    
}

