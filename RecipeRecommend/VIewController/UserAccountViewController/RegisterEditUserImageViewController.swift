import UIKit

class RegisterEditUserImageViewController : EditUserImageViewController {
    
    
    var editUserImageLabel : UILabel = UILabel()
    
    var finishedButton : ZoomAnimatedButton = ZoomAnimatedButton()
    
    var password : String!
    
    
    override init(user: User) {
        super.init(user: user)
        
    }
    
    init(user: User, password : String) {
        super.init(user: user)
        self.password = password
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetup()
        labelSetup()
        viewSetup()
        
        
    }

    
    func buttonLayout() {
        let bounds = UIScreen.main.bounds
        NSLayoutConstraint.activate([
            finishedButton.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.7),
            finishedButton.heightAnchor.constraint(equalTo:  view.heightAnchor,multiplier: 0.06),
            finishedButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bounds.height * 0.1),
            finishedButton.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
        ])

    }
    
    func viewSetup() {
        self.view.backgroundColor = UIColor.accent
    }
    
    override func navItemSetup() {
        super.navItemSetup()
        self.navigationItem.backButtonTitle = ""
        navigationItem.title = nil
    }
    
    override func initLayout() {
        super.initLayout()
        [editUserImageLabel, finishedButton].forEach(){
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        labelLayout()
        buttonLayout()
    }
    
    func labelLayout() {
        let bounds = UIScreen.main.bounds
        
        NSLayoutConstraint.activate([
            editUserImageLabel.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: bounds.width * 0.05),
            
            editUserImageLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -bounds.height * 0.02)
        ])
        
    }
    

    
    func buttonSetup() {
        [finishedButton].forEach() {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 14
        }
        var config = UIButton.Configuration.filled()

        var registerAttributedString = AttributedString("註冊", attributes: .init())
        registerAttributedString.font = UIFont.weightSystemSizeFont(systemFontStyle: .title1, weight: .medium)
        config.attributedTitle = registerAttributedString
        config.baseBackgroundColor = .orangeTheme
        
        config.baseForegroundColor = .white
        finishedButton.configuration = config
        finishedButton.addTarget(self, action: #selector(finishedButtonTapped ( _ :)), for: .touchUpInside)
        
    }
    
    func labelSetup() {
        editUserImageLabel.font =  UIFont.weightSystemSizeFont(systemFontStyle: .largeTitle, weight: .bold)
        editUserImageLabel.textColor = .primaryLabel
        editUserImageLabel.text = "個人照片"
    }
    
    
    @objc func finishedButtonTapped(_ button : UIButton) {
        Task {
            var config = finishedButton.configuration
            finishedButton.configuration?.showsActivityIndicator = true
            finishedButton.configuration?.title = nil
            do {

               try await UserManager.shared.register(name: user.name, email: user.email, password: password, image: self.newImage)
                try await Task.sleep(nanoseconds: 1000000000)
                finishedButton.isUserInteractionEnabled = false
       
                config?.title = "成功註冊"
                config?.attributedTitle = AttributedString("成功註冊！", attributes: .init())
                config?.attributedTitle?.font = UIFont.weightSystemSizeFont(systemFontStyle: .title1, weight: .medium)
                config?.baseBackgroundColor = .systemGreen
                finishedButton.configuration = config
                finishedButton.configuration?.showsActivityIndicator = false
                try await Task.sleep(nanoseconds: 1000000000)
                

               // try await Task.sleep(nanoseconds: 1000000000)
                if let loginViewController = navigationController?.viewControllers.first as?  LoginViewController {
                    loginViewController.emailTextField.text = user.email
                    loginViewController.passwordTextField.text = password
                }
                self.navigationController?.popToRootViewController(animated: true)
                
            } catch {
                finishedButton.configuration = config
                finishedButton.configuration?.showsActivityIndicator = false
                print(error)
            }
        }
       
        
        
    }

    
    override func tableViewSetup() {
        super.tableViewSetup()
        self.tableView.backgroundColor = .clear
       // tableView.rowHeight = view.bounds.height * 0.4

    }
    
    override func tableViewLayout() {
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
    }
    
    override func registerCell() {
        super.registerCell()
        tableView.register(RegisterEditUserProfileUserImageViewTableCell.self, forCellReuseIdentifier: "RegisterEditUserProfileUserImageViewTableCell")
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterEditUserProfileUserImageViewTableCell", for: indexPath) as! RegisterEditUserProfileUserImageViewTableCell
        cell.editUserProfileCellDelegate = self
        cell.configure(user: user)


        return cell
        
    }
    
    
}

