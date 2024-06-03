
import UIKit

class BackGroundColorTriggerTapGesture : UITapGestureRecognizer, UIGestureRecognizerDelegate {
    
    var viewOriginalBackgroundColor : UIColor?
    
    var triggerColor : UIColor = .secondaryBackgroundColor

    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        delegate = self
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    
    init(target: Any?, action: Selector?, originalBackgroundColor : UIColor?, triggerColor : UIColor?) {
        super.init(target: target, action: action)
        if let originalBackgroundColor = originalBackgroundColor {
            self.viewOriginalBackgroundColor = originalBackgroundColor
        }
        if let triggerColor = triggerColor {
            self.triggerColor = triggerColor
        }
        delegate = self
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        triggerBackgroundColor()
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        recoverBackgroundColor()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        recoverBackgroundColor()

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        recoverBackgroundColor()

    }
    
    func recoverBackgroundColor() {
        view?.backgroundColor = self.viewOriginalBackgroundColor
    }
    
    func triggerBackgroundColor() {
        view?.backgroundColor = triggerColor
    }
}
