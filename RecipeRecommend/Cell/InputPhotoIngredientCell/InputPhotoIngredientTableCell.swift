
import UIKit

protocol InputPhotoIngredientTableCellDelegate : UIViewController {
    func changeCatchButtonStatus(to status : CatchButtonStatus)
    func lastCollectionViewIsPresentToScreen() -> Bool
}

class InputPhotoIngredientTableCell : CollectionViewTableCell, InputPhotoCollectionCellDelegate {
    
    
    var isAddingNewCollectionCell : Bool = false
    weak var delegate : InputPhotoIngredientTableCellDelegate?
    func snapshotView() -> UIImage? {
        return cameraController.snapshotView()
    }
    
    func deleteCell(image: UIImage?) {
        guard let index = images.firstIndex(of: image) else {
            return
        }

        let indexPath = IndexPath(row: index, section: 0)
        if index == images.count - 1 {
            
            let lastIndexPath = IndexPath(row: indexPath.row - 1, section: 0)
            if let cell = collectionView.cellForItem(at: lastIndexPath) as? InputPhotoIngredientCollectionCell {
                cell.toolButtonRefresh(enable: true, animated: true)
                cell.changeFlashImage(flashIsOn: cameraController.flashMode == .on  )
            }
            self.previewRemoveFromSuperView()
        }

        collectionView.performBatchUpdates( {
            images.remove(at: index)
            self.collectionView.deleteItems(at: [indexPath])
        }) { Bool in
            if let bool  = self.delegate?.lastCollectionViewIsPresentToScreen() {
                self.delegate?.changeCatchButtonStatus(to: bool ? .reset : .forbidden)
            }
        }
       
        if images.count == 1 {
            if let cell = collectionView.visibleCells.first as? InputPhotoIngredientCollectionCell {
                cell.deleteSelfButton.isHidden = true
                cell.toolButtonRefresh(enable: true, animated: true)
            }
        }
        let lastIndex = images.count - 1

        if (images[lastIndex] == nil)  {
            if let cell = collectionView.cellForItem(at: IndexPath(row: lastIndex, section: 0)) as? InputPhotoIngredientCollectionCell {

                try? self.cameraController.ChangePreView(on: cell.imageView)
            }
        } else {
            self.addButtonEnable(enable: true)
        }

    }
    
    func captureImage() async throws -> UIImage {
        return try await withCheckedThrowingContinuation { continuation in
            cameraController.capture { image in
                continuation.resume(returning: image)
            }
        }

    }
    
    
    
    func toggleFlash() -> Bool {
        return cameraController.toggleFlash()
    }
    
    
    func cameraControllerDisplayOn(view : UIView) throws {
        try self.cameraController.displayPreview(on: view)
    }
    
    func previewRemoveFromSuperView() {
        cameraController.previewLayerRemoveFromSuperLayer()
    }
    
