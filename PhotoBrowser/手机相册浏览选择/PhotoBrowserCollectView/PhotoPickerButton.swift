//
//  PhotoPickerButton.swift
//  PhotoBrowser
//
//  Created by yeeaoo on 16/5/6.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit

class PhotoPickerButton: UIButton {

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.setupUI()
    }
    private func setupUI() {
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension UIButton {
    
    func addAnimation(durationTime: Double) {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.removedOnCompletion = true
        
        let animationZoomOut = CABasicAnimation(keyPath: "transform.scale")
        animationZoomOut.fromValue = 0
        animationZoomOut.toValue = 1.2
        animationZoomOut.duration = 3/4 * durationTime
        
        let animationZoomIn = CABasicAnimation(keyPath: "transform.scale")
        animationZoomIn.fromValue = 1.2
        animationZoomIn.toValue = 1.0
        animationZoomIn.beginTime = 3/4 * durationTime
        animationZoomIn.duration = 1/4 * durationTime
        
        groupAnimation.animations = [animationZoomOut, animationZoomIn]
        self.layer.addAnimation(groupAnimation, forKey: "addAnimation")
    }

}