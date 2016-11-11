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
        photoImageView.autoresizingMask = .flexibleWidth
        photoImageView.autoresizingMask = .flexibleHeight
        photoImageView.contentMode =  .scaleAspectFill
        photoImageView.clipsToBounds = true;
        self.contentView .addSubview(photoImageView)
        
        
        self.selectBtn = UIButton(type: .custom)
        self.selectBtn.frame = CGRect(x: self.contentView.frame.size.width - 30 - 2,y: 2,width: 30,height: 30)
        self.selectBtn.setImage(UIImage(named: "CellGreySelected"), for: .normal)
        self.selectBtn.setImage(UIImage(named: "CellBlueSelected"), for: .selected)
        self.contentView.addSubview(self.selectBtn)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
}
