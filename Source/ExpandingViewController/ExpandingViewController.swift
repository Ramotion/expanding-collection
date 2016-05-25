//
//  PageViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 05/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

public class ExpandingViewController: UIViewController {
  
  public var itemSize = CGSize(width: 256, height: 335)
  public var collectionView: UICollectionView?
  private var transitionDriver: TransitionDriver?
  
  public var currentIndex: Int {
    guard let collectionView = self.collectionView else { return 0 }
    
    let startOffset = (collectionView.bounds.size.width - itemSize.width) / 2
    return Int((collectionView.contentOffset.x + startOffset) / (itemSize.width + 25))
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

extension ExpandingViewController {
  
  func pushToViewController(viewController: ExpandingTableViewController) {
    guard let collectionView = self.collectionView else {
      return
    }
    
    viewController.transitionDriver = transitionDriver
    let backImage = getBackImage(viewController, headerHeight: viewController.headerHeight)
    
    transitionDriver?.pushTransitionAnimationIndex(currentIndex, collecitionView: collectionView, backImage: backImage) { headerView in
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

extension ExpandingViewController: UICollectionViewDataSource, UICollectionViewDelegate{
  
  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    fatalError("need emplementation in subclass")
  }
  
  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    fatalError("need emplementation in subclass")
  }
}

