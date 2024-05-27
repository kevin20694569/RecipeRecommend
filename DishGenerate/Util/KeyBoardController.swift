
import UIKit

protocol KeyBoardControllerDelegate : UIViewController {
    var activeTextField : UITextField? { get set }
    var activeTextView : UITextView? { get set }
    
}

class KeyBoardController : NSObject {
    
   
    var view : UIView!
    
    init(view : UIView, delegate : KeyBoardControllerDelegate) {
        self.view = view
        self.delegate = delegate
    }
    
    weak var delegate : KeyBoardControllerDelegate?
    

    @objc func keyboardShown(notification : Notification, activeTextField : UITextField?, activeTextView : UITextView?) {

        let info: NSDictionary = notification.userInfo! as NSDictionary
        //取得鍵盤尺寸
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        //鍵盤頂部 Y軸的位置
        let keyboardY = self.view.frame.height - keyboardSize.height
        //編輯框底部 Y軸的位置
        let offsetY: CGFloat = 32
        
        if let activeTextField = activeTextField {
            let editingTextFieldY = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
            let targetY = editingTextFieldY - keyboardY
            if self.view.frame.minY >= 0 {
                if targetY > 0 {
                    let offsetY = -targetY - offsetY
                    UIView.animate(withDuration: 0.25, animations: {
                        self.view.frame.origin.y += offsetY
                    })
                }
            }
        }
        if let activeTextView = activeTextView {
            let editingTextViewY = activeTextView.convert(activeTextView.bounds, to: self.view).maxY
            let targetY = editingTextViewY - keyboardY
            if self.view.frame.minY >= 0 {
                let offsetY = -targetY - offsetY
                if targetY > 0 {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.view.frame.origin.y += offsetY
                    })
                }
            }
        }
    }
    @objc func keyboardHidden(notification : Notification, activeTextField : UITextField?, activeTextView : UITextView? ) {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }) { [weak self] bool in
            guard let self = self else {
                return
            }
            let delegate = self.delegate
            delegate?.activeTextView = nil
            delegate?.activeTextField = nil
        }
        
    }
    
}
