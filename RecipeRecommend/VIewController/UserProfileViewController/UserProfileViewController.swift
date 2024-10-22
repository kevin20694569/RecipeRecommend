
import UIKit

class UserProfileViewController : UIViewController, EditUserNameViewControllerDelegate {
    func reloadRecipe(recipe: Recipe) {
        /*  guard let index = historyDishes.firstIndex(of: recipe) else {
         return
         }
         let indexPath = IndexPath(row: index, section: 1)
         if let cell = collectionView.cellForItem(at: indexPath) as? DishDelegate  {
         cell.reloadDish(recipe: recipe)
         }*/
    }
    
    var isLoadingNewDishes : Bool = false
    
    func reloadUser() async {
        Task {
            guard let user_id = user_id else {
                return
            }
            let user = try await UserManager.shared.getUser(user_id: user_id)
            self.user = user
            self.collectionView.reloadSections([0])
        }
        
    }
    
    var user_id : String? { SessionManager.shared.user_id }
    
    
    var collectionView : UICollectionView! = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    var historyBrowsedRecipes : [Recipe] = []
    
    var user : User! = User.default
    
    var emptyView : EmptyView = EmptyView()
    
    var userRecipesIsEmpty : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleReloadDishNotification(_:)), name: .reloadDishNotification, object: nil)
        registerCell()
        registerReuseHeaderView()
        viewSetup()
        collectionViewFlowSetup()
        navItemSetup()
        initLayout()
        collectionViewSetup()
        Task {
            guard let user_id = user_id, user_id != "" else {
                return
            }
            let user = try await UserManager.shared.getUser(user_id:
            user_id  )
            self.user = user
            guard let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0 )) as? UserDetailCollectionCell else  {
                return
            }
            cell.configure(user: user)
        }
        Task {
            await reloadCollectionView()
        }
    }
    
    func reloadCollectionView() async {
        
        defer {
            collectionView.refreshControl?.endRefreshing()
        }
        guard let user_id = user_id, user_id != "" else {
            return
        }
        do {
            let newRecipes = try await RecipeManager.shared.getHistoryBrowsedRecipesByDateThresold(user_id: user_id, dateThresold: "")
            self.historyBrowsedRecipes.removeAll()
            self.historyBrowsedRecipes.append(contentsOf: newRecipes)
            if historyBrowsedRecipes.isEmpty {
                userRecipesIsEmpty = true
            }
            collectionView.performBatchUpdates ({
                self.collectionView.reloadSections([1])
            }) { bool in
                
            }
            
        } catch {
            print("reloadCollectionViewError", error)
        }
    }
    
    func insertNewRecipes(newRecipes : [Recipe], insertFunc: insertFuncToArray ) {
        
        let newIndexPaths = (historyBrowsedRecipes.count...historyBrowsedRecipes.count + newRecipes.count - 1).compactMap { index in
            return IndexPath(row: index, section: 1)
        }
        collectionView.performBatchUpdates {
            if insertFunc == .unshift {
                self.historyBrowsedRecipes.insert(contentsOf: newRecipes, at: 0)
            } else {
                self.historyBrowsedRecipes.insert(contentsOf: newRecipes, at: self.historyBrowsedRecipes.count)
            }
            collectionView.insertItems(at: newIndexPaths)
        }
    }
    
    
    
    @objc func handleReloadDishNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo, let dish = userInfo["recipe"] as? Recipe  {
            reloadRecipe(recipe: dish)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarSetup()
    }
    
    func navBarSetup() {
        self.navigationController?.navigationBar.standardAppearance.configureWithTransparentBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance?.configureWithTransparentBackground()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    func collectionViewFlowSetup() {
        let flow = UICollectionViewFlowLayout()
        self.collectionView.collectionViewLayout = flow
    }
    func registerCell() {
        self.collectionView.register(UserDetailCollectionCell.self, forCellWithReuseIdentifier: "UserDetailCollectionCell")
        self.collectionView.register(HistoryRecipeCell.self, forCellWithReuseIdentifier: "SavedDishCell")
        
        self.collectionView.register(UserProfileDishDateCell.self, forCellWithReuseIdentifier: "UserProfileDishDateCell")
        collectionView.register(EmptyCollectionCell.self, forCellWithReuseIdentifier: "EmptyCollectionCell")
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
        
        [collectionView, emptyView].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -MainTabBarViewController.bottomBarFrame.height),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            

            
        ])
        
        
    }
    
    
}

extension UserProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ShowRecipeViewControllerDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if historyBrowsedRecipes.isEmpty && userRecipesIsEmpty {
            return 1
        }
        return historyBrowsedRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserDetailCollectionCell", for: indexPath) as! UserDetailCollectionCell
            
            cell.userProfileCellDelegate = self
            cell.configure(user: user)
            return cell
        }
        if historyBrowsedRecipes.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCollectionCell", for: indexPath) as!  EmptyCollectionCell
            cell.configure(text: "尚未有食譜瀏覽紀錄！")
            return cell
            
        }
        let dish = historyBrowsedRecipes[row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedDishCell", for: indexPath) as!  HistoryRecipeCell
        
        cell.configure(recipe: dish)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LeadingLogoHeaderView", for: indexPath) as! LeadingLogoHeaderView
        if indexPath.section == 1 {
            headerView.imageViewTrigger = reloadCollectionView
            headerView.configure(logoImage: UIImage(systemName: "clock")!, title: "瀏覽紀錄")
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let bounds = view.bounds
        if section == 0 {
            return UIEdgeInsets(top: bounds.height * 0.02, left: 0, bottom: bounds.height * 0.02, right: 0)
        }

        
        return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = view.bounds
        if indexPath.section == 0 {
            return CGSize(width: bounds.width, height: bounds.height * 0.15)
        }
        if historyBrowsedRecipes.isEmpty {
            return CGSize(width: bounds.width, height: bounds.height * 0.1)
        }
        
        let spacing : CGFloat = 4
        return CGSize(width: (bounds.width - spacing * 3)  / 3, height: bounds.height * 0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
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
        let recipe = historyBrowsedRecipes[indexPath.row]
        showRecipeDetailViewController(recipe: recipe)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let user_id = user_id, user_id != "" else {
            return
        }
        guard !isLoadingNewDishes else {
            return
        }
       
        guard let created_time = self.historyBrowsedRecipes.last?.created_time else {
            return
        }

        if self.historyBrowsedRecipes.count - indexPath.row == 5 {
            Task {
                defer {
                    isLoadingNewDishes = false
                }
                isLoadingNewDishes = true
                let newRecipes = try await RecipeManager.shared.getHistoryBrowsedRecipesByDateThresold(user_id: user_id, dateThresold: created_time)
                guard newRecipes.count > 0 else {
                    return
                }
                insertNewRecipes(newRecipes: newRecipes, insertFunc: .push)
            }
        }
    }
}

extension UserProfileViewController : UserProfileCellDelegate {
    
}













