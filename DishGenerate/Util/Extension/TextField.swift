
import UIKit

class CustomTextField : UITextField {
    
    init(insets : UIEdgeInsets) {
        super.init(frame: .zero)
        self.textInsets = insets
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var textInsets: UIEdgeInsets = {
        let inset : CGFloat = 8
        return UIEdgeInsets(top: inset, left: inset * 2, bottom: inset, right: inset * 2)
    }()

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    
}
