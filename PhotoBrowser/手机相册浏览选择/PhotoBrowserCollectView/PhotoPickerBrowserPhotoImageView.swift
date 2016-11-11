//
//  PhotoPickerBrowserPhotoImageView.swift
//  PhotoBrowser
//
//  Created by yeeaoo on 16/5/6.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit

protocol PhotoPickerBrowserPhotoImageViewDelegate {
    
    // 双击手势协议
    func doubleTapimageView(imageView: UIImageView,touch: UITouch)
    // 单机手势协议
    func singleTapImageView(imageView: UIImageView,touch: UITouch)
}


class PhotoPickerBrowserPhotoImageView: UIImageView {

    
    // 退出手势
    private var exitTapGesture: UITapGestureRecognizer!
    // 双击手势
    private var tapGesture: UITapGestureRecognizer!
    // 协议
    var browserPhotoImageViewDelegate: PhotoPickerBrowserPhotoImageViewDelegate!

    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        // 添加手势
        self.addGesTure()
    }
    //MARK: - 添加手势
    private func addGesTure()
    {
        self.contentMode = .scaleAspectFit
        // 退出手势
        self.exitTapGesture = UITapGestureRecognizer(target: self, action:#selector(PhotoPickerBrowserPhotoImageView.handleExitGesture(_:)));
        self.addGestureRecognizer(exitTapGesture);
        // 双击手势
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(PhotoPickerBrowserPhotoImageView.handleTapGesture(_:)));
        self.tapGesture.numberOfTapsRequired = 2;
        self.addGestureRecognizer(tapGesture);
        // 关键在这一行，如果双击确定偵測失败才會触发单击
        self.exitTapGesture.require(toFail: tapGesture);

    }
    //MARK: - 退出手势
    func handleExitGesture(_ sender: UITouch)
    {
        browserPhotoImageViewDelegate.singleTapImageView(imageView: self, touch: sender)
    }
    //MARK: - 双击手势
    func handleTapGesture(_ sender: UITouch)
    {
        browserPhotoImageViewDelegate.doubleTapimageView(imageView: self, touch: sender)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
