//
//  DemoTableViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 24/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

class DemoTableViewController: ExpandingTableViewController {
  
}
// MARK: Helpers

extension DemoTableViewController {
  
  private func getScreen() -> UIImage? {
    let height = (headerHeight - tableView.contentOffset.y) < 0 ? 0 : (headerHeight - tableView.contentOffset.y)
    let backImageSize = CGSize(width: view.bounds.width, height: view.bounds.height - height)
    let backImageOrigin = CGPoint(x: 0, y: height + tableView.contentOffset.y)
    return view.takeSnapshot(CGRect(origin: backImageOrigin, size: backImageSize))
  }
  
}

// MARK: Actions

extension DemoTableViewController {
  
  @IBAction func backButtonHandler(sender: AnyObject) {
    guard let transitionDriver = self.transitionDriver else {
      return
    }
    // buttonAnimation
    for case let viewController as DemoViewController in navigationController!.viewControllers {
      if case let rightButton as AnimatingBarButton = viewController.navigationItem.rightBarButtonItem {
        rightButton.animationSelected(false)
      }
    }
    let backImage = getScreen()
    let offset = tableView.contentOffset.y > headerHeight ? headerHeight : tableView.contentOffset.y
    transitionDriver.popTransitionAnimationContantOffset(offset, backImage: backImage)
    self.navigationController?.popViewControllerAnimated(false)
  }
}