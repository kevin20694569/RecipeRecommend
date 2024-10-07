
import UIKit
import AVFoundation

class InputPhotoIngredientCollectionCell : UICollectionViewCell {
    
    let mainViewHorConstant : CGFloat! = 8
    
    var imageView : UIImageView! = UIImageView()
    
    var cameraToggleStackView : UIStackView! = UIStackView()
    
    var previewCameraLayer : AVCaptureVideoPreviewLayer?
    
    var cameraToggleSwitch : UISwitch! = UISwitch()
    
    var cameraToggleLabel : UILabel! = UILabel()
    
    var clickButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var currentImage : UIImage?
    
    var toggleFlashButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var deleteSelfButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    var cameraToolButtons : [UIButton] {
        return [clickButton,toggleFlashButton]
    }
    
    
    weak var ingredientAddCollectionCellDelegate : InputPhotoCollectionCellDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackViewSetup()
        imageViewSetup()
        labelSetup()
        buttonSetup()
        initLayout()
    }
    
    func configurePreviewLayer( previewLayer : AVCaptureVideoPreviewLayer?) {
        self.previewCameraLayer = previewLayer
        if let previewLayer = previewLayer {
            previewLayer.frame = imageView.bounds
            imageView.layer.insertSublayer(previewLayer, at: 0)
        }
        
    }
    
    func configure(image : UIImage?, flashIsON : Bool) {
        currentImage = image
        self.imageView.image = image
        
        changeFlashImage(flashIsOn: flashIsON)
        changeClickButtonImage(beCaptureTarget: image == nil)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InputPhotoIngredientCollectionCell {
    func initLayout() {
        
        contentView.addSubview(cameraToggleStackView)
        contentView.addSubview(imageView)
        contentView.addSubview(clickButton)
        contentView.addSubview(toggleFlashButton)
        contentView.addSubview(deleteSelfButton)
        contentView.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: mainViewHorConstant),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -mainViewHorConstant),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            deleteSelfButton.centerXAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -6),
            deleteSelfButton.centerYAnchor.constraint(equalTo: imageView.topAnchor, constant: 6),
            deleteSelfButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.15),
            deleteSelfButton.heightAnchor.constraint(equalTo: deleteSelfButton.widthAnchor),

            
            clickButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            
            clickButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor , constant: -12),

            clickButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.12),
 
            clickButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            clickButton.widthAnchor.constraint(equalTo: clickButton.heightAnchor),
            
            
            toggleFlashButton.centerYAnchor.constraint(equalTo: clickButton.centerYAnchor),
            toggleFlashButton.leadingAnchor.constraint(equalTo: clickButton.trailingAnchor, constant: 25),
          //  lightToggleButton..constraint(equalTo: clickButton.trailingAnchor, constant: 25),
            
            toggleFlashButton.heightAnchor.constraint(equalTo: clickButton.heightAnchor, multiplier: 0.8),
            toggleFlashButton.widthAnchor.constraint(equalTo: clickButton.heightAnchor, multiplier: 1),
            
        ])
        clickButton.layoutIfNeeded()
        deleteSelfButton.layoutIfNeeded()
        clickButton.layer.cornerRadius = clickButton.bounds.height / 2
        deleteSelfButton.layer.cornerRadius = deleteSelfButton.bounds.height / 2
        
    }
    
    func stackViewSetup() {
        cameraToggleStackView.axis = .horizontal
        cameraToggleStackView.alignment = .center
        cameraToggleStackView.spacing = 2
      /*  [cameraToggleLabel, cameraToggleSwitch].forEach() {
            cameraToggleStackView.addArrangedSubview($0)
        }*/
        
    }
    

    
    
    
    func buttonSetup() {
        var clickConfig = UIButton.Configuration.filled()
        clickConfig.baseBackgroundColor = .lightGray
        clickConfig.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        clickButton.configuration = clickConfig
 
        clickButton.clipsToBounds = true
        clickButton.addTarget(self, action: #selector(clickButtonTapped ( _ : )), for: .touchUpInside)
        
        var lightConfig = UIButton.Configuration.filled()
        lightConfig.baseBackgroundColor = .clear
        lightConfig.background.image = UIImage(systemName: "lightbulb.slash")?.withTintColor( .label, renderingMode: .alwaysOriginal)
        lightConfig.background.imageContentMode = .scaleAspectFit
        toggleFlashButton.configuration = lightConfig
        toggleFlashButton.addTarget(self, action: #selector(toggleFlashButtonTapped ( _  : )), for: .touchUpInside)
        
        var deleteConfig = UIButton.Configuration.filled()
        deleteConfig.baseBackgroundColor = .systemRed
        deleteConfig.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        deleteConfig.image = UIImage(systemName: "xmark")?.withTintColor( .white, renderingMode: .alwaysOriginal)
        deleteConfig.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: UIFont.weightSystemSizeFont(systemFontStyle: .callout, weight: .bold))
        deleteSelfButton.configuration = deleteConfig
        deleteSelfButton.addTarget(self, action: #selector(deleteButtonTapped ( _  : )), for: .touchUpInside)
        deleteSelfButton.clipsToBounds = true

        
    }
    
    @objc func clickButtonTapped( _ button : UIButton)  {
        guard let delegate = ingredientAddCollectionCellDelegate else {
            return
        }
        if currentImage != nil {
            //重置
            currentImage = nil
            self.imageView.image = nil
            delegate.modifyImageArray(image: nil)
            try? delegate.cameraControllerDisplayOn(view: self.imageView)
            delegate.addButtonEnable(enable: false)
            self.changeClickButtonImage(beCaptureTarget: true)
        } else {
            Task {


                let image = try await delegate.captureImage()
                currentImage = image
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.imageView.layoutIfNeeded()
                    delegate.previewRemoveFromSuperView()
                }
                delegate.modifyImageArray(image: image)
                delegate.addButtonEnable(enable: true)
                self.changeClickButtonImage(beCaptureTarget: false)
            }
        }
        toolButtonRefresh(enable: true, animated: false)
    }
    


    
    
    @objc func deleteButtonTapped( _ button : UIButton) {
        guard let delegate = ingredientAddCollectionCellDelegate else {
            return
        }
        delegate.deleteCell(image: currentImage)
        
    }
    
   
    
    @objc func toggleFlashButtonTapped(_ button : UIButton) {
        
        guard let flashIsOn = ingredientAddCollectionCellDelegate?.toggleFlash() else {
            return
        }
        toolButtonRefresh(enable: nil, animated: false)
        changeFlashImage(flashIsOn : flashIsOn)
    }
    
    func changeFlashImage(flashIsOn : Bool) {
        if flashIsOn {
            toggleFlashButton.configuration?.background.image = UIImage(systemName: "lightbulb.max.fill")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        } else {
            toggleFlashButton.configuration?.background.image =  UIImage(systemName: "lightbulb.slash")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        }
    }
    
    func changeClickButtonImage(beCaptureTarget :  Bool ) {
        self.clickButton.configuration?.image = beCaptureTarget ? nil : UIImage(systemName: "arrow.circlepath")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        //self.clickButton.configuration?.baseBackgroundColor =  beCaptureTarget ? .systemRed : .lightGray
    }
    
    
    func labelSetup() {
        cameraToggleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .footnote, weight: .medium)
        cameraToggleLabel.text = "拍照輸入"
    }
    
    
    
    
    func imageViewSetup() {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .secondaryBackgroundColor
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 0.8
        imageView.layer.borderColor = UIColor.secondaryLabelColor.cgColor
    }
    
    func toolButtonRefresh(enable : Bool?, animated : Bool) {
        if let enable = enable {
            self.cameraToolButtons.forEach() {
                $0.isEnabled = enable
            }
        }
        let enable = self.clickButton.isEnabled
        if animated {
            if enable {
                UIView.animate(withDuration: 0.2, animations : {
                    self.cameraToolButtons.forEach() {
                        $0.layer.opacity = 1
                    }
                }) { bool in
                    
                    
                }
            } else {
                UIView.animate(withDuration: 0.2, animations : {
                    self.cameraToolButtons.forEach() {
                        $0.layer.opacity = 0
                    }
                }) { bool in

                }
            }
        } else {
            if enable {
                cameraToolButtons.forEach() {
                    $0.layer.opacity = 1
                }
            } else {
                cameraToolButtons.forEach() {
                    
                    $0.layer.opacity = 0
                }
            }
        }
        
         
    }
    

    
}
