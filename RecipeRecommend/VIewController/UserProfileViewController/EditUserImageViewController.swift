import UIKit
import PhotosUI

class EditUserImageViewController : UIViewController, EditUserProfileCellDelegate {

    
    var tableView : UITableView = UITableView()
    
    var user : User!
    
    var newImage : UIImage? { didSet {
        navigationItem.rightBarButtonItem?.isEnabled = newImage != initImage && newImage != nil
    }}
    
    var initImage : UIImage?
    
    init(user : User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
        Task(priority : .background) {
            initImage = await user.getImage()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        tableViewSetup()
        navItemSetup()
        initLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TapGestureHelper.shared.shouldAddTapGestureInWindow(view:  self.view)

    }
    
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .primaryBackground
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 0
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
    }
        
    func initLayout() {
        [tableView].forEach() {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        tableViewLayout()
    }
    
    func tableViewLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func navItemSetup() {
        navigationItem.title = "更改使用者照片"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "儲存", style: .plain, target: self, action: #selector(rightButtonItemTapped ( _ : )))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func rightButtonItemTapped(_ buttonItem : UIBarButtonItem) {
        guard let image = newImage, image != initImage else {
            return
        }
       
        Task {
            try await UserManager.shared.changeUserImage(user_id: user.id, newImage: image)

            if let nav = self.navigationController as? UserProfileNavViewController {
                await nav.reloadUser()
            }
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func registerCell() {
        tableView.register(ChangeUserImageViewTableCell.self, forCellReuseIdentifier: "ChangeUserImageViewTableCell")
    }
}
extension EditUserImageViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeUserImageViewTableCell", for: indexPath) as! ChangeUserImageViewTableCell
        cell.editUserProfileCellDelegate = self
        cell.configure(user: user)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 8
        }
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView()
            return view
        }
        return nil
    }
    
    
}

extension EditUserImageViewController : PHPickerViewControllerDelegate {
    
    func showImagePicker() {
        
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode = .automatic
        let phppicker = PHPickerViewController(configuration: configuration)
        phppicker.delegate = self
        
        present(phppicker, animated: true)
        
    }
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        
        picker.dismiss(animated: true, completion: nil)
        if results.isEmpty {
            return
        }
        
        let result = results[0]
        var imageCell : ChangeUserImageViewTableCell?
        for cell in tableView.visibleCells {
            if let cell = cell as? ChangeUserImageViewTableCell {
                imageCell = cell
                imageCell?.mainImageView.image = nil
            }
        }
        
        
        Task {
            do {
                let image = try await withCheckedThrowingContinuation { (continuation : CheckedContinuation<UIImage, Error>) in
                    
                    result.itemProvider.loadObject(ofClass: UIImage.self)   { (data, error) in
                        if let error = error {
                            continuation.resume(throwing: error)
                        }
                        
                        if let image = data as? UIImage {
                            continuation.resume(returning: image)

                        } else {
                            let error = NSError(domain: "ImageErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load image"])
                            continuation.resume(throwing: error)
                        }
                    }
                    
                }
                self.newImage = image
                imageCell?.configure(image: image)
            
            } catch {
                print(error)
            }
            

            
        }
    }

    
}
