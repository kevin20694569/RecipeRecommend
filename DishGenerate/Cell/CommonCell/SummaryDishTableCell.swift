import UIKit




class SummaryDishTableCell : UITableViewCell, ReloadDishDelegate {
    func reloadDish(dish: Dish) {
        self.dish = dish
        self.updateBottomButtonStatus(animated: true)
    }
    
    
    var dish : Dish!
    
    var titleLabel : UILabel! = UILabel()
    
    
    var heartButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var dishImageView : UIImageView! = UIImageView()
    
    var summaryLabel : UILabel! = UILabel()
    
    var difficultImageView : UIImageView! = UIImageView()
    
    var difficultLabel : UILabel! = UILabel()
    
    var difficultStackView : UIStackView! = UIStackView()
    
    var timeLabel : UILabel! = UILabel()
    
    var bottomButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    weak var summaryDishTableCellDelegate : SummaryDishTableCellDelegate?
    
    var generatedStringAttributes : AttributeContainer! = AttributeContainer([.font : UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)])
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buttonSetup()
        stackViewSetup()
        timeLabelSetup()
        titleLabelSetup()
        summaryLabelSetup()
        backgroundSetup()
        imageViewSetup()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(dish : Dish) {
        self.dish = dish
        dishImageView.image = dish.image
        summaryLabel.text = dish.summary
        titleLabel.text = dish.name
        timeLabel.text = dish.costTime
        difficultLabel.text = dish.complexity.description
        updateHeartButtonStatus()
        updateBottomButtonStatus(animated: false)
    }
    
    func initLayout() {
        [ dishImageView, summaryLabel, titleLabel, timeLabel, difficultStackView, heartButton, bottomButton].forEach() {
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }


        NSLayoutConstraint.activate([
            
            dishImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            dishImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dishImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dishImageView.heightAnchor.constraint(equalTo: dishImageView.widthAnchor, multiplier: 1),
            
            titleLabel.leadingAnchor.constraint(equalTo: dishImageView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: dishImageView.trailingAnchor,  constant: -16),
            titleLabel.topAnchor.constraint(equalTo: dishImageView.bottomAnchor, constant: 20),
            
            summaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            summaryLabel.leadingAnchor.constraint(equalTo: dishImageView.leadingAnchor, constant: 16),
            summaryLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            timeLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 20),
            timeLabel.bottomAnchor.constraint(equalTo: bottomButton.topAnchor, constant: -16),
            timeLabel.trailingAnchor.constraint(equalTo: summaryLabel.trailingAnchor),
            
            bottomButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bottomButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            bottomButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            bottomButton.heightAnchor.constraint(greaterThanOrEqualTo: heartButton.heightAnchor, multiplier: 0.9),
            
            difficultStackView.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            difficultStackView.leadingAnchor.constraint(equalTo: summaryLabel.leadingAnchor),
            difficultStackView.heightAnchor.constraint(equalTo: timeLabel.heightAnchor, multiplier: 1.5),

            heartButton.trailingAnchor.constraint(equalTo: dishImageView.trailingAnchor, constant: -8),
            heartButton.topAnchor.constraint(equalTo: dishImageView.topAnchor, constant: 8),
            
        ])
        
    }
    
    func backgroundSetup() {
       // background.backgroundColor = .secondaryBackgroundColor
      //  background.clipsToBounds = true
      //  background.layer.cornerRadius = 20
    }
    
    func imageViewSetup() {
        dishImageView.contentMode = .scaleAspectFill
        dishImageView.clipsToBounds = true
        dishImageView.layer.cornerRadius = 16
        dishImageView.backgroundColor = .thirdaryBackground
        difficultImageView.contentMode = .scaleAspectFit
        difficultImageView.clipsToBounds = true
        difficultImageView.layer.cornerRadius = 16
        difficultImageView.image = UIImage(systemName: "star.fill")?.withTintColor(.yelloTheme, renderingMode: .alwaysOriginal)
    }
    
    func summaryLabelSetup() {
        summaryLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .headline, weight: .regular)
        summaryLabel.numberOfLines = 4
    }
    func titleLabelSetup() {
        titleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .bold)
        titleLabel.numberOfLines = 0
    }
    
    func timeLabelSetup() {
        timeLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .regular)
        timeLabel.textColor = .secondaryLabelColor
    }
    
    func stackViewSetup() {
        [difficultImageView, difficultLabel].forEach() {
            difficultStackView.addArrangedSubview($0)
        }
        difficultStackView.spacing = 4
        difficultStackView.axis = .horizontal
        difficultStackView.distribution = .fill

    }
    
    
    func buttonSetup() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .clear
        config.image = UIImage(systemName: "heart")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: UIFont.weightSystemSizeFont(systemFontStyle: .title1, weight: .bold))
        heartButton.configuration = config
        heartButton.addTarget(self, action: #selector(heartButtonTapped( _ :)), for: .touchUpInside)
        
        var generatedDetailConfig = UIButton.Configuration.filled()
        generatedDetailConfig.baseBackgroundColor = .clear
    
        generatedDetailConfig.baseForegroundColor = .white
        generatedDetailConfig.attributedTitle = AttributedString("生成詳細食譜", attributes: generatedStringAttributes)
        generatedDetailConfig.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: UIFont.weightSystemSizeFont(systemFontStyle: .title1, weight: .medium))
        bottomButton.configuration = generatedDetailConfig
        bottomButton.addTarget(self, action: #selector(bottomButtonTapped ( _ : )), for: .touchUpInside)
        bottomButton.clipsToBounds = true
        bottomButton.layer.cornerRadius = 8
        bottomButton.backgroundColor = .themeColor
    }
    
    @objc func bottomButtonTapped(_ button : UIButton) {
        let status = dish.status
        
        if status == .already  {
            summaryDishTableCellDelegate?.showDishDetailViewController(dish: dish)
        } else if status == .none {
            Task {
                await generateDishDetail()

            }
        }
        
    }
    

    
    func generateDishDetail() async  {
        
        guard self.dish.status != .isGenerating else {
            return
        }
        self.dish.status = .isGenerating
        NotificationCenter.default.post(name: .reloadDishNotification, object: nil, userInfo: ["dish" : dish])
        defer {
            // self.updateBottomButtonStatus(animated: true)
        }
        
        try? await Task.sleep(nanoseconds: 3000000000)
        self.dish.status = .already
        NotificationCenter.default.post(name: .reloadDishNotification, object: nil, userInfo: ["dish" : dish])
    }
    
    func updateBottomButtonStatus(animated : Bool) {
        if dish.status == .already {
            self.bottomButton.configuration?.showsActivityIndicator = false
            bottomButton.configuration?.attributedTitle = AttributedString("查看食譜", attributes: generatedStringAttributes)
            if animated {
                UIView.animate(withDuration: 0.4) {
                    self.bottomButton.backgroundColor = .orangeTheme
                }
            } else {
                bottomButton.backgroundColor = .orangeTheme
            }
        } else if dish.status == .none {
            self.bottomButton.configuration?.showsActivityIndicator = false
            bottomButton.configuration?.attributedTitle = AttributedString("生成詳細食譜", attributes: generatedStringAttributes)
            if animated {
                UIView.animate(withDuration: 0.4) {
                    self.bottomButton.backgroundColor = .themeColor
                }
            } else {
                bottomButton.backgroundColor = .themeColor
            }
        } else if dish.status == .isGenerating {
            bottomButton.configuration?.attributedTitle = nil
            self.bottomButton.configuration?.showsActivityIndicator = true
        }
    }
    
    @objc func heartButtonTapped(_ button : UIButton) {
        dish.liked.toggle()
        updateHeartButtonStatus()
    }
    func updateHeartButtonStatus() {
        if dish.liked {
            self.heartButton.configuration?.image = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        } else {
            self.heartButton.configuration?.image = UIImage(systemName: "heart")
        }
    }
    
    
    
}
