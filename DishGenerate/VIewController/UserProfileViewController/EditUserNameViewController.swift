import UIKit


class EditUserNameViewController : UIViewController {

    var user : User!
    
    var newName : String?{ didSet {
        navigationItem.rightBarButtonItem?.isEnabled = newName != initName && newName != nil
    }}
    
    
    var tableView : UITableView! = UITableView()
    
    var initName : String!
    
    var editUserNameViewControllerDelegate : EditUserNameViewControllerDelegate?
    
    init(user : User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
        self.initName = user.name
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        navItemSetup()
        registerCell()
        tableViewSetup()
        initLayout()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TapGestureHelper.shared.shouldAddTapGestureInWindow(view: self.view)
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldTableCell {
            cell.textField.becomeFirstResponder()
        }
    }
    
    
    
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorColor = .primaryLabel
        tableView.isScrollEnabled = false
    }
    
    
    func initLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    
    func viewSetup() {
        view.isUserInteractionEnabled = true
        view.backgroundColor = .primaryBackground
    }
    
    func navItemSetup() {
        navigationItem.title = "更改名字"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "儲存", style: .plain, target: self, action: #selector(rightButtonItemTapped ( _ : )))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func rightButtonItemTapped(_ buttonItem : UIBarButtonItem) {
        if newName != "" && newName != nil, let name = newName, self.initName != name {
            
            Task {
                try await UserManager.shared.rename(user_id: self.user.id, newName: name)
                if let nav = self.navigationController as? UserProfileNavViewController {
                    
                    await nav.reloadUser()
                    user.name = name
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    
    func registerCell() {
        tableView.register(TextFieldTableCell.self, forCellReuseIdentifier: "TextFieldTableCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EditUserNameViewController : UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableCell", for: indexPath) as! TextFieldTableCell
        cell.textFieldDelegate = self
        if let newName = newName {
            cell.configure(title : "名字", value: newName)
        } else {
            cell.configure(title : "名字", value: user.name)
        }
        
        return cell
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let updatedText = text.replacingCharacters(in: range, with: string)
            newName = updatedText
        }
        return true
    }
    
    
    
    
}



