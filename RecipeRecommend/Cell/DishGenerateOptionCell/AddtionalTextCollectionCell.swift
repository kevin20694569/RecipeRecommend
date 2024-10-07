import UIKit

class AddtionalTextCollectionCell : UICollectionViewCell {
    var textView : UITextView! = UITextView()
    
    weak var textViewDelegate : UITextViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textViewSetup()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        textView.delegate = self.textViewDelegate
    }
    
    func initLayout() {
        [textView].forEach() { view in
            textView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(textView)
        }
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    func textViewSetup() {
        textView.font = UIFont.weightSystemSizeFont(systemFontStyle: .headline, weight: .regular)
        textView.backgroundColor = .secondaryBackground
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 12
        let inset : CGFloat = 12
        textView.textContainerInset = UIEdgeInsets(top: inset, left: inset , bottom: inset, right: inset )
    }
}
