

import UIKit

class CollectionViewCollectionCell : UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView : UICollectionView! = UICollectionView(frame: .zero, collectionViewLayout: .init())

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
        return cell
    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        registerCell()
        initLayout()
        collectionViewSetup()
    }
    
    func registerCell() {

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func collectionViewSetup() {
        collectionView.delegate  = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delaysContentTouches = false
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = flow
    }
    

    
    func initLayout() {
        contentView.addSubview(collectionView)
        contentView.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
