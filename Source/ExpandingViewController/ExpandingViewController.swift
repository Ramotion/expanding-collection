//
//  PageViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 05/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

/// UIViewController with UICollectionView with custom transition method
open class ExpandingViewController: UIViewController {

    /// The default size to use for cells. Height of open cell state
    open var itemSize = CGSize(width: 256, height: 460)

    ///  The collection view object managed by this view controller.
    open var collectionView: UICollectionView?

    fileprivate var transitionDriver: TransitionDriver?

    /// Index of current cell
    open var currentIndex: Int {
        guard let collectionView = self.collectionView else { return 0 }

        let startOffset = (collectionView.bounds.size.width - itemSize.width) / 2
        guard let collectionLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return 0
        }

        let minimumLineSpacing = collectionLayout.minimumLineSpacing
        let a = collectionView.contentOffset.x + startOffset + itemSize.width / 2
        let b = itemSize.width + minimumLineSpacing
        return Int(a / b)
    }
}

// MARK: life cicle

extension ExpandingViewController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
}

// MARK: Transition

public extension ExpandingViewController {

    /**
     Pushes a view controller onto the receiver’s stack and updates the display with custom animation.

     - parameter viewController: The table view controller to push onto the stack.
     */
    func pushToViewController(_ viewController: ExpandingTableViewController) {
        guard let collectionView = self.collectionView,
            let navigationController = self.navigationController else {
            return
        }

        viewController.transitionDriver = transitionDriver
        let insets = viewController.automaticallyAdjustsScrollViewInsets
        let tabBarHeight = insets == true ? navigationController.navigationBar.frame.size.height : 0
        let stausBarHeight = insets == true ? UIApplication.shared.statusBarFrame.size.height : 0
        let backImage = getBackImage(viewController, headerHeight: viewController.headerHeight)

        transitionDriver?.pushTransitionAnimationIndex(currentIndex,
                                                       collecitionView: collectionView,
                                                       backImage: backImage,
                                                       headerHeight: viewController.headerHeight,
                                                       insets: tabBarHeight + stausBarHeight) { headerView in
            viewController.tableView.tableHeaderView = headerView
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
}

// MARK: create

extension ExpandingViewController {

    fileprivate func commonInit() {

        let layout = PageCollectionLayout(itemSize: itemSize)
        collectionView = PageCollectionView.createOnView(view,
                                                         layout: layout,
                                                         height: itemSize.height,
                                                         dataSource: self,
                                                         delegate: self)
        if #available(iOS 10.0, *) {
            collectionView?.isPrefetchingEnabled = false
        }
        transitionDriver = TransitionDriver(view: view)
    }
}

// MARK: Helpers

extension ExpandingViewController {

    fileprivate func getBackImage(_ viewController: UIViewController, headerHeight: CGFloat) -> UIImage? {
        let imageSize = CGSize(width: viewController.view.bounds.width, height: viewController.view.bounds.height - headerHeight)
        let imageFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: imageSize)
        return viewController.view.takeSnapshot(imageFrame)
    }
}

// MARK: UICollectionViewDataSource

extension ExpandingViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    open func collectionView(_: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt _: IndexPath) {
        guard case let cell as BasePageCollectionCell = cell else {
            return
        }

        cell.configureCellViewConstraintsWithSize(itemSize)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    open func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        fatalError("need emplementation in subclass")
    }

    open func collectionView(_: UICollectionView, cellForItemAt _: IndexPath) -> UICollectionViewCell {
        fatalError("need emplementation in subclass")
    }
}
