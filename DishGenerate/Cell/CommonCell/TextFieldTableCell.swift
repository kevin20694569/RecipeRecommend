import UIKit

class TextFieldTableCell : UITableViewCell {
    
    var titleLabel : UILabel! = UILabel()
    
    var textField : CustomTextField! = CustomTextField()
    
    weak var textFieldDelegate : UITextFieldDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellSetup()
        titleLabelSetup()
        textFieldSetup()
        initLayout()
        
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
        
        titleLabelLayout()
        textFieldLayout()
        
    }
    
    func titleLabelLayout() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
            
        ])
    }
    
    func textFieldLayout() {
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    func titleLabelSetup() {
        titleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)
        titleLabel.textColor = .secondaryLabel
    }
    
    func textFieldSetup() {
        textField.placeholder = "名字"
        textField.font = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)
        textField.textInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    }
    

    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

