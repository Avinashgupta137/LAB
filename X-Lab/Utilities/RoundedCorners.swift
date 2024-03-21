//
//  RoundedCorners.swift
//  Cinemax
//
//  Created by IPS-161 on 24/01/24.
//

import Foundation
import UIKit

@IBDesignable
class RoundedButton: UIButton {
    // Custom corner radius value
    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            setNeedsLayout()
        }
    }

    // Custom border color
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Set corner radius
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        // Set border color
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 1.0 // You can customize the border width if needed
    }
}


class RoundedButtonWithBorder: UIButton {
    // Custom corner radius value
    var cornerRadius: CGFloat = 10 {
        didSet {
            setNeedsLayout()
        }
    }
    
    // Custom border width value
    var borderWidth: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    // Custom border color value
    var borderColor: UIColor = .gray {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set corner radius
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        
        // Set border
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}

class CircularButtonWithBorder: UIButton {
    // Custom border color value
    var borderColor: UIColor = .gray {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set corner radius to make it circular
        layer.cornerRadius = bounds.width / 2
        layer.masksToBounds = true
        
        // Set border
        layer.borderWidth = 1
        layer.borderColor = borderColor.cgColor
    }
}



class RoundedViewWithBorder: UIView {
    // Custom corner radius value
    var cornerRadius: CGFloat = 10 {
        didSet {
            setNeedsLayout()
        }
    }
    
    // Custom border width value
    var borderWidth: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    // Custom border color value
    var borderColor: UIColor = .gray {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set corner radius
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        
        // Set border
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}

class RoundedLabelWithBorder: UILabel {
    // Custom corner radius value
    var cornerRadius: CGFloat = 10 {
        didSet {
            setNeedsLayout()
        }
    }
    
    // Custom border width value
    var borderWidth: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    // Custom border color value
    var borderColor: UIColor = .gray {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set corner radius
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        
        // Set border
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}


@IBDesignable
class CircleImageView: UIImageView {

    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
        layer.masksToBounds = true
        clipsToBounds = true
    }
}

class CircleUIView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        // Set the corner radius to half of the view's width to make it a circle
        layer.cornerRadius = bounds.width / 2
        layer.masksToBounds = true
        clipsToBounds = true
    }
}


class ViewWithBorder: UIView {
    // Custom border width value
    var borderWidth: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    // Custom border color value
    var borderColor: UIColor = .black {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set border
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}

class CircularLabel: UILabel {
    override func layoutSubviews() {
        super.layoutSubviews()
        // Set the corner radius to half of the view's width to make it a circle
        layer.cornerRadius = bounds.width / 2
        layer.masksToBounds = true
    }
}

@IBDesignable
class RoundedCornerView: UIView {
    // Custom corner radius value
    @IBInspectable var cornerRadius: CGFloat = 20 {
        didSet {
            setNeedsLayout()
        }
    }

    // Custom border width value
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            setNeedsLayout()
        }
    }

    // Custom border color
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet {
            setNeedsLayout()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Set corner radius for rounded corners
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0

        // Set border properties
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}

@IBDesignable
class RoundedCornerButton: UIButton {
    // Custom corner radius value
    @IBInspectable var cornerRadius: CGFloat = 20 {
        didSet {
            setNeedsLayout()
        }
    }

    // Custom border width value
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            setNeedsLayout()
        }
    }

    // Custom border color
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet {
            setNeedsLayout()
        }
    }

    // Shadow properties
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var shadowOpacity: Float = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Set corner radius for rounded corners
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0

        // Set border properties
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor

        // Set shadow properties
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
    }
}

@IBDesignable
class RoundedCornerImageView: UIImageView {
    // Custom corner radius value
    @IBInspectable var cornerRadius: CGFloat = 20 {
        didSet {
            setNeedsLayout()
        }
    }

    // Custom border width value
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            setNeedsLayout()
        }
    }

    // Custom border color
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet {
            setNeedsLayout()
        }
    }

    // Shadow properties
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var shadowOpacity: Float = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Set corner radius for rounded corners
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0

        // Set border properties
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor

        // Set shadow properties
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
    }
}
