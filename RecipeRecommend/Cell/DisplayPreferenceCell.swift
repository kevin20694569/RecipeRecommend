import UIKit

class DisplayPreferenceCell : UITableViewCell {
    
    var preference : GenerateRecipePreference!
    
    var mainView : UIView! = UIView()
    
    
    var labelStackView : UIStackView = UIStackView()
    
    var ingredientsLabel : UILabel = UILabel()
    var cuisineLabel : UILabel = UILabel()
    var equipmentsLabel : UILabel = UILabel()

    var complexityLabel : UILabel = UILabel()
    var timeLimitLabel : UILabel = UILabel()
    
    var addtionalTextLabel : UILabel = UILabel()
    
    
    var created_timeLabel : UILabel = UILabel()
    
    
    
    var mainViewTapGesture : UITapGestureRecognizer!
    
    weak var delegate : DisplayPreferenceCellDelegate?
    
    
    func configure(preference : GenerateRecipePreference) {
        
        self.preference = preference
        func getAttributedString(text : String, color : UIColor = .color950, font : UIFont = UIFont.weightSystemSizeFont(systemFontStyle: .headline, weight: .bold)) -> NSAttributedString {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            let attString = AttributedString(text, attributes: AttributeContainer([.font : font,
                                                                                   .paragraphStyle : paragraphStyle, .foregroundColor : color]))
            let ns = NSAttributedString(attString)
            return ns
        }
        
        
        
        ingredientsLabel.attributedText = getAttributedString(text: "食材：" + preference.ingredientsDescription)
        cuisineLabel.attributedText = getAttributedString(text: "菜式：" + preference.cuisinesDescription)
        equipmentsLabel.attributedText = getAttributedString(text: "設備：" + preference.equipementsDescription)
      //  complexityLabel.attributedText = getAttributedString(text: "難度：" + preference.complexity.description)
       // timeLimitLabel.attributedText = getAttributedString(text: "時間：" + preference.timeLimitDescription)
        
        if let text = preference.addictionalText {
            addtionalTextLabel.attributedText = getAttributedString(text: "ex：" + text)
            labelStackView.addArrangedSubview(addtionalTextLabel)
        } else {
            addtionalTextLabel.removeFromSuperview()
        }
        
        if let created_time = preference.created_time,
           let formattedStr = Formatter.timeAgoOrDate(from: created_time) {
            created_timeLabel.attributedText = getAttributedString(text: formattedStr, color: .secondaryLabelColor, font: UIFont.weightSystemSizeFont(systemFontStyle: .callout, weight: .medium))
        }
        

        
        
    }
    
    func labelSetup() {
        ingredientsLabel.numberOfLines = 0
        equipmentsLabel.numberOfLines = 0
        [ingredientsLabel, cuisineLabel, equipmentsLabel, /*complexityLabel, timeLimitLabel,*/ addtionalTextLabel ].forEach() {
            let attributedString = NSMutableAttributedString(string: "", attributes: [.foregroundColor : UIColor.color950])

            // 设置行间距
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6



            $0.attributedText = attributedString
            $0.textColor = .color950
            labelStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        mainViewSetup()
        labelSetup()
        stackViewSetup()
        gestureSetup()
        initLayout()
        backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //addtionalTextLabel.removeFromSuperview()
    }
    
    
    func gestureSetup() {
        mainViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(mainViewGestureTapped( _ :)))
       // mainView.addGestureRecognizer(mainViewTapGesture)
    }
    
    @objc func mainViewGestureTapped(_ sender : UITapGestureRecognizer) {
        delegate?.showDishSummaryViewController(preference_id: self.preference.id, showRightBarButtonItem: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func mainViewSetup() {
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 20
        mainView.backgroundColor = .thirdaryBackground
        mainView.isUserInteractionEnabled = true
    }
    
    func initLayout() {
        contentView.addSubview(mainView)
        contentView.addSubview(labelStackView)
        contentView.addSubview(created_timeLabel)
        contentView.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        mainViewLayout()
        labelLayout()

    }
    
    func stackViewSetup() {

        labelStackView.axis = .vertical
        labelStackView.spacing = 6
        labelStackView.distribution = .equalSpacing
        labelStackView.isUserInteractionEnabled = true
    }
    
    func mainViewLayout() {

        let verConstant : CGFloat = 10
        let horConstant : CGFloat = 20
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verConstant),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verConstant),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horConstant),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horConstant),
        ])
    }
    
    func labelLayout() {
        let verConstant : CGFloat = 16

        NSLayoutConstraint.activate([

            labelStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: verConstant),
         
            created_timeLabel.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: verConstant / 2),
            created_timeLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: verConstant),
            created_timeLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -12),
        
        ])
        let horConstant : CGFloat = 16
        var horConstaintArray : [NSLayoutConstraint]  = []
        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: horConstant),
            labelStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -horConstant)
        ])
    }
      
}
