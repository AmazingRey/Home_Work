//
//  XKRWArticleTitleCell.swift
//  XKRW
//
//  Created by Jack on 15/6/2.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWArticleTitleCell: UITableViewCell {
    
    @IBOutlet var moreArticleBtn: UIButton!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var readNumLabel: UILabel!
    
    @IBOutlet var starImg: UIImageView!
    
    @IBOutlet var moreLabel: UILabel!
    
    @IBOutlet var moduleLabel: UILabel!
    
    var articleTitleEntity:XKRWManagementEntity5_0?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = XKDefaultFontWithSize(17);
        titleLabel.textColor = XK_TITLE_COLOR;
        titleLabel.numberOfLines = 0;
        
        timeLabel.font = XKDefaultFontWithSize(12);
        timeLabel.textColor = XK_ASSIST_TEXT_COLOR;
        
        readNumLabel.font = XKDefaultFontWithSize(12);
        readNumLabel.textColor = XK_ASSIST_TEXT_COLOR;
        
        moduleLabel.font = XKDefaultFontWithSize(12);
        moduleLabel.textColor = XK_ASSIST_TEXT_COLOR;
        
        moreLabel.font = XKDefaultFontWithSize(12);
        moreLabel.textColor = XK_ASSIST_TEXT_COLOR;
        
        
        let bottomLineImg:UIImageView = UIImageView(frame: CGRectMake(0.0, moreArticleBtn.bottom-0.5, UI_SCREEN_WIDTH, 0.5));
        bottomLineImg.backgroundColor = XK_ASSIST_LINE_COLOR;
        moreArticleBtn.addSubview(bottomLineImg);
        
    }
    
    func setContent(articleTitleEntity articleTitleEntity:XKRWManagementEntity5_0?) {
        if articleTitleEntity != nil {
        
            let timeAndTitleDic:NSDictionary = articleTitleEntity!.content as NSDictionary
            
            self.timeLabel.text = timeAndTitleDic.objectForKey("date") as? String
            
            let attributeSting = XKRWUtil.createAttributeStringWithString(timeAndTitleDic.objectForKey("title") as! String, font: UIFont.systemFontOfSize(17), color: XK_TITLE_COLOR, lineSpacing: 8.5, alignment: NSTextAlignment.Left)
            self.titleLabel.attributedText = attributeSting
            
            //阅读过 标题变成灰色
            if articleTitleEntity?.read != 0 {
                self.titleLabel.textColor = XK_ASSIST_TEXT_COLOR
            }
            
            if articleTitleEntity?.category != eOperationEncourage && articleTitleEntity?.category != eOperationSport && articleTitleEntity?.category != eOperationKnowledge {
                self.starImg.hidden = true
            } else {
                self.starImg.hidden = false
            }
            
            if articleTitleEntity?.complete == true {
                self.starImg.image = UIImage(named: "discover_star")
            } else {
                self.starImg.image = UIImage(named: "discover_star_hightlighted")
            }
        
            self.moreArticleBtn.backgroundImageForState(UIControlState.Highlighted)?.createImageWithColor(XK_ASSIST_LINE_COLOR)
        }
        
        if articleTitleEntity?.readNum == nil {
            self.readNumLabel.text = "0"
        } else if Int((articleTitleEntity?.readNum)!) >= 10000 {
            let readNum = Int((articleTitleEntity?.readNum)!)!/10000
            self.readNumLabel.text = "\(readNum)" + "万+"
        } else {
            self.readNumLabel.text = articleTitleEntity?.readNum
        }

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
