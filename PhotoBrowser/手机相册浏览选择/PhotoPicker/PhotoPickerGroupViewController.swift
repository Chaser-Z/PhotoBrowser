//
//  PhotoPickerGroupViewController.swift
//  PhotoBrowser
//
//  Created by yeeaoo on 16/4/27.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit
import AssetsLibrary
import Photos


class PhotoPickerGroupViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var groupTableView: UITableView!
    var groupsArray: Array<PhotoModel>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        self.automaticallyAdjustsScrollViewInsets = false

        

        let navigationBarappearace = UINavigationBar.appearance()
        navigationBarappearace.translucent = false
        navigationBarappearace.barTintColor = UIColor.yellowColor()
        
        
        let rightItem = UIBarButtonItem.init(title: "取消", style: .Plain, target: self, action: #selector(PhotoPickerGroupViewController.addApp(_:)))
        self.navigationItem.rightBarButtonItem = rightItem;

        
        
        self.title = "选择相册"

        

        
        //self.addNavBarCancelButton()
        
        
        self.groupsArray = []
        
        self.view.backgroundColor = UIColor.yellowColor()
        
        let author = PHPhotoLibrary.authorizationStatus()
        //let author = ALAssetsLibrary.authorizationStatus()
        PHAuthorizationStatus.Restricted
        if author == PHAuthorizationStatus.Restricted || author == .Denied
        {
            print("访问权限被关闭了，请前往设置->隐私->照片中设定")
        }
        else
        {
            self.tableView()
            self.getAllImage()
        }

    }
    func addApp(sender:UIBarButtonItem){
        
        self.dismissViewControllerAnimated(true, completion: nil)
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func addNavBarCancelButton()
    {
        let temporaryBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(self.testbtn))
        self.navigationItem.rightBarButtonItem = temporaryBarButtonItem
    }
    func testbtn()
    {
       print("111111")
    }
    //MARK: - 创建tableview
    private func tableView() -> UITableView
    {
        if (self.groupTableView == nil)
        {
            self.groupTableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 64), style: .Plain)
            self.groupTableView.separatorStyle = .None
            self.groupTableView.delegate = self
            self.groupTableView.dataSource = self
            self.view.addSubview(self.groupTableView)
        }
        return self.groupTableView
    }
    //MARK: - 获取图片
    private func getAllImage()
    {
        
        let albumOptions = PHFetchOptions()
        albumOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let userAlbum = PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .AlbumRegular, options: nil)
        
        userAlbum.enumerateObjectsUsingBlock { (collection, index, stop) -> Void in
            let coll = collection as! PHAssetCollection
            let assert = PHAsset.fetchAssetsInAssetCollection(coll, options: nil)
            
            if assert.count > 0 {
                
                print(assert.count)
                //let ass = assert[0] as! PHAsset
                //print("mediaType = \(ass.mediaType)")
                
                print("coll.localizedTitle = \(coll.localizedTitle)")
                // 过滤非图片
                if coll.localizedTitle == "Screenshots" || coll.localizedTitle == "Recently Added" || coll.localizedTitle == "Camera Roll" || coll.localizedTitle == "Selfies"{
                    
                    var title: String!
                    
                    if coll.localizedTitle == "Screenshots" {
                        title = "屏幕快照"
                    }
                    if coll.localizedTitle == "Recently Added" {
                        
                        title = "最近添加"

                    }
                    if coll.localizedTitle == "Camera Roll" {
                        
                        title = "相机胶卷"
                    }
                    if coll.localizedTitle == "Selfies" {
                        title = "自拍"
                    }
                    
//                    let model = PhotoModel(title: title, count: assert.count, fetchResult: assert, assetCollection: collection)
//
//                    
//                    self.groupsArray.append(model)
 
                    
                }
                let model = PhotoModel(title: coll.localizedTitle!, count: assert.count, fetchResult: assert, assetCollection: collection)
                
                
                self.groupsArray.append(model)
 
            }
        }
        
        let userCollection = PHCollectionList.fetchTopLevelUserCollectionsWithOptions(nil)
        
        userCollection.enumerateObjectsUsingBlock { (list, index, stop) -> Void in
            let list = list as! PHAssetCollection
            let assert = PHAsset.fetchAssetsInAssetCollection(list, options: nil)
            if assert.count > 0 {
                
                let ass = assert[0] as! PHAsset
                print("mediaType = \(ass.mediaType)")
                let model = PhotoModel(title: list.localizedTitle!, count: assert.count, fetchResult: assert,assetCollection: list)
                self.groupsArray.append(model)

            }
        }
        


        //print(self.groupsArray)
    
        
    }
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.groupsArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.registerClass(GroupsCell.self, forCellReuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! GroupsCell
        
        
        cell.model = self.groupsArray[indexPath.row]
        return cell
        
    }
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        let model = self.groupsArray[indexPath.row]
        
        let assetsVC = PhotoPickerAssetsViewController()
        assetsVC.assetCollection = model.assetCollection as! PHAssetCollection
        
        self.navigationController?.pushViewController(assetsVC, animated: true)
        //self.presentViewController(assetsVC, animated: true, completion: nil)
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
