import UIKit

class UserDetailCollectionCell : UICollectionViewCell  {
    
    var imageView : UIImageView! = UIImageView()
    
    var nameLabel : UILabel! = UILabel()
    
    var user : User!
    
    var editButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var editButtonTitleAttributes : AttributeContainer = AttributeContainer([.font : UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .medium)])
    
    weak var userProfileCellDelegate : UserProfileCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageViewSetup()
        labelSetup()
        buttonSetup()
        initLayout()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        [imageView, nameLabel, editButton].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        let bounds = UIScreen.main.bounds
        NSLayoutConstraint.activate([

            
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: bounds.width * 0.08),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1),

            nameLabel.topAnchor.constraint(equalTo: imageView.centerYAnchor, constant: -32),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            editButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            editButton.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
        ])
        imageView.layoutIfNeeded()
        imageView.layer.cornerRadius = imageView.bounds.height / 2
    }
    func configure(user : User) {
        self.user = user
        nameLabel.text = user.name
        Task {
            let image = await user.getImage()
            self.imageView.image = image
        }
    }
    
    func imageViewSetup() {
        imageView.backgroundColor = .thirdaryBackground
        imageView.image = UIImage.焗烤玉米濃湯
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    func labelSetup() {
        nameLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
        nameLabel.text = ""
        nameLabel.adjustsFontSizeToFitWidth = true
    }
    
    func buttonSetup() {
        var editConfig = UIButton.Configuration.filled()
        let title = AttributedString("編輯檔案", attributes: editButtonTitleAttributes)
        editConfig.attributedTitle = title
        
        editButton.configuration = editConfig
        editButton.addTarget(self, action: #selector(editButtonTapped ( _ : )), for: .touchUpInside)
    }
    
    @objc func editButtonTapped(_ button : UIButton) {
        userProfileCellDelegate?.showEditUserProfileViewController()
    }
    
}
