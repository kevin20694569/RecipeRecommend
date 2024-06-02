
import UIKit

class UserProfileViewController : UIViewController {
    
    var collectionView : UICollectionView! = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    var historyDishes : [Dish] = Dish.examples
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        registerReuseHeaderView()
        viewSetup()
        collectionViewFlowSetup()
        navItemSetup()
        initLayout()
        collectionViewSetup()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func collectionViewSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delaysContentTouches = false

    }
    
    func collectionViewFlowSetup() {
        let flow = UICollectionViewFlowLayout()
        self.collectionView.collectionViewLayout = flow
    }
    func registerCell() {
        self.collectionView.register(UserDetailCollectionCell.self, forCellWithReuseIdentifier: "UserDetailCollectionCell")
        self.collectionView.register(UserProfileDishCell.self, forCellWithReuseIdentifier: "UserProfileDishCell")
        
        self.collectionView.register(UserProfileDishDateCell.self, forCellWithReuseIdentifier: "UserProfileDishDateCell")
    }
    
    func registerReuseHeaderView() {
        collectionView.register(LeadingLogoHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "LeadingLogoHeaderView")
    }
    
    func viewSetup() {
        self.view.backgroundColor = .primaryBackground
    }
    
    func navItemSetup() {
        self.navigationItem.title = "個人檔案"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func initLayout() {
        
        [collectionView].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    
}

extension UserProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return historyDishes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserDetailCollectionCell", for: indexPath) as!  UserDetailCollectionCell
            return cell
        }
        let dish = historyDishes[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserProfileDishCell", for: indexPath) as!  UserProfileDishCell
        cell.configure(dish: dish)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LeadingLogoHeaderView", for: indexPath) as! LeadingLogoHeaderView
        if indexPath.section == 1 {
            headerView.configure(logoImage: UIImage(systemName: "clock")!, title: "瀏覽紀錄")
        }
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let bounds = view.bounds
        if section == 0 {
            return UIEdgeInsets(top: bounds.height * 0.01, left: 0, bottom: bounds.height * 0.02, right: 0)
        }
        return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = view.bounds
        if indexPath.section == 0 {
            return CGSize(width: bounds.width, height: bounds.height * 0.15)
        }
        return CGSize(width: (bounds.width - 6)  / 3, height: bounds.height * 0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let bounds = view.bounds
        if section == 0 {
           
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: bounds.width, height: bounds.height * 0.04)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if indexPath.section != 1 {
            return false
        }
    
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.visibleCells.forEach() {
            $0.isSelected = false
        }
        guard indexPath.section == 1 else {
            return
        }
        let dish = historyDishes[indexPath.row]
        showDishDetailViewController(dish: dish)
    }
    


}

extension UserProfileViewController {
    func showDishDetailViewController(dish : Dish) {
        let controller = DishDetailViewController(dish: dish)
        show(controller, sender: nil)
        navigationController?.isNavigationBarHidden = false
    }
    
    func showGeneratedDishesDisplayController(newDishes : [Dish]) {

        let controller = GeneratedDishesDisplayController(dishes: newDishes)
        show(controller, sender: nil)
        navigationController?.isNavigationBarHidden = false
    }
}

class UserProfileDishCellHeaderView : UICollectionReusableView {
    
    var titleLabel : UILabel! = UILabel()
    
    var circleView : UIView! = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        circleViewSetup()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        [circleView, titleLabel].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        NSLayoutConstraint.activate([
            circleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            circleView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
            
            titleLabel.leadingAnchor.constraint(equalTo: circleView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            
        ])
        circleView.layoutIfNeeded()
        circleView.layer.cornerRadius = circleView.bounds.height / 2
    }
    
    func circleViewSetup() {
        circleView.backgroundColor = .secondaryBackground
        
    }
}

class UserProfileDishDateCell : UICollectionViewCell {
    
    var titleLabel : UILabel! = UILabel()
    
    var circleView : UIView! = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        circleViewSetup()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        [circleView, titleLabel].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        NSLayoutConstraint.activate([
            circleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            circleView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
            
            titleLabel.leadingAnchor.constraint(equalTo: circleView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            
        ])
        circleView.layoutIfNeeded()
        circleView.layer.cornerRadius = circleView.bounds.height / 2
    }
    
    func circleViewSetup() {
        circleView.backgroundColor = .secondaryBackground
        
    }
}







