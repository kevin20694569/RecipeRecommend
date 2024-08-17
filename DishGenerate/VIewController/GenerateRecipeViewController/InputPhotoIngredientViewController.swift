import UIKit
import PhotosUI

class InputPhotoIngredientViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var nextTapButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var selectPhotoButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputPhotoIngredientTableCell", for: indexPath)
            cell.separatorInset = UIEdgeInsets(top: 0, left: bounds.width / 2, bottom: 0, right: bounds.width / 2)
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
        buttonLayout()
        registerCell()
        navItemSetup()
        
        tableViewSetup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarSetup()
    }
    
    
    
    func navItemSetup() {
        
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backButtonTitle = ""
        let barButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = barButtonItem
    }
    
    func navBarSetup() {
        self.navigationController?.navigationBar.standardAppearance.configureWithOpaqueBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance?.configureWithOpaqueBackground()
        
    }
    
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.delaysContentTouches = false
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)

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
        view.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
        self.view.backgroundColor = .systemBackground
    }
    
    func buttonLayout() {
        NSLayoutConstraint.activate([
            nextTapButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            nextTapButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24 + -MainTabBarViewController.bottomBarFrame.height),
            
            nextTapButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            nextTapButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
        ])
        
        NSLayoutConstraint.activate([
            selectPhotoButton.centerXAnchor.constraint(equalTo: nextTapButton.centerXAnchor),
            selectPhotoButton.bottomAnchor.constraint(equalTo: nextTapButton.topAnchor, constant: -24),
            
            selectPhotoButton.widthAnchor.constraint(equalTo: nextTapButton.widthAnchor),
            selectPhotoButton.heightAnchor.constraint(equalTo: nextTapButton.heightAnchor),
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
        
        var selectPhotoConfig = UIButton.Configuration.filled()
        let selectPhotoAttributedString = AttributedString("從圖庫選擇", attributes: AttributeContainer([.font : UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)]) )
        selectPhotoConfig.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset * 2, bottom: inset, trailing: inset * 2)
        selectPhotoConfig.attributedTitle = selectPhotoAttributedString
        selectPhotoConfig.baseBackgroundColor = .accent
        selectPhotoButton.configuration = selectPhotoConfig
        selectPhotoButton.clipsToBounds = true
        selectPhotoButton.layer.cornerRadius = 16
        
        selectPhotoButton.addTarget(self, action: #selector(selectPhotoButtonTapped ( _ :)), for: .touchUpInside)
        

    }
    
    @objc func nextTapButtonTapped( _ button : UIButton) {
        showCorrectIngredientViewController()
    }
    
    @objc func selectPhotoButtonTapped( _ button : UIButton) {
        showImagePicker()
    }
    
    
    
    func showCorrectIngredientViewController() {
       
        let photoInputedIngredients = cameraInputTableCell.images.enumerated().compactMap { (index, image) in
            if let image = image {
                return PhotoInputedIngredient(image: image, leftTitle: nil, rightTitle: nil)
            }
            return nil
        }
        
        
        
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
                if !lastImageEqualNil {
                    cell.addButtonEnable(enable: true)
                }
               
                cell.refreshCollectionCellPreviewLayer()
            }
        }
    }
}
