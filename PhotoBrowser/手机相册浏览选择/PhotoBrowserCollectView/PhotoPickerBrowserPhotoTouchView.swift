//
//  PhotoPickerBrowserPhotoTouchView.swift
//  PhotoBrowser
//
//  Created by yeeaoo on 16/5/6.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit

// 协议
protocol PhotoPickerBrowserPhotoTouchViewDelegate {
    
    // 单击
    func singleTapView(view: UIView,touch: UITouch)
    // 双击
    func doubleTapView(view: UIView,touch: UITouch)
    
}

class PhotoPickerBrowserPhotoTouchView: UIView {

    var touchDelegate: PhotoPickerBrowserPhotoTouchViewDelegate!
    
    // 退出手势
    private var exitTapGesture: UITapGestureRecognizer!
    // 双击手势
    private var tapGesture: UITapGestureRecognizer!

    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        // 添加手势
        self.addGesTure()
    }
    //MARK: - 添加手势
    private func addGesTure()
    {
        // 退出手势
        self.exitTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleExitGesture(_:)));
        self.addGestureRecognizer(exitTapGesture);
        // 双击手势
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(_:)));
        self.tapGesture.numberOfTapsRequired = 2;
        self.addGestureRecognizer(tapGesture);
        // 关键在这一行，如果双击确定偵測失败才會触发单击
        self.exitTapGesture.require(toFail: tapGesture);
        
    }
    //MARK: - 退出手势
    func handleExitGesture(_ sender: UITouch)
    {
        touchDelegate.singleTapView(view: self, touch: sender)
    }
    //MARK: - 双击手势
    func handleTapGesture(_ sender: UITouch)
    {
        touchDelegate.doubleTapView(view: self, touch: sender)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    

}