    func modifyImageArray(image: UIImage?) {

        images[images.count - 1] = image
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        Task {
            try await configureCameraController()
            configure()
        }
        backgroundColor = .clear
        collectionView.backgroundColor = .clear
    }
    func configureCameraController() async throws {
        
        try await withCheckedThrowingContinuation { (continuation : CheckedContinuation<Void, Error>)  in
            cameraController.prepare { err in
                if let err = err {
                    continuation.resume(throwing: err)
                    return
                }
                continuation.resume()
                
                
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var addButtonEnable : Bool! = false
    
    var cameraController : CameraController! = CameraController()
    
    func addNewCameraCollectionCell() {
        guard images.last != nil else {
            return
        }
        guard self.addButtonEnable else {
            return
        }
        isAddingNewCollectionCell = true
        self.addButtonEnable(enable: false)



        
        self.images.append(nil)
        if images.count > 1 {
            if let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? InputPhotoIngredientCollectionCell {
                cell.deleteSelfButton.isHidden = false
            }
        }
        let indexPath = IndexPath(row: images.count - 1, section: 0)
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: [indexPath])
        } completion: { Bool in
            self.isAddingNewCollectionCell = false
        }

        
        
        let lastIndexPath = IndexPath(row: indexPath.row - 1, section: 0)
        if let lastCell = collectionView.cellForItem(at: lastIndexPath) as? InputPhotoIngredientCollectionCell {
            lastCell.toolButtonRefresh(enable: false, animated: true)
        }
        let addButtonIndexPath = IndexPath(row: 0, section: 1)
        
        DispatchQueue.main.async { [self] in
            collectionView.scrollToItem(at: addButtonIndexPath, at: .centeredHorizontally, animated: true)
            
            if let cell = collectionView.cellForItem(at: indexPath) as? InputPhotoIngredientCollectionCell {
                try? self.cameraController.ChangePreView(on: cell.imageView)
                cell.toolButtonRefresh(enable: true, animated: true)
            }
            
            
        }
        
        
        
        
    }
    var images : [UIImage?] = [nil]
    
   // var images : [UIImage?] = UIImage.ingredientImages
    
    func addButtonEnable(enable : Bool) {
        addButtonEnable = enable
        if let cell = self.addButtonCell {
            
            cell.configure(buttonEnable: enable)
        }
        
    }
    
    
    override var collectionViewHeightConstant: CGFloat! {
        UIScreen.main.bounds.height * 0.6
    }
    
    
    var addButtonCell : AddButtonCollectionCell? {
        self.collectionView.cellForItem(at: IndexPath(row: 0, section: 1)) as? AddButtonCollectionCell
    }
    
    func configure() {
        if let cell = collectionView.visibleCells.first as? InputPhotoIngredientCollectionCell {
            try? self.cameraController.ChangePreView(on: cell.imageView)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return images.count
    }
    
    override func registerCell() {
        super.registerCell()
        collectionView.register(InputPhotoIngredientCollectionCell.self, forCellWithReuseIdentifier: "InputPhotoIngredientCollectionCell")
        collectionView.register(AddButtonCollectionCell.self, forCellWithReuseIdentifier: "AddButtonCollectionCell")
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddButtonCollectionCell", for: indexPath) as! AddButtonCollectionCell
            cell.inputPhotoCollectionCellDelegate = self    
            cell.configure(buttonEnable: addButtonEnable)
            
            return cell
        }

        let image = images[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InputPhotoIngredientCollectionCell", for: indexPath) as! InputPhotoIngredientCollectionCell
        cell.ingredientAddCollectionCellDelegate = self
        cell.configure(image: image, flashIsON: cameraController.flashMode == .on)
        if row == images.count - 1 {
            if image == nil {
                cell.configurePreviewLayer(previewLayer: cameraController.previewLayer)
            }
            cell.toolButtonRefresh(enable : true, animated : false)
        } else {
            cell.toolButtonRefresh(enable : false, animated : false)
        }
        if row == 0 && image == nil  {
            cell.deleteSelfButton.isHidden = true
        } else {
            cell.deleteSelfButton.isHidden = false
        }


        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == images.count - 1 && images[indexPath.row] != nil {
            cameraController.previewLayer?.removeFromSuperlayer()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        
        if section == 1 {
            return CGSize(width: collectionViewHeightConstant * 0.2, height: collectionViewHeightConstant)
        }
        return CGSize(width: collectionViewHeightConstant / 1.8, height: collectionViewHeightConstant)
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isAddingNewCollectionCell else {
            return
        }
        
        let currentXOffSet = scrollView.contentOffset.x
        let contentXSize = scrollView.contentSize.width
        let singlePageXSize = Double(contentXSize) / Double(self.images.count)
        let currentPage = round(currentXOffSet / singlePageXSize)
        
        guard let lastImageCollectionCell = collectionView.cellForItem(at: IndexPath(row: images.count - 1, section: 0)) as? InputPhotoIngredientCollectionCell  else {
            return
        }
        
        guard let lastCollectionImageViewFrameInView =  lastImageCollectionCell.imageView.superview?.convert(lastImageCollectionCell.imageView.frame, to: nil) else {
            return
        }
        let viewWidth = UIScreen.main.bounds.width
        if viewWidth - lastCollectionImageViewFrameInView.minX  >= lastImageCollectionCell.bounds.width * 0.5  {
            
            delegate?.changeCatchButtonStatus(to: .catch)
        } else {
            delegate?.changeCatchButtonStatus(to: .forbidden)
        }
       
    }

    
    override func collectionViewSetup() {
        super.collectionViewSetup()
        let screenBounds = UIScreen.main.bounds
        collectionView.contentInset = UIEdgeInsets(top: 0, left: screenBounds.width / 2 -  (collectionViewHeightConstant / 1.8 / 2), bottom: 0, right: screenBounds.width / 2 -  (collectionViewHeightConstant / 1.8 / 2) - collectionViewHeightConstant * 0.2 )
    }
    
    func refreshCollectionCellPreviewLayer() {
        guard let image = images.last else {
            return
        }
        if image == nil {
            let index = images.count - 1
            if let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? InputPhotoIngredientCollectionCell {
                cell.configurePreviewLayer(previewLayer: cameraController.previewLayer)
                
            }
        }
    }
}
