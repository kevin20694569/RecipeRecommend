import UIKit

class SummaryRecipeTableCell : UITableViewCell, RecipeDelegate, RecipeTableCell {
    func reloadRecipe(recipe: Recipe) {
        self.recipe = recipe
        self.updateBottomButtonStatus(animated: true)
    }
    
    
    var recipe : Recipe!
    
    var titleLabel : UILabel! = UILabel()
    
    
    var heartButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var recipeImageView : UIImageView! = UIImageView()
    
    var summaryLabel : UILabel! = UILabel()
    
    var difficultImageView : UIImageView! = UIImageView()
    
    var difficultLabel : UILabel! = UILabel()
    
    var difficultStackView : UIStackView! = UIStackView()
    
    var timeLabel : UILabel! = UILabel()
    
    var bottomButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var tagCollectionView : UICollectionView! = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    weak var summaryDishTableCellDelegate : SummaryRecipeTableCellDelegate?
    
    var generatedStringAttributes : AttributeContainer! = AttributeContainer([.font : UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)])
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        registerCell()
        tagCollectionViewSetup()
        buttonSetup()
        stackViewSetup()
        timeLabelSetup()
        titleLabelSetup()
        summaryLabelSetup()
        backgroundSetup()
        imageViewSetup()
        initLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.recipeImageView.image = nil
        if tagCollectionView.visibleCells.count > 0 {
            
            tagCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
            
        }
    }
    
    
    
    func registerCell() {
        self.tagCollectionView.register(TagCollectionCell.self, forCellWithReuseIdentifier:  "TagCollectionCell")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(recipe : Recipe) {
        self.recipe = recipe
        summaryLabel.text = recipe.description
        titleLabel.text = recipe.name
        if let created_time = recipe.created_time,
           let formattedStr = Formatter.timeAgoOrDate(from: created_time) {
            timeLabel.text = formattedStr
        }
        configureRecipeLikedStatus(liked: recipe.liked)
        updateBottomButtonStatus(animated: false)
        Task(priority : .background) {
            let image = await recipe.getImage()
            recipeImageView.setImageWithAnimation(image: image)
        }
    }
    
    func initLayout() {
        [ recipeImageView, summaryLabel, titleLabel, timeLabel, /*difficultStackView,*/ heartButton, bottomButton, tagCollectionView].forEach() {
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        let bounds = UIScreen.main.bounds


        NSLayoutConstraint.activate([
            
            recipeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recipeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            recipeImageView.heightAnchor.constraint(equalTo: recipeImageView.widthAnchor, multiplier: 1),
            
            titleLabel.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: recipeImageView.trailingAnchor,  constant: -16),
            titleLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 20),
            
            summaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            summaryLabel.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor, constant: 16),
            summaryLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            //timeLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 20),
            //timeLabel.bottomAnchor.constraint(equalTo: bottomButton.topAnchor, constant: -16),
            timeLabel.trailingAnchor.constraint(equalTo: summaryLabel.trailingAnchor),
            
            timeLabel.centerYAnchor.constraint(equalTo: tagCollectionView.centerYAnchor),
            
            
            tagCollectionView.leadingAnchor.constraint(equalTo: summaryLabel.leadingAnchor),
            tagCollectionView.trailingAnchor.constraint(equalTo: summaryLabel.trailingAnchor),
            tagCollectionView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 20),
            tagCollectionView.bottomAnchor.constraint(equalTo: bottomButton.topAnchor, constant: -20),
          // tagCollectionView.widthAnchor.constraint(greaterThanOrEqualTo: contentView.widthAnchor, multiplier: 0.5),
            tagCollectionView.heightAnchor.constraint(equalToConstant: bounds.height * 0.05),
            
            bottomButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bottomButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            bottomButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            bottomButton.heightAnchor.constraint(greaterThanOrEqualTo: heartButton.heightAnchor, multiplier: 0.9),
            

            /*difficultStackView.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            difficultStackView.leadingAnchor.constraint(equalTo: summaryLabel.leadingAnchor),
            difficultStackView.heightAnchor.constraint(equalTo: timeLabel.heightAnchor, multiplier: 1.5),*/

            heartButton.trailingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: -8),
            heartButton.topAnchor.constraint(equalTo: recipeImageView.topAnchor, constant: 8),
            
        ])
        
    }
    
    func tagCollectionViewSetup() {
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.showsHorizontalScrollIndicator = false
        tagCollectionView.backgroundColor = .clear
        let bounds = UIScreen.main.bounds
        let flow = UICollectionViewFlowLayout()
        flow.minimumLineSpacing = 4
        flow.scrollDirection = .horizontal
    
        flow.itemSize = CGSize(width: bounds.width * 0.3, height: bounds.height * 0.05)
        tagCollectionView.collectionViewLayout = flow
    }
    
    func backgroundSetup() {
        backgroundColor = .clear
    }
    
    func imageViewSetup() {
        recipeImageView.contentMode = .scaleAspectFill
        recipeImageView.clipsToBounds = true
        recipeImageView.layer.cornerRadius = 16
        recipeImageView.backgroundColor = .thirdaryBackground
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
        var bottomButtonConfig = UIButton.Configuration.filled()
        bottomButtonConfig.baseBackgroundColor = .clear
    
        bottomButtonConfig.baseForegroundColor = .white
        bottomButtonConfig.attributedTitle = AttributedString("查看食譜", attributes: generatedStringAttributes)
        bottomButtonConfig.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: UIFont.weightSystemSizeFont(systemFontStyle: .title1, weight: .medium))
        bottomButton.configuration = bottomButtonConfig
        bottomButton.addTarget(self, action: #selector(bottomButtonTapped ( _ : )), for: .touchUpInside)
        bottomButton.clipsToBounds = true
        bottomButton.layer.cornerRadius = 8
        bottomButton.backgroundColor = .orangeTheme
    }
    
    @objc func bottomButtonTapped(_ button : UIButton) {
        guard let delegate = summaryDishTableCellDelegate else {
           return
        }
        delegate.showRecipeDetailViewController(recipe: recipe)
    }
    
    
    func updateBottomButtonStatus(animated : Bool) {
        self.bottomButton.configuration?.showsActivityIndicator = false
        bottomButton.configuration?.attributedTitle = AttributedString("查看食譜", attributes: generatedStringAttributes)
        if animated {
            UIView.animate(withDuration: 0.4) {
                self.bottomButton.backgroundColor = .orangeTheme
            }
        } else {
            bottomButton.backgroundColor = .orangeTheme
        }
    }
    
    @objc func heartButtonTapped(_ button : UIButton) {
        recipe.liked.toggle()
        configureRecipeLikedStatus(liked: recipe.liked)
        Task {
            try await RecipeManager.shared.markAsLiked(recipe_id: self.recipe.id, like: recipe.liked)
        }
        summaryDishTableCellDelegate?.configureRecipeLikedStatus(liked: recipe.liked)
        
    }
    func configureRecipeLikedStatus(liked : Bool) {
        if liked {
            self.heartButton.configuration?.image = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        } else {
            self.heartButton.configuration?.image = UIImage(systemName: "heart")?.withTintColor( .primaryLabel, renderingMode: .alwaysOriginal )
        }
    }
    
    
    
}

extension SummaryRecipeTableCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = self.recipe.tags?.count else {
            return 0
        }
        return count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionCell", for: indexPath) as! TagCollectionCell
        let text = self.recipe.tags?[indexPath.row].title
        cell.configure(tagText : text ?? "")
        
        return cell
    }
    
}




