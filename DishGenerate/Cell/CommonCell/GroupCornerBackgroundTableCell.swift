import UIKit

class GroupCornerBackgroundTableCell : UITableViewCell {
    var background : UIView! = UIView()
    
    var customAccessoryImageView : UIImageView! = UIImageView()
    
    
    
    var cellTapGesture : BackGroundColorTriggerTapGesture!

    func configureCorners(topCornerMask : Bool?) {
        guard let topCornerMask = topCornerMask else {
            background.layer.maskedCorners = []
            return
        }
        
        background.layer.maskedCorners = topCornerMask ? [.layerMinXMinYCorner, .layerMaxXMinYCorner] : [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func cellTapGestureSetup() {
        cellTapGesture = BackGroundColorTriggerTapGesture(target: self, action: #selector(cellGestureTriggered ( _ : )), originalBackgroundColor: background.backgroundColor, triggerColor: nil)
        background.addGestureRecognizer(cellTapGesture)
       // cellTapGesture.isEnabled = false
    }
    
    @objc func cellGestureTriggered( _ gesture : UITapGestureRecognizer  ) {


    }
    
    func backgroundSetup() {
        background.isUserInteractionEnabled = true
        background.backgroundColor = UIColor.thirdaryBackground
        background.clipsToBounds = true
        background.layer.cornerRadius = 20
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellSetup()
        backgroundSetup()
        cellTapGestureSetup()
        backgroundLayout()
        customAccessoryImageViewSetup()
        customAccessoryImageViewLayout()
        
    }
    
    func cellSetup() {
        
        let bounds = UIScreen.main.bounds
        self.separatorInset = UIEdgeInsets(top: 0, left: bounds.width / 2, bottom: 0, right: bounds.width / 2)
        selectionStyle = .none
    }
    func customAccessoryImageViewSetup() {
        let checkmarkImage = UIImage(systemName: "chevron.right")?.withTintColor(.thirdaryLabel, renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(font: UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .bold)))
        customAccessoryImageView.image = checkmarkImage
        customAccessoryImageView.contentMode = .scaleAspectFit
        customAccessoryImageView.isHidden = true
    }
    
    func customAccessoryImageViewLayout() {
        customAccessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(customAccessoryImageView)

        NSLayoutConstraint.activate([
            customAccessoryImageView.topAnchor.constraint(equalTo: background.topAnchor),

            customAccessoryImageView.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -20),
            customAccessoryImageView.bottomAnchor.constraint(equalTo: background.bottomAnchor),
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func backgroundLayout() {
        background.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(background)

        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            triggerBackgroundColor()
        } else {
            recoverBackgroundColor()
        }
    }
    
    func recoverBackgroundColor() {
        background.alpha = 1

    }
    
    func triggerBackgroundColor() {
        background.alpha = 0.5
    }
}
