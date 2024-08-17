import UIKit

class DisplayPreferenceViewController : UIViewController {
    
    var preferences : [DishPreference]! = [] // DishPreference.examples
    var tableView : UITableView! = UITableView()
    
    var user_id : String = SessionManager.user_id
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        tableViewSetup()
        navBarSetup()
        initLayout()
        Task {
            await getHistoryPreferences(dateThreshold: "")
        }
    }
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getHistoryPreferences(dateThreshold : String) async {
        do {
            let newPreferences =  try await GeneratePreferenceManager.shared.getHistoryPreferences(user_id: self.user_id, dateThreshold: dateThreshold)
            guard newPreferences.count > 0 else {
                return
            }
            tableView.beginUpdates()
            let newIndexPaths = (self.preferences.count...self.preferences.count + newPreferences.count - 1).compactMap() { index in
                return IndexPath(row: index, section: 0)
            }
            self.preferences.insert(contentsOf: newPreferences, at: preferences.count)
            tableView.insertRows(at: newIndexPaths, with: .automatic)
            tableView.endUpdates()
        } catch {
            print("error",error)
        }
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
    
    @objc func refreshControllerTriggered(_ sender : UIRefreshControl) {
        
    }
    
    func navBarSetup() {
        navigationItem.backButtonTitle = ""
        
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
                showDishSummaryViewController(preference_id: preference_id)
            }
        }
    }
    
}

extension DisplayPreferenceViewController : DisplayPreferenceCellDelegate {
    
}




