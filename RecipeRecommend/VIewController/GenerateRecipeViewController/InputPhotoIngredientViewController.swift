import UIKit
import PhotosUI

enum CatchButtonStatus {
    case `catch`, reset, forbidden
}

class InputPhotoIngredientViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, InputPhotoIngredientTableCellDelegate {
    
    
    
    var nextTapButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var selectPhotoButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var catchButton : ZoomAnimatedButton = ZoomAnimatedButton()
    var catchButtonSubView : UIView = UIView()
    var flashLightButton : ZoomAnimatedButton = ZoomAnimatedButton()
    
    var catchButtonStatus : CatchButtonStatus = .catch
    
    var catchButtonIsAnimating : Bool = false
    var cameraInputTableCell : InputPhotoIngredientTableCell {
        
        return tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! InputPhotoIngredientTableCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let bounds = UIScreen.main.bounds
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IndicatorTableCell", for: indexPath) as! IndicatorTableCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: bounds.width / 2, bottom: 0, right: bounds.width / 2)
            cell.configure(highlightIndex: 0)
            return cell
        }
        if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputPhotoIngredientTableCell", for: indexPath) as! InputPhotoIngredientTableCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: bounds.width / 2, bottom: 0, right: bounds.width / 2)
            cell.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionViewTableCell", for: indexPath)
        return cell
    }
   
    var tableView : UITableView! = UITableView()
    
    func registerCell() {
        
        tableView.register(IndicatorTableCell.self, forCellReuseIdentifier: "IndicatorTableCell")
        tableView.register(InputPhotoIngredientTableCell.self, forCellReuseIdentifier: "InputPhotoIngredientTableCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetup()
        initLayout()
        
        registerCell()
        navItemSetup()
        
        tableViewSetup()
        view.backgroundColor = .primaryBackground
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        navBarSetup()
    }
    
    
    
    func navItemSetup() {
        
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backButtonTitle = ""
        let barButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = barButtonItem
        var rightBarButtonItem = UIBarButtonItem(title: "下一步", style: .plain, target: self, action: #selector(nextTapButtonTapped (_ : )))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    func navBarSetup() {
        self.navigationController?.navigationBar.standardAppearance.configureWithTransparentBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance?.configureWithTransparentBackground()
        
    }
    
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.delaysContentTouches = false
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.backgroundColor = .primaryBackground


    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let bounds = UIScreen.main.bounds
        let section = indexPath.section
        
        if section == 0 {
            return bounds.height * 0.08 
        }
        if section == 1 {
            return UITableView.automaticDimension
        }
        return bounds.height * 0.4
    }
    
    
    
    func initLayout() {
        self.view.addSubview(tableView)
        self.view.addSubview(nextTapButton)
        self.view.addSubview(selectPhotoButton)
        view.addSubview(flashLightButton)
        view.addSubview(catchButton)
        view.insertSubview(catchButtonSubView , belowSubview: catchButton.imageView!)
        view.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -MainTabBarViewController.tabBarFrame.height),
            
        ])
        buttonLayout()
        self.view.backgroundColor = .primaryBackground
    }
    
    func buttonLayout() {
        
        NSLayoutConstraint.activate([
            nextTapButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            nextTapButton.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant:  -24),
            
            nextTapButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            nextTapButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
        ])
        
        NSLayoutConstraint.activate([
  
            selectPhotoButton.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -view.bounds.width * 0.05),
            
            selectPhotoButton.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -view.bounds.width * 0.02),
            
          //  selectPhotoButton.widthAnchor.constraint(equalTo: nextTapButton.widthAnchor),
          //  selectPhotoButton.heightAnchor.constraint(equalTo: nextTapButton.heightAnchor),
            
            catchButton.centerYAnchor.constraint(equalTo: selectPhotoButton.centerYAnchor),
            catchButton.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            catchButton.heightAnchor.constraint(equalTo: selectPhotoButton.heightAnchor),
            catchButton.widthAnchor.constraint(equalTo: catchButton.heightAnchor),
            
            catchButtonSubView.centerYAnchor.constraint(equalTo: catchButton.centerYAnchor),
            catchButtonSubView.centerXAnchor.constraint(equalTo: catchButton.centerXAnchor),
            catchButtonSubView.heightAnchor.constraint(equalTo: catchButton.heightAnchor, multiplier: 0.8),
            catchButtonSubView.widthAnchor.constraint(equalTo: catchButtonSubView.heightAnchor),
            
            
            
        ])
        view.layoutIfNeeded()
        
        catchButton.layer.cornerRadius = catchButton.bounds.height / 2
        catchButtonSubView.layer.cornerRadius = catchButtonSubView.bounds.height / 2
        
        
        NSLayoutConstraint.activate([
            
            flashLightButton.centerYAnchor.constraint(equalTo: catchButton.centerYAnchor),
            flashLightButton.centerXAnchor.constraint(equalTo: tableView.leadingAnchor, constant: tableView.frame.maxX - selectPhotoButton.center.x),
        ])
        
        
        
    }
    
    func buttonSetup() {
        var nextTapConfig = UIButton.Configuration.filled()
        let attributedString = AttributedString("下一步", attributes: AttributeContainer([.font : UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)]) )
        let inset : CGFloat = 10
        nextTapConfig.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset * 2, bottom: inset, trailing: inset * 2)
        nextTapConfig.attributedTitle = attributedString
        nextTapConfig.baseBackgroundColor = .orangeTheme
        nextTapButton.configuration = nextTapConfig
        nextTapButton.clipsToBounds = true
        nextTapButton.layer.cornerRadius = 16
        
        nextTapButton.addTarget(self, action: #selector(nextTapButtonTapped ( _ :)), for: .touchUpInside)
        nextTapButton.isHidden = true
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .color950
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        config.image = UIImage()
 
       
        catchButton.configuration = config
        catchButton.clipsToBounds = true
        catchButton.scaleTargets?.append(catchButtonSubView)
        catchButton.addTarget(self, action: #selector( catchButtonTapped( _ :)), for: .touchUpInside)
        
        catchButtonSubView.clipsToBounds = true
        catchButtonSubView.backgroundColor = .primaryBackground
        catchButtonSubView.isUserInteractionEnabled = false
        
        var flashConfig = UIButton.Configuration.filled()
        flashConfig.baseBackgroundColor = .clear
        flashConfig.image = UIImage(systemName: "lightbulb.slash")?.withTintColor( .label, renderingMode: .alwaysOriginal)
        flashConfig.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration.init(font: UIFont.weightSystemSizeFont(systemFontStyle: .largeTitle, weight: .medium))
        flashLightButton.configuration = flashConfig
        flashLightButton.addTarget(self, action: #selector( flashLightButtonTapped( _ :)), for: .touchUpInside)
        

        
        

        

        /*let selectPhotoAttributedString = AttributedString("從圖庫選擇", attributes: AttributeContainer([.font : UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)]) )
        selectPhotoConfig.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset * 2, bottom: inset, trailing: inset * 2)
        selectPhotoConfig.attributedTitle = selectPhotoAttributedString*/
        var selectPhotoConfig = UIButton.Configuration.filled()
        selectPhotoConfig.baseBackgroundColor = .clear
        selectPhotoConfig.image = UIImage(systemName: "photo.on.rectangle.angled.fill")?.withTintColor(.color950, renderingMode: .alwaysOriginal)
        selectPhotoConfig.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font :      UIFont.weightSystemSizeFont(systemFontStyle: .largeTitle, weight: .medium))
        selectPhotoButton.configuration = selectPhotoConfig
   
        selectPhotoButton.clipsToBounds = true
        selectPhotoButton.layer.cornerRadius = 16
        
        selectPhotoButton.addTarget(self, action: #selector(selectPhotoButtonTapped ( _ :)), for: .touchUpInside)
        

    }
    
    @objc func nextTapButtonTapped( _ button : UIView) {
        showCorrectIngredientViewController()
    }
    
    @objc func catchButtonTapped( _ button : UIButton) {
        guard lastCollectionViewIsPresentToScreen() else {
            return
        }
        guard let imageCollectionViewTableCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? InputPhotoIngredientTableCell else {
            return
        }
        guard let lastImageCollectionCell = imageCollectionViewTableCell.collectionView.cellForItem(at: IndexPath(row: imageCollectionViewTableCell.images.count - 1, section: 0)) as? InputPhotoIngredientCollectionCell  else {
            return
        }
        
        let status = lastImageCollectionCell.triggerCatchButton(button)
        changeCatchButtonStatus(to: status)
       

        
    }
    
    func lastCollectionViewIsPresentToScreen() -> Bool {
        guard let imageCollectionViewTableCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? InputPhotoIngredientTableCell else {
            return false
        }
        guard let lastImageCollectionCell = imageCollectionViewTableCell.collectionView.cellForItem(at: IndexPath(row: imageCollectionViewTableCell.images.count - 1, section: 0)) as? InputPhotoIngredientCollectionCell  else {
            return false
        }
        
        guard let lastCollectionImageViewFrameInView =  lastImageCollectionCell.imageView.superview?.convert(lastImageCollectionCell.imageView.frame, to: self.view) else {
            return false
        }
        //最後一個imageCollectionCell要露出自己的0.5才可以觸發
        let viewWidth = view.bounds.width
        if viewWidth - lastCollectionImageViewFrameInView.minX  >= lastImageCollectionCell.bounds.width * 0.5  {
            
            return true
        }
        
        return false
        
    }
    

    
    func changeCatchButtonStatus(to status : CatchButtonStatus) {
        guard !catchButtonIsAnimating else {
            return
        }
        catchButtonIsAnimating = true
        
        switch status {
        case .catch:
            catchButton.isEnabled = true
            catchButton.configuration?.baseBackgroundColor = .color950
            UIView.animate(withDuration: 0.15, animations: { [self] in
                [catchButtonSubView, catchButton].forEach() {
                    $0.transform = .identity
                }
            },completion: { bool in
                self.catchButtonIsAnimating = false
            })
        case .reset:
            catchButton.isEnabled = true
            self.catchButtonIsAnimating = false
            break
        case .forbidden:
            catchButton.isEnabled = false
            catchButton.configuration?.baseBackgroundColor = .secondaryBackground
            UIView.animate(withDuration: 0.15, animations: { [self] in
                [catchButtonSubView, catchButton].forEach() {
                    $0.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }
            }, completion: { _ in
                self.catchButtonIsAnimating = false
            })
        }
        catchButtonStatus = status
    }
    
    
    
    @objc func flashLightButtonTapped( _ button : UIButton) {
        guard let imageCollectionViewTableCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? InputPhotoIngredientTableCell else {
            return
        }
        
        guard let lastImageCollectionCell = imageCollectionViewTableCell.collectionView.cellForItem(at: IndexPath(row: imageCollectionViewTableCell.images.count - 1, section: 0)) as? InputPhotoIngredientCollectionCell  else {
            return
        }
        changeFlashImage(flashIsOn: imageCollectionViewTableCell.toggleFlash())
    }
    
    @objc func selectPhotoButtonTapped( _ button : UIButton) {
        showImagePicker()
    }
    
    
    
    func changeFlashImage(flashIsOn : Bool) {
        if flashIsOn {
            flashLightButton.configuration?.image = UIImage(systemName: "lightbulb.max.fill")?.withTintColor(.primaryLabel, renderingMode: .alwaysOriginal)
        } else {
            flashLightButton.configuration?.image =  UIImage(systemName: "lightbulb.slash")?.withTintColor(.primaryLabel, renderingMode: .alwaysOriginal)
        }
    }
    
    
    
    func showCorrectIngredientViewController() {
       
        var photoInputedIngredients : [PhotoInputedIngredient]? = cameraInputTableCell.images.enumerated().compactMap { (index, image) in
            if let image = image {
                return PhotoInputedIngredient(image: image, leftTitle: nil, rightTitle: nil)
            }
            return nil
        }
        //photoInputedIngredients = PhotoInputedIngredient.examples
        
        let controller = CorrectIngredientViewController(photoInputedIngredients: photoInputedIngredients)
       // let controller = CorrectIngredientViewController(photoInputedIngredients: PhotoInputedIngredient.examples)
        show(controller, sender: nil)
        
        
    }
}


extension InputPhotoIngredientViewController : PHPickerViewControllerDelegate {
    
    func showImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.playbackStyle(  .image)
        configuration.selectionLimit = 20
      //  configuration.selection = .continuousAndOrdered
       // configuration.preferredAssetRepresentationMode = .automatic
        let phppicker = PHPickerViewController(configuration: configuration)
        phppicker.delegate = self
        present(phppicker, animated: true)
    }
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        if results.isEmpty {
            return
        }
        Task {
            let images = await withTaskGroup(of: (index : Int, image : UIImage?).self, returning: [UIImage].self) { group in
                
                for (i, result) in results.enumerated() {
                    group.addTask() {
                        do {
                            return try await withCheckedThrowingContinuation { (continuation : CheckedContinuation<(Int, UIImage), any Error>)  in
                                result.itemProvider.loadObject(ofClass: UIImage.self)   { (data, error) in
                                    if let error = error {
                                        
                                        continuation.resume(throwing: error)
                                        print("image失敗 \(error.localizedDescription)" )
                                        return
                                    }
                                    
                                    if let image = data as? UIImage {
                                        continuation.resume(returning: (i, image))
                                    }
                                }
                            }
                        } catch  {
                            print(error)
                        }
                        return (i, nil)
                    }
                    
                }
                var images : [UIImage] = Array.init(repeating: UIImage(), count: results.count)
                for await result in group {
                    guard let image = result.image else {
                        continue
                    }
                    images[result.index] = image
                }
                images = images.compactMap() { $0}
                return images
            }
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? InputPhotoIngredientTableCell {
                var index = cell.images.count
                var lastImageEqualNil : Bool = false
                if let lastImage = cell.images.last,
                   lastImage == nil {
                    lastImageEqualNil = true
                    index -= 1
                }
                cell.images.insert(contentsOf: images, at: index)
                cell.collectionView.reloadSections([0])
                let bool = self.lastCollectionViewIsPresentToScreen()
                
                self.changeCatchButtonStatus(to: bool ? .catch :.forbidden)



                cell.collectionView.reloadSections([0])
                if !lastImageEqualNil {
                    cell.addButtonEnable(enable: true)
                }
               
                cell.refreshCollectionCellPreviewLayer()
            }
        }
    }
}
