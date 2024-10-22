
import UIKit
extension UIFont {
    static func weightSystemSizeFont(systemFontStyle: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
        // 取得指定 TextStyle 的 preferredFont
        let preferredFont = UIFont.preferredFont(forTextStyle: systemFontStyle)
        
        // 取得螢幕寬度，作為調整比例的基準
        let screenWidth = UIScreen.main.bounds.width
        
        // 基於權重創建自訂的字體
        var customFont = UIFont.systemFont(ofSize: preferredFont.pointSize, weight: weight)

        
        // 根據螢幕大小動態調整字體比例
        if screenWidth <= 375 {  // iPhone SE 或較小裝置
            customFont = customFont.withSize(preferredFont.pointSize * 0.9)
        } else if screenWidth > 414 {  // iPhone Plus 或 Max, iPad
            customFont = customFont.withSize(preferredFont.pointSize * 1.4)
        }
        
        // 使用 UIFontMetrics 進行比例調整
        return UIFontMetrics(forTextStyle: systemFontStyle).scaledFont(for: customFont)
    }
    
}
