//
//  XKRWArticleSubTitleHeadImgCell.swift
//  XKRW
//
//  Created by Jack on 15/6/2.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWArticleSubTitleHeadImgCell: UITableViewCell {
   
    @IBOutlet var curArticleBtn: UIButton!
   
    @IBOutlet var moreArticleBtn: UIButton!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var headImgView: UIImageView!
    
    @IBOutlet var readNumLabel: UILabel!
    
    @IBOutlet var starImg: UIImageView!
    
    @IBOutlet var subTitleLabel: UILabel!
    
    @IBOutlet var moduleLabel: UILabel!
    
    @IBOutlet var moreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let lineImg:UIImageView = UIImageView(frame: CGRectMake(0.0, curArticleBtn.bottom-0.5, UI_SCREEN_WIDTH, 0.5));
        lineImg.backgroundColor = XK_ASSIST_LINE_COLOR;
        curArticleBtn.addSubview(lineImg);
        
        moduleLabel.font = XKDefaultFontWithSize(12);
        moduleLabel.textColor = XK_ASSIST_TEXT_COLOR;
        
        moreLabel.font = XKDefaultFontWithSize(12);
        moreLabel.textColor = XK_ASSIST_TEXT_COLOR;
        
        let bottomLineImg:UIImageView = UIImageView(frame: CGRectMake(0.0, moreArticleBtn.bottom-0.5, UI_SCREEN_WIDTH, 0.5));
        bottomLineImg.backgroundColor = XK_ASSIST_LINE_COLOR;
        moreArticleBtn.addSubview(bottomLineImg);
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
