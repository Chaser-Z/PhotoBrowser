//
//  PhotoPickerBrowserTopView.swift
//  PhotoBrowser
//
//  Created by yeeaoo on 16/5/6.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit

class PhotoPickerBrowserTopView: UIView {

    var backBtn: UIButton!
    var selectBtn: UIButton!

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.setupUI()
    }
    private func setupUI(){
        
        self.backgroundColor = UIColor.blackColor()
        self.alpha = 0.7
        
        self.backBtn = UIButton(type: .Custom)
        self.backBtn.frame = CGRectMake(0, 20, 60, 50)
        self.backBtn.setImage(UIImage(named: "btn_back_imagePicker.png"), forState: .Normal)
        self .addSubview(self.backBtn)
        
        
        self.selectBtn = UIButton(type: .Custom)
        self.selectBtn.frame = CGRectMake(self.frame.size.width - 20 - 30, 20 + 7, 30, 30)
        self.selectBtn.setImage(UIImage(named: "CellGreySelected"), forState: .Normal)
        self.selectBtn.setImage(UIImage(named: "CellBlueSelected"), forState: .Selected)

        self.addSubview(self.selectBtn)

    }
    // MARK: - 点击事件
    func addTarget(target:AnyObject,backAction:Selector,selectAction:Selector,controlEvents:UIControlEvents)
    {
        self.backBtn.addTarget(target, action: backAction, forControlEvents: controlEvents)
        self.selectBtn.addTarget(target, action: selectAction, forControlEvents: controlEvents)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
