//
//  AnimationBarButton.swift
//  TestCollectionView
//
//  Created by Alex K. on 23/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

fileprivate final class CustomView: UIView {
    var onLayoutSubviews: () -> Void = {}

    override func layoutSubviews() {
        super.layoutSubviews()
        onLayoutSubviews()
    }
}

class AnimatingBarButton: UIBarButtonItem, Rotatable {

    @IBInspectable var normalImageName: String = ""
    @IBInspectable var selectedImageName: String = ""

    @IBInspectable var duration: Double = 1

    let normalView = UIImageView(frame: .zero)
    let selectedView = UIImageView(frame: .zero)
}

// MARK: life cicle

extension AnimatingBarButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        let view = CustomView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        view.onLayoutSubviews = { [weak self] in self?.configurateImageViews() }
        customView = view
    }
}

// MARK: public

extension AnimatingBarButton {

    func animationSelected(_ selected: Bool) {
        if selected {
            rotateAnimationFrom(normalView, toItem: selectedView, duration: duration)
        } else {
            rotateAnimationFrom(selectedView, toItem: normalView, duration: duration)
        }
    }
}

// MARK: Create

extension AnimatingBarButton {

    fileprivate func configurateImageViews() {
        configureImageView(normalView, imageName: normalImageName)
        configureImageView(selectedView, imageName: selectedImageName)

        selectedView.alpha = 0
    }

    fileprivate func configureImageView(_ imageView: UIImageView, imageName: String) {
        guard let customView = customView else { return }
        guard let image = UIImage(named: imageName)?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate) else { return }

        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = tintColor

        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowRadius = 0.6
        imageView.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        imageView.layer.shadowOpacity = 0.3

        let x = (customView.bounds.size.width - image.size.width) / 2 + 12
        let y = (customView.bounds.size.height - image.size.height) / 2
        imageView.frame = CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        customView.addSubview(imageView)
    }
}
