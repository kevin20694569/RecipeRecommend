import UIKit

class EditNameLabelTableCell : UITableViewCell {
    
    var warningLabel : UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellSetup()
        labelSetup()
        initLayout()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        contentView.addSubview(warningLabel)
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        labelLayout()
        
    }
    
    func cellSetup() {
        let bounds = UIScreen.main.bounds
        separatorInset = UIEdgeInsets(top: 0, left: bounds.width / 2, bottom: 0, right: bounds.width / 2)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }

    
    func labelSetup() {
        warningLabel.text = "最多輸入16個字元。"
        warningLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .regular)
        warningLabel.textColor = .primaryLabel
        warningLabel.backgroundColor = .clear
    }
    
    
    func labelLayout() {
        
        NSLayoutConstraint.activate([
            warningLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            warningLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            warningLabel.topAnchor.constraint(equalTo: topAnchor),
            warningLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    
    
    
    
}
