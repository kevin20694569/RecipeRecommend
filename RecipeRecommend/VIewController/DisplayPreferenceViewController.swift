import UIKit

class DisplayPreferenceViewController : UIViewController {
    
    var preferences : [RecommendRecipePreference]! = [] // GenerateRecipePreference.examples
    var tableView : UITableView = UITableView()
    
    var user_id : String? { SessionManager.shared.user_id }
    
    var isLoadingNewPreferences : Bool = false
    
    var emptyView : EmptyView = EmptyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        tableViewSetup()
        navBarSetup()
        emptyView.configure(text: "尚未有任何推薦食譜紀錄！")
        emptyView.isHidden = true
        initLayout()
        
        Task {
            await reloadTableView()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TapGestureHelper.shared.shouldAddTapGestureInWindow(view:  self.view)
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
            emptyView.isHidden = preferences.count > 0
            
            tableView.reloadSections([0], with: .automatic)
            
            
            
        } catch {
            print("reloadTableViewError", error)
        }
    }
    
    func insertNewPreferences(newPreferences : [RecommendRecipePreference], insertFunc: insertFuncToArray ) {
        
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
        tableView.backgroundColor = .primaryBackground

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
        view.addSubview(emptyView)
        view.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -MainTabBarViewController.tabBarFrame.height),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            emptyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -(navigationController?.navigationBar.bounds.height)!),
            emptyView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
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
        let preference = self.preferences[indexPath.row]
        if let cell = tableView.cellForRow(at: indexPath) as? DisplayPreferenceCell {
            let preference_id = cell.preference.id
            showDishSummaryViewController(preference_id: preference_id, showRightBarButtonItem: false, preference: preference)
            
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




