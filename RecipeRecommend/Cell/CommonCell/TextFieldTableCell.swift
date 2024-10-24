import UIKit

class TextFieldTableCell : UITableViewCell {
    
    var titleLabel : CustomTextField! = CustomTextField()
    
    var textField : CustomTextField! = CustomTextField()
    
    weak var textFieldDelegate : UITextFieldDelegate?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cellSetup()
        labelSetup()
        textFieldSetup()
        initLayout()
        self.backgroundColor = .clear
        
    }
    
    func cellSetup() {
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func configure(title : String, value : String?) {
        titleLabel.text = title
        if let value = value {
            textField.text = value
        }
        textField.delegate = textFieldDelegate
    }
    
    func initLayout() {
        [titleLabel, textField].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        
        labelLayout()
        textFieldLayout()
        
    }

    

    
    func labelSetup() {
        titleLabel.textInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        titleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)
        titleLabel.textColor = .secondaryLabel
    }
    
    func textFieldSetup() {
        textField.placeholder = "名字"
        textField.font = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)
        textField.textInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    }
    
    func labelLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
           
        ])
    }
    
    func textFieldLayout() {
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    

    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

