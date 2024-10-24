import UIKit

class EditUserProfileUserImageViewTableCell : ImageViewTableCell {

    var cameraButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var cameraBlurView : UIView = UIVisualEffectView(frame: .zero, style: .userInterfaceStyle)
    
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
        mainImageView.addSubview(cameraBlurView)
        self.mainImageView.addSubview(cameraButton)

        cameraBlurView.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraBlurView.isUserInteractionEnabled = false
        buttonLayout()
    }
    
    
    func buttonLayout() {
        NSLayoutConstraint.activate([
            cameraButton.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor),
            cameraButton.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),
            cameraButton.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
            cameraButton.heightAnchor.constraint(equalTo: mainImageView.heightAnchor, multiplier: 0.2),
            
            cameraBlurView.centerXAnchor.constraint(equalTo: cameraButton.centerXAnchor),
            cameraBlurView.centerYAnchor.constraint(equalTo: cameraButton.centerYAnchor),
            cameraBlurView.widthAnchor.constraint(equalTo: cameraButton.widthAnchor),
            cameraBlurView.heightAnchor.constraint(equalTo: cameraButton.heightAnchor)
            
            
        ])
    }
    
    func buttonSetup() {

        var cameraConfig = UIButton.Configuration.filled()
        cameraConfig.baseBackgroundColor = .clear
        cameraConfig.image = UIImage(systemName: "camera")
        cameraConfig.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font :      UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium))
        cameraButton.configuration = cameraConfig
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped ( _ : )), for: .touchUpInside)
        cameraButton.scaleTargets?.append(cameraBlurView)
        cameraButton.animatedEnable = false
        
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


class RegisterEditUserProfileUserImageViewTableCell : ChangeUserImageViewTableCell {
    
    
    var photoLibraryButton : ZoomAnimatedButton = ZoomAnimatedButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    override func buttonSetup() {
        super.buttonSetup()
        
        cameraButton.isHidden = true
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .clear
        config.image = UIImage(systemName: "photo.on.rectangle.angled.fill")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font :      UIFont.weightSystemSizeFont(systemFontStyle: .largeTitle, weight: .medium))
        photoLibraryButton.configuration = config
        photoLibraryButton.addTarget(self, action: #selector(photoLibraryButtonTapped ( _ : )), for: .touchUpInside)
        cameraBlurView.isHidden = true
        

        

        
    }
    
    
   override func imageViewLayout() {
        let bounds = UIScreen.main.bounds
        
        NSLayoutConstraint.activate([
            mainImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
           // mainImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
           // mainImageView.bottomAnchor.constraint(equalTo: photoLibraryButton.topAnchor),
            
            mainImageView.heightAnchor.constraint(equalToConstant: bounds.height * 0.4),
            mainImageView.heightAnchor.constraint(equalToConstant: bounds.height * 0.4),
            mainImageView.widthAnchor.constraint(equalTo: mainImageView.heightAnchor, multiplier: 1)
        ])
       
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = UIScreen.main.bounds
        mainImageView.layer.cornerRadius = bounds.height * 0.4 / 2
    }
    
    @objc func photoLibraryButtonTapped( _ button : UIButton) {
        editUserProfileCellDelegate?.showImagePicker()
    }

    
    
    override func initLayout() {

        super.initLayout()
        [photoLibraryButton].forEach(){
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            
            photoLibraryButton.topAnchor.constraint(equalTo: mainImageView.bottomAnchor),
            photoLibraryButton.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
            
         //   photoLibraryButton.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor),
         //   photoLibraryButton.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor),
         //   photoLibraryButton.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),
         //   photoLibraryButton.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
            photoLibraryButton.heightAnchor.constraint(equalTo: mainImageView.heightAnchor, multiplier: 0.2),
            photoLibraryButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            
            
            
        ])

    }
    
    
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
