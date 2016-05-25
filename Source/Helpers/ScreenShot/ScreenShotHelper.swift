//
//  ScreenShotHelper.swift
//  TestCollectionView
//
//  Created by Alex K. on 11/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

extension UIView {
  func takeSnapshot(frame: CGRect) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
    
    let context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, frame.origin.x * -1, frame.origin.y * -1)
    
    guard let currentContext = UIGraphicsGetCurrentContext() else {
      return nil
    }
    
    self.layer.renderInContext(currentContext)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image
  }
}