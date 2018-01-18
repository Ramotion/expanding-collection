//
//  ScreenShotHelper.swift
//  TestCollectionView
//
//  Created by Alex K. on 11/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

extension UIView {
    func takeSnapshot(_ frame: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: frame.origin.x * -1, y: frame.origin.y * -1)

        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return nil
        }

        layer.render(in: currentContext)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
