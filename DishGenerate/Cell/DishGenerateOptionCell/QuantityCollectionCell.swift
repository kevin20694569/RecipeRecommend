import UIKit


class QuantityCollectionCell : UICollectionViewCell, UITextFieldDelegate {
    
    var titleLabel : UILabel! = UILabel()
    var textField : CustomTextField! = {
        let inset : CGFloat = 6
        let insets = UIEdgeInsets(top: inset, left: inset * 2, bottom: inset, right: inset * 2)
        return CustomTextField(insets: insets)
    }()
    
    var suffixLabel : UILabel! = UILabel()
    
    var stepper : UIStepper = UIStepper()
    
    weak var deleagate :  GenerateOptionCellDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stepperSetup()
        titleLabelSetup()
        textFieldSetup()
        suffixLabelSetup()
        initLayout()
 
    }
    
    func configure(quantity : Int) {
        self.titleLabel.text = String(quantity)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        let screenBounds = UIScreen.main.bounds
        [titleLabel, textField, suffixLabel, stepper ].forEach() { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
        }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            
            textField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            textField.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            textField.widthAnchor.constraint(greaterThanOrEqualToConstant: screenBounds.width * 0.12),
            suffixLabel.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 8),
            suffixLabel.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            
            stepper.leadingAnchor.constraint(equalTo: suffixLabel.trailingAnchor, constant: 8),
            stepper.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
        ])
    }
    
    func textFieldSetup() {
        textField.text = String(Int(stepper.value))
        textField.textAlignment = .center
        textField.textColor = .label
        textField.backgroundColor = .secondaryBackgroundColor
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 6
        textField.font = UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .medium)
        textField.delegate = self
        textField.isEnabled = false
    }
    
    func titleLabelSetup() {
        titleLabel.text = "份量"
        titleLabel.font = UIFont.weightSystemSizeFont(systemFontStyle: .title2, weight: .medium)
    }
    
    func suffixLabelSetup() {
        suffixLabel.text = "人"
        suffixLabel.font = textField.font
    }
    @objc func stepperValueChanged( _ stepper : UIStepper) {
        textField.text = String(Int(stepper.value))
        deleagate?.quantity = Int(stepper.value)
    }
    
    func stepperSetup() {
        stepper.value = 1
        stepper.minimumValue = 1
        stepper.maximumValue = 10
        stepper.addTarget(self, action: #selector(stepperValueChanged ( _ :)), for: .touchUpInside)
    }
    
}
