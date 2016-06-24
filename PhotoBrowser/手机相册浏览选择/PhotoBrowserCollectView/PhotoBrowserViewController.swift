//
//  PhotoBrowserViewController.swift
//  PhotoBrowser
//
//  Created by yeeaoo on 16/5/5.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit
import Photos

let SCREENH = UIScreen.mainScreen().bounds.height
let SCREENW = UIScreen.mainScreen().bounds.width
// 图片与图片之间的间隙
let PhotoCollectionViewPadding: CGFloat = 20
// 缓存页数（暂时还没有做）
let CachePage = 2

class PhotoBrowserViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,PhotoPickerBrowserPhotoScrollViewDelegate,PhotoPickerBrowserToolBarViewDelegate {

    /** 可以选择最大照片数 */
    var maxCount: Int!
    /** 选中的NSIndexPath  */
    var currentIndexPath: NSIndexPath!
    var currentIndex: Int! = 0
    /** 是否展示图片选择器 */
    var isShowBrower: Bool = false
    /** 是否是预览 */
    var isSample: Bool = false

    /** 图片数组 */
    var photosArray: Array<PHAsset>!
    /** 选中的图片数组 */
    var selectPhotosArray: NSMutableArray?
    /** 选择的图片的index数 */
    var selectPhotoNumbesArray: NSMutableArray?
    /** 预览图片数组 */
    var samplePhotoArray: NSMutableArray = NSMutableArray()
    
    
    var cacheArray: NSMutableArray?
    var intArray: Array<Int> = Array()

    
    /** 图片选择器中ScrollView  */
    var browerScrollView: PhotoPickerBrowserPhotoScrollView!
    var topView: PhotoPickerBrowserTopView!
    var toolBar: PhotoPickerBrowserToolBarView!
    
    var photoImageView: PhotoPickerBrowserPhotoImageView!

    
    /** UICollectionView 懒加载 */
    lazy private var collectionView: UICollectionView = {
        
 

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(SCREENW, SCREENH)
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = PhotoCollectionViewPadding
        layout.minimumInteritemSpacing = 0
        layout.footerReferenceSize = CGSizeMake(PhotoCollectionViewPadding, SCREENH)


        
        let frame = UIScreen.mainScreen().bounds
        let tCollectionView: UICollectionView = UICollectionView(frame: CGRectMake(0, 0, frame.size.width + PhotoCollectionViewPadding, frame.size.height), collectionViewLayout: layout)
        tCollectionView.showsVerticalScrollIndicator = false
        tCollectionView.showsHorizontalScrollIndicator = true
        tCollectionView.pagingEnabled = true
        tCollectionView.backgroundColor = UIColor.blackColor()
        tCollectionView.bounces = true
        tCollectionView.delegate = self
        tCollectionView.dataSource = self
        tCollectionView.registerClass(PhotoBrowserCell.self, forCellWithReuseIdentifier: "PhotoBrowserCell")

        if self.isSample == false {
            
            
            let point = CGPointMake(CGFloat(self.currentIndexPath.row) * tCollectionView.frame.size.width, 0)
            tCollectionView.contentOffset = point
            //tCollectionView.scrollToItemAtIndexPath(self.currentIndexPath, atScrollPosition: .None, animated: false)

            self.currentIndex = self.currentIndexPath.row


        }
        return tCollectionView
        
    }()
    lazy var imageManager: PHCachingImageManager = {
        return PHCachingImageManager()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        dispatch_async(dispatch_get_main_queue()) { 
            
            self.view.addSubview(self.collectionView)
            
            
            self.setupToolbar()
            self.setupTopView()

        }
        
        
        


    }
    // MARK: - 浏览图片上部分View
    private func setupTopView(){
    
        self.topView = PhotoPickerBrowserTopView(frame: CGRectMake(0, 0, self.view.width(), 64))
        self.topView.addTarget(self, backAction: #selector(PhotoBrowserViewController.back), selectAction: #selector(PhotoBrowserViewController.selectBtnClick(_:)), controlEvents: .TouchUpInside)
        self.view.addSubview(self.topView)

        self.updateSelectBtn()

    }
    // MARK: - 返回按钮点击事件
    func back()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    // MARK: - 选择按钮点击事件
    func selectBtnClick(btn:UIButton)
    {
        
        let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: self.currentIndex, inSection: 0)) as! PhotoBrowserCell
 
        
        btn.selected = !btn.selected
        
