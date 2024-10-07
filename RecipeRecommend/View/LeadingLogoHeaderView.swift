import UIKit

class LeadingLogoHeaderView : UICollectionReusableView {
    var imageView : UIImageView! = UIImageView()
    
    var titleLabel : UILabel! = UILabel()
    
    var imageViewTrigger : (() async -> Void)?
    
    var imageViewTapGesture : UITapGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gestureSetup()
        labelSetup()
        imageViewSetup()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initLayout() {
        [imageView, titleLabel].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1),
            
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant : 12),
            titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
            
            
        ])
        
        
        
    }
    

    
    func configure(logoImage : UIImage, title : String) {
        self.imageView.image = logoImage
        self.titleLabel.text = title
    }
    
    func imageViewSetup() {
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageViewTapGesture)
    }
    
    @objc func imageViewGestureTriggered() {
        guard let trigger = imageViewTrigger else {
            return
        }
        Task {
            await trigger()
        }
        
    }
    
    func gestureSetup() {
        
        imageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector (imageViewGestureTriggered))

    }
    

    
    func labelSetup() {
        titleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
    }
}
