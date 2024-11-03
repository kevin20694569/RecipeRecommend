import UIKit



class TextFieldWithWarningLabelTableCell : TextFieldTableCell {
    
    var warningLabel : UILabel = UILabel()
    
    
    override func labelLayout() {

        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
        ])
        
        
        
        NSLayoutConstraint.activate([
            warningLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            warningLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
        ])
    }
    
    
    
    
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textFieldSetup()
        
        labelSetup()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func labelSetup() {
        super.labelSetup()
        titleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
        titleLabel.textColor = .primaryLabel
        
        warningLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .headline, weight: .medium)
        warningLabel.textColor = .systemRed
        warningLabel.isHidden = true
    }
    
    override func textFieldSetup() {
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .secondaryBackground
        textField.font = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)
        textField.textInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
    }
    
         
    func configure(title: String, value : String?, isSecureEntry : Bool) {
        if let value = value {
            textField.text = value
        }
        if title == "電子郵件" {
            textField.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        }  else {
            textField.removeTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        }
        self.titleLabel.text = title
        textField.delegate = textFieldDelegate
        textField.isSecureTextEntry = isSecureEntry
    }
    
    override func initLayout() {
        [warningLabel].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        super.initLayout()


    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    @objc func emailTextFieldDidChange(_ textField: UITextField) {
        if let email = textField.text, isValidEmail(email) {
            warningLabel.isHidden = true
            
        } else {
            warningLabel.isHidden = false
            warningLabel.text = "無效的電子郵件"
    
        }
    }

    
    override func textFieldLayout() {

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
    
    
}
