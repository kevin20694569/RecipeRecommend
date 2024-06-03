import UIKit

class EquipmentTextFieldCollectionCell : TextFieldSideCollectionCell {
    
    var equipment : Equipment!
    
    weak var editEquipmentCellDelegate : EditEquipmentCellDelegate?
    
    override func deleteSelfGesureTrigger(_ gesture: UITapGestureRecognizer) {
        super.deleteSelfGesureTrigger(gesture)

        editEquipmentCellDelegate?.deleteEquipment(equipment: equipment)
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configure(equipment : Equipment) {
        self.equipment = equipment
        textField.text = equipment.name
        textField.delegate = textfieldDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class EquipmentTextFieldCenterCollectionCell : EquipmentTextFieldCollectionCell {
    
    

    override func initLayout() {
        super.initLayout()
        backgroundCenterAnchor.isActive = true

    }

}

class EquipmentTextFieldLeadingCollectionCell : EquipmentTextFieldCollectionCell {
    override func initLayout() {
        super.initLayout()
        
        backgroundLeadingAnchor.isActive = true
    }

}


class EquipmentTextFieldTrailingCollectionCell : EquipmentTextFieldCollectionCell {
    override func initLayout() {
        super.initLayout()
        
        backgroundTrailingAnchor.isActive = true
    }

}


class CuisineTextFieldCollectionCell : TextFieldSideCollectionCell {
    
    var cuisine : Cuisine!
    
    weak var generateOptionCellDelegate : GenerateOptionCellDelegate?
    
    override func deleteSelfGesureTrigger(_ gesture: UITapGestureRecognizer) {
        super.deleteSelfGesureTrigger(gesture)

        generateOptionCellDelegate?.deleteCuisine(cuisine: cuisine)
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configure(cuisine : Cuisine) {
        self.cuisine = cuisine
        textField.text = cuisine.name
        textField.delegate = textfieldDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CuisineTextFieldCenterCollectionCell : CuisineTextFieldCollectionCell {
    
    

    override func initLayout() {
        super.initLayout()
        backgroundCenterAnchor.isActive = true

    }

}

class CuisineTextFieldLeadingCollectionCell : CuisineTextFieldCollectionCell {
    override func initLayout() {
        super.initLayout()
        
        backgroundLeadingAnchor.isActive = true
    }

}


class CuisineTextFieldTrailingCollectionCell : CuisineTextFieldCollectionCell {
    override func initLayout() {
        super.initLayout()
        
        backgroundTrailingAnchor.isActive = true
    }

}

