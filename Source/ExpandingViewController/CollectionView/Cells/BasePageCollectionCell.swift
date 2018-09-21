//
//  PageConllectionCell.swift
//  TestCollectionView
//
//  Created by Alex K. on 04/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

/// Base class for UICollectionViewCell
open class BasePageCollectionCell: UICollectionViewCell {

    /// DEPRECATED! Animation oposition offset when cell is open
    @IBInspectable open var yOffset: CGFloat = 40
    /// Spacing between centers of views
    @IBInspectable open var ySpacing: CGFloat = CGFloat.greatestFiniteMagnitude
    /// Additional height of back view, when it grows
    @IBInspectable open var additionalHeight: CGFloat = CGFloat.greatestFiniteMagnitude
    /// Additional width of back view, when it grows
    @IBInspectable open var additionalWidth: CGFloat = CGFloat.greatestFiniteMagnitude
    /// Should front view drow shadow to bottom or not
    @IBInspectable open var dropShadow: Bool = true

    // MARK: Constants

    struct Constants {
        static let backContainer = "backContainerViewKey"
        static let shadowView = "shadowViewKey"
        static let frontContainer = "frontContainerKey"

        static let backContainerY = "backContainerYKey"
        static let frontContainerY = "frontContainerYKey"
    }

    // MARK: Vars

    /// The view used as the face of the cell must connectid from xib or storyboard.
    @IBOutlet open var frontContainerView: UIView!
    /// The view used as the back of the cell must connectid from xib or storyboard.
    @IBOutlet open var backContainerView: UIView!

    /// constraints for backContainerView must connectid from xib or storyboard
    @IBOutlet open var backConstraintY: NSLayoutConstraint!
    /// constraints for frontContainerView must connectid from xib or storyboard
    @IBOutlet open var frontConstraintY: NSLayoutConstraint!

    var shadowView: UIView?

    /// A Boolean value that indicates whether the cell is opened.
    open var isOpened = false

    // MARK: inits

    /**
     Initializes a UICollectionViewCell from data in a given unarchiver.

     - parameter aDecoder: An unarchiver object.

     - returns: An initialized UICollectionViewCell object.
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        configureOutletFromDecoder(aDecoder)
    }

    /**
     Initializes and returns a newly allocated view object with the specified frame rectangle.

     - parameter frame: The frame rectangle for the view

     - returns: An initialized UICollectionViewCell object.
     */
    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }
}

// MARK: life cicle

extension BasePageCollectionCell {

    open override func awakeFromNib() {
        super.awakeFromNib()

        commonInit()
    }

    fileprivate func commonInit() {
        configurationViews()
        shadowView = createShadowViewOnView(frontContainerView)
    }
}

// MARK: Control

extension BasePageCollectionCell {

    /**
     Open or close cell.

     - parameter isOpen: Contains the value true if the cell should display open state, if false should display close state.
     - parameter animated: Set to true if the change in selection state is animated.
     */
    public func cellIsOpen(_ isOpen: Bool, animated: Bool = true) {
        if isOpen == isOpened { return }

        if ySpacing == .greatestFiniteMagnitude {
            frontConstraintY.constant = isOpen == true ? -frontContainerView.bounds.size.height / 6 : 0
            backConstraintY.constant = isOpen == true ? frontContainerView.bounds.size.height / 6 - yOffset / 2 : 0
        } else {
            frontConstraintY.constant = isOpen == true ? -ySpacing / 2 : 0
            backConstraintY.constant = isOpen == true ? ySpacing / 2 : 0
        }

        if let widthConstant = backContainerView.getConstraint(.width) {
            if additionalWidth == .greatestFiniteMagnitude {
                widthConstant.constant = isOpen == true ? frontContainerView.bounds.size.width + yOffset : frontContainerView.bounds.size.width
            } else {
                widthConstant.constant = isOpen == true ? frontContainerView.bounds.size.width + additionalWidth : frontContainerView.bounds.size.width
            }
        }

        if let heightConstant = backContainerView.getConstraint(.height) {
            if additionalHeight == .greatestFiniteMagnitude {
                heightConstant.constant = isOpen == true ? frontContainerView.bounds.size.height + yOffset : frontContainerView.bounds.size.height
            } else {
                heightConstant.constant = isOpen == true ? frontContainerView.bounds.size.height + additionalHeight : frontContainerView.bounds.size.height
            }
        }

        isOpened = isOpen

        if animated == true {
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.contentView.layoutIfNeeded()
            }, completion: nil)
        } else {
            contentView.layoutIfNeeded()
        }
    }
}

// MARK: Configuration

extension BasePageCollectionCell {

    fileprivate func configurationViews() {
        backContainerView.layer.masksToBounds = true
        backContainerView.layer.cornerRadius = 5

        frontContainerView.layer.masksToBounds = true
        frontContainerView.layer.cornerRadius = 5

        contentView.layer.masksToBounds = false
        layer.masksToBounds = false
    }

