//
//  PhotoBrowser.swift
//  PhotoBrowser
//
//  Created by yeeaoo on 16/4/15.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit

// 协议
@objc protocol GestureImageViewDelegate {
    
    optional func gestureImageViewExit()
}

class GestureImageView: UIImageView {
    
    // 退出手势
    private var exitTapGesture: UITapGestureRecognizer!;
    // 双击手势
    private var tapGesture: UITapGestureRecognizer!;
    // 是否已经放大
    var isZoomBig = false;
    // 协议
    var delegate: GestureImageViewDelegate!;
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI()
    {
        self.userInteractionEnabled = true;
        // 退出手势
        self.exitTapGesture = UITapGestureRecognizer(target: self, action: #selector(GestureImageView.handleExitGesture(_:)));
        self.addGestureRecognizer(exitTapGesture);
        // 双击手势
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(GestureImageView.handleTapGesture(_:)));
        self.tapGesture.numberOfTapsRequired = 2;
        self.addGestureRecognizer(tapGesture);
        // 关键在这一行，如果双击确定偵測失败才會触发单击
        self.exitTapGesture.requireGestureRecognizerToFail(tapGesture);

    }
    //MARK: - 退出手势
    func handleExitGesture(sender: UITapGestureRecognizer)
    {
        //print("\(sender.view)")

        
        let scrollView = self.superview as! UIScrollView;
        scrollView.setZoomScale(1, animated: false);
        self.delegate?.gestureImageViewExit?();
    }
    //MARK: - 双击手势
    func handleTapGesture(sender: UITapGestureRecognizer)
    {
        
        print(self.superview)
        
        let scrollView = self.superview as! UIScrollView;
        if self.isZoomBig {
            scrollView.setZoomScale(1, animated: true);
        }else {
            scrollView.setZoomScale(2.5, animated: true);
        }
        self.isZoomBig = !self.isZoomBig;
    }

    
    
}

// 枚举
enum ImageType {
    // 网络图片
    case Net
    // 本地图片
    case Local
}


class PhotoBrowser: UIView, UIScrollViewDelegate, GestureImageViewDelegate {
    
    // 网络图片还是本地图片
    var imageType: ImageType?
    // 图片url数组
    private var imagesArray: [AnyObject]!
    /** 滚动视图 */
    private var mainScrollView: UIScrollView!
    // 当前滚动视图
    private var currentScrollView: UIScrollView!
    // 当前此变量没有作用
    private var index = 0
    // 动画时间
    private var zoomAniationTime = 0.3
    // 当前选中index
    private var currentIndex = 0;
    // 当前此变量没有作用
    private var column = 0
    // 当前选中图片
    private var currentImageView: GestureImageView!
    // 图片tag
    private let imageViewTag = 10
    /** 背景View */
    private var backgroundView: UIView!
    // 点击图片原有后的位置
    private var rect: CGRect!
    // label
    private var showTextLabelHeight: CGFloat = 20
    private var showTextLabel: UILabel!
    // 当前是否展现图片浏览器
    private var isShowPhotoBrowser: Bool = false
    // 图片浏览器展示的view
    private var showView: AnyObject!
    
    //MARK: - 展示图片浏览器
    class func show(imagesArray: [AnyObject],index: Int, item: UIView, column: Int,type: ImageType,showView: UIView) ->PhotoBrowser {
        
