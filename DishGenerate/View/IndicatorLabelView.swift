import UIKit

class IndicatorLabelView : UIView {
    
    var stackView : UIStackView! = UIStackView(frame: .zero)
    
    var indicatorCircleView : UIView! = UIView()
    
    var textLabel : UILabel! = UILabel()
    
    var orderLabel : UILabel! = UILabel()
    
    var leftLineView : UIView! = UIView()
    var rightLineView : UIView! = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackViewSetup()
        lineViewSetup()
        indicatorCicleViewSetup()
        labelSetup()



    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        initLayout()
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    func configure(orderIndex : Int, title : String) {
        self.orderLabel.text = String(orderIndex)
        self.textLabel.text = title
    }
    

    
    func initLayout() {
        self.addSubview(stackView)

        self.addSubview(orderLabel)
        self.addSubview(leftLineView)
        self.addSubview(rightLineView)
        self.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            indicatorCircleView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4),
            indicatorCircleView.widthAnchor.constraint(equalTo: indicatorCircleView.heightAnchor),
            orderLabel.centerXAnchor.constraint(equalTo: indicatorCircleView.centerXAnchor),
            orderLabel.centerYAnchor.constraint(equalTo: indicatorCircleView.centerYAnchor),
        ])
        NSLayoutConstraint.activate([
            rightLineView.leadingAnchor.constraint(equalTo: indicatorCircleView.trailingAnchor),
            rightLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            rightLineView.heightAnchor.constraint(equalToConstant: 1),
            rightLineView.centerYAnchor.constraint(equalTo: indicatorCircleView.centerYAnchor),
            
            leftLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor ),
            leftLineView.trailingAnchor.constraint(equalTo:  indicatorCircleView.leadingAnchor ),
            leftLineView.heightAnchor.constraint(equalToConstant: 1),
            leftLineView.centerYAnchor.constraint(equalTo: indicatorCircleView.centerYAnchor),
        ])
        indicatorCircleView.layoutIfNeeded()
        indicatorCircleView.layer.cornerRadius = indicatorCircleView.bounds.height / 2
    }
    enum LineDirection {
        case left
        case right
    }
    
    func drawLine(direction : LineDirection) {
        switch direction {
        case .left :
            rightLineView.isHidden = true
        case .right :
            leftLineView.isHidden = true
        }
    }
    
    func highlight() {
        self.indicatorCircleView.backgroundColor = .tintColor
        
    }
    
    func lineViewSetup() {
        leftLineView.backgroundColor = .label
        rightLineView.backgroundColor = .label
    }
    
    func indicatorCicleViewSetup() {
        indicatorCircleView.backgroundColor = .secondaryBackgroundColor
        indicatorCircleView.clipsToBounds = true
    }
    
    func stackViewSetup() {
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fillProportionally
        [indicatorCircleView , textLabel].forEach() {
            stackView.addArrangedSubview($0)
        }
    }
    
    
    
    func labelSetup() {
        self.orderLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .callout, weight: .regular)
        textLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .footnote , weight: .medium)
        textLabel.adjustsFontSizeToFitWidth = true
    }
    
}
