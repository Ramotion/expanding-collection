//
//  PageCollectionLayout.swift
//  TestCollectionView
//
//  Created by Alex K. on 04/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

class PageCollectionLayout: UICollectionViewFlowLayout {

    fileprivate var lastCollectionViewSize: CGSize = CGSize.zero

    var scalingOffset: CGFloat = 200
    var minimumScaleFactor: CGFloat = 0.9
    var minimumAlphaFactor: CGFloat = 0.3
    var scaleItems: Bool = true

    required init?(coder _: NSCoder) {
        fatalError()
    }

    init(itemSize: CGSize) {
        super.init()
        commonInit(itemSize)
    }
}

// MARK: life cicle

extension PageCollectionLayout {

    fileprivate func commonInit(_ itemSize: CGSize) {
        scrollDirection = .horizontal
        minimumLineSpacing = 25
        self.itemSize = itemSize
    }
}

// MARK: override

extension PageCollectionLayout {

    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)

        guard let collectionView = self.collectionView else { return }

        if collectionView.bounds.size != lastCollectionViewSize {
            configureInset()
            lastCollectionViewSize = collectionView.bounds.size
        }
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
            return proposedContentOffset
        }

        let proposedRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height)
        guard let layoutAttributes = self.layoutAttributesForElements(in: proposedRect) else {
            return proposedContentOffset
        }

        var candidateAttributes: UICollectionViewLayoutAttributes?
        let proposedContentOffsetCenterX = proposedContentOffset.x + collectionView.bounds.width / 2

        for attributes in layoutAttributes {
            if attributes.representedElementCategory != .cell {
                continue
            }

            if candidateAttributes == nil {
                candidateAttributes = attributes
                continue
            }

            if abs(attributes.center.x - proposedContentOffsetCenterX) < abs(candidateAttributes!.center.x - proposedContentOffsetCenterX) {
                candidateAttributes = attributes
            }
        }

        guard let aCandidateAttributes = candidateAttributes else {
            return proposedContentOffset
        }

        var newOffsetX = aCandidateAttributes.center.x - collectionView.bounds.size.width / 2
        let offset = newOffsetX - collectionView.contentOffset.x

        if (velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0) {
            let pageWidth = itemSize.width + minimumLineSpacing
            newOffsetX += velocity.x > 0 ? pageWidth : -pageWidth
        }

        return CGPoint(x: newOffsetX, y: proposedContentOffset.y)
    }

    override func shouldInvalidateLayout(forBoundsChange _: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView,
            let superAttributes = super.layoutAttributesForElements(in: rect) else {
            return super.layoutAttributesForElements(in: rect)
        }
        if scaleItems == false {
            return super.layoutAttributesForElements(in: rect)
        }

        let contentOffset = collectionView.contentOffset
        let size = collectionView.bounds.size

        let visibleRect = CGRect(x: contentOffset.x, y: contentOffset.y, width: size.width, height: size.height)
        let visibleCenterX = visibleRect.midX

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

    fileprivate func configureInset() {
        guard let collectionView = self.collectionView else {
            return
        }

        let inset = collectionView.bounds.size.width / 2 - itemSize.width / 2
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: inset, bottom: 0, right: inset)
        collectionView.contentOffset = CGPoint(x: -inset, y: 0)
    }
}
