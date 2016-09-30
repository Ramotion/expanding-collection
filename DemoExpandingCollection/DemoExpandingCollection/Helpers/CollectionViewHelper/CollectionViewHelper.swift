//
//  CollectionViewHelper.swift
//  TestCollectionView
//
//  Created by Alex K. on 04/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

extension UICollectionView {

  func getReusableCellWithIdentifier<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T where T: CollectionViewCellIdentifiable {
    guard let cell = dequeueReusableCell(withReuseIdentifier: T.cellIdentifier, for: indexPath) as? T else {
      fatalError("Couldn't instantiate view controller with identifier \(T.cellIdentifier) ")
    }
    
    return cell
  }
}

// MARK: UITableViewCell

protocol CollectionViewCellIdentifiable {
  static var cellIdentifier: String { get }
}

extension CollectionViewCellIdentifiable where Self: UICollectionViewCell {
  static var cellIdentifier: String {
    return String(describing: self)
  }
}

extension UICollectionViewCell : CollectionViewCellIdentifiable { }
