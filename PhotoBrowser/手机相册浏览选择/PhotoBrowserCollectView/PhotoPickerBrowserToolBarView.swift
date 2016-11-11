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
        self.backgroundColor = UIColor.black
        self.alpha = 0.7
        self .createButton()
    }
    private func createButton(){
        
        self.leftBtn = self.setupButton(image: nil, title: "预览", titleColor: UIColor.white,unSelectedTitleColor: UIColor.gray ,target: self, action: #selector(PhotoPickerBrowserToolBarView.letfBtnClick),isLeft: true)
        self.leftBtn.isSelected = false
        self.leftBtn.isEnabled = false
        
        self.rightSendBtn = self.setupButton(image: nil, title: "发送", titleColor: UIColor.green, unSelectedTitleColor: UIColor.gray ,target: self, action: #selector(PhotoPickerBrowserToolBarView.sendPhotosClick), isLeft: false)
        self.rightSendBtn.isSelected = false
        self.rightSendBtn.isEnabled = false

        self.addSubview(self.leftBtn)
        self.addSubview(self.rightSendBtn)
        
        //let fiexItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        //self.toolBar.items = [self.leftBtn,fiexItem,self.rightSendBtn]
        
    }
    private func setupButton(image:UIImage?,title: String,titleColor: UIColor,unSelectedTitleColor: UIColor,target: AnyObject,action: Selector,isLeft: Bool) -> UIButton {
        
        let button = UIButton(type: .custom)
        if  isLeft == true {
            
            button.frame = CGRect(x:0,y: 0,width: 100,height: 44)
            button.titleLabel?.textAlignment = .left
            
        } else {
            
            button.frame = CGRect(x: self.width() - 100,y: 0,width: 100,height: 44)
            button.titleLabel?.textAlignment = .right

        }
        button.setTitle(title, for: .normal)
        button.setTitleColor(unSelectedTitleColor, for: .normal)
        button.setTitleColor(titleColor, for: .selected)
        if image != nil {
            
            button.setImage(image, for: .normal)

        }
        button.addTarget(target, action: action, for: .touchUpInside)


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
