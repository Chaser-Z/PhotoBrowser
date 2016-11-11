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
        
        self.backgroundColor = UIColor.black
        self.alpha = 0.7
        
        self.backBtn = UIButton(type: .custom)
        self.backBtn.frame = CGRect(x:0,y: 20,width: 60,height: 50)
        self.backBtn.setImage(UIImage(named: "btn_back_imagePicker.png"), for: .normal)
        self.addSubview(self.backBtn)
        
        
        self.selectBtn = UIButton(type: .custom)
        self.selectBtn.frame = CGRect(x: self.frame.size.width - 20 - 30,y: 20 + 7,width: 30, height: 30)
        self.selectBtn.setImage(UIImage(named: "CellGreySelected"), for: .normal)
        self.selectBtn.setImage(UIImage(named: "CellBlueSelected"), for: .selected)

        self.addSubview(self.selectBtn)

    }
    // MARK: - 点击事件
    func addTarget(target:AnyObject,backAction:Selector,selectAction:Selector,controlEvents:UIControlEvents)
    {
        self.backBtn.addTarget(target, action: backAction, for: controlEvents)
        self.selectBtn.addTarget(target, action: selectAction, for: controlEvents)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