        var removeIndex: Int!
        
        if btn.selected == false {
            
            //btn.addAnimation(0.3)
            
            
            for i in 0 ..< self.selectPhotosArray!.count {
                
                let model: PhotoSampleModel = self.selectPhotosArray![i] as! PhotoSampleModel
                

                if self.isSample == true {
                    
                    if i == self.currentIndex {
                        
                        self.selectPhotosArray!.removeObject(model)
                        removeIndex = model.index
                        break
                    }

                    
                } else {
                   
                    if model.index == self.currentIndex {
                        
                        self.selectPhotosArray!.removeObject(model)
                        break
                    }


                }
             }

            //self.selectPhotosArray?.removeObject(cell.scrollView.photoImageView.image!)
            if self.isSample == true {
                
                self.selectPhotoNumbesArray!.replaceObjectAtIndex(removeIndex, withObject: "1")

                
            } else {
                
                self.selectPhotoNumbesArray!.replaceObjectAtIndex(self.currentIndex, withObject: "1")

            }

            
        } else {
            
            let model = PhotoSampleModel()
            model.image = cell.scrollView.photoImageView.image!
            model.index = cell.scrollView.photoImageView.tag

            
            btn.addAnimation(0.3)
            self.selectPhotosArray?.addObject(model)
            self.selectPhotoNumbesArray!.replaceObjectAtIndex(cell.scrollView.photoImageView.tag, withObject: "2")

            
        }
        print(cell.scrollView.photoImageView.image)
        
        let objectArray = NSMutableArray()
        
        objectArray.addObject(self.selectPhotoNumbesArray!)
        objectArray.addObject(self.selectPhotosArray!)
        
