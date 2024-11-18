
import UIKit

protocol AdvertiseViewDelegate : UIViewController {
    func dismissAdvertiseView()
    func showAdvertiseView()
        
    
}

class AdvertiseView : UIView {
    
    var collectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    var pageControll : UIPageControl = UIPageControl(frame: .zero)
    
    var advertises : [Advertise] = []
    
    var xmarkButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var titleLabel : UILabel = UILabel()
    
    var subTitleLabel : UILabel = UILabel()
    
    var logoImageView : UIImageView = UIImageView()
    
    weak var advertiseViewDelegate : AdvertiseViewDelegate?
    
    
    
    var blurView : UIVisualEffectView = UIVisualEffectView(frame: .zero, style: .userInterfaceStyle)
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
        
    }
    
    func blurViewSetup() {
        blurView.clipsToBounds = true
        
    }
    
    func blurViewLayout() {
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
        ])
    }
    
    func initSetup() {
        clipsToBounds = true
        layer.cornerRadius = 28
        backgroundColor = .clear
        labelSetup()
        collectionViewSetup()
        registerCells()
        buttonSetup()
        pageControllSetup()
        imageViewSetup()
        blurViewSetup()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        initLayout()
    }
    
    func configure(advertises : [Advertise] ) {
        
        self.advertises = advertises
        
        pageControll.numberOfPages = advertises.count

    }
    
    func registerCells() {
        collectionView.register(AdvetiseCollectionCell.self, forCellWithReuseIdentifier: "AdvetiseCollectionCell")
    }
    
    
    
    func initLayout() {
        [blurView, collectionView, pageControll, xmarkButton, titleLabel, subTitleLabel, logoImageView].forEach() {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            
        }
        blurViewLayout()
        collectionViewLayout()
        pageControllLayout()
        buttonLayout()
        labelLayout()
        imageViewLayout()
        
        
    }
    
    func imageViewSetup() {
        logoImageView.image = Advertise.wonderfulfood_logo
        logoImageView.backgroundColor = .clear
        logoImageView.contentMode = .scaleAspectFit
    }
    
    
    func imageViewLayout() {
        let logoImageViewTopAnchor = logoImageView.topAnchor.constraint(equalTo: xmarkButton.topAnchor )
        logoImageViewTopAnchor.priority = .defaultLow
        let screenBounds = UIScreen.main.bounds
        
        
        NSLayoutConstraint.activate([
            
            logoImageViewTopAnchor,
         //   logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: xmarkButton.centerYAnchor),

            logoImageView.heightAnchor.constraint(equalTo: self.xmarkButton.heightAnchor, multiplier: 1.2),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenBounds.width * 0.03),
            //logoImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor),
        ])
        
    }
    
    func collectionViewLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: xmarkButton.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    
    func buttonLayout() {
        let screenBounds = UIScreen.main.bounds
        NSLayoutConstraint.activate([

            xmarkButton.topAnchor.constraint(equalTo: topAnchor, constant: screenBounds.width * 0.02 ),

            xmarkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenBounds.width * 0.02),

            xmarkButton.heightAnchor.constraint(equalToConstant: screenBounds.height * 0.05)
        ])
        
    }
    
    func labelSetup() {
        titleLabel.text = "感謝台灣好農贊助！"
        titleLabel.adjustsFontForContentSizeCategory = true
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title1, weight: .medium)
        titleLabel.numberOfLines = 1
        
        subTitleLabel.text = "App食譜皆由台灣好農提供"
        subTitleLabel.adjustsFontForContentSizeCategory = true
        
        subTitleLabel.adjustsFontSizeToFitWidth = true
        subTitleLabel.textAlignment = .center
        subTitleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .medium)
        subTitleLabel.numberOfLines = 1

    }
    
    func labelLayout() {
        let screenBounds = UIScreen.main.bounds
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: xmarkButton.bottomAnchor, constant: 4),
            titleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: screenBounds.height * 0.03),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -8),
            
            subTitleLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subTitleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: screenBounds.height * 0.02),
        ])
    }
    
    
    func collectionViewSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        let flow = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = flow
        collectionView.isPagingEnabled = true
        flow.minimumLineSpacing = 0
        flow.scrollDirection = .horizontal
        collectionView.isScrollEnabled = true
    }
    
    func buttonSetup() {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "xmark")?.withConfiguration(UIImage.SymbolConfiguration.init(font: UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .bold)))
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .primaryLabel
        xmarkButton.configuration = config
        xmarkButton.addTarget(self, action: #selector(dismissSelfAdvertiseView( _ :)), for: .touchUpInside)
    }
    @objc func dismissSelfAdvertiseView(_ button : UIButton) {
        advertiseViewDelegate?.dismissAdvertiseView()
    }
    
    
    func pageControllLayout() {
        NSLayoutConstraint.activate([

            pageControll.centerXAnchor.constraint(equalTo: centerXAnchor),

            pageControll.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -20),
        ])
        
    }
    
    func pageControllSetup() {
        pageControll.currentPageIndicatorTintColor = .orangeTheme
        pageControll.pageIndicatorTintColor = .secondaryBackground
    }
}

extension AdvertiseView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return advertises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvetiseCollectionCell", for: indexPath) as! AdvetiseCollectionCell
        let advertise = advertises[indexPath.row]
        cell.configure(advertise: advertise)

        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height )
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let currentXOffSet = scrollView.contentOffset.x
        let contentXSize = scrollView.contentSize.width
        let singlePageXSize = Double(contentXSize) / Double(self.advertises.count)
        let currentPage = round(currentXOffSet / singlePageXSize)
        self.pageControll.currentPage = Int(currentPage)
    }
    

}





