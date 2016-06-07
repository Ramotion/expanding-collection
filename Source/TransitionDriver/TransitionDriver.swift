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
  
  private let view: UIView
  private let duration: Double = 0.4
  
  // for push animation
  private var copyCell: BasePageCollectionCell?
  private var currentCell: BasePageCollectionCell?
  private var backImageView: UIImageView?
  
  private var leftCell: UICollectionViewCell?
  private var rightCell: UICollectionViewCell?
  private var step: CGFloat = 0
  
  private var frontViewFrame = CGRect.zero
  private var backViewFrame  = CGRect.zero
  
  init(view: UIView) {
    self.view = view
  }
}

// MARK: control

extension TransitionDriver {
  
  func pushTransitionAnimationIndex(currentIndex: Int,
                                    collecitionView: UICollectionView,
                                    backImage: UIImage?,
                                    headerHeight: CGFloat,
                                    insets: CGFloat,
                                    completion: UIView -> Void) {
    
    guard case let cell as BasePageCollectionCell = collecitionView.cellForItemAtIndexPath(NSIndexPath(forRow: currentIndex, inSection: 0)),
      let copyView = cell.copyCell() else { return }
    copyCell = copyView
    
    // move cells
    moveCellsCurrentIndex(currentIndex, collectionView: collecitionView)
    
    currentCell = cell
    cell.hidden = true
    
    configurateCell(copyView, backImage: backImage)
    backImageView = addImageToView(copyView.backContainerView, image: backImage)
    
    openBackViewConfigureConstraints(copyView, height: headerHeight, insets: insets)
    openFrontViewConfigureConstraints(copyView, height: headerHeight, insets: insets)
    
    // corner animation 
    copyView.backContainerView.animationCornerRadius(0, duration: duration)
    copyView.frontContainerView.animationCornerRadius(0, duration: duration)
    
   // constraints animation
    UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: {
      self.view.layoutIfNeeded()
      self.backImageView?.alpha        = 1
      self.copyCell?.shadowView?.alpha = 0
      copyView.frontContainerView.subviewsForEach { if $0.tag == Constants.HideKey { $0.alpha = 0 } }
    }, completion: { success in
      let data = NSKeyedArchiver.archivedDataWithRootObject(copyView.frontContainerView)
      guard case let headerView as UIView = NSKeyedUnarchiver.unarchiveObjectWithData(data) else {
        fatalError("must copy")
      }
      completion(headerView)
    })
  }
  
  func popTransitionAnimationContantOffset(offset: CGFloat, backImage: UIImage?) {
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
    
    UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: {
      self.rightCell?.center.x -= self.step
      self.leftCell?.center.x  += self.step
      
      self.view.layoutIfNeeded()
      self.backImageView?.alpha  = 0
      copyCell.shadowView?.alpha = 1
      
      copyCell.frontContainerView.subviewsForEach { if $0.tag == Constants.HideKey { $0.alpha = 1 } }
      }, completion: { success in
         self.currentCell?.hidden = false
         self.removeCurrentCell()
    })
  }
}

// MARK: Helpers

extension TransitionDriver {
  
  private func removeCurrentCell()  {
    if case let currentCell as UIView = self.copyCell {
      currentCell.removeFromSuperview()
    }
  }
  
  private func configurateCell(cell: BasePageCollectionCell, backImage: UIImage?) {
    cell.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(cell)
    
    // add constraints
    [(NSLayoutAttribute.Width, cell.bounds.size.width), (NSLayoutAttribute.Height, cell.bounds.size.height)].forEach { info in
      cell >>>- {
        $0.attribute = info.0
        $0.constant  = info.1
      }
    }
    
    [NSLayoutAttribute.CenterX, .CenterY].forEach { attribute in
      (view, cell) >>>- { $0.attribute = attribute }
    }
    cell.layoutIfNeeded()
  }
  
