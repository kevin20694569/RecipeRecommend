

import UIKit

class IndicatorTableCell : UITableViewCell {
    
    var stackView : UIStackView! = UIStackView()
    
    let navTitleArray : [String]! = ["輸入食材", "詳細需求", "生產食譜"]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        stackViewSetup()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func indicatorViewSetup() {
        
    }
    
    func configure() {
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
                indicatorView.highlight()
            case count :
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
                                


