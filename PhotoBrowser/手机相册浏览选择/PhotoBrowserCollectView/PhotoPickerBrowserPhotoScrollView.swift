//
//  PhotoPickerBrowserPhotoScrollView.swift
//  PhotoBrowser
//
//  Created by yeeaoo on 16/5/6.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit
import Photos
/** 协议 */
protocol PhotoPickerBrowserPhotoScrollViewDelegate: class {
    
    /** 点击事件 */
    func pickerPhotoScrollViewDidSingleClick(browserPhotoScrollView: PhotoPickerBrowserPhotoImageView)
    /** 长按手势事件 */
    func pickerPhotoScrollViewDidLongPressed(browserPhotoScrollView: PhotoPickerBrowserPhotoImageView)
    
}

class PhotoPickerBrowserPhotoScrollView: UIScrollView,UIScrollViewDelegate,PhotoPickerBrowserPhotoImageViewDelegate,PhotoPickerBrowserPhotoTouchViewDelegate
{

    /** UIScrollView上的imageView */
    var photoImageView: PhotoPickerBrowserPhotoImageView!
    /** 滚动视图协议  */
    var browerPhotoScrollViewDelegate:PhotoPickerBrowserPhotoScrollViewDelegate!
    /** 点击手势视图 */
    var tapView: PhotoPickerBrowserPhotoTouchView!
    // 是否已经放大
    var isZoomBig = false
    /** 图片数组 */
    var photosArray: Array<PHAsset>!
    // 是否点了双击手势
    var isClickDoubleTap = false

    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.setUI()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - 配置UI
    private func setUI()
    {
        
        isZoomBig = false
        
        // 点击手势视图
        tapView = PhotoPickerBrowserPhotoTouchView(frame: self.bounds)
        tapView.touchDelegate = self
        tapView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        tapView.backgroundColor = UIColor.black
        self.addSubview(tapView)
        
        // ImageView
        photoImageView = PhotoPickerBrowserPhotoImageView(frame: self.bounds)
        photoImageView.browserPhotoImageViewDelegate = self
        //photoImageView.contentMode = .Center
//        photoImageView.autoresizingMask = .FlexibleWidth
//        photoImageView.autoresizingMask = .FlexibleHeight
//        photoImageView.clipsToBounds = true;
        photoImageView.backgroundColor = UIColor.black
        self.addSubview(photoImageView)
        
        // 滚动视图
        self.backgroundColor = UIColor.black
        self.delegate = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.decelerationRate = UIScrollViewDecelerationRateFast
        self.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        self.zoomScale = 1
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 2.0
        
        // 添加手势
        let longGesTure = UILongPressGestureRecognizer(target: self, action: Selector(("longGesture:")))
        
        self.addGestureRecognizer(longGesTure)

        
        
    }
    //MARK: - 长按手势
    func longGesture(sender: UITouch)
    {
        print("长按")
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        //if self.isClickDoubleTap == true {
            
            
            let offsetX = (scrollView.width() > scrollView.contentSize.width) ?
                (scrollView.width() - scrollView.contentSize.width) / 2.0 : 0.0;
            let offsetY = (scrollView.height() > scrollView.contentSize.height) ?
                (scrollView.height() - scrollView.contentSize.height) / 2.0 : 0.0;
            
            
        self.photoImageView.center = CGPoint(x: scrollView.contentSize.width / 2.0 + offsetX,y:
                                                     scrollView.contentSize.height / 2.0 + offsetY);
//        } else {
//            
//            //self.isZoomBig = false
//        }
 
    }
//    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        
//        //print("scrollViewDidEndDecelerating")
//    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
        if scale <= 1 {
            
            self.isZoomBig = false
        }
        else {
            self.isZoomBig = true
        }
        
    }
    private func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return self.photoImageView
    }
    
    //MARK: - PhotoPickerBrowserPhotoImageViewDelegate
    func doubleTapimageView(imageView: UIImageView, touch: UITouch) {
        print("11")
        
    
        let imageViewSize = self.photoImageView.frame.size
        
        if imageViewSize.height < imageViewSize.width {
            
            
            
        } else {
            
            
            
        }

        self.isClickDoubleTap = true
        self.handleDoubleTapClick(isZoom: self.isZoomBig)
        

    }
    func singleTapImageView(imageView: UIImageView, touch: UITouch) {
        print("22")
        browerPhotoScrollViewDelegate.pickerPhotoScrollViewDidSingleClick(browserPhotoScrollView: photoImageView)

    }
    //MARK: - PhotoPickerBrowserPhotoTouchView
    func singleTapView(view: UIView, touch: UITouch)
    {
        print("33")
        browerPhotoScrollViewDelegate.pickerPhotoScrollViewDidSingleClick(browserPhotoScrollView: photoImageView)

    }
    func doubleTapView(view: UIView, touch: UITouch)
    {
        print("44")
        self.handleDoubleTapClick(isZoom: self.isZoomBig)

//        var touchX: CGFloat = touch.locationInView(view).x
//        var touchY: CGFloat = touch.locationInView(view).y
//        
//        touchX *= 1 / self.zoomScale
//        touchY *= 1 / self.zoomScale
//        
//        
//        touchX += self.contentOffset.x
//        touchY += self.contentOffset.y
//        
//        print("touchX = \(touchX) touchY = \(touchY)")

    }
    //MARK: - 处理双击手势缩放
    func handleDoubleTapClick(isZoom: Bool){
        
        if isZoom == true {
            
            self.setZoomScale(1, animated: true)
            isZoomBig = false

        }
        else {
            
            self.setZoomScale(2, animated: true)
            isZoomBig = true

        }
        
    }

    
    
    
}
