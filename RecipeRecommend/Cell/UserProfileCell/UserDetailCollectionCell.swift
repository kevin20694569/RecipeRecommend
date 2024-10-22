import UIKit

class UserDetailCollectionCell : UICollectionViewCell  {
    
    var imageView : UIImageView! = UIImageView()
    
    var nameLabel : UILabel! = UILabel()
    
    var user : User!
    
    var editButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var editButtonTitleAttributes : AttributeContainer = AttributeContainer([.font : UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .medium)])
    
    var horStackView : UIStackView = UIStackView()
    var verStackView : UIStackView = UIStackView()
    
    weak var userProfileCellDelegate : UserProfileCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageViewSetup()
        stackViewSetup()
        labelSetup()
        buttonSetup()
        initLayout()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        [horStackView].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            horStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor    ),
            horStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -contentView.bounds.height * 0.2),
            

            editButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: contentView.bounds.height * 0.2),
            
            
           // editButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant : -8),
            editButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3)

        ])
        imageView.layoutIfNeeded()
        imageView.layer.cornerRadius = imageView.bounds.height / 2
    }
    func configure(user : User) {
        self.user = user
        nameLabel.text = user.name
        Task(priority : .background) {
            let image = await user.getImage()
            self.imageView.setImageWithAnimation(image: image)
        }
    }
    
    func imageViewSetup() {
        imageView.backgroundColor = .thirdaryBackground
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    func labelSetup() {
        nameLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)
        nameLabel.text = " "
        nameLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    func stackViewSetup() {


        [nameLabel, editButton].forEach() {
            verStackView.addArrangedSubview($0)
        }
        verStackView.axis = .vertical
        verStackView.distribution = .fillProportionally
        
        
        [imageView, verStackView].forEach { view in
            horStackView.addArrangedSubview(view)
        }
        horStackView.axis = .horizontal
        horStackView.spacing = 16

        
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
