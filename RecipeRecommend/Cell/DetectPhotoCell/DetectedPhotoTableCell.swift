import UIKit

class DetectedPhotoTableCell : CollectionViewTableCell {
    
    var photoInputedIngredients : [PhotoInputedIngredient] = []
    
    override var collectionViewHeightConstant: CGFloat! {
        return UIScreen.main.bounds.height * 0.4
    }
    
    func configure(photoInputedIngredients : [PhotoInputedIngredient]) {
        self.photoInputedIngredients = photoInputedIngredients
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoInputedIngredients.count
    }
    
    override func registerCell() {
        super.registerCell()
        
        collectionView.register(DetectedPhotoCollectionCell.self, forCellWithReuseIdentifier: "DetectedPhotoCollectionCell")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let inputedIngredient = photoInputedIngredients[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetectedPhotoCollectionCell", for: indexPath) as! DetectedPhotoCollectionCell
        cell.configure(inputedIngredient: inputedIngredient, outputedIngredient: inputedIngredient.outputedIngredient)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section

        return CGSize(width: bounds.width / 1.7, height: collectionViewHeightConstant)
    }
    
    override func collectionViewSetup() {
        super.collectionViewSetup()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}




