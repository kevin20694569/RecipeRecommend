
import UIKit

class IndicatorCollectionCell : UICollectionViewCell, IndicatorCell {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackViewSetup()
        initLayout()
        configureIndicatorViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var stackView : UIStackView! = UIStackView()
    
    let navTitleArray : [String]! = ["照片輸入食材", "確認食材"]

    func indicatorViewSetup() {
        
    }
    
    func configure(highlightIndex : Int) {
        stackView.arrangedSubviews.enumerated().forEach() { (index ,view) in
            if let indicatorView = view as? IndicatorLabelView {
                switch index {
                case highlightIndex :
                    indicatorView.highlight()
                    return
                default:
                    break
                }
            }
        }
    }
    
    func configureIndicatorViews() {
        let count = navTitleArray.count - 1
        for i in 0...count {
            let index = CGFloat(i)
            let frame = CGRect(x: 0, y: 0, width: self.bounds.width / index, height: bounds.height)
            let indicatorView = IndicatorLabelView(frame: frame)
            stackView.addArrangedSubview(indicatorView)
            let title = self.navTitleArray[i]
            indicatorView.configure(orderIndex: i + 1 , title: title)
            switch i {
            case 0 :
                indicatorView.drawLine(direction: .right)
            case navTitleArray.count - 1 :
                indicatorView.drawLine(direction: .left)
            default:
                break
            }
        }
    }
    
    func initLayout() {

        contentView.addSubview(stackView)
        
        contentView.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        
        ])
    }
    
    func stackViewSetup() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.alignment = .fill
    }
    
    
}
