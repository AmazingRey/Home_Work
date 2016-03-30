//
//  XKRWArticleTitleImageCell.swift
//  XKRW
//
//  Created by Jack on 15/6/2.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWArticleTitleImageCell: UITableViewCell {
    
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet var curArticleBtn: UIButton!

    @IBOutlet var moreArticleBtn: UIButton!

    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var readNumLabel: UILabel!
    
    @IBOutlet var moduleLabel: UILabel!
    
    @IBOutlet var moreLabel: UILabel!
    
    @IBOutlet var starImg: UIImageView!
    
    var articleTitleImageEntity:XKRWManagementEntity5_0?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = XKDefaultFontWithSize(17);
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = UIColor.whiteColor();
        
        timeLabel.font = XKDefaultFontWithSize(12);
        timeLabel.textColor = XK_ASSIST_LINE_COLOR;
        
        readNumLabel.font = XKDefaultFontWithSize(12);
        readNumLabel.textColor = XK_ASSIST_LINE_COLOR;
        
        moduleLabel.font = XKDefaultFontWithSize(12);
        moduleLabel.textColor = XK_ASSIST_TEXT_COLOR;
        
        moreLabel.font = XKDefaultFontWithSize(12);
        moreLabel.textColor = XK_ASSIST_TEXT_COLOR;
        
        let lineImg:UIImageView = UIImageView(frame: CGRectMake(0.0, curArticleBtn.bottom-0.5, UI_SCREEN_WIDTH, 0.5));
        lineImg.backgroundColor = XK_ASSIST_LINE_COLOR;
        curArticleBtn.addSubview(lineImg);
        
        
        let bottomLineImg:UIImageView = UIImageView(frame: CGRectMake(0.0, moreArticleBtn.bottom-0.5, UI_SCREEN_WIDTH, 0.5));
        bottomLineImg.backgroundColor = XK_ASSIST_LINE_COLOR;
        moreArticleBtn.addSubview(bottomLineImg);

        // Initialization code
    }

    func setContent(articleTitleImageEntity articleTitleImageEntity: XKRWManagementEntity5_0?) {
        
        if articleTitleImageEntity != nil {

            self.articleTitleImageEntity = articleTitleImageEntity!
            self.moduleLabel.text = articleTitleImageEntity!.module
            
            let dic:NSDictionary = articleTitleImageEntity!.content as NSDictionary
            self.timeLabel.text = dic.objectForKey("date") as? String
            let attributeString = XKRWUtil.createAttributeStringWithString(dic.objectForKey("title") as! String, font: UIFont.systemFontOfSize(17), color: UIColor.whiteColor(), lineSpacing: 8.5, alignment: NSTextAlignment.Left)
            self.titleLabel.attributedText = attributeString
            
            if articleTitleImageEntity?.category != eOperationEncourage && articleTitleImageEntity?.category != eOperationSport && articleTitleImageEntity?.category != eOperationKnowledge {
                self.starImg.hidden = true
            } else {
                self.starImg.hidden = false
            }
            
            if ((articleTitleImageEntity?.complete)! as Bool == true ) {
                self.starImg.image = UIImage(named: "discover_star")
            } else {
                self.starImg.image = UIImage(named: "discover_star_hightlighted")
            }
            
            if articleTitleImageEntity?.readNum == nil {
                self.readNumLabel.text = "0"
            } else if Int((articleTitleImageEntity?.readNum)!) >= 10000 {
                let readNum = Int((articleTitleImageEntity?.readNum)!)!/10000
                self.readNumLabel.text = String(readNum) + "万+"
            } else {
                self.readNumLabel.text = articleTitleImageEntity?.readNum
            }
            
            self.showImageView.setImageWithURL(NSURL(string: (articleTitleImageEntity?.bigImage)!))
            
        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
