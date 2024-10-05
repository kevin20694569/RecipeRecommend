import UIKit


class RecipeSnapshotCell : UITableViewCell, RecipeTableCell, RecipeDelegate {
    
    func reloadRecipe(recipe: Recipe) {
        self.currentDish = recipe
        configureDetailStatus()
    }
    

    var dishImageView : UIImageView! = UIImageView()
    var titleLabel : UILabel! = UILabel()
    var timeLabel : UILabel! = UILabel()
    
    var dishDetailStatusLogoButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var heartButton : ZoomAnimatedButton! = ZoomAnimatedButton(frame: .zero)
    
    var currentDish : Recipe!
    
    let detailButtonConfig = UIImage.SymbolConfiguration(font: UIFont.weightSystemSizeFont(systemFontStyle: .footnote, weight: .bold))
    
    let heartButtonConfig = UIImage.SymbolConfiguration(font: UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium))
    
    
    
    func configure(recipe : Recipe) {
        
        currentDish = recipe
        self.titleLabel.text = recipe.name
        self.timeLabel.text = recipe.costTimeDescription
        self.dishImageView.image = recipe.image
        configureRecipeLikedStatus(liked: recipe.liked)
        configureDetailStatus()
        Task(priority : .background) {
            let image = await recipe.getImage()
            self.dishImageView.setImageWithAnimation(image: image)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier: reuseIdentifier)
        viewLayout()
        cellSetup()
        buttonSetup()
        labelSetup()
        imageViewSetup()
    }
    
    func imageViewSetup() {
        dishImageView.contentMode = .scaleAspectFill
        dishImageView.layer.cornerRadius = 12
        dishImageView.clipsToBounds = true
        dishImageView.backgroundColor = .secondaryBackgroundColor
        
        dishDetailStatusLogoButton.contentMode = .scaleAspectFit
        dishDetailStatusLogoButton.clipsToBounds = true
        dishDetailStatusLogoButton.layer.cornerRadius = 8

        
    }
    
    
    func configureDetailStatus() {
        var image : UIImage?
        var backgroundColor : UIColor = .themeColor
        var showsActivityIndicator : Bool = false
      /*  switch self.currentDish.status {
        case .none :
            image = UIImage(systemName: "frying.pan.fill")
            backgroundColor = .themeColor
            
        case .already :
            image = UIImage(systemName: "checkmark")
            backgroundColor = .orangeTheme
            
        case .isGenerating :
            showsActivityIndicator = true
        default :
            image = nil
            showsActivityIndicator = false
        }*/
        dishDetailStatusLogoButton.configuration?.image = image?.withConfiguration(detailButtonConfig)
        dishDetailStatusLogoButton.configuration?.baseBackgroundColor = backgroundColor
        dishDetailStatusLogoButton.configuration?.showsActivityIndicator = showsActivityIndicator
    }
    
    func cellSetup() {
        self.selectionStyle = .default
    }
    
    func buttonSetup() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .clear
        config.preferredSymbolConfigurationForImage = heartButtonConfig
        config.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        self.heartButton.configuration = config
        heartButton.addTarget(self, action: #selector(heartButtonToggle), for: .touchUpInside)
        
        var detailConfig = UIButton.Configuration.filled()
        detailConfig.baseBackgroundColor = .themeColor
        detailConfig.preferredSymbolConfigurationForImage = detailButtonConfig
        detailConfig.baseForegroundColor = .backgroundPrimary
        detailConfig.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        self.dishDetailStatusLogoButton.configuration = detailConfig
    }
    
    func labelSetup() {
        let nameFont = UIFont.weightSystemSizeFont(systemFontStyle: .title3 , weight: .medium)
        titleLabel.font = nameFont
        //titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        let timeFont = UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .regular)
        timeLabel.textColor = .secondaryLabelColor
        timeLabel.font = timeFont
        timeLabel.textAlignment = .right
        timeLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    @objc func heartButtonToggle() {
        self.currentDish.liked.toggle()
        Task {
            try await RecipeManager.shared.markAsLiked(recipe_id: self.currentDish.id, like: currentDish.liked)
        }
        configureRecipeLikedStatus(liked: currentDish.liked)
    }

    
    func configureRecipeLikedStatus(liked : Bool) {
        let fillImage = UIImage(systemName: "heart.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        let borderImage = UIImage(systemName: "heart")
        self.heartButton.configuration?.image = self.currentDish.liked ? fillImage :  borderImage
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dishImageView.image = nil
    }
    
    func viewLayout() {
        let screenBounds = UIScreen.main.bounds
        self.contentView.addSubview(dishImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(heartButton)
        contentView.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            dishImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            dishImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dishImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dishImageView.heightAnchor.constraint(equalToConstant: screenBounds.height * 0.25),
            
            titleLabel.topAnchor.constraint(equalTo: dishImageView.bottomAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(equalTo: dishImageView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -8),
           
            timeLabel.trailingAnchor.constraint(equalTo: dishImageView.trailingAnchor, constant: -12),
            timeLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 2),
            timeLabel.widthAnchor.constraint(equalTo: dishImageView.widthAnchor, multiplier: 0.18),
            heartButton.topAnchor.constraint(equalTo: dishImageView.topAnchor, constant: 16),
            heartButton.trailingAnchor.constraint(equalTo: dishImageView.trailingAnchor, constant: -16),
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
