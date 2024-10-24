import UIKit
extension UIVisualEffectView  {
    
    convenience init(frame : CGRect, style : UIBlurEffect.Style ) {
            self.init(frame: frame)
            self.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: style)
            self.effect = blurEffect
            self.frame = frame
        }

    
}

extension UIBlurEffect.Style {
    static var userInterfaceStyle : UIBlurEffect.Style {
        
        if UITraitCollection.current.userInterfaceStyle == .dark {
            return .systemUltraThinMaterialDark
        }
        return .systemUltraThinMaterialLight
    }

    
}

