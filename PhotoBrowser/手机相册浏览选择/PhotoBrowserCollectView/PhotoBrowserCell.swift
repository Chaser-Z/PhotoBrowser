//
//  PhotoBrowserCell.swift
//  PhotoBrowser
//
//  Created by yeeaoo on 16/5/6.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit

class PhotoBrowserCell: UICollectionViewCell {
    
    
    
    //var photoImageView: PhotoPickerBrowserPhotoImageView!
    var scrollView: PhotoPickerBrowserPhotoScrollView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        
    }
    private func setUI()
    {
        let tempFrame = UIScreen.main.bounds
        let scrollBoxView = UIView()
        scrollBoxView.frame = tempFrame
        self.contentView.addSubview(scrollBoxView)
        
        self.scrollView = PhotoPickerBrowserPhotoScrollView(frame: tempFrame)
        scrollBoxView.addSubview(self.scrollView)
        
        
    }
    func resetUI() {
        
        self.scrollView.zoomScale = self.scrollView.minimumZoomScale
        self.scrollView.isZoomBig = false
        self.scrollView.isClickDoubleTap = false
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 2.0
        self.scrollView.zoomScale = 1
        self.scrollView.setZoomScale(1.0, animated: false)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
}
