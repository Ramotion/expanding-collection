//
//  DemoCollectionViewCell.swift
//  TestCollectionView
//
//  Created by Alex K. on 12/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

class DemoCollectionViewCell: BasePageCollectionCell {
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var customTitle: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
      
//      customTitle.layer.shadowRadius = 3
//      customTitle.layer.shadowOpacity = 1
      
    }
}