

import UIKit

extension UIColor {
    
    static let backgroundPrimary = UIColor { (trait) -> UIColor in
        switch (trait.userInterfaceStyle, trait.userInterfaceLevel) {
        case (.dark, _):
            // For this color set you can set "Appearances" to "none"
            return .black
        default:
            // This color set has light and dark colors specified
            return .white
        }
    }
    
    static let secondaryLabelColor = UIColor { (trait) -> UIColor in
        switch (trait.userInterfaceStyle, trait.userInterfaceLevel) {
        case (.dark, _):

            return .lightGray
        default:

            return .darkGray
        }
    }
    
    static let secondaryBackgroundColor = UIColor  { (trait) -> UIColor in
        switch (trait.userInterfaceStyle, trait.userInterfaceLevel) {
        case (.dark, _):
                
            return .darkGray
        default:

            return .systemGray3
        }
    }
    
    static let themeColor = UIColor(red: 0.921, green: 0.739, blue: 0.469, alpha: 1)
}
