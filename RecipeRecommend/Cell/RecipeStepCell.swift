import UIKit



class RecipeStepCell : UITableViewCell {
    
    var step : Step!
    
    var stepImageView : UIImageView! = UIImageView(image: UIImage(systemName: "photo"))
    
    var descriptionLabel : UILabel! = UILabel()
    var stepOrderLabel : UILabel! = UILabel()
    
    func configure(step : Step) {
        self.step = step
        stepOrderLabel.text = String(step.order + 1)
        updateDescriptionLabel(text: step.description)
        Task(priority : .background) {
            let image =  await step.getImage()
            stepImageView.setImageWithAnimation(image: image)
                
        }
    }
    
    
    func initLayout() {
        [stepImageView, descriptionLabel, stepOrderLabel].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        

        imageViewLayout()
        descriptionLabelLayout()
        orderLabelLayout()
        
        
    }
    
    func imageViewLayout() {
        NSLayoutConstraint.activate([
            stepImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stepImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stepImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stepImageView.heightAnchor.constraint(equalTo: stepImageView.widthAnchor, multiplier: 1),
        ])
    }
    
    func descriptionLabelLayout() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: stepImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: stepImageView.leadingAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: stepImageView.trailingAnchor, constant: -4),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    func orderLabelLayout() {
        
        NSLayoutConstraint.activate([
            stepOrderLabel.leadingAnchor.constraint(equalTo: stepImageView.leadingAnchor, constant: 12),
            stepOrderLabel.topAnchor.constraint(equalTo: stepImageView.topAnchor, constant: 12),
            
            stepOrderLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.09),
            stepOrderLabel.heightAnchor.constraint(equalTo: stepOrderLabel.widthAnchor, multiplier: 1)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stepImageView.image = nil
    }
         
    func imageViewSetup() {
        stepImageView.contentMode = .scaleAspectFill
        stepImageView.clipsToBounds = true
        stepImageView.layer.cornerRadius = 16
        stepImageView.backgroundColor = .secondaryBackground
    }
    
    func labelSetup() {
        descriptionLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
        descriptionLabel.numberOfLines = 0
        stepOrderLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .bold)
        stepOrderLabel.backgroundColor = .orangeTheme
        stepOrderLabel.clipsToBounds = true
        stepOrderLabel.textAlignment = .center
        stepOrderLabel.layer.cornerRadius = 8
    }
    
    func updateDescriptionLabel(text : String?) {
        guard let text = text else {
            return
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        let attString = AttributedString(text, attributes: AttributeContainer([.font : UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .bold),
                                                                               .paragraphStyle : paragraphStyle,
                                                                               .kern : 2]))
        let ns = NSAttributedString(attString)
        descriptionLabel.attributedText = ns
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        imageViewSetup()
        labelSetup()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


 
