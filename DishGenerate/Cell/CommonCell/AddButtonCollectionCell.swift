import UIKit


class AddButtonCollectionCell : UICollectionViewCell {
    
    var addButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addButtonSetup()
        initLayout()
    }


    weak var ingredientAddCollectionCellDelegate : InputPhotoCollectionCellDelegate?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        self.contentView.addSubview(addButton)
        contentView.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -bounds.height * 0.12 + 24),
            addButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.13),
            addButton.widthAnchor.constraint(equalTo: addButton.heightAnchor)
        ])
        
    }
    
    func configure(buttonEnable : Bool) {
        self.addButton.isEnabled = buttonEnable
    }
    
    func addButtonSetup() {
        var config = UIButton.Configuration.filled()
        config.background.image = UIImage(systemName: "plus.circle.fill")?.withTintColor(.tintColor, renderingMode: .alwaysOriginal)
        config.background.imageContentMode = .scaleAspectFit
        config.background.backgroundColor = .clear
        addButton.configuration  = config
        addButton.isEnabled = false
        addButton.configurationUpdateHandler = { sender in
            switch sender.state {
            case .normal:
                UIView.animate(withDuration: 0.2, animations: {
                    self.addButton.configuration?.background.image = config.background.image?.withTintColor(.tintColor, renderingMode: .alwaysOriginal)
                    sender.alpha = 1
                })
                
            case .disabled :
                UIView.animate(withDuration: 0.2, animations: {
                    self.addButton.configuration?.background.image = config.background.image?.withTintColor(.secondaryBackgroundColor, renderingMode: .alwaysOriginal)
                    sender.alpha = 0.6
                })
            default:
                break
            }
        }
        addButton.addTarget(self, action: #selector(addButtonTapped ( _ : )), for: .touchUpInside)
    }
    
    @objc func addButtonTapped( _ button : UIButton) {
        self.ingredientAddCollectionCellDelegate?.addNewCameraCollectionCell()
    }
     
}

class AddTextIngredientCollectionCell : AddButtonCollectionCell {
    
    
    weak var addTextIngrdientCollectionCellDelegate : AddTextIngrdientCellDelegate?
    
    override func addButtonTapped(_ button: UIButton) {
        addTextIngrdientCollectionCellDelegate?.insertNewIngredient(ingredient: Ingredient(), section: .Text)
    }
    
    override func initLayout() {
        
        self.contentView.addSubview(addButton)
        
        contentView.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            addButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8)
        ])
        
    }
    
    
}
