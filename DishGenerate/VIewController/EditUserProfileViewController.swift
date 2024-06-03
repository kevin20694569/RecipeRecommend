import UIKit

class EditUserProfileViewController : UIViewController {
    var tableView : UITableView! = UITableView()
    
    var options : [String]! = ["暱稱", "討厭的食材", "喜好的菜式"]
    
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        registerCell()
        navItemSetup()
        tableViewSetup()
        initLayout()
        
    }
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .primaryBackground
        tableView.separatorStyle = .none
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 0
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        
        
    }
    
    func viewSetup() {
        view.backgroundColor = .primaryBackground   
    }
    
    func registerCell() {
        tableView.register(EditUserProfileUserImageViewTableCell.self, forCellReuseIdentifier: "EditUserProfileUserImageViewTableCell")
        tableView.register(EditUserProfileOptionCell.self, forCellReuseIdentifier: "EditUserProfileOptionCell")
    }
    
    func initLayout() {
        [tableView].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func navItemSetup() {
        self.navigationItem.title = "編輯個人檔案"
        navigationItem.backButtonTitle = ""
    }
}

extension EditUserProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return options.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditUserProfileUserImageViewTableCell", for: indexPath) as! EditUserProfileUserImageViewTableCell
            cell.editUserProfileCellDelegate = self
            if let image = user.image {
                cell.configure(image: image)
            }
            return cell
        }
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditUserProfileOptionCell", for: indexPath) as! EditUserProfileOptionCell
        
        cell.editUserProfileCellDelegate = self
        let title = options[row]
        var value : String = ""
        var cellType : EditUserProfileOptionCellType! = cell.cellType
        
        if row == options.count - 1 {
            cell.configureCorners(topCornerMask: false)
        } else {
            cell.configureCorners(topCornerMask: nil)
        }
        switch row {
        case 0 :
            value = user.name
            cell.configureCorners(topCornerMask: true)
            break
        default :
            cell.customAccessoryImageView.isHidden = false
        }
        cellType = .init(rawValue: row)
        cell.configure(title: title, value: value, cellType: cellType)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let bounds = view.bounds
        if section == 0 {
            return bounds.height * 0.2
        }
        
        return bounds.height * 0.08
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView()
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 10
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 {
            return nil
        }
        return indexPath
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let type = EditUserProfileOptionCellType(rawValue: indexPath.row)
        switch type {
        case .userName :
            break
        case .dislikeIngredient :
            showEditDislikeIngredientViewController()
        case .cuisine :
            showEditFavoriteCuisineViewController()
        default :
            break
        }*/
       
    }
    
    
}

extension EditUserProfileViewController : EditUserProfileCellDelegate {
    
    
}




