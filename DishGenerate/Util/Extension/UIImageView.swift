
import UIKit

extension UIImageView {
    
    func setImageWithAnimation(image : UIImage?, duration : CGFloat = 0.1) {
        guard let image = image, image != self.image  else {
            return
        }
        var fadedView : UIView = UIView()
        fadedView.layer.opacity = 1
        fadedView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(fadedView)
        fadedView.backgroundColor = backgroundColor
        NSLayoutConstraint.activate([
            fadedView.topAnchor.constraint(equalTo: topAnchor),
            fadedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            fadedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            fadedView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        self.image = image
        UIView.animate(withDuration: duration, animations: {
            fadedView.layer.opacity = 0
        }) { bool in
            fadedView.removeFromSuperview()
        }
        

    }
}
