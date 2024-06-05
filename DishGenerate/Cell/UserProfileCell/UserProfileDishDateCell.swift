
import UIKit

class UserProfileDishDateCell : UICollectionViewCell {
    
    var titleLabel : UILabel! = UILabel()
    
    var circleView : UIView! = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        circleViewSetup()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        [circleView, titleLabel].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        NSLayoutConstraint.activate([
            circleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            circleView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
            
            titleLabel.leadingAnchor.constraint(equalTo: circleView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            
        ])
        circleView.layoutIfNeeded()
        circleView.layer.cornerRadius = circleView.bounds.height / 2
    }
    
    func circleViewSetup() {
        circleView.backgroundColor = .secondaryBackground
        
    }
}
