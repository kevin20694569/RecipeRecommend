import UIKit

class TextFieldWithLabelTableCell : UITableViewCell {
    
    var textField : CustomTextField = CustomTextField()
    
    var titleLabel : UILabel = UILabel()
    
    var warningLabel : UILabel = UILabel()
    
    weak var textFieldDelegate : UITextFieldDelegate?
    
    var subViewPadding : CGFloat = 8

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textFieldSetup()
        
        labelSetup()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func labelSetup() {
        titleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)
        warningLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .headline, weight: .regular)
        warningLabel.textColor = .systemRed
        warningLabel.isHidden = true
    }
    
    func textFieldSetup() {
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .secondaryBackground
        textField.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
        textField.textInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
    }
    
    func configure(title: String, value : String?, isSecureEntry : Bool) {
        if let value = value {
            textField.text = value
        }
        self.titleLabel.text = title
        textField.delegate = textFieldDelegate
        textField.isSecureTextEntry = isSecureEntry
        
        
    }
    
    func initLayout() {
        [textField, titleLabel].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        textFieldLayout()
        labelLayout()
    }
    
    func textFieldLayout() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: subViewPadding),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
        ])
        
    }
    func labelLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: subViewPadding),
            titleLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
           
        ])
    }
    
    
}
