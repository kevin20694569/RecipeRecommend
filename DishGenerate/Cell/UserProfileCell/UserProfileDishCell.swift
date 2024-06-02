import UIKit

class UserProfileDishCell : UICollectionViewCell {
    
    var dish : Dish!
    
    var background : UIView! = UIView()
    
    var imageView : UIImageView! = UIImageView()
    
    var titleLabel : UILabel! = UILabel()
    
    var diffiicultStackView : UIStackView! = UIStackView()
    
    var starImageView : UIImageView! = UIImageView(image: UIImage(systemName: "star.fill")?.withTintColor(.yelloTheme, renderingMode: .alwaysOriginal))
    var complexityLabel : UILabel! = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundSetup()
        labelSetup()
        stackViewSetup()
        imageViewSetup()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(dish : Dish) {
        self.dish = dish
        self.titleLabel.text = dish.name
        complexityLabel.text = dish.complexity
    }
    
    func initLayout() {
        [background, imageView, titleLabel, diffiicultStackView].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: background.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            

            diffiicultStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            diffiicultStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func stackViewSetup() {
        diffiicultStackView.axis = .horizontal
        diffiicultStackView.spacing = 2
        diffiicultStackView.distribution = .fill
        diffiicultStackView.alignment = .fill
        [complexityLabel, starImageView].forEach() {
            diffiicultStackView.addArrangedSubview($0)
        }
    }
    
    func labelSetup() {
        titleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .callout, weight: .medium)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.thirdaryLabel
        complexityLabel.textColor = UIColor.thirdaryLabel
        complexityLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .footnote, weight: .regular)
        complexityLabel.adjustsFontSizeToFitWidth = true
    }
    
    func backgroundSetup() {
        background.clipsToBounds = true
        background.backgroundColor = UIColor.thirdaryBackground
        background.layer.cornerRadius = 12
    }
    
    func imageViewSetup() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .secondaryBackground
        
        starImageView.contentMode = .scaleAspectFit
    }
}
