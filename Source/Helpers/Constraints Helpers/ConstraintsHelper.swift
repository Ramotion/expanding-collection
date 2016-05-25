//
//  ConstraintsHelper.swift
//  TestCollectionView
//
//  Created by Alex K. on 05/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

struct ConstraintInfo {
  var attribute: NSLayoutAttribute = .Left
  var secondAttribute: NSLayoutAttribute = .NotAnAttribute
  var constant: CGFloat = 0
  var identifier: String?
  var relation: NSLayoutRelation = .Equal
}

infix operator >>>- { associativity left precedence 150 }

func >>>- <T: UIView> (left: (T, T), @noescape block: (inout ConstraintInfo) -> ()) -> NSLayoutConstraint {
  var info = ConstraintInfo()
  block(&info)
  info.secondAttribute = info.secondAttribute == .NotAnAttribute ? info.attribute : info.secondAttribute
  
  let constraint = NSLayoutConstraint(item: left.1,
                                      attribute: info.attribute,
                                      relatedBy: info.relation,
                                      toItem: left.0,
                                      attribute: info.secondAttribute,
                                      multiplier: 1,
                                      constant: info.constant)
  constraint.identifier = info.identifier
  left.0.addConstraint(constraint)
  return constraint
}

func >>>- <T: UIView> (left: T, @noescape block: (inout ConstraintInfo) -> ()) -> NSLayoutConstraint {
  var info = ConstraintInfo()
  block(&info)
  
  let constraint = NSLayoutConstraint(item: left,
                                      attribute: info.attribute,
                                      relatedBy: info.relation,
                                      toItem: nil,
                                      attribute: info.attribute,
                                      multiplier: 1,
                                      constant: info.constant)
  constraint.identifier = info.identifier
  left.addConstraint(constraint)
  return constraint
}

func >>>- <T: UIView> (left: (T, T, T), @noescape block: (inout ConstraintInfo) -> ()) -> NSLayoutConstraint {
  var info = ConstraintInfo()
  block(&info)
  info.secondAttribute = info.secondAttribute == .NotAnAttribute ? info.attribute : info.secondAttribute
  
  let constraint = NSLayoutConstraint(item: left.1,
                                      attribute: info.attribute,
                                      relatedBy: info.relation,
                                      toItem: left.2,
                                      attribute: info.secondAttribute,
                                      multiplier: 1,
                                      constant: info.constant)
  constraint.identifier = info.identifier
  left.0.addConstraint(constraint)
  return constraint
}

// MARK: UIView

extension UIView {
  
  func addScaleToFillConstratinsOnView(view: UIView) {
    [NSLayoutAttribute.Left, .Right, .Top, .Bottom].forEach { attribute in
      (self, view) >>>- { $0.attribute = attribute }
    }
  }
  
  func getConstraint(attributes: NSLayoutAttribute) -> NSLayoutConstraint? {
    return constraints.filter {
      if $0.firstAttribute == attributes && $0.secondItem == nil {
        return true
      }
      return false
    }.first
  }


}
