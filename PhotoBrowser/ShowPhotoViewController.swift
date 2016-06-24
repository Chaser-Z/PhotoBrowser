//
//  ShowPhotoViewController.swift
//  PhotoBrowser
//
//  Created by yeeaoo on 16/4/27.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit

class ShowPhotoViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        let button = UIButton(type: .Custom)
        button.frame = CGRectMake(0, 60, self.view.width(), 30)
        button.addTarget(self, action: #selector(ShowPhotoViewController.btnClick), forControlEvents: .TouchUpInside)
        button.setTitle("上一页", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.blueColor()
        self.view.addSubview(button)
        
        
        let photoButton = UIButton(type: .Custom)
        photoButton.frame = CGRectMake(0, 200, self.view.width(), 40)
        photoButton.addTarget(self, action: #selector(ShowPhotoViewController.photoClick), forControlEvents: .TouchUpInside)
        photoButton.setTitle("调用相册", forState: UIControlState.Normal)
        photoButton.backgroundColor = UIColor.blueColor()
        self.view.addSubview(photoButton)


        
    }
    func btnClick()
    {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    func photoClick()
    {
        if self.isPhotoLibraryAvailable()
        {
            let pickController = UIImagePickerController()
            pickController.sourceType = .PhotoLibrary
            pickController.delegate = self
            self.presentViewController(pickController, animated: true, completion: { 
                
            })
        }
        
    }
    
    private func isPhotoLibraryAvailable() -> Bool
    {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
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