        return PhotoBrowser(frame: UIScreen.mainScreen().bounds, imagesArray: imagesArray, index: index, rect: item.convertRect(item.bounds, toView: (UIApplication.sharedApplication().delegate?.window)!), column: column,type: type,showView: showView)
        
    }
    //MARK: - 初始化
    init(frame: CGRect, imagesArray: [AnyObject], index: Int, rect: CGRect, column: Int,type:ImageType,showView: UIView) {
        
        super.init(frame: frame)
        self.imagesArray = imagesArray
        self.index = index
        self.currentIndex = index
        self.column = column
        self.rect = rect
        self.imageType = type
        self.showView = showView

        self.layoutUI()
    }
    
    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }
    //MARK: - 搭建UI
    private func layoutUI()
    {
        // 背景View
        self.backgroundView = UIView(frame: UIScreen.mainScreen().bounds)
        self.backgroundView.backgroundColor = UIColor.blackColor()
        self.backgroundView.alpha = 0
        UIApplication.sharedApplication().delegate?.window??.addSubview(self.backgroundView)
        
        self.backgroundColor = UIColor.clearColor()
        
        // 滚动视图
        self.mainScrollView = UIScrollView(frame: self.bounds)
        self.mainScrollView.tag = 999
        self.mainScrollView.bounces = false
        self.mainScrollView.delegate = self
        self.mainScrollView.showsVerticalScrollIndicator = false
        self.mainScrollView.showsHorizontalScrollIndicator = false
        self.addSubview(self.mainScrollView)
        
        
        // 遍历图片数组
        if  self.imagesArray.count > 0
        {
            // swift提供一个enumerate函数来遍历数组，会同时返回数据项和索引值
            for (i ,image) in self.imagesArray.enumerate()
            {
            
                
                // 创建滚动视图
                let imageScrollView = UIScrollView(frame: CGRectMake(CGFloat(i) * self.width(),0,self.width(),self.height()))
                imageScrollView.bounces = false
                // 创建imageView
                let imageView = GestureImageView(frame: imageScrollView.bounds)
                imageView.delegate = self
                
                // 如果点击的图片tag = i
                if self.currentIndex == i
                {
                    // 当前选中的图片
                    self.currentImageView = imageView
                    self.currentScrollView = imageScrollView
                }
                imageView.tag = imageViewTag + i;
                // 把imageView添加到滚动视图上
               imageScrollView.addSubview(imageView);
                imageScrollView.delegate = self
                imageScrollView.multipleTouchEnabled = true
                // 设置最大最小缩放
                imageScrollView.minimumZoomScale = 1.0
                imageScrollView.maximumZoomScale = 2.5
                imageScrollView.backgroundColor = UIColor.clearColor()
                imageScrollView.tag = i
                // 添加到主滚动视图上
                self.mainScrollView.addSubview(imageScrollView)
                
                // 本地图片
                if self.imageType == ImageType.Local
                {
                    var imageObject: UIImage!
                    if image is UIImage
                    {
                        imageObject = image as! UIImage
                    }
                    else if image is String
                    {
                        let imageName: String = image  as! String;
                        imageObject = UIImage(named: imageName)
                        print(imageObject.size)

                    }
                    // 设置imageView的frame
                    if imageObject.size.width < imageScrollView.width()
                    {
                        imageView.setWidth(imageObject.size.width);
                    }
                    
                    if imageObject.size.height < imageScrollView.height()
                    {
                        imageView.setHeight(imageObject.size.height)
                    }
                    // 调整位置
                    imageView.setXy(CGPointMake((imageScrollView.width() - imageView.width()) / 2.0, (imageScrollView.height() - imageView.height()) / 2.0))
                    
                    imageView.image = imageObject

                }

                
            }
            
            // 本地图片
            if self.imageType == ImageType.Local
            {
                isShowPhotoBrowser = true
                self.addBeginAnimation()
            }
            
            // 网络图片
            if self.imageType == ImageType.Net
            {
                
                self.layoutNetImageViewSize(self.currentImageView,imageStr: self.imagesArray[self.currentIndex] as! String,imageScrollView: self.currentScrollView)
                
            }

            
            
            
        }
        
        
    }
    //MARK: - 添加开始动画
    private func addBeginAnimation()
    {
        self.mainScrollView.pagingEnabled = true
        // 偏移量
        self.mainScrollView.contentSize = CGSizeMake(CGFloat(self.imagesArray.count) * self.mainScrollView.width(), self.height())
        self.mainScrollView.setContentOffset(CGPointMake(CGFloat(self.index) * self.width(), 0), animated: false)
        // 把该图片浏览器放到主窗口上
        UIApplication.sharedApplication().delegate?.window??.addSubview(self);
        
        // 调整浏览图片后ImageView的位置
        var rc = CGRectMake(0, 0, self.currentImageView.width(), self.currentImageView.height());
        rc.origin = CGPointMake((self.width() - currentImageView.width()) / 2.0, (self.height() - currentImageView.height()) / 2.0);
        // 图片的高度大于页面高度
        if self.currentImageView.image?.size.height >= self.height()
        {
            // y坐标置为0
            rc.origin.y = 0

        }
        
        // 当前图片的位置
        self.currentImageView.frame = self.rect;
        
        // 添加动画
        UIView.animateWithDuration(zoomAniationTime, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
            
            // 图片在浏览器中的位置
            self.currentImageView.frame = rc;
            // 背景颜色出现
            self.backgroundView.alpha = 1.0;
            }, completion: nil);
 
    }
    
    
    //MARK: - 处理网络图片大小
    private func layoutNetImageViewSize(imageView: GestureImageView,imageStr:String,imageScrollView: UIScrollView)
    {
        
        imageView.sd_setImageWithURL(NSURL(string:  imageStr), placeholderImage: nil, options: .RetryFailed, progress:
            { (receivedSize, expectedSize) in
                
                print(receivedSize)
                
        }) { (image, error, cacheType, imageURL) in
            
            if (error != nil){
                print(error.debugDescription)
                print(error.description)
                print("haha")
                
            }
            else
            {
                
                // 获取图片大小
                let imageSize = imageView.image?.size
                print(imageSize)
                
                var imageFrame = CGRectMake(0, 0, imageSize!.width, imageSize!.height)
                
                let ratio = self.backgroundView.width() / imageFrame.size.width
                imageFrame.size.height = imageFrame.size.height * ratio
                imageFrame.size.width = self.backgroundView.width()
                
                // 设置imageView的frame
                imageView.frame = imageFrame
                // 设置每个滚动视图的contentSize
                imageScrollView.contentSize = CGSizeMake(0, imageView.height())
                
                // 调整图片在滚动视图上的位置
                imageView.setXy(CGPointMake((imageScrollView.width() - imageView.width()) / 2.0, (imageScrollView.height() - imageView.height()) / 2.0))
                // 如果图片高度大于视图高度
                if imageView.height() >= self.height()
                {
                    // 调整图片在滚动视图上的位置
                    
                    imageView.setXy(CGPointMake((imageScrollView.width() - imageView.width()) / 2.0, 0))
                    
                }

                if self.isShowPhotoBrowser == false
                {
                    self.addBeginAnimation()
                    self.isShowPhotoBrowser = true

                }
             }
            
        }
        
        
        
//        let URL = NSURL(string: imageStr)
//        let isExists = SDWebImageManager.sharedManager().cachedImageExistsForURL(URL)
//        let key = SDWebImageManager.sharedManager().cacheKeyForURL(URL) ?? ""
//
//        if isExists{
//            
//            let cacheImage = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(key)
//
//            imageView.image = cacheImage
//        }
//        else
//        {
//            imageView.sd_setImageWithURL(URL)
//
//        }
        
        
        
        // 加载网络图片
        //imageView.sd_setImageWithURL(NSURL(string:  imageStr))
    }
    
    //MARK: - (结束动画)GestureImageViewDelegate
    func gestureImageViewExit() {
        
        let subView = self.mainScrollView.viewWithTag(self.currentIndex)
        self.currentImageView = subView?.viewWithTag(imageViewTag + self.currentIndex) as! GestureImageView
        
        // 隐藏currentImageView
        self.currentImageView.hidden = true
        
        // 新建中间tempView
        let tempView = UIImageView()
        tempView.clipsToBounds = true
        tempView.image = self.currentImageView.image
        
        let h = (self.width() / (self.currentImageView.image?.size.width)!) * (currentImageView.image?.size.height)!
        tempView.bounds = CGRectMake(0, 0, self.width(), h)
        tempView.center = self.center
        self .addSubview(tempView)
        
        
        // 展示的view
        var view: UIView!
        if self.showView is UICollectionView {
            
            let collectView = self.showView as! UICollectionView
            let path = NSIndexPath(forItem: self.currentIndex, inSection: 0)
            view = collectView.cellForItemAtIndexPath(path)


        }
        else if self.showView is UIView{
            
            view = self.showView.subviews[self.currentIndex + 2]

        }
        // 取得位置
        let targetTemp: CGRect = self.showView.convertRect(view.frame, toView: self)
        //let rc = self.getExitRect()
        UIView.animateWithDuration(zoomAniationTime, delay: 0, options: .CurveEaseOut, animations: {
            
            self.backgroundView.alpha = 0
            tempView.frame = targetTemp
            }) { (finish) in
                
              self.backgroundView.removeFromSuperview()
                self.removeFromSuperview()
        }
        
        
        self.isShowPhotoBrowser = true
    }
    //MARK: - 结束为止（暂时不用）
    private func getExitRect() -> CGRect
    {
        var rc = CGRectMake(0, 0, CGRectGetWidth(self.rect), CGRectGetHeight(self.rect))
        var startRect = CGRectMake(0, 0, CGRectGetWidth(self.rect), CGRectGetHeight(self.rect))
        if self.index < self.column
        {
            startRect.origin.x = CGRectGetMinX(self.rect) - CGFloat(self.index) * CGRectGetWidth(self.rect)
            startRect.origin.y = CGRectGetMinY(self.rect);
        }
        else
        {
            let row = ((self.index + 1) / self.column + ((self.index + 1) % self.column != 0 ? 1 : 0) - 1);
            let col = ((self.index + 1) % self.column == 0 ? self.column : (self.index + 1) % self.column) - 1;
            startRect.origin.x = CGRectGetMinX(self.rect) - CGFloat(col) * CGRectGetWidth(self.rect);
            startRect.origin.y = CGRectGetMinY(self.rect) - CGFloat(row) * CGRectGetHeight(self.rect);

        }
        
        if self.currentIndex < self.column
        {
            rc.origin.x = CGRectGetMinX(startRect) + CGFloat(self.currentIndex) * CGRectGetWidth(self.rect);
            rc.origin.y = CGRectGetMinY(startRect);
        }
        else
        {
            let row = ((self.currentIndex + 1) / self.column + ((self.currentIndex + 1) % self.column != 0 ? 1 : 0) - 1);
            let col = ((self.currentIndex + 1) % self.column == 0 ? self.column : (self.currentIndex + 1) % self.column) - 1;
            rc.origin.x = CGRectGetMinX(startRect) + CGFloat(col) * CGRectGetWidth(self.rect);
            rc.origin.y = CGRectGetMinY(startRect) + CGFloat(row) * CGRectGetHeight(self.rect);
        }
        return rc;

        
    }
    //MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
      
        if self.mainScrollView === scrollView
        {
            self.currentIndex = Int(floor((scrollView.contentOffset.x - scrollView.width() / 2.0) / scrollView.width())) + 1;
            if self.currentIndex < 0
            {
                self.currentIndex = 0;
            }
            else if self.currentIndex > self.imagesArray.count
            {
                self.currentIndex = self.imagesArray.count - 1;
            }
            // self.showLabel.text = "\(self.images.count) / \(self.currentIndex + 1)";

            let subView = self.mainScrollView.viewWithTag(self.currentIndex)!
            
            print(self.currentIndex)
            print(subView)
            
            // 当前图片
            self.currentImageView = subView.viewWithTag(imageViewTag  + self.currentIndex) as! GestureImageView
            // 当前滚动视图
            self.currentScrollView = subView.viewWithTag(self.currentIndex) as! UIScrollView
            // 加载网络图片
            if self.imageType == ImageType.Net
            {
                self.layoutNetImageViewSize(self.currentImageView, imageStr: self.imagesArray[self.currentIndex] as! String, imageScrollView: self.currentScrollView)

            }
        }

    }
    // 当正在缩放的时候调用
    func scrollViewDidZoom(scrollView: UIScrollView)
    {
        
        if scrollView !== self.mainScrollView
        {
            let offsetX = (scrollView.width() > scrollView.contentSize.width) ?
                (scrollView.width() - scrollView.contentSize.width) / 2.0 : 0.0;
            let offsetY = (scrollView.height() > scrollView.contentSize.height) ?
                (scrollView.height() - scrollView.contentSize.height) / 2.0 : 0.0;
            

            self.currentImageView.center = CGPointMake(scrollView.contentSize.width / 2.0 + offsetX,
                                                       scrollView.contentSize.height / 2.0 + offsetY);
        }

        
    }
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat)
    {
        
        if scale <= 1
        {
            self.currentImageView.isZoomBig = false;
        }
        else
        {
            self.currentImageView.isZoomBig = true;
        }

        
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        
        if scrollView !== self.mainScrollView
        {
            let subView = self.mainScrollView.viewWithTag(self.currentIndex)!;
            self.currentImageView = subView.viewWithTag(imageViewTag  + self.currentIndex) as! GestureImageView;
            return self.currentImageView;
        }
        return nil;
    }


}
