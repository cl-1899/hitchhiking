import UIKit

class StyleChangedTextField: UITextField {

    let newPadding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: newPadding)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: newPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: newPadding)
    }
    
    private let defaultCornerRadius: CGFloat = 20.0
    
    private func applyCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyCornerRadius(defaultCornerRadius)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyCornerRadius(defaultCornerRadius)
    }
}
