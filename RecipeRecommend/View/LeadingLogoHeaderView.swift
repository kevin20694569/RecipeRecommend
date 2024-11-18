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
        let bounds = UIScreen.main.bounds
        [imageView, titleLabel].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: bounds.width * 0.04),
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

enum UserProfileCollectionRecipePresentedStatus {
    case browsed, generated
}


protocol UserProfileCollectionHeaderViewDelegate : NSObject {
    
    var collectionViewRecipePresentedStatus : UserProfileCollectionRecipePresentedStatus { get set }
    
    func changeCollectionViewPresenting(to status : UserProfileCollectionRecipePresentedStatus)
    
}

extension UserProfileCollectionHeaderViewDelegate {
    func changeCollectionViewPresenting(to status : UserProfileCollectionRecipePresentedStatus) {
        self.collectionViewRecipePresentedStatus = status
        switch status {
        case .browsed:
            break
        case .generated:
            break
        }
    }
}

class UserProfileCollectionHeaderView : LeadingLogoHeaderView {
    
    var titleButton : ZoomAnimatedButton = ZoomAnimatedButton()
    
    weak var delegate : UserProfileCollectionHeaderViewDelegate?
    
    var selectedStatus : UserProfileCollectionRecipePresentedStatus = .browsed
    
    var titleMenu : UIMenu = UIMenu(title: "", image: nil, identifier: nil, options: .singleSelection, children: [])
    
    lazy var browsedAction : UIAction = {return UIAction(title: "瀏覽記錄", image: nil) { action in
        self.selectedStatus = .browsed
        self.delegate?.changeCollectionViewPresenting(to: .browsed)}
    }()
    
    lazy var generatedAction : UIAction = {return UIAction(title: "生成紀錄", image: nil) { action in
        self.selectedStatus = .generated
        self.delegate?.changeCollectionViewPresenting(to: .generated)}

        
    }()
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        menuSetup()
        buttonSetup()
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func labelSetup() {
        super.labelSetup()
        titleLabel.textColor = .color950
    }
    
    override func initLayout() {
        super.initLayout()
        [titleButton].forEach() {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        buttonLayout()
    }
    
    func buttonSetup() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .clear
        titleButton.configuration = config
        titleButton.menu = titleMenu
        titleButton.showsMenuAsPrimaryAction = true
        titleButton.scaleTargets?.append(self.titleLabel)
        
    }
    
    func menuSetup() {
        if #available(iOS 17.0, *) {
            self.titleMenu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, preferredElementSize: .automatic, children: [browsedAction, generatedAction])
        }
        
        
        else if #available(iOS 16, *) {

            self.titleMenu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, preferredElementSize: .large, children: [browsedAction, generatedAction])

        } else {
            self.titleMenu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [browsedAction, generatedAction])
        }
        
        
    }
    
    func buttonLayout() {
        NSLayoutConstraint.activate([
            
            titleButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            titleButton.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            titleButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
        ])
    }
    
    func configure(logoImage : UIImage, title : String, status : UserProfileCollectionRecipePresentedStatus) {
        super.configure(logoImage: logoImage, title: title)
        if status == .browsed {
            self.titleLabel.text = "瀏覽記錄"
        } else {
            self.titleLabel.text = "生成記錄"
        }
    }

    
}
