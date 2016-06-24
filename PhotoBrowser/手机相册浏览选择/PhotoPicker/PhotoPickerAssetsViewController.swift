//
//  PhotoPickerAssetsViewController.swift
//  PhotoBrowser
//
//  Created by yeeaoo on 16/4/29.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit
import Photos

let SCREEN_W = UIScreen.mainScreen().bounds.size.width
let CELL_W = (SCREEN_W-10)/4

class PhotoPickerAssetsViewController: UIViewController,PickerCollectionViewDelegate,PhotoPickerBrowserToolBarViewDelegate {

    var fetchResult :PHFetchResult!
    var assetCollection :PHAssetCollection!
    var imageArray = Array<UIImage>()
    var toolBar: PhotoPickerBrowserToolBarView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        dispatch_async(dispatch_get_main_queue()) { 
            
            
            PhotoAssets.myPhotoAssets.sharedPhotoAssets.getGroupPhotosWithGroup(self.assetCollection) { (obj) in
                
                var zAssets:Array<PHAsset> = []
                
                obj.enumerateObjectsUsingBlock({ (asset, index, stop) in
                    
                    
                    //print("asset = \(asset) index = \(index) stop = \(stop)")
                    zAssets.append(asset as! PHAsset)
                })
                
                
                self.collectionView.imageArray = zAssets
                
                print("self.imageArray = \(zAssets)")
                print("count = \(zAssets.count)")
                
                
            }

            self.setupToolbar()

            
        }
        

        
     }
    // MARK: - 浏览图片下部分View
    private func setupToolbar(){
        
        
        toolBar = PhotoPickerBrowserToolBarView(frame: CGRectMake(0, self.view.height() - 44, self.view.width(), 44))
        toolBar.toolBarViewDelegate = self
        self.view.addSubview(toolBar)
    }

    lazy var collectionView: PickerCollectionView = {
        let layout = UICollectionViewFlowLayout()
        // cell的大小
        layout.itemSize = CGSizeMake(CELL_W, CELL_W)
        // 每行的间距
        layout.minimumLineSpacing = 2
        // 每行cell内部的间距
        layout.minimumInteritemSpacing = 2
        layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
        
        let theCollectionView: PickerCollectionView = PickerCollectionView.init(frame: CGRectMake(0, 0, SCREEN_W, self.view.bounds.size.height  - 44), collectionViewLayout: layout)
        theCollectionView.photosTransitiveClosures = { (photoArray: NSMutableArray) -> Void in
            
            self.changeToolBarButtonStatus(photoArray)
            

        }
        theCollectionView.backgroundColor = UIColor.whiteColor()
        theCollectionView.showsVerticalScrollIndicator = false
        theCollectionView.showsHorizontalScrollIndicator = false
        theCollectionView.registerClass(PickerCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        theCollectionView.pickerDelegate = self
        self.view.addSubview(theCollectionView)
        return theCollectionView
        

        
        
    }()
    private func changeToolBarButtonStatus(photoArray: NSMutableArray) {
        
        
        if photoArray.count > 0 {
            
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
        
        
        self.toolBar.rightSendBtn.setTitle(String(format: "发送(%d张)",(photoArray.count)), forState: .Normal)

    }
    
    //MARK: - PickerCollectionViewDelegate
    func pickerCollectionCellSelectIndexPath(indexPath: NSIndexPath) {
        
        //print(indexPath)
        let vc = PhotoBrowserViewController()
        vc.selectPhotoNumbesArray = self.collectionView.selectPhotoNumbersArray
        vc.photosArray = self.collectionView.imageArray
        vc.toolBar = self.toolBar
        vc.selectPhotosArray  = self.collectionView.selectPhotosArray
        vc.currentIndexPath = indexPath
    
        self.presentViewController(vc, animated: true) { 
            
        }
    }
    //MARK: - PhotoPickerBrowserToolBarViewDelegate
    func toolBarViewIsOriginalBtnTouched(){
        
        let vc = PhotoBrowserViewController()
        vc.selectPhotoNumbesArray = self.collectionView.selectPhotoNumbersArray
        vc.photosArray = self.collectionView.imageArray
        vc.isSample = true
        vc.toolBar = self.toolBar
        vc.selectPhotosArray  = self.collectionView.selectPhotosArray
        self.presentViewController(vc, animated: true) {
            
        }

    }
    func toolBarViewSendBtnTouched(){
        
        
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.toolBar != nil {
            
            self.toolBar.frame = CGRectMake(0, self.view.height() - 44, self.view.width(), 44)
            self.toolBar.toolBarViewDelegate = self
            self.toolBar.leftBtn.hidden = false
            self.view.addSubview(self.toolBar)
        } else {
            
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
