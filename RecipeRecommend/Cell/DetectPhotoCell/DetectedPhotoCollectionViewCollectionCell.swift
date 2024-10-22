import UIKit

class DetectedPhotoCollectionViewCollectionCell : CollectionViewCollectionCell, UICollectionViewDelegateFlowLayout {
    
    var photoInputedIngredients : [PhotoInputedIngredient] = []
    
    func configure(photoInputedIngredients : [PhotoInputedIngredient]) {
        self.photoInputedIngredients = photoInputedIngredients

    }
    
    weak var delegate : DetectedPhotoCollectionCellDelegate?
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoInputedIngredients.count
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    

    
    override func registerCell() {
        super.registerCell()
        
        collectionView.register(DetectedPhotoCollectionCell.self, forCellWithReuseIdentifier: "DetectedPhotoCollectionCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let inputedIngredient = photoInputedIngredients[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetectedPhotoCollectionCell", for: indexPath) as! DetectedPhotoCollectionCell
        cell.configure(inputedIngredient: inputedIngredient, outputedIngredient: inputedIngredient.outputedIngredient)
        cell.delegate = self.delegate
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 1.7, height: collectionView.bounds.height)
    }
    
    
    
    override func collectionViewSetup() {
        super.collectionViewSetup()

    }
    
}
