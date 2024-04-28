
import UIKit
extension UIFont {
    static func weightSystemSizeFont(systemFontStyle : UIFont.TextStyle, weight : UIFont.Weight) -> UIFont {
        let bodyFont = UIFont.preferredFont(forTextStyle: systemFontStyle)
        return UIFont.systemFont(ofSize: bodyFont.pointSize, weight: weight)
    }
    
}
