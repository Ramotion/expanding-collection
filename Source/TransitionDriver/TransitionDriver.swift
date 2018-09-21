//
//  TransitionDriver.swift
//  TestCollectionView
//
//  Created by Alex K. on 11/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

class TransitionDriver {

    // MARK: Constants

    struct Constants {
        static let HideKey = 101
    }

    // MARK: Vars

    fileprivate let view: UIView
    fileprivate let duration: Double = 0.4

    // for push animation
    fileprivate var copyCell: BasePageCollectionCell?
    fileprivate var currentCell: BasePageCollectionCell?
    fileprivate var backImageView: UIImageView?

    fileprivate var leftCell: UICollectionViewCell?
    fileprivate var rightCell: UICollectionViewCell?
    fileprivate var step: CGFloat = 0

    fileprivate var frontViewFrame = CGRect.zero
    fileprivate var backViewFrame = CGRect.zero

    init(view: UIView) {
        self.view = view
    }
}

// MARK: control

extension TransitionDriver {

    func pushTransitionAnimationIndex(_ currentIndex: Int,
                                      collecitionView: UICollectionView,
                                      backImage: UIImage?,
                                      headerHeight: CGFloat,
                                      insets: CGFloat,
                                      completion: @escaping (UIView) -> Void) {

        guard case let cell as BasePageCollectionCell = collecitionView.cellForItem(at: IndexPath(row: currentIndex, section: 0)),
            let copyView = cell.copyCell() else { return }
        copyCell = copyView

        // move cells
        moveCellsCurrentIndex(currentIndex, collectionView: collecitionView)

        currentCell = cell
        cell.isHidden = true

        configurateCell(copyView, backImage: backImage)
        backImageView = addImageToView(copyView.backContainerView, image: backImage)

        openBackViewConfigureConstraints(copyView, height: headerHeight, insets: insets)
        openFrontViewConfigureConstraints(copyView, height: headerHeight, insets: insets)

        // corner animation
        copyView.backContainerView.animationCornerRadius(0, duration: duration)
        copyView.frontContainerView.animationCornerRadius(0, duration: duration)
        copyView.center = view.center

        // constraints animation
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.view.layoutIfNeeded()
            self.backImageView?.alpha = 1
            self.copyCell?.shadowView?.alpha = 0
            copyView.frontContainerView.subviewsForEach { if $0.tag == Constants.HideKey { $0.alpha = 0 } }
        }, completion: { _ in
            let data = NSKeyedArchiver.archivedData(withRootObject: copyView.frontContainerView)
            guard case let headerView as UIView = NSKeyedUnarchiver.unarchiveObject(with: data) else {
                fatalError("must copy")
            }
            completion(headerView)
        })
    }

    func popTransitionAnimationContantOffset(_ offset: CGFloat, backImage: UIImage?) {
        guard let copyCell = self.copyCell else {
            return
        }

        backImageView?.image = backImage
        // configuration start position
        configureCellBeforeClose(copyCell, offset: offset)

        closeBackViewConfigurationConstraints(copyCell)
        closeFrontViewConfigurationConstraints(copyCell)

        // corner animation
        copyCell.backContainerView.animationCornerRadius(copyCell.backContainerView.layer.cornerRadius, duration: duration)
        copyCell.frontContainerView.animationCornerRadius(copyCell.frontContainerView.layer.cornerRadius, duration: duration)

        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.rightCell?.center.x -= self.step
            self.leftCell?.center.x += self.step

            self.view.layoutIfNeeded()
            self.backImageView?.alpha = 0
            copyCell.shadowView?.alpha = 1

            copyCell.frontContainerView.subviewsForEach { if $0.tag == Constants.HideKey { $0.alpha = 1 } }
        }, completion: { _ in
            self.currentCell?.isHidden = false
            self.removeCurrentCell()
        })
    }
}

// MARK: Helpers

extension TransitionDriver {

    fileprivate func removeCurrentCell() {
        if case let currentCell as UIView = copyCell {
            currentCell.removeFromSuperview()
        }
    }

    fileprivate func configurateCell(_ cell: BasePageCollectionCell, backImage _: UIImage?) {
        cell.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cell)

        // add constraints
        [(NSLayoutConstraint.Attribute.width, cell.bounds.size.width), (NSLayoutConstraint.Attribute.height, cell.bounds.size.height)].forEach { info in
            cell >>>- {
                $0.attribute = info.0
                $0.constant = info.1
                return
            }
        }