    fileprivate func createShadowViewOnView(_ view: UIView?) -> UIView? {
        guard let view = view else { return nil }

        let shadow = Init(UIView(frame: .zero)) {
            $0.backgroundColor = UIColor(white: 0, alpha: 0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.masksToBounds = false
            if dropShadow {
                $0.layer.shadowColor = UIColor.black.cgColor
                $0.layer.shadowRadius = 10
                $0.layer.shadowOpacity = 0.3
                $0.layer.shadowOffset = CGSize(width: 0, height: 0)
            }
        }
        contentView.insertSubview(shadow, belowSubview: view)

        // create constraints
        let sizeConstaints: [(NSLayoutConstraint.Attribute, CGFloat)] = [(NSLayoutConstraint.Attribute.width, 0.8), (NSLayoutConstraint.Attribute.height, 0.9)]
        for info: (attribute: NSLayoutConstraint.Attribute, scale: CGFloat) in sizeConstaints {
            if let frontViewConstraint = view.getConstraint(info.attribute) {
                shadow >>>- {
                    $0.attribute = info.attribute
                    $0.constant = frontViewConstraint.constant * info.scale
                    return
                }
            }
        }
        
        let centerConstraints: [(NSLayoutConstraint.Attribute, CGFloat)] = [(NSLayoutConstraint.Attribute.centerX, 0), (NSLayoutConstraint.Attribute.centerY, 30)]
        for info: (attribute: NSLayoutConstraint.Attribute, offset: CGFloat) in centerConstraints {
            (contentView, shadow, view) >>>- {
                $0.attribute = info.attribute
                $0.constant = info.offset
                return
            }
        }

        // size shadow
        let width = shadow.getConstraint(.width)?.constant
        let height = shadow.getConstraint(.height)?.constant

        shadow.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width!, height: height!), cornerRadius: 0).cgPath

        return shadow
    }

    func configureCellViewConstraintsWithSize(_ size: CGSize) {
        guard isOpened == false && frontContainerView.getConstraint(.width)?.constant != size.width else { return }

        [frontContainerView, backContainerView].forEach {
            let constraintWidth = $0?.getConstraint(.width)
            constraintWidth?.constant = size.width

            let constraintHeight = $0?.getConstraint(.height)
            constraintHeight?.constant = size.height
        }
    }
}

// MARK: NSCoding

extension BasePageCollectionCell {

    fileprivate func highlightedImageFalseOnView(_ view: UIView) {
        for item in view.subviews {
            if case let imageView as UIImageView = item {
                imageView.isHighlighted = false
            }
            if item.subviews.count > 0 {
                highlightedImageFalseOnView(item)
            }
        }
    }

    fileprivate func copyShadowFromView(_ fromView: UIView, toView: UIView) {
        fromView.layer.shadowPath = toView.layer.shadowPath
        fromView.layer.masksToBounds = toView.layer.masksToBounds
        fromView.layer.shadowColor = toView.layer.shadowColor
        fromView.layer.shadowRadius = toView.layer.shadowRadius
        fromView.layer.shadowOpacity = toView.layer.shadowOpacity
        fromView.layer.shadowOffset = toView.layer.shadowOffset
    }

    func copyCell() -> BasePageCollectionCell? {
        highlightedImageFalseOnView(contentView)

        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        guard case let copyView as BasePageCollectionCell = NSKeyedUnarchiver.unarchiveObject(with: data),
            let shadowView = self.shadowView else {
            return nil
        }

        // configure
        copyView.backContainerView.layer.masksToBounds = backContainerView.layer.masksToBounds
        copyView.backContainerView.layer.cornerRadius = backContainerView.layer.cornerRadius

        copyView.frontContainerView.layer.masksToBounds = frontContainerView.layer.masksToBounds
        copyView.frontContainerView.layer.cornerRadius = frontContainerView.layer.cornerRadius

        // copy shadow layer
        copyShadowFromView(copyView.shadowView!, toView: shadowView)

        for index in 0 ..< copyView.frontContainerView.subviews.count {
            copyShadowFromView(copyView.frontContainerView.subviews[index], toView: frontContainerView.subviews[index])
        }
        return copyView
    }

    open override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(backContainerView, forKey: Constants.backContainer)
        coder.encode(frontContainerView, forKey: Constants.frontContainer)
        coder.encode(frontConstraintY, forKey: Constants.frontContainerY)
        coder.encode(backConstraintY, forKey: Constants.backContainerY)
        coder.encode(shadowView, forKey: Constants.shadowView)
    }

    fileprivate func configureOutletFromDecoder(_ coder: NSCoder) {
        if case let shadowView as UIView = coder.decodeObject(forKey: Constants.shadowView) {
            self.shadowView = shadowView
        }

        if case let backView as UIView = coder.decodeObject(forKey: Constants.backContainer) {
            backContainerView = backView
        }

        if case let frontView as UIView = coder.decodeObject(forKey: Constants.frontContainer) {
            frontContainerView = frontView
        }

        if case let constraint as NSLayoutConstraint = coder.decodeObject(forKey: Constants.frontContainerY) {
            frontConstraintY = constraint
        }

        if case let constraint as NSLayoutConstraint = coder.decodeObject(forKey: Constants.backContainerY) {
            backConstraintY = constraint
        }
    }
}
