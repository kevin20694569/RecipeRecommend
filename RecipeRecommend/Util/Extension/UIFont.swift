
import UIKit
extension UIFont {
    static func weightSystemSizeFont(systemFontStyle: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
        // 取得指定 TextStyle 的 preferredFont
        let preferredFont = UIFont.preferredFont(forTextStyle: systemFontStyle)
        
        // 取得螢幕寬度，作為調整比例的基準
        let screenWidth = UIScreen.main.bounds.width
        
        // 基於權重創建自訂的字體
        var customFont = UIFont.systemFont(ofSize: preferredFont.pointSize, weight: weight)
        
        var scale = (screenWidth / 390)
        if screenWidth < 390 {
            scale = max(scale, 0.9)
        } else if screenWidth > 390 {
            scale = min(scale, 1.2)
            
        }
        

        customFont = customFont.withSize(preferredFont.pointSize *  scale)
        
        // 使用 UIFontMetrics 進行比例調整
        return UIFontMetrics(forTextStyle: systemFontStyle).scaledFont(for: customFont)
    }
    
}
