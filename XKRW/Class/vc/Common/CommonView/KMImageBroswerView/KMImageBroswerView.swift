//
//  KMImageBroswerView.swift
//  XKRW
//
//  Created by Klein Mioke on 15/9/18.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

//enum KMImageBroswerViewType {
//        case AutoComposing(gapWidth: CGFloat)
//}

@objc protocol KMImageBroswerViewDelegate {
    
    optional func imageBroswerView(view: KMImageBroswerView, clickImageAtIndex index: Int) -> Void
}

@objc (KMImageBroswerView)
class KMImageBroswerView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var gapWidth: CGFloat = 10
    weak var delegate: protocol<KMImageBroswerViewDelegate>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, imageURLs: [String], gapWidth:CGFloat) {
        self.init(frame: frame)
//        self.setContentWithImageURLs(imageURLs, type: type)
        
        self.setContentWithImageURLs(imageURLs, gapWidth: gapWidth)
      
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContentWithImageURLs(imageURLs: [String], gapWidth:CGFloat) -> Void {
        
        guard imageURLs.count > 0 else {
            return
        }
//        switch type {
//        case .AutoComposing(gapWidth: let x):
        
            self.gapWidth = gapWidth
            let imageNum = imageURLs.count
            
            // multiple images
            if imageNum > 1 {
//                let imageWidth = (frame.width - self.gapWidth * 2) / 3
                let imageWidth = (UI_SCREEN_WIDTH - 40) / 3.0
                var xPoint = CGFloat(-(imageWidth + self.gapWidth))
                var yPoint = CGFloat(0)
                
                let numbersInALine: CGFloat = imageNum == 4 ? 2 : 3
                
                var tag: Int = 0
                for urlString in imageURLs {
                    
                    xPoint += imageWidth + self.gapWidth
                    
                    if xPoint >= numbersInALine * (imageWidth + self.gapWidth) {
                        yPoint += imageWidth + self.gapWidth
                        xPoint = 0
                    }
                    
                    let button = UIButton(frame: CGRectMake(xPoint, yPoint, imageWidth, imageWidth))
                    button.tag = tag++
                    button.imageView?.contentMode = .ScaleAspectFill
                    
                    button.addTarget(self, action: #selector(KMImageBroswerView.clickImageButton(_:)), forControlEvents: .TouchUpInside)
                    
                    self.addSubview(button)
                    
                    let url: NSURL
                    if XKRWUtil.pathIsNative(urlString) {
                        url = NSURL(fileURLWithPath: urlString)
                    } else {
                        url = NSURL(string: urlString + kNineThumb)!
                    }
                    button.setImageWithURL(url, forState: .Normal, placeholderImage: UIImage(named: "share_photo_placeholder"),options:.RetryFailed)
                }
                self.height = yPoint + imageWidth
            }
            // only one image will be composing in another way
            else {
                let imageHeight: CGFloat = 175.0
                
                let button = UIButton(frame: CGRectMake(0, 0, self.width, imageHeight))
                button.imageView?.contentMode = .ScaleAspectFill
                button.addTarget(self, action: #selector(KMImageBroswerView.clickImageButton(_:)), forControlEvents: .TouchUpInside)
                
                self.addSubview(button)
                
                let url: NSURL
                if XKRWUtil.pathIsNative(imageURLs.first!) {
                    url = NSURL(fileURLWithPath: imageURLs.first!)
                } else {
                    url = NSURL(string: imageURLs.first! + kOneThumb)!
                }
                button.setImageWithURL(url, forState: .Normal, placeholderImage: UIImage(named: "share_cover_placeholder"), options:.RetryFailed ,completed: { (image, error, cacheType) -> Void in
                    if image != nil {
                        let ratio = imageHeight / image.size.height
                        let imageWidth = image.size.width * ratio < self.width ? image.size.width * ratio : self.width
                        
                        button.width = imageWidth
                    }
                })
                button.clipsToBounds = true
                
                self.height = imageHeight
            }
        
    }
    
    func setContentWithImages(images: [UIImage], gapWidth:CGFloat) {
        
        guard images.count > 0 else {
            return
        }
//        switch type {
//        case .AutoComposing(gapWidth: let x):
        
            self.gapWidth = gapWidth
            let imageNum = images.count
            
            // multiple images
            if imageNum > 1 {
//                let imageWidth = (frame.width - self.gapWidth * 2) / 3
                let imageWidth = (UI_SCREEN_WIDTH - 40) / 3.0
                
                var xPoint = CGFloat(-(imageWidth + self.gapWidth))
                var yPoint = CGFloat(0)
                
                let numbersInALine: CGFloat = imageNum == 4 ? 2 : 3
                
                var tag: Int = 0
                for image in images {
                    
                    xPoint += imageWidth + self.gapWidth
                    
                    if xPoint >= numbersInALine * (imageWidth + self.gapWidth) {
                        yPoint += imageWidth + self.gapWidth
                        xPoint = 0
                    }
                    
                    let button = UIButton(frame: CGRectMake(xPoint, yPoint, imageWidth, imageWidth))
                    button.tag = tag++
                    button.imageView?.contentMode = .Center
                    button.imageView?.clipsToBounds = true
                    
                    button.addTarget(self, action: "clickImageButton:", forControlEvents: .TouchUpInside)
                    
                    self.addSubview(button)
                    
                    button.setImage(image, forState: UIControlState.Normal)
                }
                self.height = yPoint + imageWidth
            }
                // only one image will be composing in another way
            else {
                let imageHeight: CGFloat = 175.0
                
                let image = images.first!
                let ratio = imageHeight / image.size.height
                let imageWidth = image.size.width * ratio < self.width ? image.size.width * ratio : self.width
                
                let button = UIButton(frame: CGRectMake(0, 0, imageWidth, imageHeight))
                button.imageView?.contentMode = .ScaleAspectFill
                button.addTarget(self, action: "clickImageButton:", forControlEvents: .TouchUpInside)
                
                self.addSubview(button)
                
                button.setImage(image, forState: .Normal)
                button.clipsToBounds = true

                self.height = imageHeight
            }
//        }
    }
    
    func calculateSizeWithImagesCount(count: Int, gapWidth:CGFloat) -> CGRect {
        
//        switch type {
//        case .AutoComposing(gapWidth: let x):
            
            self.gapWidth = gapWidth
            
            // multiple images
            if count > 1 {
                let imageWidth = (UI_SCREEN_WIDTH - 40) / 3.0
//                let imageWidth = (frame.width - self.gapWidth * 2) / 3
                let numOfLine = count % 3 == 0 ? count / 3 : count / 3 + 1
                
                self.height = CGFloat(numOfLine) * imageWidth + self.gapWidth * CGFloat(numOfLine - 1)
            }
            // only one image will be composing in another way
            else {
                self.height = 175.0
            }
//        }
        return self.frame
    }
    
    func clickImageButton(button: UIButton) -> Void {

        self.delegate?.imageBroswerView?(self, clickImageAtIndex: button.tag)
    }
    
    

    
}
