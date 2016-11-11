//
//  PhotoBrowserViewController.swift
//  PhotoBrowser
//
//  Created by yeeaoo on 16/5/5.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit
import Photos

let SCREENH = UIScreen.main.bounds.height
let SCREENW = UIScreen.main.bounds.width
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
        layout.itemSize = CGSize(width: SCREENW, height: SCREENH)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = PhotoCollectionViewPadding
        layout.minimumInteritemSpacing = 0
        layout.footerReferenceSize = CGSize(width: PhotoCollectionViewPadding,height: SCREENH)


        
        let frame = UIScreen.main.bounds
        let tCollectionView: UICollectionView = UICollectionView(frame: CGRect(x: 0,y: 0,width: frame.size.width + PhotoCollectionViewPadding,height: frame.size.height), collectionViewLayout: layout)
        tCollectionView.showsVerticalScrollIndicator = false
        tCollectionView.showsHorizontalScrollIndicator = true
        tCollectionView.isPagingEnabled = true
        tCollectionView.backgroundColor = UIColor.black
        tCollectionView.bounces = true
        tCollectionView.delegate = self
        tCollectionView.dataSource = self
        tCollectionView.register(PhotoBrowserCell.self, forCellWithReuseIdentifier: "PhotoBrowserCell")

        if self.isSample == false {
            
            
            let point = CGPoint(x: CGFloat(self.currentIndexPath.row) * tCollectionView.frame.size.width,y: 0)
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

        self.view.backgroundColor = UIColor.white
        

        DispatchQueue.main.async { [weak self] ()->() in
            
            self?.view.addSubview((self?.collectionView)!)
            
            
            self?.setupToolbar()
            self?.setupTopView()

        }
        
        
        


    }
    // MARK: - 浏览图片上部分View
    private func setupTopView(){
    
        self.topView = PhotoPickerBrowserTopView(frame: CGRect(x: 0,y: 0,width: self.view.width(),height: 64))
        self.topView.addTarget(target: self, backAction: #selector(PhotoBrowserViewController.back), selectAction: #selector(PhotoBrowserViewController.selectBtnClick(_:)), controlEvents: .touchUpInside)
        self.view.addSubview(self.topView)

        self.updateSelectBtn()

    }
    // MARK: - 返回按钮点击事件
    func back()
    {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - 选择按钮点击事件
    func selectBtnClick(_ btn:UIButton)
    {
        
        //let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: self.currentIndex, inSection: 0)) as! PhotoBrowserCell
        
        let cell = self.collectionView.cellForItem(at: IndexPath(row: self.currentIndex, section: 0)) as! PhotoBrowserCell
        
        
 
        
        btn.isSelected = !btn.isSelected
        
        var removeIndex: Int!
        
        if btn.isSelected == false {
            
            //btn.addAnimation(0.3)
            
            
            for i in 0 ..< self.selectPhotosArray!.count {
                
                let model: PhotoSampleModel = self.selectPhotosArray![i] as! PhotoSampleModel
                

                if self.isSample == true {
                    
                    if i == self.currentIndex {
                        
                        self.selectPhotosArray!.remove(model)
                        removeIndex = model.index
                        break
                    }

                    
                } else {
                   
                    if model.index == self.currentIndex {
                        
                        self.selectPhotosArray!.remove(model)
                        break
                    }


                }
             }

            //self.selectPhotosArray?.removeObject(cell.scrollView.photoImageView.image!)
            if self.isSample == true {
                
                self.selectPhotoNumbesArray!.replaceObject(at: removeIndex, with: "1")

                
            } else {
                
                self.selectPhotoNumbesArray!.replaceObject(at: self.currentIndex, with: "1")

            }

            
        } else {
            
            let model = PhotoSampleModel()
            model.image = cell.scrollView.photoImageView.image!
            model.index = cell.scrollView.photoImageView.tag

            
            btn.addAnimation(durationTime: 0.3)
            self.selectPhotosArray?.add(model)
            self.selectPhotoNumbesArray!.replaceObject(at: cell.scrollView.photoImageView.tag, with: "2")

            
        }
        print(cell.scrollView.photoImageView.image)
        
        let objectArray = NSMutableArray()
        
        objectArray.add(self.selectPhotoNumbesArray!)
        objectArray.add(self.selectPhotosArray!)
        
        // 发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeSelectButton"), object: objectArray)
       // print(self.selectPhotoNumbesArray)
        
        
        self.toolBar.rightSendBtn.setTitle(String(format: "发送(%d张)",(self.selectPhotosArray?.count)!), for: .normal)
        if (self.selectPhotosArray?.count)! > 0 {
            
            self.toolBar.rightSendBtn.isSelected = true
            self.toolBar.leftBtn.isSelected = true
            self.toolBar.rightSendBtn.isEnabled = true
            self.toolBar.leftBtn.isEnabled = true

        } else {
            
            self.toolBar.rightSendBtn.isSelected = false
            self.toolBar.leftBtn.isSelected = false
            self.toolBar.rightSendBtn.isEnabled = false
            self.toolBar.leftBtn.isEnabled = false
        }

    }
    // MARK: - 更新上面View选择按钮
    private func updateSelectBtn(){
    
        // 预览
        if self.isSample == true {
            
            var index: Int! = 0
            
            // 页面加载完毕
            if self.isShowBrower == true {
                
                //let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: self.currentIndex, inSection: 0)) as! PhotoBrowserCell
                let cell = self.collectionView.cellForItem(at: IndexPath(row: self.currentIndex, section: 0)) as! PhotoBrowserCell

                index = cell.scrollView.photoImageView.tag
                
            }

            if self.selectPhotoNumbesArray![index] as! String == "2" {
                
                self.topView.selectBtn.isSelected = true
                
            } else {
                
                self.topView.selectBtn.isSelected = false
                
            }
            
            // 页面没加载完成
            if self.isShowBrower != true {
                
                self.topView.selectBtn.isSelected = true

            }


        } else {
        

        
            if self.selectPhotoNumbesArray![self.currentIndex] as! String == "2" {
                
                self.topView.selectBtn.isSelected = true
                
            } else {
                
                self.topView.selectBtn.isSelected = false
                
            }

        }
        
    }
    // MARK: - 浏览图片下部分View
    private func setupToolbar(){
        
        self.toolBar.frame = CGRect(x: 0,y: self.view.height() - 44,width: self.view.width(),height: 44)
        self.toolBar.leftBtn.isHidden = true
        self.toolBar.toolBarViewDelegate = self
        self.view.addSubview(toolBar)
    }
    //MARK: - PhotoPickerBrowserPhotoScrollViewDelegate(隐藏显示头部视图和底部视图)
    func pickerPhotoScrollViewDidSingleClick(browserPhotoScrollView: PhotoPickerBrowserPhotoImageView) {
        
        // 隐藏
        if topView.isHidden == true {
           
            topView.isHidden = false
            toolBar.isHidden = false
            
        } else {
            
            topView.isHidden = true
            toolBar.isHidden = true
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
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // 预览数组元素个数
        if self.isSample == true {
            
            return (self.samplePhotoArray.count)
        }
        // 看全部图片元素个数
        return photosArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoBrowserCell", for: indexPath as IndexPath) as! PhotoBrowserCell
        cell.resetUI()
        cell.tag = 200 + indexPath.row
        
        if self.isSample == true {
            
            print("count = \(self.samplePhotoArray.count)")
            let model: PhotoSampleModel = self.samplePhotoArray[indexPath.row] as! PhotoSampleModel

            cell.scrollView.photoImageView.image = model.image
            cell.scrollView.photoImageView.tag = model.index
            cell.scrollView.browerPhotoScrollViewDelegate = self
            
            self.layoutImageViewSize(cell: cell, image: cell.scrollView.photoImageView.image!)

            
        } else {
           
            

            let mainQueue = DispatchQueue.main
            mainQueue.async{
            
                
                self.loadImage(cell: cell, index: indexPath.item)
                
            }
              print("~~~~~~~~~")
                
 
        }
        
        self.browerScrollView = cell.scrollView
        self.currentIndexPath = indexPath as NSIndexPath!
        self.currentIndex = self.currentIndexPath.row
        self.photoImageView = cell.scrollView.photoImageView

        
        return cell
    }
    
    //MARK: - 展示图片
    private func loadImage(cell:PhotoBrowserCell, index: Int) {
        
        
        let initialRequestOptions = PHImageRequestOptions()
        // 是否同步请求，设置为false，否则会很卡
        initialRequestOptions.isSynchronous = false
        // Fast - 快速
        initialRequestOptions.resizeMode = .fast
        // HighQualityFormat - 图片高质量
        initialRequestOptions.deliveryMode = .highQualityFormat
        // 是否允许网络请求
        initialRequestOptions.isNetworkAccessAllowed = false
        
        var asset: PHAsset!

        asset = self.photosArray[index]
        print("Load Current Page \(index)")
        
        // PHImageManagerMaximumSize 获取原图 但是莫名会卡，有时候崩溃
        // 可以这样获取原图
        let targetSize = CGSize(width: CGFloat(asset.pixelWidth),height: CGFloat(asset.pixelHeight))
        // CGSizeMake(self.view.width(),self.view.height())
        if self.cacheArray![index] is String {
            
            self.imageManager.requestImage(for: asset, targetSize:targetSize , contentMode: .aspectFill, options: initialRequestOptions) { (result, info) in
                
                //print("result = \(result)")
                
                cell.scrollView.photoImageView.image = result
                cell.scrollView.photoImageView.tag = index
                cell.scrollView.browerPhotoScrollViewDelegate = self
                self.layoutImageViewSize(cell: cell, image: result!)
                
            }

        } else {
            
            cell.scrollView.photoImageView.image = self.cacheArray![index] as? UIImage
            cell.scrollView.photoImageView.tag = index
            cell.scrollView.browerPhotoScrollViewDelegate = self
            self.layoutImageViewSize(cell: cell, image: (self.cacheArray![index] as? UIImage)!)
            
        }
        
        
        
        
        // 加载缓存组
        for i in 0 ..< CachePage
        {
          
            var pid = index + i + 1
            if pid < self.photosArray.count {
                
                asset = self.photosArray[pid]
                self.cacheImage(pid: pid, asset: asset)
                //print("load page \(pid)")
                
            }
            pid = index - i - 1
            if pid >= 0 {
                
                asset = self.photosArray[pid]
                self.cacheImage(pid: pid, asset: asset)

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
                initialRequestOptions.isSynchronous = false
                // Fast - 快速
                initialRequestOptions.resizeMode = .fast
                // HighQualityFormat - 图片高质量
                initialRequestOptions.deliveryMode = .highQualityFormat
                // 是否允许网络请求
                initialRequestOptions.isNetworkAccessAllowed = false
                
                
                // PHImageManagerMaximumSize 获取原图 但是莫名会卡，有时候崩溃
                // 可以这样获取原图
                let targetSize = CGSize(width: CGFloat(asset.pixelWidth),height: CGFloat(asset.pixelHeight))
                // CGSizeMake(self.view.width(),self.view.height())
                self.imageManager.requestImage(for: asset, targetSize:targetSize , contentMode: .aspectFill, options: initialRequestOptions) { (result, info) in
                    
                    //print("result = \(result)")
                    
                    self.cacheArray?.replaceObject(at: pid, with: result!)
                }

            }
 
            
        } else {
            
        }
        
        
    }
    
    //MARK: - 调节图片大小
    private func layoutImageViewSize(cell:PhotoBrowserCell,image: UIImage){
        
        // 获取图片大小
        let imageSize = image.size
        var imageFrame = CGRect(x: 0,y: 0,width: imageSize.width,height: imageSize.height)
        let ratio = self.view.frame.size.width / imageFrame.size.width
        imageFrame.size.height = imageFrame.size.height * ratio
        imageFrame.size.width = self.view.frame.size.width
        cell.scrollView.contentSize = CGSize(width: 0,height: imageFrame.height)
        cell.scrollView.photoImageView.frame = imageFrame
        if imageFrame.height < SCREENH {
            
            cell.scrollView.photoImageView.center = CGPoint(x: self.view.frame.size.width / 2,y: self.view.frame.size.height / 2)
 
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        
    }
    //MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.currentIndex = Int(floor((scrollView.contentOffset.x - scrollView.width() / 2.0) / scrollView.width())) + 1
        
            self.updateSelectBtn()
 
        let cell = self.collectionView.viewWithTag(200 + self.currentIndex) as! PhotoBrowserCell
        if scrollView is UICollectionView {
            
            self.browerScrollView = cell.scrollView
            
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.isShowBrower = true
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 遍历selectPhotosArray数组，把每个元素分别添加到samplePhotoArray数组中
        for i in 0 ..< self.selectPhotosArray!.count {
            
            let model: PhotoSampleModel = self.selectPhotosArray![i] as! PhotoSampleModel
            self.samplePhotoArray.add(model)
        }
        
        self.cacheArray = NSMutableArray()
        for _ in 0 ..< self.photosArray.count {
            
            let str = ""
            self.cacheArray?.add(str)
            
        }
        
        
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
