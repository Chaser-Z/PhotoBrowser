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
    // 是否授权访问
    var isAuthorization: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        self.automaticallyAdjustsScrollViewInsets = false

        

        let navigationBarappearace = UINavigationBar.appearance()
        navigationBarappearace.isTranslucent = false
        navigationBarappearace.barTintColor = UIColor.yellow
        
        
        let rightItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(PhotoPickerGroupViewController.addApp(_:)))
        self.navigationItem.rightBarButtonItem = rightItem;

        
        
        self.title = "选择相册"

        

        
        //self.addNavBarCancelButton()
        
        
        self.groupsArray = []
        
        self.view.backgroundColor = UIColor.yellow
        
        let author = PHPhotoLibrary.authorizationStatus()
        //let author = ALAssetsLibrary.authorizationStatus()
        if author == PHAuthorizationStatus.restricted || author == .denied
        {
            print("访问权限被关闭了，请前往设置->隐私->照片中设定")
        }
        else
        {
            self.createTableView()
            self.getAllImage()
        }

    }
    func addApp(_ sender:UIBarButtonItem){
        
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func addNavBarCancelButton()
    {
        let temporaryBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.testbtn))
        self.navigationItem.rightBarButtonItem = temporaryBarButtonItem
    }
    func testbtn()
    {
       print("111111")
    }
    //MARK: - 创建tableview
    func createTableView() -> UITableView
    {
        if (self.groupTableView == nil)
        {
            self.groupTableView = UITableView(frame: CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height - 64), style: .plain)
            self.groupTableView.separatorStyle = .none
            self.groupTableView.delegate = self
            self.groupTableView.dataSource = self
            self.view.addSubview(self.groupTableView)
        }
        return self.groupTableView
    }
    
//    class func fetchAllLocalIdentifiersOfPhotos(completion : (_ localIdentifiers : [String]) -> ()) {
//        
//        let userAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
//        userAlbum.enumerateObjects ({ _,_,_ in
//            
//        })
//        
//    }
    //MARK: - 获取图片
    private func getAllImage()
    {
        
        let albumOptions = PHFetchOptions()
        albumOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let userAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        
        
        
        
        
        
        userAlbum.enumerateObjects (
            { (collection, index, stop) -> Void in
            let coll = collection 
            let assert = PHAsset.fetchAssets(in: coll, options: nil)
            
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
                let model = PhotoModel(title: coll.localizedTitle!, count: assert.count, fetchResult: assert as! PHFetchResult<AnyObject>, assetCollection: collection)
                
                
                self.groupsArray.append(model)
 
            }
        })
        
        let userCollection = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        userCollection.enumerateObjects ({ (list, index, stop) -> Void in
            let list = list as! PHAssetCollection
            let assert = PHAsset.fetchAssets(in: list, options: nil)
            if assert.count > 0 {
                
                let ass = assert[0] 
                print("mediaType = \(ass.mediaType)")
                let model = PhotoModel(title: list.localizedTitle!, count: assert.count, fetchResult: assert as! PHFetchResult<AnyObject>,assetCollection: list)
                self.groupsArray.append(model)

            }
        })
        

        //print(self.groupsArray)
    
        
    }
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.groupsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(GroupsCell.self, forCellReuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! GroupsCell
        
        
        cell.model = self.groupsArray[indexPath.row]
        return cell
        
    }
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
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
