import UIKit

class HistoryRecipeCell : UICollectionViewCell, RecipeDelegate {
    func reloadRecipe(recipe: Recipe) {
        self.recipe = recipe
    }

    var recipe : Recipe!
    
    var background : UIView! = UIView()
    
    var imageView : UIImageView! = UIImageView()
    
    var titleLabel : UILabel! = UILabel()
    
    var costTimeLabel : UILabel! = UILabel()
    
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
    
    func configure(recipe : Recipe) {
        self.recipe = recipe
        self.titleLabel.text = recipe.name
       // costTimeLabel.text = recipe.costTimeDescription
        Task(priority : .background) {
            let image = await recipe.getImage()
            self.imageView.setImageWithAnimation(image: image)
        }
    }
    
    func initLayout() {
        [background, imageView, titleLabel].forEach() {
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
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            /*
            costTimeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            costTimeLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            costTimeLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            costTimeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            costTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
             */
        ])
    }
    
    func stackViewSetup() {
        /*stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fill
        stackView.alignment = .fill
        [costTimeLabel, starImageView].forEach() {
            stackView.addArrangedSubview($0)
        }
        stackView.isHidden = true*/
    }
    
    func labelSetup() {
        titleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .bold)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.textColor = .primaryLabel
        costTimeLabel.textColor = .secondaryLabel
        costTimeLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .callout, weight: .medium)
      //  costTimeLabel.adjustsFontSizeToFitWidth = true
      //  costTimeLabel.textAlignment = .center
    }
    
    func backgroundSetup() {
        background.clipsToBounds = true
        background.backgroundColor = UIColor.thirdaryBackground
        background.layer.cornerRadius = 16
    }
    
    func imageViewSetup() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .secondaryBackground
        
        //starImageView.contentMode = .scaleAspectFit
    }
}
