//
//  PageCollectionLayout.swift
//  TestCollectionView
//
//  Created by Alex K. on 04/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

class PageCollectionLayout: UICollectionViewFlowLayout {
  
  private var lastCollectionViewSize: CGSize = CGSizeZero
  
  var scalingOffset: CGFloat      = 200
  var minimumScaleFactor: CGFloat = 0.9
  var minimumAlphaFactor: CGFloat = 0.3
  var scaleItems: Bool            = true
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  init(itemSize: CGSize) {
    super.init()
    commonInit(itemSize)
  }
}

// MARK: life cicle

extension PageCollectionLayout {
  
  private func commonInit(itemSize: CGSize) {
    scrollDirection    = .Horizontal
    minimumLineSpacing = 25
    self.itemSize      = itemSize
  }
}

// MARK: override

extension PageCollectionLayout {
  
  override func invalidateLayoutWithContext(context: UICollectionViewLayoutInvalidationContext) {
    super.invalidateLayoutWithContext(context)
    
    guard let collectionView = self.collectionView else { return }
    
    if collectionView.bounds.size != lastCollectionViewSize {
      self.configureInset()
      self.lastCollectionViewSize = collectionView.bounds.size
    }
  }
  
  override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    guard let collectionView = self.collectionView else {
      return proposedContentOffset
    }
    
    let proposedRect = CGRectMake(proposedContentOffset.x, 0, collectionView.bounds.width, collectionView.bounds.height)
    guard let layoutAttributes = self.layoutAttributesForElementsInRect(proposedRect) else {
      return proposedContentOffset
    }
    
    var candidateAttributes: UICollectionViewLayoutAttributes?
    let proposedContentOffsetCenterX = proposedContentOffset.x + collectionView.bounds.width / 2
    
    for attributes in layoutAttributes {
      if attributes.representedElementCategory != .Cell {
        continue
      }
      
      if candidateAttributes == nil {
        candidateAttributes = attributes
        continue
      }
      
      if fabs(attributes.center.x - proposedContentOffsetCenterX) < fabs(candidateAttributes!.center.x - proposedContentOffsetCenterX) {
        candidateAttributes = attributes
      }
    }
    
    guard let aCandidateAttributes = candidateAttributes else {
      return proposedContentOffset
    }
    
    var newOffsetX = aCandidateAttributes.center.x - collectionView.bounds.size.width / 2
    let offset = newOffsetX - collectionView.contentOffset.x
    
    if (velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0) {
      let pageWidth = self.itemSize.width + self.minimumLineSpacing
      newOffsetX += velocity.x > 0 ? pageWidth : -pageWidth
    }
    
    return CGPointMake(newOffsetX, proposedContentOffset.y)
  }
  
  override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return true
  }
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard let collectionView = self.collectionView,
      let superAttributes = super.layoutAttributesForElementsInRect(rect) else {
        return super.layoutAttributesForElementsInRect(rect)
    }
    if scaleItems == false{
      return super.layoutAttributesForElementsInRect(rect)
    }
    
    let contentOffset = collectionView.contentOffset
    let size = collectionView.bounds.size
    
    let visibleRect = CGRectMake(contentOffset.x, contentOffset.y, size.width, size.height)
    let visibleCenterX = CGRectGetMidX(visibleRect)
    
    guard case let newAttributesArray as [UICollectionViewLayoutAttributes] = NSArray(array: superAttributes, copyItems: true) else {
      return nil
    }
    
    newAttributesArray.forEach {
      let distanceFromCenter = visibleCenterX - $0.center.x
      let absDistanceFromCenter = min(abs(distanceFromCenter), self.scalingOffset)
      let scale = absDistanceFromCenter * (self.minimumScaleFactor - 1) / self.scalingOffset + 1
      $0.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
      
      let alpha = absDistanceFromCenter * (self.minimumAlphaFactor - 1) / self.scalingOffset + 1
      $0.alpha = alpha
    }
   
    return newAttributesArray
  }
}

// MARK: helpers

extension PageCollectionLayout {
  
  private func configureInset() -> Void {
    guard let collectionView = self.collectionView else {
      return
    }
    
    let inset = collectionView.bounds.size.width / 2 - itemSize.width / 2
    collectionView.contentInset  = UIEdgeInsetsMake(0, inset, 0, inset)
    collectionView.contentOffset = CGPointMake(-inset, 0)
  }
}
