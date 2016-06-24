//
//  PickerCollectionViewCell.swift
//  PhotoBrowser
//
//  Created by yeeaoo on 16/5/3.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit

class PickerCollectionViewCell: UICollectionViewCell {
    
    var photoImageView: UIImageView!
    var selectBtn: UIButton!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        
    }
    private func setUI()
    {
        photoImageView = UIImageView(frame: self.contentView.bounds)
        photoImageView.autoresizingMask = .FlexibleWidth
        photoImageView.autoresizingMask = .FlexibleHeight
        photoImageView.contentMode =  .ScaleAspectFill
        photoImageView.clipsToBounds = true;
        self.contentView .addSubview(photoImageView)
        
        
        self.selectBtn = UIButton(type: .Custom)
        self.selectBtn.frame = CGRectMake(self.contentView.frame.size.width - 30 - 2, 2, 30, 30)
        self.selectBtn.setImage(UIImage(named: "CellGreySelected"), forState: .Normal)
        self.selectBtn.setImage(UIImage(named: "CellBlueSelected"), forState: .Selected)
        self.contentView.addSubview(self.selectBtn)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
}
