import UIKit

class DisplayPreferenceViewController : UIViewController {
    
    var preferences : [GenerateRecipePreference]! = [] // GenerateRecipePreference.examples
    var tableView : UITableView = UITableView()
    
    var user_id : String? { SessionManager.shared.user_id }
    
    var isLoadingNewPreferences : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        tableViewSetup()
        navBarSetup()
        
        initLayout()
        Task {
            await reloadTableView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TapGestureHelper.shared.shouldAddTapGestureInWindow(view:  self.view)
        let bottomInset = MainTabBarViewController.bottomBarFrame.height - self.view.safeAreaInsets.bottom
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        self.tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
    }
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadTableView() async {
        
        defer {
            tableView.refreshControl?.endRefreshing()
        }
        guard let user_id = user_id else {
            return
        }
        do {
            let newPreferences = try await GeneratePreferenceManager.shared.getHistoryPreferences(user_id: user_id, dateThreshold: nil)

            tableView.refreshControl?.endRefreshing()
           // tableView.beginUpdates()
            tableView.endUpdates()
            self.preferences.removeAll()
            self.preferences.append(contentsOf: newPreferences)
            
            tableView.reloadSections([0], with: .automatic)
            
        } catch {
            print("reloadTableViewError", error)
        }
    }
    
    func insertNewPreferences(newPreferences : [GenerateRecipePreference], insertFunc: insertFuncToArray ) {
        
        let newIndexPaths = (preferences.count...preferences.count + newPreferences.count - 1).compactMap { index in
            return IndexPath(row: index, section: 0)
        }
        
        if insertFunc == .unshift {
            self.preferences.insert(contentsOf: newPreferences, at: 0)
        } else {
            self.preferences.insert(contentsOf: newPreferences, at: self.preferences.count)
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: newIndexPaths, with: .automatic)
        tableView.endUpdates()
    }
    
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delaysContentTouches = false
    
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: MainTabBarViewController.bottomBarFrame.height + 24, right: 0)
        tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: MainTabBarViewController.bottomBarFrame.height, right: 0)
        tableView.estimatedRowHeight = 100
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControllerTriggered( _: )), for: .valueChanged)
    }
    
    @objc func refreshControllerTriggered(_ sender : UIRefreshControl)  {
        Task {
            await reloadTableView()
        }
    }
    
    
    
    func navBarSetup() {
        navigationItem.backButtonTitle = ""
        navigationItem.title = "過往推薦紀錄"
    }
    
    func initLayout() {
        view.addSubview(tableView)
        view.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    
}

extension DisplayPreferenceViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preferences.count
    }
    
    
    func registerCell() {
        tableView.register(DisplayPreferenceCell.self, forCellReuseIdentifier: "DisplayPreferenceCell")
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let preference = preferences[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayPreferenceCell", for: indexPath) as! DisplayPreferenceCell
        cell.delegate = self
        cell.configure(preference: preference)
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? DisplayPreferenceCell {
            if let preference_id = cell.preference.id {
                showDishSummaryViewController(preference_id: preference_id, showRightBarButtonItem: false)
            }
        }
    }
    
}

extension DisplayPreferenceViewController : DisplayPreferenceCellDelegate {
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !isLoadingNewPreferences else {
            return
        }
        guard let user_id = user_id else {
            return
        }
        
        
        guard self.preferences.count - indexPath.row == 7 else {
            return
        }
        guard let created_time = self.preferences.last?.created_time else {
            return
        }
        
        Task {
            defer {
                isLoadingNewPreferences = false
            }
            isLoadingNewPreferences = true
            let newPreferences = try await GeneratePreferenceManager.shared.getHistoryPreferences(user_id: user_id, dateThreshold: created_time)
            guard newPreferences.count > 0 else {
                return
            }
            
            insertNewPreferences(newPreferences: newPreferences, insertFunc: .push)
            
        }
    }
    
    
    
}




