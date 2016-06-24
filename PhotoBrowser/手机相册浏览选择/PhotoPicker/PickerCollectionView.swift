//
//  PickerCollectionView.swift
//  PhotoBrowser
//
//  Created by yeeaoo on 16/5/3.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit
import Photos

protocol PickerCollectionViewDelegate {
    
    func pickerCollectionCellSelectIndexPath(indexPath: NSIndexPath)
    
}


class PickerCollectionView: UICollectionView, UICollectionViewDelegate,UICollectionViewDataSource {
    
    var dataArray: PHFetchResult!
    var imageArray: Array<PHAsset>!
    /** 获取的高清图 */
    var highImage: UIImage!
    /** 选中的图片 */
    var selectPhotosArray = NSMutableArray()
    /** 闭包 */
    var photosTransitiveClosures: ((photoArray: NSMutableArray) -> Void)?
    /** 选择的图片的index  */
    lazy var selectPhotoNumbersArray: NSMutableArray = {
        
        var array = NSMutableArray()
        for i in 0 ..< self.imageArray.count{
            array.addObject("1")
        }
        return array
    }()

    var pickerDelegate: PickerCollectionViewDelegate!

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor.clearColor()
        self.dataSource = self
        self.delegate = self
        
        // 通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PickerCollectionView.receiveNotic(_:)), name: "changeSelectButton", object: nil)

        
    }
    //MARK: - 接收通知并刷新状态
    func receiveNotic(notic: NSNotification) {
        
        
        let objectArray: NSMutableArray = notic.object as! NSMutableArray
        self.selectPhotoNumbersArray = objectArray[0] as! NSMutableArray
        self.selectPhotosArray = objectArray[1] as! NSMutableArray
        //print("notic = \(notic)")
        //print("收到通知")
        self.reloadData()
    }
    

    lazy var imageManager: PHCachingImageManager = {
        return PHCachingImageManager()
    }()

    
    //MARK: - UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.imageArray.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PickerCollectionViewCell
        
 
        // 获取图片像素
        self.getImagePixels(index: indexPath.item, isHitgQualityImage: false, cell: cell,btn: nil)
        
        return cell
        
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       
        //print(indexPath.row)
        self.pickerDelegate.pickerCollectionCellSelectIndexPath(indexPath)
        

    }
    // MARK: - 获取图片清晰程度
    private func getImagePixels(index index: Int,isHitgQualityImage: Bool,cell: PickerCollectionViewCell?,btn: UIButton?) {
        
        let scale = UIScreen.mainScreen().scale
        var size: CGSize!
        let asset = self.imageArray[index]
        // 如果清晰图
        if isHitgQualityImage == true {
            
            // 可以这样获取原图
           size  = CGSizeMake(CGFloat(asset.pixelWidth), CGFloat(asset.pixelHeight))
            //size = CGSizeMake(self.frame.width  , self.frame.height)
            
        } else {
            
            size = CGSizeMake(CELL_W * scale, CELL_W * scale)
        }
        
        
        let initialRequestOptions = PHImageRequestOptions()
        // 是否同步请求，设置为false，否则会很卡
        initialRequestOptions.synchronous = false
        // Fast - 快速
        initialRequestOptions.resizeMode = .Fast
        // HighQualityFormat - 图片高质量
        initialRequestOptions.deliveryMode = .HighQualityFormat
        // 是否允许网络请求
        initialRequestOptions.networkAccessAllowed = false
        
        imageManager.requestImageForAsset(asset, targetSize: size, contentMode: .AspectFill, options: initialRequestOptions) { (result, info) in
            
            //print("row = \(indexPath.row) resutl = \(result)")
            // 如果是cell获取的图片
            if cell != nil {
               
                cell!.photoImageView.image = result
                
                cell!.selectBtn.tag = index
                cell!.selectBtn.addTarget(self, action: #selector(PickerCollectionView.click(_:)), forControlEvents: .TouchUpInside)
                if self.selectPhotoNumbersArray[index] as! String == "2" {
                    
                    cell!.selectBtn.selected = true
                    
                } else {
                    cell!.selectBtn.selected = false
                }

                
            } else {
                
                // 不是cell上获取的图片
                //self.highImage = result
                

                
                btn!.selected = !btn!.selected
                
                if btn!.selected == false {
                    
                    for i in 0 ..< self.selectPhotosArray.count {
                        
                        let model: PhotoSampleModel = self.selectPhotosArray[i] as! PhotoSampleModel
                        if model.index == btn?.tag {
                           
                            self.selectPhotosArray.removeObject(model)
                            break

                        }
                    }
                    
                    self.selectPhotoNumbersArray.replaceObjectAtIndex(btn!.tag, withObject: "1")
                    
                } else {
                    

                    let model = PhotoSampleModel()
                    model.image = result
                    model.index = btn?.tag
                    
                    btn!.addAnimation(0.3)
                    self.selectPhotoNumbersArray.replaceObjectAtIndex(btn!.tag, withObject: "2")
                    self.selectPhotosArray.addObject(model)
                    
                }

                self.photosTransitiveClosures!(photoArray: self.selectPhotosArray)
            }
            
            
        }

            
        
    }
    //MARK: - 对勾按钮点击事件
    func click(btn: UIButton)
    {
        // 获取图片像素（这里获取的是高清图）
        self.getImagePixels(index: btn.tag, isHitgQualityImage: true, cell: nil,btn: btn)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
