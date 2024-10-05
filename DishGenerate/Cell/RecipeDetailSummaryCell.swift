import UIKit

class RecipeDetailSummaryCell : UITableViewCell {
    
    var recipe : Recipe!

    var dishImageView : UIImageView! = UIImageView()
    
    var titleLabel : UILabel = UILabel()
    
    var stackView : UIStackView! = UIStackView()
    
    var costTimeLabel : UILabel = UILabel()
    
    //var costTimeLabel : UILabel = UILabel()
    
    var quantityLabel : UILabel = UILabel()
    
    var tagCollectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout:    .init())
    
    var summaryLabel : UILabel! = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        registerCell()
        tagCollectionViewSetup()
        imageViewSetup()
        labeltSetup()
        stackViewSetup()
        
        initLayout()
        cellSetup()
    }
    
    func registerCell() {
        self.tagCollectionView.register(TagCollectionCell.self, forCellWithReuseIdentifier:  "TagCollectionCell")
        
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
        quantityLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
        quantityLabel.numberOfLines = 0
        
        costTimeLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
        costTimeLabel.numberOfLines = 0
        
        [quantityLabel, costTimeLabel].forEach() { label in

            

        }
        //costTimeLabel.backgroundColor = .gray
    }
    func stackViewSetup() {
        stackView.axis = .horizontal
        stackView.spacing = 20
        let starImageView = UIImageView(image: UIImage(systemName: "star.fill")?.withTintColor(.yelloTheme  , renderingMode: .alwaysOriginal))
        for (index, label) in [quantityLabel, costTimeLabel].enumerated() {
            let backgroundView = UIView()
            backgroundView.clipsToBounds = true
            backgroundView.layer.cornerRadius = 12
            backgroundView.backgroundColor = .thirdaryBackground
            stackView.addArrangedSubview(backgroundView)
            backgroundView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            ])
            
        }
        
        //stackView.addArrangedSubview(quantityLabel)
        //stackView.addArrangedSubview(costTimeLabel)
        
        
        stackView.distribution = .fillEqually
        //stackView.backgroundColor = .red
        //stackView.addArrangedSubview(starImageView)
       // stackView.addArrangedSubview(costTimeLabel)
        //stackView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        
        contentView.addSubview(dishImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(summaryLabel)
        contentView.addSubview(stackView)
        //contentView.addSubview(costTimeLabel)
        contentView.addSubview(tagCollectionView)
        contentView.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        imageViewLayout()
        stackViewLayout()
        labelLayout()
        collectionViewLayout()
        
    }
    
    func tagCollectionViewSetup() {
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.showsHorizontalScrollIndicator = false
        let bounds = UIScreen.main.bounds
        let flow = UICollectionViewFlowLayout()
        flow.minimumLineSpacing = 4
        flow.scrollDirection = .horizontal
    
        flow.itemSize = CGSize(width: bounds.width * 0.3, height: bounds.height * 0.05)
        tagCollectionView.collectionViewLayout = flow
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
            
            //costTimeLabel.centerYAnchor.constraint(equalTo: tagCollectionView.centerYAnchor),
            //costTimeLabel.topAnchor.constraint(equalTo: tagCollectionView.bottomAnchor, constant: 20),
           // costTimeLabel.trailingAnchor.constraint(equalTo: dishImageView.trailingAnchor, constant: -20),
            //costTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    

    
    func stackViewLayout() {
        let bounds = UIScreen.main.bounds
        return
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: summaryLabel.leadingAnchor, constant: bounds.width * 0.05),
            stackView.topAnchor.constraint(equalTo: tagCollectionView.bottomAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: summaryLabel.trailingAnchor, constant: -bounds.width * 0.05),
            stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: bounds.height * 0.05),
            stackView.bottomAnchor.constraint(equalTo:  contentView.bottomAnchor),
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
    
    func collectionViewLayout() {
        let bounds = UIScreen.main.bounds
        NSLayoutConstraint.activate([
            tagCollectionView.leadingAnchor.constraint(equalTo: summaryLabel.leadingAnchor),
            tagCollectionView.trailingAnchor.constraint(equalTo: summaryLabel.trailingAnchor),
            tagCollectionView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 20),
            tagCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            // tagCollectionView.widthAnchor.constraint(greaterThanOrEqualTo: contentView.widthAnchor, multiplier: 0.5),
            tagCollectionView.heightAnchor.constraint(equalToConstant: bounds.height * 0.05),
        ])
    }
    
    func configure(dish : Recipe) {
        self.recipe = dish
        self.titleLabel.text = dish.name
        summaryLabel.text = dish.description
        costTimeLabel.text = dish.costTimeDescription
        quantityLabel.text = String(dish.quantity) + "人份"
        //costTimeLabel.text = recipe.complexity.description
        Task(priority : .background) {
            let image = await dish.getImage()
            dishImageView.setImageWithAnimation(image: image)
        }
    }
}

extension RecipeDetailSummaryCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recipe.tags?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionCell", for: indexPath) as! TagCollectionCell
        let text = self.recipe.tags?[indexPath.row].title
        cell.configure(tagText : text ?? "")
        
        return cell
    }
    
    
}
