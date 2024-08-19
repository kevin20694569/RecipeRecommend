import UIKit

class DisplayPreferenceCell : UITableViewCell {
    
    var preference : DishPreference!
    
    var mainView : UIView! = UIView()
    
    
    var labelStackView : UIStackView = UIStackView()
    
    var ingredientsLabel : UILabel = UILabel()
    var cuisineLabel : UILabel = UILabel()
    var equipmentsLabel : UILabel = UILabel()

    var complexityLabel : UILabel = UILabel()
    var timeLimitLabel : UILabel = UILabel()

    var created_timeLabel : UILabel = UILabel()
    
    var mainViewTapGesture : UITapGestureRecognizer!
    
    weak var delegate : DisplayPreferenceCellDelegate?
    
    
    func configure(preference : DishPreference) {
        
        self.preference = preference
        func getAttributedString(text : String) -> NSAttributedString {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            let attString = AttributedString(text, attributes: AttributeContainer([.font : UIFont.weightSystemSizeFont(systemFontStyle: .headline, weight: .medium),
                                                                                   .paragraphStyle : paragraphStyle]))
            let ns = NSAttributedString(attString)
            return ns
        }



        ingredientsLabel.attributedText = getAttributedString(text: "食材：" + preference.ingredientsDescription)
        cuisineLabel.attributedText = getAttributedString(text: "菜式：" + preference.cuisinesDescription)
        equipmentsLabel.attributedText = getAttributedString(text: "設備：" + preference.equipementsDescription)
        complexityLabel.attributedText = getAttributedString(text: "難度：" + preference.complexity.description)
        timeLimitLabel.attributedText = getAttributedString(text: "時間：" + preference.timeLimitDescription)
        
    }
    
    func labelSetup() {
        ingredientsLabel.numberOfLines = 2
        
        
        // 將 attributedString 設置為 UILabel 的 attributedText
      //  label.attributedText = attributedString
    
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        mainViewSetup()
        labelSetup()
        stackViewSetup()
        gestureSetup()
        initLayout()
        mainViewLayout()
        labelLayout()
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
        /*[mainView, ingredientsLabel, cuisineLabel, equipmentsLabel, costTimeLabel, timeLimitLabel, created_timeLabel].forEach() { view in
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }*/
        contentView.addSubview(mainView)
        contentView.addSubview(labelStackView)
        contentView.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        
    }
    
    func stackViewSetup() {
        [mainView, ingredientsLabel, cuisineLabel, equipmentsLabel, complexityLabel, timeLimitLabel, created_timeLabel].forEach() {
            
            labelStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        labelStackView.axis = .vertical
        labelStackView.spacing = 4
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
          //  mainView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
    
    func labelLayout() {
        let verConstant : CGFloat = 16

        NSLayoutConstraint.activate([
           /* ingredientsLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: verConstant),
            cuisineLabel.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: verConstant),
            equipmentsLabel.topAnchor.constraint(equalTo: cuisineLabel.bottomAnchor, constant: verConstant),
            costTimeLabel.topAnchor.constraint(equalTo: equipmentsLabel.bottomAnchor, constant: verConstant),
            timeLimitLabel.topAnchor.constraint(equalTo: costTimeLabel.bottomAnchor, constant: verConstant),
            created_timeLabel.topAnchor.constraint(equalTo: timeLimitLabel.bottomAnchor, constant: verConstant),
            created_timeLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -verConstant)*/
            labelStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: verConstant),
            labelStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -verConstant)
        ])
        let horConstant : CGFloat = 16
        var horConstaintArray : [NSLayoutConstraint]  = []
        [ingredientsLabel, cuisineLabel, equipmentsLabel, complexityLabel, timeLimitLabel, created_timeLabel].forEach() { label in
            label.textColor = .black
            horConstaintArray.append( label.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: horConstant))
            horConstaintArray.append( label.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -horConstant))
        }
       // NSLayoutConstraint.activate(horConstaintArray)
        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: horConstant),
            labelStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -horConstant)
        ])
    }
      
}
