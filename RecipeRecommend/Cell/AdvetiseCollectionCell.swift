import UIKit

class AdvetiseCollectionCell : UICollectionViewCell {
    
    var imageView : UIImageView = UIImageView()
    
    var advertise : Advertise!
    
    var tapGesture : UITapGestureRecognizer!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageViewSetup()
        gestureSetup()
        initLayout()
        
        
    }
    func gestureSetup() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(showBrowserPage (_ :)))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func showBrowserPage(_ gesture : UITapGestureRecognizer) {
        guard let url = advertise.page_url else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(advertise : Advertise) {
        self.advertise = advertise
        Task {
            let image = await advertise.getImage()
            self.imageView.setImageWithAnimation(image: image)
        }
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func initLayout() {
        [imageView].forEach() {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        imageViewLayout()
    }
    
    func imageViewLayout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
        ])
    }
    
    func imageViewSetup() {
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
    }
    
}
