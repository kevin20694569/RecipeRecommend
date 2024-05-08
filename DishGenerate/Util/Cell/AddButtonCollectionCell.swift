import UIKit
protocol IngredientAddCollectionCellDelegate : UICollectionViewDelegate {
    func addNewCameraCollectionCell()
}

class AddButtonCollectionCell : UICollectionViewCell {
    var addButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addButtonSetup()
        initLayout()
    }
    
    weak var ingredientAddCollectionCellDelegate : IngredientAddCollectionCellDelegate?
    
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
            addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.13),
            addButton.widthAnchor.constraint(equalTo: addButton.heightAnchor)
        ])
    }
    
    func addButtonSetup() {
        var config = UIButton.Configuration.filled()
        config.background.image = UIImage(systemName: "plus.circle.fill")
        config.background.imageContentMode = .scaleAspectFit
        config.background.backgroundColor = .clear
        addButton.configuration  = config
        addButton.addTarget(self, action: #selector(addButtonTapped ( _ : )), for: .touchUpInside)
    }
    
    @objc func addButtonTapped( _ button : UIButton) {
        self.ingredientAddCollectionCellDelegate?.addNewCameraCollectionCell()
    }
}
