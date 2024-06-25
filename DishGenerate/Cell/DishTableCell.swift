import UIKit


class DishSnapshotCell : UITableViewCell, DishTableCell {
    
    var dishImageView : UIImageView! = UIImageView()
    var nameLabel : UILabel! = UILabel()
    var timeLabel : UILabel! = UILabel()
    
    var dishDetailStatusLogoButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var heartButton : ZoomAnimatedButton! = ZoomAnimatedButton(frame: .zero)
    
    var currentDish : Dish!
    
    let detailButtonConfig = UIImage.SymbolConfiguration(font: UIFont.weightSystemSizeFont(systemFontStyle: .footnote, weight: .bold))
    
    let heartButtonConfig = UIImage.SymbolConfiguration(font: UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium))
    
    func configure(dish : Dish) {
        
        currentDish = dish
        self.nameLabel.text = dish.name
        self.timeLabel.text = dish.costTime
        self.dishImageView.image = dish.image
        configureHearButtonImage()
        configureDetailStatus()
        Task {
            self.dishImageView.image = await dish.getImage()
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
        switch self.currentDish.status {
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
        }
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
        nameLabel.font = nameFont
        
        let timeFont = UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .regular)
        timeLabel.textColor = .secondaryLabelColor
        timeLabel.font = timeFont
    }
    
    @objc func heartButtonToggle() {
        self.currentDish.liked.toggle()
        configureHearButtonImage()
    }

    
    func configureHearButtonImage() {
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
        contentView.addSubview(dishDetailStatusLogoButton)
        self.contentView.addSubview(nameLabel)
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
            
            nameLabel.topAnchor.constraint(equalTo: dishImageView.bottomAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            nameLabel.leadingAnchor.constraint(equalTo: dishImageView.leadingAnchor, constant: 4),
            timeLabel.trailingAnchor.constraint(equalTo: dishImageView.trailingAnchor, constant: -4),
            timeLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            
            heartButton.topAnchor.constraint(equalTo: dishImageView.topAnchor, constant: 16),
            heartButton.trailingAnchor.constraint(equalTo: dishImageView.trailingAnchor, constant: -16),
            
            dishDetailStatusLogoButton.centerYAnchor.constraint(equalTo: heartButton.centerYAnchor),
            dishDetailStatusLogoButton.leadingAnchor.constraint(equalTo: dishImageView.leadingAnchor, constant: 16),

            
            dishDetailStatusLogoButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.13),
            dishDetailStatusLogoButton.widthAnchor.constraint(equalTo: dishDetailStatusLogoButton.heightAnchor),

            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
