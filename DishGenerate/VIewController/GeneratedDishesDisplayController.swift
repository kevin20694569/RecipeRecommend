

import UIKit

class GeneratedDishesDisplayController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dishes : [Dish] = Dish.examples
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dish = dishes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryDishTableCell", for: indexPath) as! SummaryDishTableCell
        cell.configure(dish: dish)
        return cell
    }
    
    
    var tableView : UITableView! = UITableView()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        tableViewSetup()
        initLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarSetup()
    }
    
    
    func navBarSetup() {
        self.navigationController?.navigationBar.standardAppearance.configureWithOpaqueBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance?.configureWithOpaqueBackground()
    }

    
    func initLayout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
    
    func tableViewSetup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.delaysContentTouches = false
        tableView.allowsSelection = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func registerCell() {
        tableView.register(SummaryDishTableCell.self, forCellReuseIdentifier: "SummaryDishTableCell")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    

}

class SummaryDishTableCell : UITableViewCell {
    
    var dish : Dish!
    
    var titleLabel : UILabel! = UILabel()
    
    var background : UIView! = UIView()
    
    var dishImageView : UIImageView! = UIImageView()
    
    var summaryLabel : UILabel! = UILabel()
    
    var difficultImageView : UIImageView! = UIImageView()
    
    var difficultLabel : UILabel! = UILabel()
    
    var difficultStackView : UIStackView! = UIStackView()
    
    var timeLabel : UILabel! = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        difficultLabel.text = dish.complexity
    }
    
    func initLayout() {
        [background, dishImageView, summaryLabel, titleLabel, timeLabel, difficultStackView].forEach() {
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        let screenBounds = UIScreen.main.bounds

        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            //background.heightAnchor.constraint(equalToConstant: screenBounds.height * 0.7),
            
            dishImageView.topAnchor.constraint(equalTo: background.topAnchor),
            dishImageView.leadingAnchor.constraint(equalTo: background.leadingAnchor),
            dishImageView.trailingAnchor.constraint(equalTo: background.trailingAnchor),
            dishImageView.heightAnchor.constraint(equalTo: background.widthAnchor, multiplier: 1),
            
            titleLabel.leadingAnchor.constraint(equalTo: dishImageView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: dishImageView.trailingAnchor,  constant: -16),
            titleLabel.topAnchor.constraint(equalTo: dishImageView.bottomAnchor, constant: 20),
            
            summaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            summaryLabel.leadingAnchor.constraint(equalTo: dishImageView.leadingAnchor, constant: 16),
            summaryLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            timeLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 20),
            timeLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16),
            timeLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            
            
            difficultStackView.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            difficultStackView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            difficultStackView.heightAnchor.constraint(equalTo: timeLabel.heightAnchor, multiplier: 1.5),
            
            difficultStackView.widthAnchor.constraint(equalTo: difficultStackView.heightAnchor, multiplier: 1)
            
        ])
        
    }
    
    func backgroundSetup() {
       // background.backgroundColor = .secondaryBackgroundColor
        background.clipsToBounds = true
        background.layer.cornerRadius = 20
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
        summaryLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .regular)
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
    
    
    
}
