import UIKit


class TitleLabelSideCollectionCell : UICollectionViewCell, HorizontalBackgroundAnchorSideCell {
    
    var background : UIView! = UIView()
    
    var titleLabel : UILabel! = UILabel()
    
    var anchorSide : HorizontalAnchorSide! = .center
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundSetup()
        labelSetup()
        initLayout()
    }
    
    func initLayout() {
        
        [background, titleLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
        }
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            background.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),

            titleLabel.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: background.centerYAnchor),
        ])
    }
    
    func configure(title : String) {
        titleLabel.text = title
    }
    
    
    func backgroundSetup() {
        background.backgroundColor = .themeColor
        background.clipsToBounds = true
        background.layer.cornerRadius = 12
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func labelSetup() {
        titleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .medium)
        titleLabel.adjustsFontSizeToFitWidth = true
    }
}

class TitleLabelCenterCollectionCell : TitleLabelSideCollectionCell {
    
    override func initLayout() {
        super.initLayout()
        
        backgroundCenterAnchor.isActive = true
    }
    
}
class TitleLabelLeadingCollectionCell : TitleLabelSideCollectionCell {
    
    override func initLayout() {
        super.initLayout()
        
        backgroundLeadingAnchor.isActive = true
    }
    
}
class TitleLabelTrailngCollectionCell : TitleLabelSideCollectionCell {
    
    override func initLayout() {
        super.initLayout()
        
        backgroundTrailingAnchor.isActive = true
    }
    
}











