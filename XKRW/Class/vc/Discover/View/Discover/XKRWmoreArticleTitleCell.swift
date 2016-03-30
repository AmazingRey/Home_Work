//
//  XKRWmoreArticleTitleCell.swift
//  XKRW
//
//  Created by Jack on 15/6/2.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWmoreArticleTitleCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
   
    @IBOutlet var readNumLabel: UILabel!
    
    @IBOutlet var readImage: UIImageView!
    
    var moreArticleTitleEntity:XKRWManagementEntity5_0?
//    headImgBG  titleLabel  timeLabel  readNumLabel  curArticleBtn
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.font = XKDefaultFontWithSize(15);
//        titleLabel.textColor = XK_TEXT_COLOR;
        
        timeLabel.font = XKDefaultFontWithSize(12);
        timeLabel.textColor = XK_ASSIST_TEXT_COLOR;
        
//        readNumLabel.font = XKDefaultFontWithSize(12);
//        readNumLabel.textColor = XK_ASSIST_TEXT_COLOR;
        
//        var lineImg:UIImageView = UIImageView(frame: CGRectMake(0.0, curArticleBtn.bottom-0.5, UI_SCREEN_WIDTH, 0.5));
//        lineImg.backgroundColor = XK_ASSIST_LINE_COLOR;
//        curArticleBtn.addSubview(lineImg);
        
    }
    
    func setContent(moreArticleTitleEntity moreArticleTitleEntity:XKRWManagementEntity5_0?) {
        if moreArticleTitleEntity != nil {
            
            let dic:NSDictionary = moreArticleTitleEntity!.content as NSDictionary
            self.timeLabel.text = dic.objectForKey("date") as? String
            
//            if moreArticleTitleEntity?.readNum as String {
//                
//            }
            //
            //            if([entity.readNum isKindOfClass:[NSNull class]]||!entity.readNum){
            //                lhyyCell.readNumLabel.text = @"0";
            //            }else{
            //                NSInteger readNum = [entity.readNum integerValue];
            //                if (readNum >= 10000) {
            //                    lhyyCell.readNumLabel.text = [NSString stringWithFormat:@"%ld万+",(long)readNum/10000];
            //                } else {
            //                    lhyyCell.readNumLabel.text = entity.readNum;
            //                }
            //
            //            }
            //            lhyyCell.titleLabel.text = entity.content[@"title"];
            //
            //            //根据字的长短来变动
            //            NSAttributedString *text =
            //            [XKRWUtil createAttributeStringWithString:lhyyCell.titleLabel.text
            //                                                 font:XKDefaultFontWithSize(17)
            //                                                color:XK_TITLE_COLOR
            //                                          lineSpacing:8.5 alignment:NSTextAlignmentLeft];
            //            lhyyCell.titleLabel.attributedText = text;
            //            lhyyCell.titleLabel.numberOfLines = 0;
            //            
            //            //阅读过 字体变灰
            //            if(entity.read) {
            //                lhyyCell.titleLabel.textColor = XK_ASSIST_TEXT_COLOR;
            //            }
        }
    }

    /*
    if([entity.readNum isKindOfClass:[NSNull class]]||!entity.readNum){
    lhyyCell.readNumLabel.text = @"0";
    }else{
    NSInteger readNum = [entity.readNum integerValue];
    if (readNum >= 10000) {
    lhyyCell.readNumLabel.text = [NSString stringWithFormat:@"%ld万+",(long)readNum/10000];
    }else
    {
    lhyyCell.readNumLabel.text = entity.readNum;
    }
    
    }
    lhyyCell.titleLabel.text = entity.content[@"title"];
    
    //根据字的长短来变动
    NSAttributedString *text =
    [XKRWUtil createAttributeStringWithString:lhyyCell.titleLabel.text
    font:XKDefaultFontWithSize(17)
    color:XK_TITLE_COLOR
    lineSpacing:8.5 alignment:NSTextAlignmentLeft];
    lhyyCell.titleLabel.attributedText = text;
    lhyyCell.titleLabel.numberOfLines = 0;
    
    //阅读过 字体变灰
    if(entity.read){
    lhyyCell.titleLabel.textColor = XK_ASSIST_TEXT_COLOR;
    }*/
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