        // 发送通知
        NSNotificationCenter.defaultCenter().postNotificationName("changeSelectButton", object: objectArray)
       // print(self.selectPhotoNumbesArray)
        
        
        self.toolBar.rightSendBtn.setTitle(String(format: "发送(%d张)",(self.selectPhotosArray?.count)!), forState: .Normal)
        if self.selectPhotosArray?.count > 0 {
            
            self.toolBar.rightSendBtn.selected = true
            self.toolBar.leftBtn.selected = true
            self.toolBar.rightSendBtn.enabled = true
            self.toolBar.leftBtn.enabled = true

        } else {
            
            self.toolBar.rightSendBtn.selected = false
            self.toolBar.leftBtn.selected = false
            self.toolBar.rightSendBtn.enabled = false
            self.toolBar.leftBtn.enabled = false
        }

    }
    // MARK: - 更新上面View选择按钮
    private func updateSelectBtn(){
    
        // 预览
        if self.isSample == true {
            
            var index: Int! = 0
            
            // 页面加载完毕
            if self.isShowBrower == true {
                
                let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: self.currentIndex, inSection: 0)) as! PhotoBrowserCell

                index = cell.scrollView.photoImageView.tag
                
            }

            if self.selectPhotoNumbesArray![index] as! String == "2" {
                
                self.topView.selectBtn.selected = true
                
            } else {
                
                self.topView.selectBtn.selected = false
                
            }
            
            // 页面没加载完成
            if self.isShowBrower != true {
                
                self.topView.selectBtn.selected = true

            }


        } else {
        

        
            if self.selectPhotoNumbesArray![self.currentIndex] as! String == "2" {
                
                self.topView.selectBtn.selected = true
                
            } else {
                
                self.topView.selectBtn.selected = false
                
            }

        }
        
    }
    // MARK: - 浏览图片下部分View
    private func setupToolbar(){
        
        self.toolBar.frame = CGRectMake(0, self.view.height() - 44, self.view.width(), 44)
        self.toolBar.leftBtn.hidden = true
        self.toolBar.toolBarViewDelegate = self
        self.view.addSubview(toolBar)
    }
    //MARK: - PhotoPickerBrowserPhotoScrollViewDelegate(隐藏显示头部视图和底部视图)
    func pickerPhotoScrollViewDidSingleClick(browserPhotoScrollView: PhotoPickerBrowserPhotoImageView) {
        
        // 隐藏
        if topView.hidden == true {
           
            topView.hidden = false
            toolBar.hidden = false
            
        } else {
            
            topView.hidden = true
            toolBar.hidden = true
        }

    }
    //MARK: - PhotoPickerBrowserToolBarViewDelegate
    func toolBarViewIsOriginalBtnTouched(){
        
        // 设置是预览情况
        self.isSample = true
        
    }
    func toolBarViewSendBtnTouched(){
        
        
    }
    
    func pickerPhotoScrollViewDidLongPressed(browserPhotoScrollView: PhotoPickerBrowserPhotoImageView) {
        
    }
    //MARK: - UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // 预览数组元素个数
        if self.isSample == true {
            
            return (self.samplePhotoArray.count)
        }
        // 看全部图片元素个数
        return photosArray.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoBrowserCell", forIndexPath: indexPath) as! PhotoBrowserCell
        cell.resetUI()
        cell.tag = 200 + indexPath.row
        
        if self.isSample == true {
            
            print("count = \(self.samplePhotoArray.count)")
            let model: PhotoSampleModel = self.samplePhotoArray[indexPath.row] as! PhotoSampleModel

            cell.scrollView.photoImageView.image = model.image
            cell.scrollView.photoImageView.tag = model.index
            cell.scrollView.browerPhotoScrollViewDelegate = self
            
            self.layoutImageViewSize(cell, image: cell.scrollView.photoImageView.image!)

            
        } else {
           
            

            let mainQueue = dispatch_get_main_queue()
            dispatch_async(mainQueue, {
            
                
                self.loadImage(cell, index: indexPath.item)
                
            })
              print("~~~~~~~~~")
                
 
        }
        
        self.browerScrollView = cell.scrollView
        self.currentIndexPath = indexPath
        self.currentIndex = self.currentIndexPath.row
        self.photoImageView = cell.scrollView.photoImageView

        
        return cell
    }
    
    //MARK: - 展示图片
    private func loadImage(cell:PhotoBrowserCell, index: Int) {
        
        
        let initialRequestOptions = PHImageRequestOptions()
        // 是否同步请求，设置为false，否则会很卡
        initialRequestOptions.synchronous = false
        // Fast - 快速
        initialRequestOptions.resizeMode = .Fast
        // HighQualityFormat - 图片高质量
        initialRequestOptions.deliveryMode = .HighQualityFormat
        // 是否允许网络请求
        initialRequestOptions.networkAccessAllowed = false
        
        var asset: PHAsset!

        asset = self.photosArray[index]
        print("Load Current Page \(index)")
        
        // PHImageManagerMaximumSize 获取原图 但是莫名会卡，有时候崩溃
        // 可以这样获取原图
        let targetSize = CGSizeMake(CGFloat(asset.pixelWidth), CGFloat(asset.pixelHeight))
        // CGSizeMake(self.view.width(),self.view.height())
        if self.cacheArray![index] is String {
            
            self.imageManager.requestImageForAsset(asset, targetSize:targetSize , contentMode: .AspectFill, options: initialRequestOptions) { (result, info) in
                
                //print("result = \(result)")
                
                cell.scrollView.photoImageView.image = result
                cell.scrollView.photoImageView.tag = index
                cell.scrollView.browerPhotoScrollViewDelegate = self
                self.layoutImageViewSize(cell, image: result!)
                
            }

        } else {
            
            cell.scrollView.photoImageView.image = self.cacheArray![index] as? UIImage
            cell.scrollView.photoImageView.tag = index
            cell.scrollView.browerPhotoScrollViewDelegate = self
            self.layoutImageViewSize(cell, image: (self.cacheArray![index] as? UIImage)!)
            
        }
        
        
        
        
        // 加载缓存组
        for i in 0 ..< CachePage
        {
          
            var pid = index + i + 1
            if pid < self.photosArray.count {
                
                asset = self.photosArray[pid]
                self.cacheImage(pid, asset: asset)
                //print("load page \(pid)")
                
            }
            pid = index - i - 1
            if pid >= 0 {
                
                asset = self.photosArray[pid]
                self.cacheImage(pid, asset: asset)

                //print("load page \(pid)")

            }
        }


        
    }
    //MARK: - 缓存图片，内存缓存
    private func cacheImage(pid: Int,asset: PHAsset) {
        
        if self.cacheArray![pid] is String {
            
            if self.cacheArray![pid] as! String == "" {
                
                let initialRequestOptions = PHImageRequestOptions()
                // 是否同步请求，设置为false，否则会很卡
                initialRequestOptions.synchronous = false
                // Fast - 快速
                initialRequestOptions.resizeMode = .Fast
                // HighQualityFormat - 图片高质量
                initialRequestOptions.deliveryMode = .HighQualityFormat
                // 是否允许网络请求
                initialRequestOptions.networkAccessAllowed = false
                
                
                // PHImageManagerMaximumSize 获取原图 但是莫名会卡，有时候崩溃
                // 可以这样获取原图
                let targetSize = CGSizeMake(CGFloat(asset.pixelWidth), CGFloat(asset.pixelHeight))
                // CGSizeMake(self.view.width(),self.view.height())
                self.imageManager.requestImageForAsset(asset, targetSize:targetSize , contentMode: .AspectFill, options: initialRequestOptions) { (result, info) in
                    
                    //print("result = \(result)")
                    
                    self.cacheArray?.replaceObjectAtIndex(pid, withObject: result!)
                }

            }
 
            
        } else {
            
        }
        
        
    }
    
    //MARK: - 调节图片大小
    private func layoutImageViewSize(cell:PhotoBrowserCell,image: UIImage){
        
        // 获取图片大小
        let imageSize = image.size
        var imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height)
        let ratio = self.view.frame.size.width / imageFrame.size.width
        imageFrame.size.height = imageFrame.size.height * ratio
        imageFrame.size.width = self.view.frame.size.width
        cell.scrollView.contentSize = CGSizeMake(0, imageFrame.height)
        cell.scrollView.photoImageView.frame = imageFrame
        if imageFrame.height < SCREENH {
            
            cell.scrollView.photoImageView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
 
        }

        
        
