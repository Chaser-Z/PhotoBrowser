//
//  PhotoPickerBrowserToolBarView.swift
//  PhotoBrowser
//
//  Created by yeeaoo on 16/5/6.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit

protocol PhotoPickerBrowserToolBarViewDelegate {
    
    func toolBarViewIsOriginalBtnTouched()
    func toolBarViewSendBtnTouched()
    
}

class PhotoPickerBrowserToolBarView: UIView {

    var toolBarViewDelegate: PhotoPickerBrowserToolBarViewDelegate!
    //var toolBar: UIToolbar!
    /** 左边按钮 */
    var leftBtn: UIButton!
    /** 右边发送按钮 */
    var rightSendBtn: UIButton!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUI(){
        
//        self.toolBar = UIToolbar(frame: CGRectMake(0,0,self.width(),self.height()))
//        self.toolBar.barTintColor = UIColor.blackColor()
//        self.toolBar.alpha = 0.7
//        self.addSubview(self.toolBar)
        self.backgroundColor = UIColor.blackColor()
        self.alpha = 0.7
        self .createButton()
    }
    private func createButton(){
        
        self.leftBtn = self.setupButton(nil, title: "预览", titleColor: UIColor.whiteColor(),unSelectedTitleColor: UIColor.grayColor() ,target: self, action: #selector(PhotoPickerBrowserToolBarView.letfBtnClick),isLeft: true)
        self.leftBtn.selected = false
        self.leftBtn.enabled = false
        
        self.rightSendBtn = self.setupButton(nil, title: "发送", titleColor: UIColor.greenColor(), unSelectedTitleColor: UIColor.grayColor() ,target: self, action: #selector(PhotoPickerBrowserToolBarView.sendPhotosClick), isLeft: false)
        self.rightSendBtn.selected = false
        self.rightSendBtn.enabled = false

        self.addSubview(self.leftBtn)
        self.addSubview(self.rightSendBtn)
        
        //let fiexItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        //self.toolBar.items = [self.leftBtn,fiexItem,self.rightSendBtn]
        
    }
    private func setupButton(image:UIImage?,title: String,titleColor: UIColor,unSelectedTitleColor: UIColor,target: AnyObject,action: Selector,isLeft: Bool) -> UIButton {
        
        let button = UIButton(type: .Custom)
        if  isLeft == true {
            
            button.frame = CGRectMake(0, 0, 100, 44)
            button.titleLabel?.textAlignment = .Left
            
        } else {
            
            button.frame = CGRectMake(self.width() - 100, 0, 100, 44)
            button.titleLabel?.textAlignment = .Right

        }
        button.setTitle(title, forState: .Normal)
        button.setTitleColor(unSelectedTitleColor, forState: .Normal)
        button.setTitleColor(titleColor, forState: .Selected)
        if image != nil {
            
            button.setImage(image, forState: .Normal)

        }
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)


        //let barButton: UIBarButtonItem = UIBarButtonItem(customView: button)
         return button

    }
    func letfBtnClick(){
        
        print("左边")
        self.toolBarViewDelegate.toolBarViewIsOriginalBtnTouched()
    }
    func sendPhotosClick(){
        print("右边")
        self.toolBarViewDelegate.toolBarViewSendBtnTouched()
    }
    

}
