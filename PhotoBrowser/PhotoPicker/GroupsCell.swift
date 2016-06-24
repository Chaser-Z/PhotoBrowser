//
//  GroupsCell.swift
//  PhotoBrowser
//
//  Created by yeeaoo on 16/4/27.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit
import Photos
class GroupsCell: UITableViewCell {

    var leftImageView: UIImageView!
    var photogroupNameLabel: UILabel!
    var photoCountLabel: UILabel!
    var model: PhotoModel!{
        
        didSet{
            
            self.photogroupNameLabel.text = model.title
            self.photoCountLabel.text = String(format: "%d", model.count)
            
            PHImageManager.defaultManager().requestImageForAsset(model.fetchResult.lastObject as! PHAsset, targetSize: CGSizeMake(120, 120), contentMode: .AspectFill, options: nil) { (image, _: [NSObject: AnyObject]?) in
                
                if image == nil
                {
                    return
                }
                self.leftImageView.image = image
                
 
            }

        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setUI()
    }
    
    private func setUI()
    {
        leftImageView = UIImageView()
        leftImageView.frame = CGRectMake(0, 0, 60, 60)
        leftImageView.backgroundColor = UIColor.purpleColor()
        self.contentView.addSubview(leftImageView)
        
        self.photogroupNameLabel = UILabel()
        self.photogroupNameLabel.frame = CGRectMake(70, 7.5, 200, 20)
        self.contentView.addSubview(self.photogroupNameLabel)
        
        self.photoCountLabel = UILabel()
        self.photoCountLabel.frame = CGRectMake(70, 30, 100, 20)
        self.contentView.addSubview(self.photoCountLabel)
    }
    
    
    func placeholderImageWithSize(size:CGSize)->UIImage{
        
        UIGraphicsBeginImageContext(size);
        let context = UIGraphicsGetCurrentContext()! as CGContextRef;
        
        let backgroundColor = UIColor.init(red: (239.0 / 255.0), green: (239.0 / 255.0), blue: (244.0 / 255.0), alpha: 1.0)
        
        let iconColor = UIColor.init(red:(179.0 / 255.0), green: (179.0 / 255.0), blue: (182.0 / 255.0), alpha: 1.0)
        
        // Background
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
        
        //    // Icon (back)
        let backIconRect = CGRectMake(size.width * (16.0 / 68.0),
                                      size.height * (20.0 / 68.0),
                                      size.width * (32.0 / 68.0),
                                      size.height * (24.0 / 68.0));
        
        CGContextSetFillColorWithColor(context, iconColor.CGColor);
        CGContextFillRect(context, backIconRect);
        
        CGContextSetFillColorWithColor(context,backgroundColor.CGColor);
        CGContextFillRect(context, CGRectInset(backIconRect, 1.0, 1.0));
        
        // Icon (front)
        let frontIconRect = CGRectMake(size.width * (20.0 / 68.0),
                                       size.height * (24.0 / 68.0),
                                       size.width * (32.0 / 68.0),
                                       size.height * (24.0 / 68.0));
        
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, CGRectInset(frontIconRect, -1.0, -1.0));
        
        CGContextSetFillColorWithColor(context, iconColor.CGColor);
        CGContextFillRect(context,frontIconRect);
        
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, CGRectInset(frontIconRect, 1.0, 1.0));
        
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage;
        UIGraphicsEndImageContext();
        
        return image;
    }

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
