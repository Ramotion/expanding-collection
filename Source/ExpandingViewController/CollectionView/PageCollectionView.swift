//
//  PageCollectionView.swift
//  TestCollectionView
//
//  Created by Alex K. on 05/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

class PageCollectionView: UICollectionView {
}

// MARK: init

extension PageCollectionView {

    class func createOnView(_ view: UIView,
                            layout: UICollectionViewLayout,
                            height: CGFloat,
                            dataSource: UICollectionViewDataSource,
                            delegate: UICollectionViewDelegate) -> PageCollectionView {

        let collectionView = Init(PageCollectionView(frame: CGRect.zero, collectionViewLayout: layout)) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.decelerationRate = UIScrollView.DecelerationRate.fast
            $0.showsHorizontalScrollIndicator = false
            $0.dataSource = dataSource
            $0.delegate = delegate
            $0.backgroundColor = UIColor(white: 0, alpha: 0)
        }
        view.addSubview(collectionView)

        // add constraints
        collectionView >>>- {
            $0.attribute = .height
            $0.constant = height
            return
        }
        [NSLayoutConstraint.Attribute.left, .right, .centerY].forEach { attribute in
            (view, collectionView) >>>- {
                $0.attribute = attribute
                return
            }
        }

        return collectionView
    }
}