  private func addImageToView(view: UIView, image: UIImage?) -> UIImageView? {
    guard let image = image else { return nil }
    
    let imageView = Init(UIImageView(image: image)) {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.alpha = 0
    }
    view.addSubview(imageView)
    
    // add constraints
    [NSLayoutAttribute.Left, .Right, .Top, .Bottom].forEach { attribute in
      (view, imageView) >>>- { $0.attribute = attribute }
    }
    imageView.layoutIfNeeded()
    
    return imageView
  }
  
  private func moveCellsCurrentIndex(currentIndex: Int, collectionView: UICollectionView) {
    self.leftCell  = nil
    self.rightCell = nil

    if let leftCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: currentIndex - 1, inSection: 0)) {
      let step = leftCell.frame.size.width + (leftCell.frame.origin.x - collectionView.contentOffset.x)
      UIView.animateWithDuration(0.2, animations: {
        leftCell.center.x -= step
      })
      self.leftCell = leftCell
      self.step     = step
    }
    
    if let rightCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: currentIndex + 1, inSection: 0)) {
      let step = collectionView.frame.size.width - (rightCell.frame.origin.x - collectionView.contentOffset.x)
      UIView.animateWithDuration(0.2, animations: {
        rightCell.center.x += step
      })
      self.rightCell = rightCell
      self.step      = step
    }
  }
}

// MARK: animations

extension TransitionDriver {
  
  private func openFrontViewConfigureConstraints(cell: BasePageCollectionCell, height: CGFloat, insets: CGFloat) {
    
    if let heightConstraint = cell.frontContainerView.getConstraint(.Height) {
      frontViewFrame.size.height = heightConstraint.constant
      heightConstraint.constant  = height
    }
    
    if let widthConstraint = cell.frontContainerView.getConstraint(.Width) {
      frontViewFrame.size.width = widthConstraint.constant
      widthConstraint.constant  = view.bounds.size.width
    }
    
    frontViewFrame.origin.y        = cell.frontConstraintY.constant
    cell.frontConstraintY.constant = -view.bounds.size.height / 2 + height / 2 + insets
  }
  
  private func openBackViewConfigureConstraints(cell: BasePageCollectionCell, height: CGFloat, insets: CGFloat) {
    
    if let heightConstraint = cell.backContainerView.getConstraint(.Height) {
      backViewFrame.size.height = heightConstraint.constant
      heightConstraint.constant = view.bounds.size.height - height
    }
    
    if let widthConstraint = cell.backContainerView.getConstraint(.Width) {
      backViewFrame.size.width = widthConstraint.constant
      widthConstraint.constant = view.bounds.size.width
    }
    
    backViewFrame.origin.y        = cell.backConstraintY.constant
    cell.backConstraintY.constant = view.bounds.size.height / 2 - (view.bounds.size.height - 236) / 2 + insets
  }
  
  private func closeBackViewConfigurationConstraints(cell: BasePageCollectionCell?) {
    guard let cell = cell else { return }
    
    let heightConstraint       = cell.backContainerView.getConstraint(.Height)
    heightConstraint?.constant = backViewFrame.size.height

    let widthConstraint       = cell.backContainerView.getConstraint(.Width)
    widthConstraint?.constant = backViewFrame.size.width

    cell.backConstraintY.constant = backViewFrame.origin.y
  }
  
  private func closeFrontViewConfigurationConstraints(cell: BasePageCollectionCell?) {
    guard let cell = cell else { return }
    
    if let heightConstraint = cell.frontContainerView.getConstraint(.Height) {
      heightConstraint.constant = frontViewFrame.size.height
    }
    
    if let widthConstraint = cell.frontContainerView.getConstraint(.Width) {
      widthConstraint.constant = frontViewFrame.size.width
    }
    
    cell.frontConstraintY.constant = frontViewFrame.origin.y
  }
  
  private func configureCellBeforeClose(cell: BasePageCollectionCell, offset: CGFloat) {
    cell.frontConstraintY.constant -= offset
    cell.backConstraintY.constant  -= offset / 2.0
    if let heightConstraint = cell.backContainerView.getConstraint(.Height) {
      heightConstraint.constant += offset
    }
    cell.contentView.layoutIfNeeded()
  }
}
