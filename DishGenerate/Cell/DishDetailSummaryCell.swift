import UIKit

class DishDetailSummaryCell : UITableViewCell {
    
    var dish : Recipe!

    var dishImageView : UIImageView! = UIImageView()
    
    var titleLabel : UILabel = UILabel()
    
    var complexityStackView : UIStackView! = UIStackView()
    
    var costTimeLabel : UILabel = UILabel()
    
    var complexityLabel : UILabel = UILabel()
    

    
    var summaryLabel : UILabel! = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        imageViewSetup()
        labeltSetup()
        stackViewSetup()
        initLayout()
        cellSetup()
    }
    
    func imageViewSetup() {
        dishImageView.contentMode = .scaleAspectFill
        dishImageView.clipsToBounds = true
        dishImageView.layer.cornerRadius = 16
        dishImageView.backgroundColor = .secondaryBackground
    }
    
    func labeltSetup() {
        titleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)
        titleLabel.numberOfLines = 0
        summaryLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
        summaryLabel.numberOfLines = 0
    }
    func stackViewSetup() {
        complexityStackView.axis = .horizontal
        complexityStackView.spacing = 4
        let starImageView = UIImageView(image: UIImage(systemName: "star.fill")?.withTintColor(.yelloTheme  , renderingMode: .alwaysOriginal))
        complexityStackView.addArrangedSubview(starImageView)
        complexityStackView.addArrangedSubview(complexityLabel)
        complexityStackView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        
        contentView.addSubview(dishImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(summaryLabel)
        contentView.addSubview(complexityStackView)
        contentView.addSubview(costTimeLabel)
        contentView.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        imageViewLayout()
        stackViewLayout()
        labelLayout()
        
    }
    
    func cellSetup() {
        let screenBounds = UIScreen.main.bounds
        self.separatorInset = UIEdgeInsets(top: 0, left: screenBounds.width / 2, bottom: 0, right: screenBounds.width / 2)
    }
    
    func labelLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: dishImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: dishImageView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: dishImageView.trailingAnchor, constant: -20),
            
            summaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            summaryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            summaryLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            costTimeLabel.centerYAnchor.constraint(equalTo: complexityStackView.centerYAnchor),
            costTimeLabel.trailingAnchor.constraint(equalTo: dishImageView.trailingAnchor, constant: -20),
        ])
    }
    

    
    func stackViewLayout() {
        let screenBounds = UIScreen.main.bounds
        NSLayoutConstraint.activate([
            complexityStackView.leadingAnchor.constraint(equalTo: summaryLabel.leadingAnchor),
            complexityStackView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 20),
            dishImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            complexityStackView.bottomAnchor.constraint(equalTo:  contentView.bottomAnchor, constant: -12),
        ])
    }
    
    func imageViewLayout() {
        let screenBounds = UIScreen.main.bounds
        NSLayoutConstraint.activate([
            dishImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dishImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            dishImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            //recipeImageView.bottomAnchor.constraint(equalTo:  contentView.bottomAnchor, constant: -20),
            dishImageView.heightAnchor.constraint(equalToConstant: screenBounds.height * 0.3)
        ])
    }
    
    func configure(dish : Recipe) {
        self.dish = dish
        self.titleLabel.text = dish.name
        summaryLabel.text = dish.description
        costTimeLabel.text = dish.costTimeDescription
        //complexityLabel.text = recipe.complexity.description
        Task {
            dishImageView.image = await dish.getImage()
        }
    }
}
