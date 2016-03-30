//
//  XKRWArticleSectionView.swift
//  XKRW
//
//  Created by Klein Mioke on 15/9/18.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWArticleSectionView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    var textLabel: UILabel!
    var imageBroswer: KMImageBroswerView!
    
    var clickHandler: ((index: Int)-> Void)?
    var attributes: [String: AnyObject]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        #if DEBUG
        self.clipsToBounds = true
        #endif
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContentWithText(text: String, imageURLs: [String]?, ifHaveImages images: [UIImage]?) -> Void {
        
        if self.textLabel == nil {
            self.textLabel = UILabel(frame: CGRectMake(15, 15, self.width - 30, 0))
            self.textLabel.numberOfLines = 0;
            
            self.addSubview(self.textLabel)
        }
        
        if self.attributes == nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3.5
            paragraphStyle.alignment = .Justified
            paragraphStyle.firstLineHeadIndent = 0.05
            
            self.attributes = [NSFontAttributeName: UIFont.systemFontOfSize(15), NSForegroundColorAttributeName: XK_TITLE_COLOR, NSParagraphStyleAttributeName: paragraphStyle]
        }
        let attributeString = NSMutableAttributedString(string: text, attributes: self.attributes)
        
        let textheight = text.isEmpty ? 0 : attributeString.boundingRectWithSize(CGSizeMake(self.width - 30, 1000), options: .UsesLineFragmentOrigin, context: nil).size.height
        
        self.textLabel.height = textheight
        self.textLabel.attributedText = attributeString
        
        if self.imageBroswer == nil {
            self.imageBroswer = KMImageBroswerView(frame: CGRectMake(15, self.textLabel.bottom + 10, self.frame.width - 90, 0))
            self.imageBroswer.delegate = self
            
            self.addSubview(self.imageBroswer)
        }
        self.imageBroswer.setY(textheight == 0 ? self.textLabel.bottom : self.textLabel.bottom + 10)
        
        if images != nil && images?.count > 0 {
            self.imageBroswer.setContentWithImages(images!, gapWidth: 5)
        } else {
            self.imageBroswer.setContentWithImageURLs(imageURLs!,gapWidth: 5 )
        }
        
        self.height = imageBroswer.bottom + 15
    }
    
    func calculateSizeWithText(text: String, imageURLs: [String]?, ifHaveImages images: [UIImage]?) -> CGRect {
        
        let attributeString = XKRWUtil.createAttributeStringWithString(text, font: UIFont.systemFontOfSize(15), color: XK_TEXT_COLOR, lineSpacing: 3.5, alignment: NSTextAlignment.Justified)
        
        let textheight = text.isEmpty ? 0 : attributeString.boundingRectWithSize(CGSizeMake(self.width - 30, 1000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).size.height
        
        if self.imageBroswer == nil {
            self.imageBroswer = KMImageBroswerView(frame: CGRectMake(15, 0, self.frame.width - 90, 0))
        }
        if images != nil && images?.count > 0 {
            self.imageBroswer.calculateSizeWithImagesCount(images!.count, gapWidth: 5)
        } else {
            self.imageBroswer.calculateSizeWithImagesCount(imageURLs!.count, gapWidth: 5)
        }
        self.height = self.imageBroswer.height + 15 + textheight + 15
        if !text.isEmpty {
            self.height += 10
        }
        return self.frame
    }
}

extension XKRWArticleSectionView: KMImageBroswerViewDelegate {
    
    func imageBroswerView(view: KMImageBroswerView, clickImageAtIndex index: Int) {
        self.clickHandler?(index: index)
    }
}
