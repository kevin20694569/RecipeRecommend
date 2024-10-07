import UIKit

class StepIndicatorCollectionCell : UICollectionViewCell {
    var indicatorView : UIView! = UIView()
    
    var indicatorOrderLabel : UILabel! = UILabel()
    
    var indicatorDescriptonLabel : UILabel! = UILabel()
    
    func initLayout() {
        contentView.addSubview(indicatorView)
        contentView.addSubview(indicatorOrderLabel)
        contentView.addSubview(indicatorDescriptonLabel)
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            indicatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.33),
            indicatorView.heightAnchor.constraint(equalTo: indicatorView.widthAnchor, multiplier: 1),

            indicatorOrderLabel.centerXAnchor.constraint(equalTo: indicatorView.centerXAnchor),
            indicatorOrderLabel.centerYAnchor.constraint(equalTo: indicatorView.centerYAnchor),
            
            indicatorOrderLabel.widthAnchor.constraint(equalTo: indicatorView.widthAnchor, multiplier: 0.8),
            indicatorOrderLabel.heightAnchor.constraint(equalTo: indicatorOrderLabel.widthAnchor, multiplier: 1),
            
            indicatorDescriptonLabel.centerYAnchor.constraint(equalTo: indicatorView.centerYAnchor),
            
            indicatorDescriptonLabel.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 12),
            
            indicatorDescriptonLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            
            
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
