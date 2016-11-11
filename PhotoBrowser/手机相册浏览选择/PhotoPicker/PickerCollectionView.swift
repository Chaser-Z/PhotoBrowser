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
    
    
    var dataArray: PHFetchResult<AnyObject>!
    var imageArray: Array<PHAsset>!
    /** 获取的高清图 */
    var highImage: UIImage!
    /** 选中的图片 */
    var selectPhotosArray = NSMutableArray()
    /** 闭包 */
    var photosTransitiveClosures: ((_ photoArray: NSMutableArray) -> Void)?
    /** 选择的图片的index  */
    lazy var selectPhotoNumbersArray: NSMutableArray = {
        
        var array = NSMutableArray()
        for i in 0 ..< self.imageArray.count{
            array.add("1")
        }
        return array
    }()

    var pickerDelegate: PickerCollectionViewDelegate!

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor.clear
        self.dataSource = self
        self.delegate = self
        
        // 通知
        NotificationCenter.default.addObserver(self, selector: #selector(PickerCollectionView.receiveNotic(_:)), name: NSNotification.Name(rawValue: "changeSelectButton"), object: nil)

        
    }
    //MARK: - 接收通知并刷新状态
    func receiveNotic(_ notic: NSNotification) {
        
        
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
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.imageArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! PickerCollectionViewCell
        
 
        // 获取图片像素
        self.getImagePixels(index: indexPath.item, isHitgQualityImage: false, cell: cell,btn: nil)
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        //print(indexPath.row)
        self.pickerDelegate.pickerCollectionCellSelectIndexPath(indexPath: indexPath as NSIndexPath)
        

    }
    // MARK: - 获取图片清晰程度
    private func getImagePixels(index: Int,isHitgQualityImage: Bool,cell: PickerCollectionViewCell?,btn: UIButton?) {
        
        let scale = UIScreen.main.scale
        var size: CGSize!
        let asset = self.imageArray[index]
        // 如果清晰图
        if isHitgQualityImage == true {
            
            // 可以这样获取原图
            size  = CGSize(width: CGFloat(asset.pixelWidth),height: CGFloat(asset.pixelHeight))
            //size = CGSizeMake(self.frame.width  , self.frame.height)
            
        } else {
            
            size = CGSize(width: CELL_W * scale,height: CELL_W * scale)
        }
        
        
        let initialRequestOptions = PHImageRequestOptions()
        // 是否同步请求，设置为false，否则会很卡
        initialRequestOptions.isSynchronous = false
        // Fast - 快速
        initialRequestOptions.resizeMode = .fast
        // HighQualityFormat - 图片高质量
        initialRequestOptions.deliveryMode = .highQualityFormat
        // 是否允许网络请求
        initialRequestOptions.isNetworkAccessAllowed = false
        
        imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: initialRequestOptions) { (result, info) in
            
            //print("row = \(indexPath.row) resutl = \(result)")
            // 如果是cell获取的图片
            if cell != nil {
               
                cell!.photoImageView.image = result
                
                cell!.selectBtn.tag = index
                cell!.selectBtn.addTarget(self, action: #selector(PickerCollectionView.click(_:)), for: .touchUpInside)
                if self.selectPhotoNumbersArray[index] as! String == "2" {
                    
                    cell!.selectBtn.isSelected = true
                    
                } else {
                    cell!.selectBtn.isSelected = false
                }

                
            } else {
                
                // 不是cell上获取的图片
                //self.highImage = result
                

                
                btn!.isSelected = !btn!.isSelected
                
                if btn!.isSelected == false {
                    
                    for i in 0 ..< self.selectPhotosArray.count {
                        
                        let model: PhotoSampleModel = self.selectPhotosArray[i] as! PhotoSampleModel
                        if model.index == btn?.tag {
                           
                            self.selectPhotosArray.remove(model)
                            break

                        }
                    }
                    
                    self.selectPhotoNumbersArray.replaceObject(at: btn!.tag, with: "1")
                    
                } else {
                    

                    let model = PhotoSampleModel()
                    model.image = result
                    model.index = btn?.tag
                    
                    btn!.addAnimation(durationTime: 0.3)
                    self.selectPhotoNumbersArray.replaceObject(at: btn!.tag, with: "2")
                    self.selectPhotosArray.add(model)
                    
                }

                self.photosTransitiveClosures!(self.selectPhotosArray)
            }
            
            
        }

            
        
    }
    //MARK: - 对勾按钮点击事件
    func click(_ btn: UIButton)
    {
        // 获取图片像素（这里获取的是高清图）
        self.getImagePixels(index: btn.tag, isHitgQualityImage: true, cell: nil,btn: btn)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
