import UIKit

class RecipeTextStepCell : RecipeStepCell {
    override func imageViewSetup() {
        super.imageViewSetup()
    }
    
    override func initLayout() {
        super.initLayout()
    }
    
    override func orderLabelLayout() {
        
        NSLayoutConstraint.activate([
            stepOrderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            stepOrderLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            stepOrderLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.09),
            stepOrderLabel.heightAnchor.constraint(equalTo: stepOrderLabel.widthAnchor, multiplier: 1)
        ])
    }
    
    override func descriptionLabelLayout() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: stepOrderLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
        
    override func imageViewLayout() {
        stepImageView.removeFromSuperview()
    }
}

class RecipeImageStepCell : RecipeStepCell {
    
    override func imageViewLayout() {
        super.imageViewLayout()
        NSLayoutConstraint.activate([
            stepImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    
    }
    
   /*override func orderLabelLayout() {
        
        NSLayoutConstraint.activate([
            stepOrderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            stepOrderLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            stepOrderLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.09),
            stepOrderLabel.heightAnchor.constraint(equalTo: stepOrderLabel.widthAnchor, multiplier: 1)
        ])
    }*/
    
    override func descriptionLabelLayout() {
        descriptionLabel.removeFromSuperview()
    }
}
