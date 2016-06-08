//
//  PageViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 05/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

/// UIViewController with UICollectionView with custom transition method
public class ExpandingViewController: UIViewController {
  
  /// The default size to use for cells.
  public var itemSize = CGSize(width: 256, height: 335)
  
  ///  The collection view object managed by this view controller.
  public var collectionView: UICollectionView?
  
  private var transitionDriver: TransitionDriver?
  
  /// Index of current cell
  public var currentIndex: Int {
    guard let collectionView = self.collectionView else { return 0 }
    
    let startOffset = (collectionView.bounds.size.width - itemSize.width) / 2
    guard let collectionLayout  = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
      return 0
    }
    
    let minimumLineSpacing = collectionLayout.minimumLineSpacing
    return Int((collectionView.contentOffset.x + startOffset + itemSize.width / 2) / (itemSize.width + minimumLineSpacing))
  }
}

// MARK: life cicle

extension ExpandingViewController {
  
  public override func viewDidLoad() {
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
  func pushToViewController(viewController: ExpandingTableViewController) {
    guard let collectionView = self.collectionView,
    let navigationController = self.navigationController else {
      return
    }
    
    viewController.transitionDriver = transitionDriver
    let insets = viewController.automaticallyAdjustsScrollViewInsets
    let tabBarHeight =  insets == true ? navigationController.navigationBar.frame.size.height : 0
    let stausBarHeight = insets == true ? UIApplication.sharedApplication().statusBarFrame.size.height : 0
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
  
  private func commonInit() {
    
    let layout = PageCollectionLayout(itemSize: itemSize)
    collectionView = PageCollectionView.createOnView(view,
                                                     layout: layout,
                                                     height: itemSize.height + itemSize.height / 5 * 2,
                                                     dataSource: self,
                                                     delegate: self)
    transitionDriver = TransitionDriver(view: view)
  }
}

// MARK: Helpers

extension ExpandingViewController {
  
  private func getBackImage(viewController: UIViewController, headerHeight: CGFloat) -> UIImage? {
    let imageSize = CGSize(width: viewController.view.bounds.width, height: viewController.view.bounds.height - headerHeight)
    let imageFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: imageSize)
    return viewController.view.takeSnapshot(imageFrame)
  }

}

// MARK: UICollectionViewDataSource

extension ExpandingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
  public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    guard case let cell as BasePageCollectionCell = cell else {
      return
    }
    
    cell.configureCellViewConstraintsWithSize(itemSize)
  }
  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    fatalError("need emplementation in subclass")
  }
  
  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    fatalError("need emplementation in subclass")
  }
}

// MARK: UIScrollViewDelegate 

extension ExpandingViewController {
  
  public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    let indexPath = NSIndexPath(forRow: currentIndex, inSection: 0)
    if case let currentCell as BasePageCollectionCell = collectionView?.cellForItemAtIndexPath(indexPath) {
      currentCell.configurationCell()
    }
  }
}

