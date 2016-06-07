//
//  TableViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 06/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

/// Base class for UITableViewcontroller which have back transition method
public class ExpandingTableViewController: UITableViewController {
  
  // MARK: Vars
  /// The height of the table view header
  public var headerHeight: CGFloat = 236
  
  var transitionDriver: TransitionDriver?
}

// MARK: Helpers 

extension ExpandingTableViewController {
  
  private func getScreen() -> UIImage? {
    let height = (headerHeight - tableView.contentOffset.y) < 0 ? 0 : (headerHeight - tableView.contentOffset.y)
    let backImageSize = CGSize(width: view.bounds.width, height: view.bounds.height - height)
    let backImageOrigin = CGPoint(x: 0, y: height + tableView.contentOffset.y)
    return view.takeSnapshot(CGRect(origin: backImageOrigin, size: backImageSize))
  }
}

// MARK: Methods

extension ExpandingTableViewController {
  
  /**
   Pops the top view controller from the navigation stack and updates the display with custom animation.
   */
  public func popTransitionAnimation() {
    guard let transitionDriver = self.transitionDriver else {
      return
    }
    
    let backImage = getScreen()
    let offset = tableView.contentOffset.y > headerHeight ? headerHeight : tableView.contentOffset.y
    transitionDriver.popTransitionAnimationContantOffset(offset, backImage: backImage)
    self.navigationController?.popViewControllerAnimated(false)
  }

}