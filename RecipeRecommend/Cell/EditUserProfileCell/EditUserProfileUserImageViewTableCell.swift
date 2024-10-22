import UIKit

class EditUserProfileUserImageViewTableCell : ImageViewTableCell {

    var cameraButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    weak var editUserProfileCellDelegate : EditUserProfileCellDelegate?
    
    var user : User!
    
    func configure(user : User) {
        self.user = user
        Task(priority : .background) {
            if let image = await user.getImage() {
                super.configure(image: image)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buttonSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initLayout() {
        super.initLayout()
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.addSubview(cameraButton)
        
        NSLayoutConstraint.activate([
            cameraButton.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor),
            cameraButton.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),
            cameraButton.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
            cameraButton.heightAnchor.constraint(equalTo: mainImageView.heightAnchor, multiplier: 0.2)
        ])
    }
    
    func buttonSetup() {
        var cameraConfig = UIButton.Configuration.filled()
        cameraConfig.baseBackgroundColor = .secondaryBackground
        cameraConfig.image = UIImage(systemName: "camera")
        cameraConfig.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font :      UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium))
        cameraButton.configuration = cameraConfig
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped ( _ : )), for: .touchUpInside)
       
    }
    
    @objc func cameraButtonTapped( _ button : UIButton) {
        guard self.user.id != SessionManager.anonymous_user_id else {
            return
        }

        editUserProfileCellDelegate?.showEditUserImageViewController()
    }
    
}

class ChangeUserImageViewTableCell : EditUserProfileUserImageViewTableCell {
    override func cameraButtonTapped(_ button: UIButton) {
        
        editUserProfileCellDelegate?.showImagePicker()
     //   editUserProfileCellDelegate
    }
}

class RegisterUserImageViewTableCell : ChangeUserImageViewTableCell {
    override func imageViewSetup() {
        super.imageViewSetup()
        mainImageView.layer.cornerRadius = 20
        mainImageView.layer.borderWidth = 0.8
        mainImageView.layer.borderColor = UIColor.secondaryLabelColor.cgColor
    }
}
