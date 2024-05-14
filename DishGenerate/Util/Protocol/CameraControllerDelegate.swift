

import UIKit
protocol CameraControllerDelegate : AnyObject {
    func captureImage() async throws -> UIImage
    
    func previewRemoveFromSuperView()
    func cameraControllerDisplayOn(view : UIView) throws
    
    func toggleFlash() -> Bool
    
    
}
