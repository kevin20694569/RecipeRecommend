import UIKit

class SliderCollectionCell : UICollectionViewCell {
    
    var slider : UISlider! = UISlider()
    
    var allLabelStackView : UIStackView! = UIStackView()
    
    var stackLabelViews : [UIStackView]! = []
    
    var labels : [UILabel]! = []
    
    
    func initLayout() {
        [slider, allLabelStackView].forEach() { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
        }
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            slider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            slider.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            
            allLabelStackView.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 6),
            allLabelStackView.leadingAnchor.constraint(equalTo: slider.leadingAnchor),
            allLabelStackView.trailingAnchor.constraint(equalTo: slider.trailingAnchor),
        ])
    }
    
    func sliderSetup() {
        slider.addTarget(self, action: #selector(sliderDidEndDraging(_:)), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderDidEndDraging(_:)), for: .touchUpOutside)
    }
    var currentValue : Float! = 0

    
    @objc func sliderDidEndDraging( _ sender : UISlider) {
        guard let newValue = getSliderTargetValue(value: sender.value) else {
            return
        }
        UIView.animate(withDuration: 0.1) {
            sender.setValue(newValue, animated: true)
        }

    }
    
    func getSliderTargetValue(value : Float) -> Float? {
        let count : Float = Float(labels.count)
        let step : Float = 1 / (count - 1)
        return round(value / step) * step

    }

    func allStackViewLabelSetup() {
        allLabelStackView.axis = .horizontal
        allLabelStackView.alignment = .center
        allLabelStackView.distribution  = .equalCentering
    }
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sliderSetup()
        allStackViewLabelSetup()

        initLayout()
        stackLabelLayout()
    }
    
    
    
    
    func stackLabelLayout() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class DifficultSliderCollectionCell : SliderCollectionCell  {
    
    func configure(titleArray : [String]) {
        
        for (index, string) in titleArray.enumerated() {
            labels[index].text = string
        }
    }
    
    override func stackLabelLayout() {
        let total = 4
        for _ in 0...total {
            let label = UILabel(frame: .zero)
            label.font = UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .medium)
            var starImage = UIImage(systemName: "star.fill")?.withConfiguration(UIImage.SymbolConfiguration(font: UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .medium)))
            starImage = starImage?.withTintColor(.yelloTheme, renderingMode: .alwaysOriginal    )
            let starImageView = UIImageView(image: starImage)
            let stackView = UIStackView(arrangedSubviews: [starImageView, label])
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.spacing = 4
            labels.append(label)
            allLabelStackView.addArrangedSubview(stackView)
            
        }
    }
}
 
class TemperatureSliderCollectionCell : SliderCollectionCell {
    func configure(titleArray : [String]) {
        for (index, string) in titleArray.enumerated() {
            labels[index].text = string
        }
    }
    
    override func stackLabelLayout() {
        let total = 2
        for _ in 0...total {
            let label = UILabel(frame: .zero)
            label.font = UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .medium)
            let stackView = UIStackView(arrangedSubviews: [label])
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.spacing = 4

            labels.append(label)
            allLabelStackView.addArrangedSubview(stackView)
            
        }
    }
}

class TimeSliderCollectionCell : SliderCollectionCell {
    func configure(titleArray : [String]) {
        for (index, string) in titleArray.enumerated() {
            labels[index].text = string
        }
    }
    
    override func stackLabelLayout() {
        let total = 2
        for _ in 0...total {
            let label = UILabel(frame: .zero)
            label.font = UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .medium)
            let stackView = UIStackView(arrangedSubviews: [label])
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.spacing = 4
            labels.append(label)
            allLabelStackView.addArrangedSubview(stackView)
            
        }
    }
    
    override func getSliderTargetValue(value: Float) -> Float? {
        return nil
    }
}

