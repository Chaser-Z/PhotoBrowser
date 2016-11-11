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

        self.view.backgroundColor = UIColor.white
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0,y: 60,width: self.view.width(),height: 30)
        button.addTarget(self, action: #selector(ShowPhotoViewController.btnClick), for: .touchUpInside)
        button.setTitle("上一页", for: UIControlState.normal)
        button.backgroundColor = UIColor.blue
        self.view.addSubview(button)
        
        
        let photoButton = UIButton(type: .custom)
        photoButton.frame = CGRect(x: 0,y: 200,width: self.view.width(),height: 40)
        photoButton.addTarget(self, action: #selector(ShowPhotoViewController.photoClick), for: .touchUpInside)
        photoButton.setTitle("调用相册", for: UIControlState.normal)
        photoButton.backgroundColor = UIColor.blue
        self.view.addSubview(photoButton)


        
    }
    func btnClick()
    {
        self.dismiss(animated: true) { 
            
        }
    }
    func photoClick()
    {
        if self.isPhotoLibraryAvailable()
        {
            let pickController = UIImagePickerController()
            pickController.sourceType = .photoLibrary
            pickController.delegate = self
            self.present(pickController, animated: true, completion: { 
                
            })
        }
        
    }
    
    private func isPhotoLibraryAvailable() -> Bool
    {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
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
