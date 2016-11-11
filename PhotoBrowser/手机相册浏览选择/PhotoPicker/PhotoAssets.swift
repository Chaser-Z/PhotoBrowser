//
//  PhotoAssets.swift
//  PhotoBrowser
//
//  Created by yeeaoo on 16/5/3.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary


typealias groupCallBackClosure = (_ obj:AnyObject) -> ()


class PhotoAssets: NSObject {

    let IOS9_OR_LATER = UIDevice.current.systemVersion.compare("9.0") != .orderedAscending
    
    var asset: PHAsset!
    /** 缩略图 */
    var thumbImage: UIImage?
    /** 压缩原图 */
    var compressionImage: UIImage?
    /** 原图 */
    var originImage: UIImage?
    var fullResolutionImage: UIImage?
    /** 获取是否是视频类型 */
    var isVideoType: Bool?
    /** 获取相册的URL */
    var assetURL: NSURL?
    let scale = UIScreen.main.scale
    var fetchResult :PHFetchResult<PHAsset>!

    
    
//    private func getThumbImage() -> UIImage
//    {
//        if IOS9_OR_LATER
//        {
//            self.asset.
//        }
//    }
    class myPhotoAssets: NSObject
    {
        static let sharedPhotoAssets = PhotoAssets()
        private override init() {
            
        }
    }
    
    

    
    func getGroupPhotosWithGroup(assetCollection:PHAssetCollection?, finished:groupCallBackClosure){
        
        let initialRequestOptions = PHImageRequestOptions()
        // 是否同步请求，设置为false，否则会很卡
        initialRequestOptions.isSynchronous = false
        // Fast - 快速
        initialRequestOptions.resizeMode = .fast
        // HighQualityFormat - 图片高质量
        initialRequestOptions.deliveryMode = .fastFormat
        // 是否允许网络请求
        initialRequestOptions.isNetworkAccessAllowed = false


        if assetCollection != nil
        {
            self.fetchResult = PHAsset.fetchAssets(in: assetCollection!, options: nil)

        }
        else
        {
            self.fetchResult = PHAsset.fetchAssets(with: nil)

        }
        
        
        finished(self.fetchResult)
        
        
    }
    
    
}
