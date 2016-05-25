//
//  TableViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 06/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

public class ExpandingTableViewController: UITableViewController {
  
  // MARK: Vars

  var headerHeight: CGFloat = 236
  var transitionDriver: TransitionDriver?
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
 }
}