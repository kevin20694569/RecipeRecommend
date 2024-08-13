import UIKit

class LoginViewController : UIViewController {
    
    var mainView : UIView = UIView()
    
    
    
    var emailLabel : UILabel = UILabel()
    
    var passwordLabel : UILabel = UILabel()
    
    var emailTextField : CustomTextField = CustomTextField(insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    
    var passwordTextField : CustomTextField = CustomTextField(insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    
    var loginButton : ZoomAnimatedButton = ZoomAnimatedButton()
    
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
        
        
    }
    
    func labelSetup() {
        [emailLabel, passwordLabel].forEach() {
            $0.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
        }
        emailLabel.text = "電子郵件"
        
        passwordLabel.text = "密碼"
    
    }
    
    func buttonSetup() {
        let attributedString = AttributedString("登入", attributes: self.buttonAttributedTitleContainer)
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attributedString
        
        config.baseBackgroundColor = .orangeTheme
        config.baseForegroundColor = .white
        loginButton.configuration = config
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped ( _ :)), for: .touchUpInside)
        
    }
    
    @objc func loginButtonTapped(_ button : UIButton) {
        guard !logining else {
            return
        }
        login()
    }
     
    func login() {

        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        logining = true
        Task {
            do {
                var config = loginButton.configuration
                loginButton.configuration?.showsActivityIndicator = true
                loginButton.configuration?.attributedTitle = nil
                try await UserManager.shared.login(email: email, password: password)
                //   let attributedString = AttributedString("登入成功", attributes: self.buttonAttributedTitleContainer)
                
                config?.attributedTitle = nil
                config?.image = UIImage(systemName: "checkmark")?.withConfiguration(UIImage.SymbolConfiguration.init(font: UIFont.weightSystemSizeFont(systemFontStyle: .title1, weight: .medium)))
                config?.baseBackgroundColor = .systemGreen
                loginButton.configuration = config
                
                try await Task.sleep(nanoseconds: 800000000)
                let vc = MainTabBarViewController()
                let animatedView = UIView()
                animatedView.backgroundColor = mainView.backgroundColor
                animatedView.frame = mainView.frame
                animatedView.clipsToBounds = true
                animatedView.layer.cornerRadius = mainView.layer.cornerRadius
                view.insertSubview(animatedView, belowSubview: mainView)
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    self.mainView.subviews.forEach() {
                        $0.alpha = 0
                    }
                    animatedView.frame = vc.view.frame
                }) { bool in
                    
                    if let window = UIApplication.shared.keyWindow {
                        window.rootViewController = vc
                    }
                }

            } catch {
                logining = false
            }
            
            
        }
        
    }
    
    func buttonLayout() {
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.widthAnchor.constraint(equalTo: mainView.widthAnchor,multiplier: 0.8),
            loginButton.heightAnchor.constraint(equalTo: mainView.heightAnchor,multiplier: 0.1),
            loginButton.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            loginButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
        ])
    }
    
    func textFieldSetup() {
        [emailTextField, passwordTextField].forEach() {
            $0.delegate = self
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .secondaryBackground
            $0.font = UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .medium)
        }
        
        emailTextField.text = "kevin20694569@gmail.com"
        passwordTextField.text = "29779499"
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
    }
    
    func textFieldLayout() {
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 12),
            emailTextField.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 0.09)
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
        mainView.backgroundColor = .white
        mainView.layer.cornerRadius = 32
    }
    
    func initLayout() {
        [mainView].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        [emailTextField, passwordTextField, emailLabel, passwordLabel, loginButton].forEach() {
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
