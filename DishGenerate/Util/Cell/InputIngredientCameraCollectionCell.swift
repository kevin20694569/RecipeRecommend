
import UIKit
import AVFoundation

class InputIngredientCameraCollectionCell : UICollectionViewCell {
    
    let mainViewHorConstant : CGFloat! = 8
    
    var mainView : UIView! = UIView()
    
    var cameraToggleStackView : UIStackView! = UIStackView()
    
    var cameraToggleSwitch : UISwitch! = UISwitch()
    
    var cameraToggleLabel : UILabel! = UILabel()
    
    var clickButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    let cameraController : CameraController! = CameraController()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCameraController()
        stackViewSetup()
        mainViewSetup()
        labelSetup()
        buttonSetup()
        toggleSwitchSetup()
        initLayout()
        

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InputIngredientCameraCollectionCell {
    
    func toggleSwitchSetup() {
        self.cameraToggleSwitch.preferredStyle = .sliding
        cameraToggleSwitch.addTarget(self, action: #selector(switchTapped ( _ : )), for: .valueChanged)
        self.cameraToggleSwitch.isEnabled = false
    
    }
    
    @objc func switchTapped( _ switchView : UISwitch) {
        if switchView.isOn {
            try? self.cameraController.displayPreview(on: self.mainView)
        } else {
            self.cameraController.previewLayerRemoveFromSuperLayer()
        }
        
    }
    
    func initLayout() {
        
        contentView.addSubview(cameraToggleStackView)
        contentView.addSubview(mainView)
        
        contentView.addSubview(clickButton)
        contentView.subviews.forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            cameraToggleStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cameraToggleStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cameraToggleStackView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor, multiplier: 0.1),
            
            mainView.topAnchor.constraint(equalTo: cameraToggleStackView.bottomAnchor, constant: 12),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: mainViewHorConstant),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -mainViewHorConstant),
            mainView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            clickButton.topAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 12),
            
            clickButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor , constant: -12),

            clickButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.12),
 
            clickButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            clickButton.widthAnchor.constraint(equalTo: clickButton.heightAnchor),
            
        ])
        clickButton.layoutIfNeeded()
        clickButton.layer.cornerRadius = clickButton.bounds.height / 2
        
    }
    
    func stackViewSetup() {
        cameraToggleStackView.axis = .horizontal
        cameraToggleStackView.alignment = .center
        cameraToggleStackView.spacing = 2
        [cameraToggleLabel, cameraToggleSwitch].forEach() {
            cameraToggleStackView.addArrangedSubview($0)
        }
        
    }
    

    
    
    
    func buttonSetup() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .lightGray
        clickButton.configuration = config
        clickButton.clipsToBounds = true
       // clickButton.layer.borderColor = UIColor.label.cgColor
       // clickButton.layer.borderWidth = 1
    }
    
    func labelSetup() {
        cameraToggleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .footnote, weight: .medium)
        cameraToggleLabel.text = "拍照輸入"
    }
    
    
    func mainViewSetup() {
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 16
        mainView.backgroundColor = .secondaryBackgroundColor
    }
    
    func configureCameraController() {
        cameraController.prepare { err in
            if let err = err {
                print(err)
                return
            }
            self.cameraToggleSwitch.isEnabled = true
        }
    }
    
}
