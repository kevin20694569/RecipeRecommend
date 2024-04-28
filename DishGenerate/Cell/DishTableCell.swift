import UIKit


class DishSnapshotCell : UITableViewCell, DishTableCell {
    
    var dishImageView : UIImageView! = UIImageView()
    var nameLabel : UILabel! = UILabel()
    var timeLabel : UILabel! = UILabel()
    
    var heartButton : ZoomAnimatedButton! = ZoomAnimatedButton(frame: .zero)
    
    var currentDish : Dish!
    
    let heartButtonConfig = UIImage.SymbolConfiguration(font: UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium))
    
    func configure(dish : Dish) {
        currentDish = dish
        self.nameLabel.text = dish.name
        self.timeLabel.text = dish.costTime
        self.dishImageView.image = dish.image
        configureHearButtonImage()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier: reuseIdentifier)
        viewLayout()
        buttonSetup()
        labelSetup()
        imageViewSetup()
    }
    
    func imageViewSetup() {
        dishImageView.contentMode = .scaleAspectFill
        dishImageView.layer.cornerRadius = 12
        dishImageView.clipsToBounds = true
        dishImageView.backgroundColor = .secondaryBackgroundColor
    }
    
    func buttonSetup() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .clear
        self.heartButton.configuration = config
        heartButton.addTarget(self, action: #selector(heartButtonToggle), for: .touchUpInside)
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
        let fillImage = UIImage(systemName: "heart.fill")!.withConfiguration(heartButtonConfig).withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        let borderImage = UIImage(systemName: "heart")!.withConfiguration(heartButtonConfig)
        self.heartButton.configuration?.image = self.currentDish.liked ? fillImage :  borderImage
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dishImageView.image = nil
    }
    
    func viewLayout() {
        let screenBounds = UIScreen.main.bounds
        self.contentView.addSubview(dishImageView)
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
            
            heartButton.topAnchor.constraint(equalTo: dishImageView.topAnchor, constant: 4),
            heartButton.trailingAnchor.constraint(equalTo: dishImageView.trailingAnchor, constant: -4)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
