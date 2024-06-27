import UIKit


protocol GetImageModel : AnyObject {
    var image : UIImage? { get set }
    var image_URL : URL? { get set }
    
    func getImage() async -> UIImage?
}

extension GetImageModel {
    func getImage() async -> UIImage? {

        if let image = self.image {
            return image
        }
        return nil
        if let image = await self.image_URL?.getImage() {
            self.image = image
        }
        return image
    }
}
