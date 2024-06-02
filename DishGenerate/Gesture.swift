
import UIKit

class BackGroundColorTriggerTapGesture : UITapGestureRecognizer {
    
    var viewOriginalBackgroundColor : UIColor?
    
    var triggerColor : UIColor = .secondaryBackgroundColor
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        guard let view = view else {
            return
        }
        viewOriginalBackgroundColor = view.backgroundColor
        view.backgroundColor = triggerColor
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {

        super.touchesEnded(touches, with: event)
        guard let view = view else {
            return
        }
        view.backgroundColor = self.viewOriginalBackgroundColor
    }
}
