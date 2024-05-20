
import UIKit

class CustomTextField : UITextField {
    
    init(insets : UIEdgeInsets) {
        super.init(frame: .zero)
        self.textInsets = insets
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var textInsets: UIEdgeInsets = .zero

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    
}