        [NSLayoutConstraint.Attribute.centerX, .centerY].forEach { attribute in
            (view, cell) >>>- {
                $0.attribute = attribute
                return
            }
        }
        cell.layoutIfNeeded()
    }

    fileprivate func addImageToView(_ view: UIView, image: UIImage?) -> UIImageView? {
        guard let image = image else { return nil }

        let imageView = Init(UIImageView(image: image)) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.alpha = 0
        }
        view.addSubview(imageView)

        // add constraints
        [NSLayoutConstraint.Attribute.left, .right, .top, .bottom].forEach { attribute in
            (view, imageView) >>>- {
                $0.attribute = attribute
                return
            }
        }
        imageView.layoutIfNeeded()

        return imageView
    }

    fileprivate func moveCellsCurrentIndex(_ currentIndex: Int, collectionView: UICollectionView) {
        leftCell = nil
        rightCell = nil

        if let leftCell = collectionView.cellForItem(at: IndexPath(row: currentIndex - 1, section: 0)) {
            let step = leftCell.frame.size.width + (leftCell.frame.origin.x - collectionView.contentOffset.x)
            UIView.animate(withDuration: 0.2, animations: {
                leftCell.center.x -= step
            })
            self.leftCell = leftCell
            self.step = step
        }

        if let rightCell = collectionView.cellForItem(at: IndexPath(row: currentIndex + 1, section: 0)) {
            let step = collectionView.frame.size.width - (rightCell.frame.origin.x - collectionView.contentOffset.x)
            UIView.animate(withDuration: 0.2, animations: {
                rightCell.center.x += step
            })
            self.rightCell = rightCell
            self.step = step
        }
    }
}

// MARK: animations

extension TransitionDriver {

    fileprivate func openFrontViewConfigureConstraints(_ cell: BasePageCollectionCell, height: CGFloat, insets: CGFloat) {

        if let heightConstraint = cell.frontContainerView.getConstraint(.height) {
            frontViewFrame.size.height = heightConstraint.constant
            heightConstraint.constant = height
        }

        if let widthConstraint = cell.frontContainerView.getConstraint(.width) {
            frontViewFrame.size.width = widthConstraint.constant
            widthConstraint.constant = view.bounds.size.width
        }

        frontViewFrame.origin.y = cell.frontConstraintY.constant
        cell.frontConstraintY.constant = -view.bounds.size.height / 2 + height / 2 + insets
    }

    fileprivate func openBackViewConfigureConstraints(_ cell: BasePageCollectionCell, height: CGFloat, insets: CGFloat) {

        if let heightConstraint = cell.backContainerView.getConstraint(.height) {
            backViewFrame.size.height = heightConstraint.constant
            heightConstraint.constant = view.bounds.size.height - height
        }

        if let widthConstraint = cell.backContainerView.getConstraint(.width) {
            backViewFrame.size.width = widthConstraint.constant
            widthConstraint.constant = view.bounds.size.width
        }

        backViewFrame.origin.y = cell.backConstraintY.constant
    cell.backConstraintY.constant = view.bounds.size.height / 2 - (view.bounds.size.height - height) / 2 + insets
    }

    fileprivate func closeBackViewConfigurationConstraints(_ cell: BasePageCollectionCell?) {
        guard let cell = cell else { return }

        let heightConstraint = cell.backContainerView.getConstraint(.height)
        heightConstraint?.constant = backViewFrame.size.height

        let widthConstraint = cell.backContainerView.getConstraint(.width)
        widthConstraint?.constant = backViewFrame.size.width

        cell.backConstraintY.constant = backViewFrame.origin.y
    }

    fileprivate func closeFrontViewConfigurationConstraints(_ cell: BasePageCollectionCell?) {
        guard let cell = cell else { return }

        if let heightConstraint = cell.frontContainerView.getConstraint(.height) {
            heightConstraint.constant = frontViewFrame.size.height
        }

        if let widthConstraint = cell.frontContainerView.getConstraint(.width) {
            widthConstraint.constant = frontViewFrame.size.width
        }

        cell.frontConstraintY.constant = frontViewFrame.origin.y
    }

    fileprivate func configureCellBeforeClose(_ cell: BasePageCollectionCell, offset: CGFloat) {
        cell.frontConstraintY.constant -= offset
        cell.backConstraintY.constant -= offset / 2.0
        if let heightConstraint = cell.backContainerView.getConstraint(.height) {
            heightConstraint.constant += offset
        }
        cell.contentView.layoutIfNeeded()
    }
}
