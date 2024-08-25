import UIKit

class LoginViewController : UIViewController {
    
    static var navShared : UINavigationController = UINavigationController(rootViewController: LoginViewController())
    
    
    var mainView : UIView = UIView()
    
    var emailLabel : UILabel = UILabel()
    
    var passwordLabel : UILabel = UILabel()
    
    var emailTextField : CustomTextField = CustomTextField()
    
    var passwordTextField : CustomTextField = CustomTextField()
    
    var loginButton : ZoomAnimatedButton = ZoomAnimatedButton()
    
    var registerButton : ZoomAnimatedButton = ZoomAnimatedButton()
    
    var anonymousLoginButton : ZoomAnimatedButton = ZoomAnimatedButton()
    
    
    var warningLabel : UILabel = UILabel()
    
    var buttonAttributedTitleContainer : AttributeContainer = AttributeContainer([.font : UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)])
    
    var logining : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetup()
        mainViewSetup()
        labelSetup()
        textFieldSetup()
        buttonSetup()
        initLayout()
        configure()
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TapGestureHelper.shared.shouldAddTapGestureInWindow(view: self.view)
        
    }
    
    
    func configure() {
        guard let email = UserDefaultManager.shared.getEmail() else {
            return
        }
        if let password = UserDefaultManager.shared.getPassword() {
            self.passwordTextField.text = password
        }
    }
    func labelSetup() {
        [emailLabel, passwordLabel].forEach() {
            $0.font = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)
        }
        warningLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .headline, weight: .regular)
        warningLabel.textColor = .systemRed
        warningLabel.isHidden = true
        emailLabel.text = "電子郵件"
        passwordLabel.text = "密碼"
    }
    
    func buttonSetup() {
        [loginButton, anonymousLoginButton, registerButton].forEach() {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 14
        }
        
        let loginAttributedString = AttributedString("登入", attributes: self.buttonAttributedTitleContainer)
        var config = UIButton.Configuration.filled()
        config.attributedTitle = loginAttributedString
        config.baseBackgroundColor = .orangeTheme
        config.baseForegroundColor = .white
        loginButton.configuration = config
        loginButton.addTarget(self, action: #selector(loginButtonTapped ( _ :)), for: .touchUpInside)
        
        config = UIButton.Configuration.filled()
        let anonymousLoginAttributedString = AttributedString("訪客使用", attributes: self.buttonAttributedTitleContainer)
        config.attributedTitle = anonymousLoginAttributedString
        config.baseBackgroundColor = .secondaryBackground
        config.baseForegroundColor = .primaryLabel
        anonymousLoginButton.configuration = config
        anonymousLoginButton.addTarget(self, action: #selector(anoymousLoginButtonTapped ( _ :)), for: .touchUpInside)
        
        
        config = UIButton.Configuration.filled()
        let registerAttributedString = AttributedString("註冊", attributes: self.buttonAttributedTitleContainer)
        config.attributedTitle = registerAttributedString
        config.baseBackgroundColor = .secondaryBackground
        config.baseForegroundColor = .primaryLabel
        registerButton.configuration = config
        registerButton.addTarget(self, action: #selector(registerButtonTapped ( _ :)), for: .touchUpInside)
        
        // loginButton.addTarget(self, action: #selector(loginButtonTapped ( _ :)), for: .touchUpInside)
        
        
    }
    
    @objc func loginButtonTapped(_ button : UIButton) {
        guard !logining else {
            return
        }
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        login(email: email, password: password, realUserLogin: true)
    }
    
    @objc func anoymousLoginButtonTapped(_ button : UIButton) {
        guard !logining else {
            return
        }
        let email = "anonymous"
        let password = "shu"
        self.login(email: email, password: password, realUserLogin: false)
    }
    
    @objc func registerButtonTapped(_ button : UIButton) {
        guard !logining else {
            return
        }
        showRegisterViewController()
        
        
    }
    
    
    
    func login(email : String, password : String, realUserLogin : Bool) {
        logining = true
        var config = loginButton.configuration
        if realUserLogin {
            loginButton.configuration?.showsActivityIndicator = true
            loginButton.configuration?.attributedTitle = nil
        }
        Task {
            do {
                try await UserManager.shared.login(email: email, password: password)
                //let attributedString = AttributedString("登入成功", attributes: self.buttonAttributedTitleContainer)
                if realUserLogin {
                    UserDefaultManager.shared.setEmail(email: email)
                    UserDefaultManager.shared.setPassword(password: password)
                    config?.attributedTitle = nil
                    config?.image = UIImage(systemName: "checkmark")?.withConfiguration(UIImage.SymbolConfiguration.init(font: UIFont.weightSystemSizeFont(systemFontStyle: .title1, weight: .medium)))
                    config?.baseBackgroundColor = .systemGreen
                    loginButton.configuration = config
                }
                showMainRecipeTableViewController()
            } catch  {
                switch error {
                case AuthenticError.LoginFail :
                    warningLabel.text = "帳號或密碼錯誤。"
                default:
                    warningLabel.text = "未知的錯誤，請稍侯再試。"
                }
                self.warningLabel.isHidden = false
                self.loginButton.configuration = config
                logining = false
                loginButton.configuration?.showsActivityIndicator = false
            }
        }
    }
    
    func showRegisterViewController() {
        let vc = RegisterViewController()
        // navigationController?.pushViewController(vc, animated: true)
        show(vc, sender: nil)
    }
    
    
    
    func showMainRecipeTableViewController() {
        MainTabBarViewController.shared = MainTabBarViewController()
        guard let vc = MainTabBarViewController.shared else {
            return
        }
        
        let animatedView = UIView()
        animatedView.backgroundColor = mainView.backgroundColor
        animatedView.frame = mainView.frame
        animatedView.clipsToBounds = true
        animatedView.layer.cornerRadius = mainView.layer.cornerRadius
        view.insertSubview(animatedView, belowSubview: mainView)
        vc.view.subviews.forEach() {
            $0.alpha = 0
        }
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: { [weak self] in
            guard let self = self else {
                return
            }
            self.mainView.subviews.forEach() {
                $0.alpha = 0
            }
            //  animatedView.frame = vc.view.frame
        }) { bool in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                animatedView.frame = vc.view.frame
            }) { bool in
                
                animatedView.removeFromSuperview()
                
                
                if let window = UIApplication.shared.keyWindow {
                    
                    window.rootViewController = vc
                }
                vc.view.isHidden = false
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    
                    vc.view.subviews.forEach() {
                        $0.alpha = 1
                    }
                    
                }) { [weak self] bool in
                    
                    guard let self = self else {
                        return
                    }
                    logining = false
                    let loginAttributedString = AttributedString("登入", attributes: self.buttonAttributedTitleContainer)
                    var config = UIButton.Configuration.filled()
                    config.attributedTitle = loginAttributedString
                    config.baseBackgroundColor = .orangeTheme
                    config.baseForegroundColor = .white
                    loginButton.configuration = config
                    
                }
                
            }
            
        }
    }
    
    func buttonLayout() {
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            loginButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 36),
            loginButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            anonymousLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.7),
            anonymousLoginButton.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.06),
            anonymousLoginButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -24),
            anonymousLoginButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            registerButton.widthAnchor.constraint(equalTo: anonymousLoginButton.widthAnchor),
            registerButton.heightAnchor.constraint(equalTo: anonymousLoginButton.heightAnchor),
            registerButton.bottomAnchor.constraint(equalTo: anonymousLoginButton.topAnchor, constant: -16),
            registerButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
        ])
    }
    
    func textFieldSetup() {
        [emailTextField, passwordTextField].forEach() {
            $0.delegate = self
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
            $0.backgroundColor = .secondaryBackground
            $0.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
            $0.textInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        }
        passwordTextField.isSecureTextEntry = true
    }
    
    func labelLayout() {
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 24),
            emailLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 24),
            emailLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -24),
        ])
        NSLayoutConstraint.activate([
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            passwordLabel.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            warningLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            warningLabel.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
        ])
    }
    
    func textFieldLayout() {
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 12),
            emailTextField.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 12),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor)
        ])
    }
    
    func mainViewSetup() {
        mainView.clipsToBounds = true
        mainView.backgroundColor = .backgroundPrimary
        mainView.layer.cornerRadius = 32
    }
    
    func initLayout() {
        [mainView].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        [emailTextField, passwordTextField, emailLabel, warningLabel, passwordLabel, loginButton, anonymousLoginButton, registerButton].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainView.addSubview($0)
        }
        mainViewLayout()
        labelLayout()
        textFieldLayout()
        buttonLayout()
    }
    
    func mainViewLayout() {
        NSLayoutConstraint.activate([
            mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            mainView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        ])
    }
    
    func viewSetup() {
        self.view.backgroundColor = .accent
    }
}

extension LoginViewController : UITextFieldDelegate {
    
}