//        // 调整图片在滚动视图上的位置
//        let offsetX = (cell.scrollView.width() > cell.scrollView.contentSize.width) ?
//            (cell.scrollView.width() - cell.scrollView.contentSize.width) / 2.0 : 0.0;
//        let offsetY = (cell.scrollView.height() > cell.scrollView.contentSize.height) ?
//            (cell.scrollView.height() - cell.scrollView.contentSize.height) / 2.0 : 0.0;
//
//        cell.scrollView.photoImageView.center = CGPointMake(cell.scrollView.contentSize.width / 2.0 + offsetX,
//                                                 cell.scrollView.contentSize.height / 2.0 + offsetY);
       
        
        
        
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    //MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        self.currentIndex = Int(floor((scrollView.contentOffset.x - scrollView.width() / 2.0) / scrollView.width())) + 1
        
            self.updateSelectBtn()
 
        let cell = self.collectionView.viewWithTag(200 + self.currentIndex) as! PhotoBrowserCell
        if scrollView is UICollectionView {
            
            self.browerScrollView = cell.scrollView
            
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        self.isShowBrower = true
        

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 遍历selectPhotosArray数组，把每个元素分别添加到samplePhotoArray数组中
        for i in 0 ..< self.selectPhotosArray!.count {
            
            let model: PhotoSampleModel = self.selectPhotosArray![i] as! PhotoSampleModel
            self.samplePhotoArray.addObject(model)
        }
        
        self.cacheArray = NSMutableArray()
        for _ in 0 ..< self.photosArray.count {
            
            let str = ""
            self.cacheArray?.addObject(str)
            
        }
        
        
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
