//
//  DemoTableViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 24/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

class DemoTableViewController: ExpandingTableViewController {
  
  private var scrollOffsetY: CGFloat = 0
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavBar()
    tableView.backgroundView = UIImageView(image: UIImage.Asset.BackgroundImage.image)
  }
}
// MARK: Helpers

extension DemoTableViewController {
  
  private func configureNavBar() {
    navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    navigationItem.rightBarButtonItem?.image = navigationItem.rightBarButtonItem?.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
  }
}

// MARK: Actions

extension DemoTableViewController {
  
  @IBAction func backButtonHandler(sender: AnyObject) {
    // buttonAnimation
    for case let viewController as DemoViewController in navigationController!.viewControllers {
      if case let rightButton as AnimatingBarButton = viewController.navigationItem.rightBarButtonItem {
        rightButton.animationSelected(false)
      }
    }
    popTransitionAnimation()
  }
}

// MARK: UIScrollViewDelegate

extension DemoTableViewController {
  
  override func scrollViewDidScroll(scrollView: UIScrollView) {
    if scrollView.contentOffset.y < -25 {
      // buttonAnimation
      for case let viewController as DemoViewController in navigationController!.viewControllers {
        if case let rightButton as AnimatingBarButton = viewController.navigationItem.rightBarButtonItem {
          rightButton.animationSelected(false)
        }
      }
      popTransitionAnimation()
    }
    
    scrollOffsetY = scrollView.contentOffset.y
  }
}