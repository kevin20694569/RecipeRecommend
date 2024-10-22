
import UIKit

class ImageViewTableCell : UITableViewCell {
    
    var mainImageView : UIImageView! = UIImageView()
    
    var image : UIImage!
    
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        imageViewSetup()
        initLayout()

    }
    
    func configure(image : UIImage) {
        self.mainImageView.setImageWithAnimation(image: image, duration: 0.2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        [mainImageView].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        imageViewLayout()
    }
    
    func imageViewLayout() {
        NSLayoutConstraint.activate([
            mainImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mainImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainImageView.widthAnchor.constraint(equalTo: mainImageView.heightAnchor, multiplier: 1)
        ])
    }
    
    func imageViewSetup() {
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.backgroundColor = .thirdaryBackground
        mainImageView.clipsToBounds = true
        mainImageView.isUserInteractionEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainImageView.layer.cornerRadius = mainImageView.bounds.height / 2
    }
}
