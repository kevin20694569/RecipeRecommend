

import UIKit

class GeneratedSummaryRecipeTableCell : SummaryRecipeTableCell {
    
    
    
    
    override func initLayout() {
        [ summaryLabel, titleLabel, heartButton, bottomButton, tagCollectionView, timeLabel].forEach() {
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        let bounds = UIScreen.main.bounds


        NSLayoutConstraint.activate([
            
            
            heartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -36),
            heartButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 36),
            titleLabel.trailingAnchor.constraint(equalTo: heartButton.leadingAnchor,  constant: -8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            summaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            summaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 36),
            summaryLabel.trailingAnchor.constraint(equalTo: heartButton.trailingAnchor),



            
            
            tagCollectionView.leadingAnchor.constraint(equalTo: summaryLabel.leadingAnchor),
            tagCollectionView.trailingAnchor.constraint(equalTo: summaryLabel.trailingAnchor),
            tagCollectionView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 20),
            //tagCollectionView.bottomAnchor.constraint(equalTo: bottomButton.topAnchor, constant: -20),

            tagCollectionView.heightAnchor.constraint(equalToConstant: bounds.height * 0.05),
            
            timeLabel.topAnchor.constraint(equalTo: tagCollectionView.bottomAnchor, constant: 16),
            
            timeLabel.leadingAnchor.constraint(equalTo: tagCollectionView.leadingAnchor),
            
            timeLabel.bottomAnchor.constraint(equalTo: bottomButton.topAnchor, constant: -20),
            
            bottomButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bottomButton.trailingAnchor.constraint(equalTo: heartButton.trailingAnchor),
            bottomButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            bottomButton.heightAnchor.constraint(greaterThanOrEqualTo: heartButton.heightAnchor, multiplier: 0.9),
            
            
        ])
        
    }
    
    override func buttonSetup() {
        super.buttonSetup()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .clear
        config.image = UIImage(systemName: "heart")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .bold))
        heartButton.configuration = config
        heartButton.addTarget(self, action: #selector(heartButtonTapped( _ :)), for: .touchUpInside)
    }
    
}
