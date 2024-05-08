
import UIKit

class IngredientImageTableCell : CollectionViewTableCell, IngredientAddCollectionCellDelegate {
    func addNewCameraCollectionCell() {
       /*guard images.last == nil else {
            return
        }*/
        cameraCellCount += 1
        let indexPath = IndexPath(row: cameraCellCount - 1, section: 0)
        collectionView.insertItems(at: [indexPath])
        let addButtonIndexPath = IndexPath(row: 0, section: 1)
        self.collectionView.scrollToItem(at: addButtonIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    var cameraCellCount : Int = 1
    
    var images : [UIImage?]! = [nil]
    
    
    override var collectionViewHeightConstant: CGFloat! {
        UIScreen.main.bounds.height * 0.4
    }

    var ingredients : [Ingredient]! = Ingredient.examples
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return cameraCellCount
    }
    
    override func registerCell() {
        super.registerCell()
        collectionView.register(InputIngredientCameraCollectionCell.self, forCellWithReuseIdentifier: "InputIngredientCameraCollectionCell")
        collectionView.register(AddButtonCollectionCell.self, forCellWithReuseIdentifier: "AddButtonCollectionCell")
        
    }
    
    
    
    override func initLayout() {
        super.initLayout()
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: collectionViewHeightConstant)
        ])
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        if section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddButtonCollectionCell", for: indexPath) as! AddButtonCollectionCell
            cell.ingredientAddCollectionCellDelegate = self
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InputIngredientCameraCollectionCell", for: indexPath)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        
        if section == 1 {
            return CGSize(width: collectionViewHeightConstant * 0.2, height: collectionViewHeightConstant)
        }
        return CGSize(width: collectionViewHeightConstant / 1.8, height: collectionViewHeightConstant)
    }
    
    override func collectionViewSetup() {
        super.collectionViewSetup()
        let screenBounds = UIScreen.main.bounds
        collectionView.contentInset = UIEdgeInsets(top: 0, left: screenBounds.width / 2 -  (collectionViewHeightConstant / 1.8 / 2), bottom: 0, right: screenBounds.width / 2 -  (collectionViewHeightConstant / 1.8 / 2) - collectionViewHeightConstant * 0.2 )
    }
}
