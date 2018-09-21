//
//  Rotatable.swift
//  TestCollectionView
//
//  Created by Alex K. on 23/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

protocol Rotatable {

    func rotateAnimationFrom(_ fromItem: UIView, toItem: UIView, duration: Double)
}

extension Rotatable {

    func rotateAnimationFrom(_ fromItem: UIView, toItem: UIView, duration: Double) {

        let fromRotate = animationFrom(0, to: Double.pi, key: "transform.rotation", duration: duration)
        let fromOpacity = animationFrom(1, to: 0, key: "opacity", duration: duration)

        let toRotate = animationFrom(-Double.pi, to: 0, key: "transform.rotation", duration: duration)
        let toOpacity = animationFrom(0, to: 1, key: "opacity", duration: duration)

        fromItem.layer.add(fromRotate, forKey: nil)
        fromItem.layer.add(fromOpacity, forKey: nil)

        toItem.layer.add(toRotate, forKey: nil)
        toItem.layer.add(toOpacity, forKey: nil)
    }

    fileprivate func animationFrom(_ from: Double, to: Double, key: String, duration: Double) -> CABasicAnimation {
        return Init(CABasicAnimation(keyPath: key)) {
            $0.duration = duration
            $0.fromValue = from
            $0.toValue = to
            $0.fillMode = CAMediaTimingFillMode.forwards
            $0.isRemovedOnCompletion = false
        }
    }
}
