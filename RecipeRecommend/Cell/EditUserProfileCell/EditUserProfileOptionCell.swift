import UIKit

enum EditUserProfileOptionCellType : Int {
    case userName, dislikeIngredient, cuisine, deleteAccount
}



class EditUserProfileOptionCell : GroupCornerBackgroundTableCell {
    
    var titleLabel : UILabel! = UILabel()
    
    var valueLabel : UILabel! = UILabel()
    
    var labelHorConstant : CGFloat {
        20
    }
    
    var cellType : EditUserProfileOptionCellType! = .userName
    
    weak var editUserProfileCellDelegate : EditUserProfileCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabelSetup()
        valueLabelSetup()
        titleLabelLayout()
        valueLabelLayout()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(title : String, value : String, cellType : EditUserProfileOptionCellType) {
        self.cellType = cellType
        titleLabel.text = title
        valueLabel.text = value
        if cellType == .deleteAccount {
            titleLabel.textColor = .systemRed
            customAccessoryImageView.image = customAccessoryImageView.image?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        } else {
            titleLabel.textColor = .primaryLabel
            customAccessoryImageView.image = customAccessoryImageView.image?.withTintColor(.primaryLabel, renderingMode: .alwaysOriginal)
        }
        
        

    }

    
    func titleLabelSetup() {
        titleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .bold)
        titleLabel.textColor = .primaryLabel
    }
    
    func valueLabelSetup() {
        valueLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)
        valueLabel.textAlignment = .right
        valueLabel.textColor = .primaryLabel
        valueLabel.adjustsFontSizeToFitWidth = true
    }
    
    func titleLabelLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: labelHorConstant),
            titleLabel.centerYAnchor.constraint(equalTo: background.centerYAnchor)
        ])
    }
    
    override func cellGestureTriggered( _ gesture : UITapGestureRecognizer ) {
        super.cellGestureTriggered(gesture)
        switch self.cellType {
        case .userName:
            guard valueLabel.text != "anonymous" else {
                return
            }
            editUserProfileCellDelegate?.showEditNameViewController()
        case .dislikeIngredient:
            editUserProfileCellDelegate?.showEditEquipementViewController()
        case .cuisine :
            editUserProfileCellDelegate?.showEditFavoriteCuisineViewController()
        case .deleteAccount :
            editUserProfileCellDelegate?.showDeleteAccountController()
            break
            
        default :
            break
        }
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        customAccessoryImageView.isHidden = true
    }
    
    
    
    func valueLabelLayout() {
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(valueLabel)
        NSLayoutConstraint.activate([
            valueLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -labelHorConstant),
            valueLabel.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            valueLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.65)
        ])
    }
    
    
}
