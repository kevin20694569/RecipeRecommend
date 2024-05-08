
import UIKit

class StepCollectionViewTableCell : CollectionViewTableCell {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    override func registerCell() {
        super.registerCell()
        collectionView.register(StepIndicatorCollectionCell.self, forCellWithReuseIdentifier: "StepIndicatorCollectionCell")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StepIndicatorCollectionCell", for: indexPath)
        return cell
    }
    
}
