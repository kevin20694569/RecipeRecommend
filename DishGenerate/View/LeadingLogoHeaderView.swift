import UIKit

class LeadingLogoHeaderView : UICollectionReusableView {
    var imageView : UIImageView! = UIImageView()
    
    var titleLabel : UILabel! = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

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
        
    }
    
    func labelSetup() {
        titleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
    }
}
