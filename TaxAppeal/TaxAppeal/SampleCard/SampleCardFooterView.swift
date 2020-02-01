import UIKit

class SampleCardFooterView: UIView {
    
    private var label = UILabel()
    
    private var gradientLayer: CAGradientLayer?
    
    init(withAddress address: String?, assessedValue: String?, subtitle: String?) {
        super.init(frame: CGRect.zero)
        backgroundColor = .clear
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 10
        clipsToBounds = true
        isOpaque = false
        initialize(address: address, assessedValue: assessedValue, subtitle: subtitle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    private func initialize(address: String?, assessedValue: String?, subtitle: String?) {
        let attributedText = NSMutableAttributedString(string: (address ?? "") + "\n", attributes: NSAttributedString.Key.addressAttributes)
        if let assessedValue = assessedValue, assessedValue != "" {
            attributedText.append(NSMutableAttributedString(string: "Assessed value: $\(assessedValue)", attributes: NSAttributedString.Key.assessedValueAttributes))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 2
            paragraphStyle.lineBreakMode = .byTruncatingTail
            attributedText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedText.length))
            label.numberOfLines = 3
        }
        if let subtitle = subtitle, subtitle != "" {
            attributedText.append(NSMutableAttributedString(string: "\n\(subtitle)", attributes: NSAttributedString.Key.subtitleAttributes))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 2
            paragraphStyle.lineBreakMode = .byTruncatingTail
            attributedText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedText.length))
            label.numberOfLines = 3
        }
        
        label.attributedText = attributedText
        addSubview(label)
    }
    
    override func layoutSubviews() {
        let padding: CGFloat = 20
        label.frame = CGRect(x: padding,
                             y: bounds.height - label.intrinsicContentSize.height - padding,
                             width: bounds.width - 2 * padding,
                             height: label.intrinsicContentSize.height)
    }
}

extension NSAttributedString.Key {
    
    static var shadowAttribute: NSShadow = {
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        shadow.shadowBlurRadius = 2
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.3)
        return shadow
    }()
    
    static var addressAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont(name: "Futura-CondensedMedium", size: 32)!,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.shadow: NSAttributedString.Key.shadowAttribute
    ]
    
    static var assessedValueAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont(name: "Futura-Medium", size: 18)!,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.shadow: NSAttributedString.Key.shadowAttribute
    ]
    
    static var subtitleAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont(name: "Baskerville-Italic", size: 18)!,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.shadow: NSAttributedString.Key.shadowAttribute
    ]
}
