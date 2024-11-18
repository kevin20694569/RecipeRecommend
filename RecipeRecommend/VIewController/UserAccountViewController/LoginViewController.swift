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
    
    var loginLabel : UILabel = UILabel()
    
    
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
        navItemSetup()
        
    }

    
    func navItemSetup() {
        navigationItem.backButtonTitle = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TapGestureHelper.shared.shouldAddTapGestureInWindow(view: self.view)
        
    }
    
    
    func configure() {
        guard let email = UserDefaultManager.shared.getEmail() else {
            
            return
        }
        self.emailTextField.text = email
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
         
        loginLabel.font =  UIFont.weightSystemSizeFont(systemFontStyle: .largeTitle, weight: .bold)
        loginLabel.textColor = .primaryLabel
        loginLabel.text = "登入"
    }
    
    func buttonSetup() {
        [loginButton, anonymousLoginButton, registerButton].forEach() {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 14
        }

        var loginAttributedString = AttributedString("登入", attributes: self.buttonAttributedTitleContainer)
        loginAttributedString.font = UIFont.weightSystemSizeFont(systemFontStyle: .title1, weight: .bold)
        var config = UIButton.Configuration.filled()
        config.attributedTitle = loginAttributedString
        config.baseBackgroundColor = .orangeTheme
        config.baseForegroundColor = .white
        loginButton.configuration = config
        loginButton.addTarget(self, action: #selector(loginButtonTapped ( _ :)), for: .touchUpInside)
        
        config = UIButton.Configuration.filled()
        var anonymousLoginAttributedString = AttributedString("不想註冊？ ", attributes: AttributeContainer([.foregroundColor : UIColor.primaryLabel, .font : UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .medium)]))
        anonymousLoginAttributedString.append(AttributedString("訪客登入", attributes: AttributeContainer([.foregroundColor : UIColor.accent, .font : UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .medium)])))
        anonymousLoginAttributedString.font = UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .medium)
        config.attributedTitle = anonymousLoginAttributedString

        
        
        
        config.baseBackgroundColor = .clear

        anonymousLoginButton.configuration = config
        anonymousLoginButton.addTarget(self, action: #selector(anoymousLoginButtonTapped ( _ :)), for: .touchUpInside)
        
        
        config = UIButton.Configuration.filled()
        var registerAttributedString = AttributedString("註冊", attributes: self.buttonAttributedTitleContainer)
        registerAttributedString.font = UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .medium)
        config.attributedTitle = registerAttributedString
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .accent
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
                    warningLabel.text = "電子郵件或密碼錯誤。"
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
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                animatedView.frame = vc.view.frame
                let bounds = UIScreen.main.bounds
                if bounds.width <= 375 {
                    animatedView.layer.cornerRadius = 0
                }
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
        let bounds = UIScreen.main.bounds
        
        
        NSLayoutConstraint.activate([
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            loginButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bounds.height * 0.1),
            loginButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            anonymousLoginButton.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.06),
            anonymousLoginButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: bounds.width * 0.02),
            anonymousLoginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant:  bounds.width * 0.01),
        ])
        
        NSLayoutConstraint.activate([
            registerButton.heightAnchor.constraint(equalTo: anonymousLoginButton.heightAnchor),

            registerButton.topAnchor.constraint(equalTo: anonymousLoginButton.topAnchor),
            registerButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor, constant: -bounds.width * 0.02),
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
        emailTextField.textContentType = .emailAddress
        passwordTextField.isSecureTextEntry = true
    }
    
    func labelLayout() {
        let bounds = view.bounds
        
        NSLayoutConstraint.activate([
            loginLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: bounds.width * 0.05),
            
            loginLabel.bottomAnchor.constraint(equalTo: mainView.topAnchor, constant: -bounds.height * 0.02)
        ])
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: bounds.height * 0.08),
            emailLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant:  bounds.height * 0.02),
            emailLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -bounds.height * 0.02),
        ])
        NSLayoutConstraint.activate([
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: bounds.height * 0.03),
            passwordLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            passwordLabel.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            warningLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            warningLabel.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
        ])
        
        
    }
    
    func textFieldLayout() {
        let screenBounds = UIScreen.main.bounds
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: screenBounds.height * 0.02),
            emailTextField.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: screenBounds.width * 0.04),
            emailTextField.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -screenBounds.width * 0.04),
            emailTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant:  screenBounds.height * 0.02),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor)
        ])
    }
    
    func mainViewSetup() {
        mainView.clipsToBounds = true
        mainView.backgroundColor = .primaryBackground
        mainView.layer.cornerRadius = 32
    }
    
    
    func initLayout() {
        [loginLabel, mainView].forEach() {
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
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mainView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
            
            
        ])
    }
    
    func viewSetup() {
        self.view.backgroundColor = .accent
    }
}

extension LoginViewController : UITextFieldDelegate {
    
}
