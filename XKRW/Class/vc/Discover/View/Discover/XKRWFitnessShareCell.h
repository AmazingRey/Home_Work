//
//  XKRWFitnessShareCell.h
//  XKRW
//
//  Created by Shoushou on 16/1/19.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKRWArticleListEntity;

typedef NS_ENUM(NSInteger, XKRWFitnessShareCellStyle) {
//    XKRWTopicCellTypeDiscover = 1,   //只含背景图，标题和“瘦身分享”黑色半透明标签
    myDraft,        // 无话题，无头像，有“未发布，已推荐”等右下标
    myArticle,     // 有话题，无头像，有“未发布，已推荐”等右下标
    recommendArticle,   // 有话题，无头像，有“已推荐”右下标
    topicArticle,   //没有话题，有头像，有“已推荐”右上标
    FitShare,     //有话题，有头像，无标签
//    XKRWTopicCellTypeThump,      //有话题，有头像 ，有“已推荐”右上标
    deleteArticle,  //只包含背景图 标题
    othersShareArticle,// 有话题，无头像，有“已推荐”右上标
    likeArticle
};

@interface XKRWFitnessShareCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *bgButton; // 文章封面btn

- (void)setContentWithEntity:(XKRWArticleListEntity *)entity style:(XKRWFitnessShareCellStyle)style andSuperVC:(UIViewController *)vc;

@end
