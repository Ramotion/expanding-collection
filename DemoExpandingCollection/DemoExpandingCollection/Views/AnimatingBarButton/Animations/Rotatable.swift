//
//  Rotatable.swift
//  TestCollectionView
//
//  Created by Alex K. on 23/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

protocol Rotatable {

  func rotateAnimationFrom(fromItem: UIView, toItem: UIView, duration: Double) 
}

extension Rotatable {

  func rotateAnimationFrom(fromItem: UIView, toItem: UIView, duration: Double) {
    
    let fromRotate  = animationFrom(0, to: M_PI, key: "transform.rotation", duration: duration)
    let fromOpacity = animationFrom(1, to: 0, key: "opacity", duration: duration)

    let toRotate    = animationFrom(-M_PI, to: 0, key: "transform.rotation", duration: duration)
    let toOpacity   = animationFrom(0, to: 1, key: "opacity", duration: duration)
    
    fromItem.layer.addAnimation(fromRotate, forKey: nil)
    fromItem.layer.addAnimation(fromOpacity, forKey: nil)
    
    toItem.layer.addAnimation(toRotate, forKey: nil)
    toItem.layer.addAnimation(toOpacity, forKey: nil)
 }
  
  private func animationFrom(from: Double, to: Double, key: String, duration: Double) -> CABasicAnimation {
    return Init(CABasicAnimation(keyPath: key)) {
      $0.duration            = duration
      $0.fromValue           = from
      $0.toValue             = to
      $0.fillMode            = kCAFillModeForwards
      $0.removedOnCompletion = false
    }
  }
}
