import UIKit

class EditUserProfileViewController : UIViewController {
    var tableView : UITableView! = UITableView()
    
    lazy var options : [String]! = {
        if user.id == SessionManager.anonymous_user_id {
            return  ["暱稱", "擁有設備", "喜好菜式"]
        }
        return ["暱稱", "擁有設備", "喜好菜式", "刪除帳號"]
    }()
        
    
    var user : User!
    
    lazy var loadingView : LoadingBlurView = {
        let view = LoadingBlurView(frame: .zero, style: .userInterfaceStyle, title: "正在刪除帳號，請稍候...")
        view.configure(title:  "正在刪除帳號，請稍候...", start_generating: true)
        view.layer.opacity = 0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        registerCell()
        navItemSetup()
        tableViewSetup()
        initLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TapGestureHelper.shared.shouldAddTapGestureInWindow(view:  self.view)
    }
    
    func showDeleteAccountController() {
        let alertController = UIAlertController(title: "確定要刪除帳號？", message: "此動作無法復原！", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil)

        alertController.addAction(cancelAction)
        
        
        let okAction = UIAlertAction(
            title: "刪除",
            style: .destructive,
            handler: { [weak self] action in
                guard let self = self else {
                    return
                }
                layoutBlurView()
                let showTask = Task {
                    try await Task.sleep(nanoseconds: 3_000_000_000)
                    self.showLoadingView()
                }
                Task {
                    do {
                        try await UserManager.shared.deleteAccount(user_id: self.user.id)
                        showTask.cancel()
                        self.dismissLoadingView()
                        SceneDelegate.logout()
                    } catch {
                        self.loadingView.errorImageView.isHidden = false
                        self.loadingView.configure(title: "刪除帳號出現問題，請稍後再試。", start_generating: false)
                        try await Task.sleep(nanoseconds: 2_000_000_000)
                        self.dismissLoadingView()
                    }
                    
                }
            })
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func layoutBlurView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func showLoadingView() {
        
        guard loadingView.layer.opacity < 1 else {
            return
        }
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        loadingView.triggerRefreshControll()
        UIView.animate(withDuration: 0.2) {
            self.loadingView.layer.opacity = 1
        } completion: { Bool in
            
        }
    }
    
    func dismissLoadingView() {
        guard loadingView.layer.opacity > 0 else {
            return
        }
        UIView.animate(withDuration: 0.2) {
            self.loadingView.layer.opacity = 0
        } completion: { Bool in
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
        }
    }
    
    func navBarSetup() {
    //   self.navigationController?.navigationBar.standardAppearance.configureWithOpaqueBackground()
     //   self.navigationController?.navigationBar.scrollEdgeAppearance?.configureWithOpaqueBackground()
        let item = UIBarButtonItem(title: "登出", style: .done, target: self, action: #selector(navBarRightButtonTapped ( _ :)))
        navigationItem.rightBarButtonItem = item
    }
    
    @objc func navBarRightButtonTapped( _ barButtonItem : UIBarButtonItem) {
        showLogOutAlertController()
    }
    
    func showLogOutAlertController() {
        
        let alertController = UIAlertController(title: "確定要登出？", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil)

        alertController.addAction(cancelAction)
        
        
        let okAction = UIAlertAction(
            title: "登出",
            style: .destructive,
            handler: { [weak self] action in
                guard let self = self else {
                    return
                }
                SceneDelegate.logout()
            })
        alertController.addAction(okAction)
        present(alertController, animated: true)
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

extension EditUserProfileViewController : UITableViewDelegate, UITableViewDataSource, EditUserNameViewControllerDelegate {
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
            cell.configure(user: user)

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
            return 8
        }
        return 8
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 {
            return nil
        }
        return indexPath
    }

    
    
}

extension EditUserProfileViewController : EditUserProfileCellDelegate {

    
    func reloadUser() {
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
    }
    
    
    
}




