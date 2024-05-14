import UIKit

protocol InputPhotoCollectionCellDelegate : CameraControllerDelegate {
    func addNewCameraCollectionCell()
    
    func addButtonEnable(enable : Bool)
    func modifyImageArray(image : UIImage?)
    
    func deleteCell(image: UIImage?)
    
    func snapshotView() -> UIImage?
}
