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

        let nav = UINavigationController(rootViewController: self)
        UIApplication.sharedApplication().delegate?.window!?.rootViewController = nav
        

        let navigationBarappearace = UINavigationBar.appearance()
        navigationBarappearace.translucent = false
        navigationBarappearace.barTintColor = UIColor.yellowColor()
        
        let rightItem = UIBarButtonItem.init(title: "确定", style: .Plain, target: self, action: #selector(PhotoPickerGroupViewController.addApp(_:)))
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
            print("11")
        }
        else
        {
            self.tableView()
            self.getAllImage()
            print("22")
        }

    }
    func addApp(sender:UIBarButtonItem){
        
        //self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
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
            self.groupTableView = UITableView(frame: CGRectMake(0, 64, self.view.frame.width, self.view.frame.height - 64), style: .Plain)
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
                let model = PhotoModel(title: coll.localizedTitle!, count: assert.count, fetchResult: assert)
                
                self.groupsArray.append(model)
            }
        }
        
        let userCollection = PHCollectionList.fetchTopLevelUserCollectionsWithOptions(nil)
        
        userCollection.enumerateObjectsUsingBlock { (list, index, stop) -> Void in
            let list = list as! PHAssetCollection
            let assert = PHAsset.fetchAssetsInAssetCollection(list, options: nil)
            if assert.count > 0 {
                let model = PhotoModel(title: list.localizedTitle!, count: assert.count, fetchResult: assert)
                self.groupsArray.append(model)

            }
        }


        print(self.groupsArray)
    
        
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
        print("row = %d",indexPath.row)
        let assetsVC = PhotoPickerAssetsViewController()
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
