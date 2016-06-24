//
//  ViewController.swift
//  PhotoBrowser
//
//  Created by yeeaoo on 16/4/15.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var imageArray: [AnyObject]! = []
    var srcStringArray: Array<String>!
    var highQualityArray: Array<String>!
    var nav: UINavigationController!
    var vc: PhotoPickerGroupViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        

        
        
        highQualityArray = [
            "http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg",
            "http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg",
            "http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
            "http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg",
            "http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr0nly5j20pf0gygo6.jpg",
            "http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg",
            "http://ww4.sinaimg.cn/bmiddle/677febf5gw1erma1g5xd0j20k0esa7wj.jpg",
            "http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg",
            "http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg"
        ]

        
        srcStringArray = [
            "http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg",
            "http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg",
            "http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
            "http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg",
            "http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr0nly5j20pf0gygo6.jpg",
            "http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg",
            "http://ww4.sinaimg.cn/thumbnail/677febf5gw1erma1g5xd0j20k0esa7wj.jpg",
            "http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg",
            "http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg"
        ]

        
        for i in 0 ..< 9
        {
           let imageStr = String(format: "pic%d.jpg", i)
            imageArray.append(imageStr)
        }
        
        // 每一格的尺寸
        let cellW: CGFloat = 100;
        let cellH: CGFloat = 100;
        // 间隙
        let margin: CGFloat = (self.view.width() - 3 * cellW) / 4
        
        for i in 0 ..< 9
        {
            
            // 计算行号  和   列号
            let row = i / 3
            let col = i % 3
            //根据行号和列号来确定 子控件的坐标 
            let cellX:CGFloat = margin + CGFloat(col) * (cellW + margin)
            let cellY:CGFloat = 100 + CGFloat(row) * (cellH + margin)

            
            let imageView = UIImageView(frame: CGRectMake(cellX, cellY, cellW, cellH))
            //print("imageView.frame = \(imageView.frame)")
            imageView.userInteractionEnabled = true
            imageView.image = UIImage(named:  imageArray[i] as! String)
            
            
            //imageView.sd_setImageWithURL(NSURL(string: srcStringArray[i]))
            
            // tag设置为i（暂时固定，可以后期修改）
            imageView.tag = i
            
            self.view.addSubview(imageView)
            let  tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapImageGesture(_:)))
            imageView.addGestureRecognizer(tapGesture)
        }
         

        print("haha")
        
        
        
        let button = UIButton(type: .Custom)
        button.frame = CGRectMake(0, 60, self.view.width(), 30)
        button.addTarget(self, action: #selector(ViewController.btnClick), forControlEvents: .TouchUpInside)
        button.setTitle("下一页", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.blueColor()
        self.view.addSubview(button)
        
        
        let button1 = UIButton(type: .Custom)
        button1.frame = CGRectMake(100, self.view.height() - 70,30, 30)
        button1.addTarget(self, action: #selector(ViewController.click), forControlEvents: .TouchUpInside)
        
        button1.setImage(UIImage(named: "CellGreySelected"), forState: .Normal)
        self.view.addSubview(button1)


        
    }
    func click(btn: UIButton)
    {
        btn.selected = !btn.selected
        
        if btn.selected == false {
            
            print("111")
            btn.setImage(UIImage(named: "CellGreySelected"), forState: .Normal)
            //btn.addAnimation(0.3)

        } else {
           
            print("222")
            btn.addAnimation(0.3)
            btn.setImage(UIImage(named: "CellBlueSelected"), forState: .Normal)

        }
        
    }
    func btnClick()
    {
        //self.navigationController?.pushViewController(vc, animated: true)
//        self.presentViewController(vc, animated: true) {
//            
//        }
        vc = PhotoPickerGroupViewController()
        self.nav = UINavigationController(rootViewController: vc)

        self.presentViewController(self.nav, animated: false, completion: nil)
    }
    func tapImageGesture(tapGesture: UITapGestureRecognizer)
    {
        PhotoBrowser.show(self.imageArray, index: tapGesture.view!.tag, item: tapGesture.view!, column: 3,type:ImageType.Local, showView: self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

