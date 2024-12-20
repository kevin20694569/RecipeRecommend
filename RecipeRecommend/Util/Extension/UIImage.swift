
import UIKit

extension UIImage {
    //static let ingredientImages : [UIImage?] = [UIImage(named: "pork"), UIImage(named: "chicken"), UIImage(named: "vegetable")]
    
    static let ingredientImages : [UIImage?] = [UIImage(named: "apple"), UIImage(named: "s")]
   
   // [UIImage(named: "焗烤玉米濃湯"), UIImage(named: "番茄炒蛋"), UIImage(named: "拔絲地瓜")]
    static let dishImages : [UIImage?] = [UIImage(named: "蒜香空心菜炒牛肉"), UIImage(named: "番茄炒蛋"), UIImage(named: "拔絲地瓜")]
    
    func compressImage(to maxFileSize: Int = 50_000) -> Data? {
        var compression: CGFloat = 1.0
        var compressedData = self.jpegData(compressionQuality: compression)
        
        // 動態調整壓縮比例直到達到目標大小
        while let data = compressedData, data.count > maxFileSize && Float(compression) > 0.1 {
            compression -= 0.1
            compressedData = self.jpegData(compressionQuality: compression)
        }
        
        return compressedData
    }
}


