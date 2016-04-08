//
//  XKRWFitnessShareCell.m
//  XKRW
//
//  Created by Shoushou on 16/1/19.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWFitnessShareCell.h"
#import "UIImageView+WebCache.h"
#import <XKRW-Swift.h>

@implementation XKRWFitnessShareCell
{
    IBOutlet UIView *_iconBgView;            // 头像、等级、昵称和宣言背景View
    IBOutlet UIView *_lookAndLikeBgView;     // 时间、访问量、喜欢数背景View
    IBOutlet UILabel *_titleLabel;           // 文章标题
    IBOutlet UILabel *_timeLabel;            // 发表时间
    IBOutlet UILabel *lookLabel;             // 访问数
    IBOutlet UILabel *likeLabel;             // 喜欢数
    IBOutlet UIButton *_iconBtn;             // 头像
    IBOutlet UIImageView *_levelImageView;   // 等级
    IBOutlet UILabel *_nickName;             // 昵称
    IBOutlet UILabel *_goalLabel;            // 宣言
    IBOutlet UIImageView *_upRecImageView;   // 推荐上标
    IBOutlet UIImageView *_downRecImageView; // 推荐下标
    IBOutlet UIButton *_topicBtn;            // 话题Button
    IBOutlet UILabel *_topicLabel;           // 话题Label
    IBOutlet UIImageView *_discoverArrow;    // 更多（箭头）
    
    XKRWArticleListEntity *_selfEntity;
    __weak UIViewController *_superVC;
}

- (void)setContentWithEntity:(XKRWArticleListEntity *)entity style:(XKRWFitnessShareCellStyle)style andSuperVC:(UIViewController *)vc{
    _selfEntity = entity;
    _superVC = vc;
    
    if(entity.articleState == XKRWUserArticleStatusDeleteByUser || entity.articleState == XKRWUserArticleStatusDeleteByAdmin ) {
        _titleLabel.text = @"已删除的内容";
        [_bgButton setBackgroundImage:[UIImage imageNamed:@"likeList_del"] forState:UIControlStateNormal];
        style = deleteArticle;
        
    } else {
        _titleLabel.text = entity.title;
        
        NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:entity.createTime];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        _timeLabel.text = [formatter stringFromDate:timeDate];
        
        if (!entity.coverEnabled) {
            [_bgButton setBackgroundImage:[UIImage imageNamed:@"share_cover_verify"] forState:UIControlStateNormal];
            
        } else if (entity.coverImageUrl != nil && entity.coverImageUrl.length > 0) {
            
            if ([XKRWUtil pathIsNative:entity.coverImageUrl]) {
                [_bgButton setBackgroundImage:[UIImage imageWithContentsOfFile:entity.coverImageUrl] forState:UIControlStateNormal];
                
            } else {
                 NSString *url = [NSString stringWithFormat:@"%@%@", entity.coverImageUrl, kCoverThumb];
//                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
//                [_bgButton setBackgroundImage:image forState:UIControlStateNormal];
                [_bgButton setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"share_cover_placeholder"]];
            }
            
        } else if (entity.coverImageUrl == nil || entity.coverImageUrl.length == 0) {
            [_bgButton setBackgroundImage:[UIImage imageNamed:@"share_cover_placeholder"] forState:UIControlStateNormal];
        }
        
        lookLabel.text = [self numberChangeToString:entity.articleViewNums];
        likeLabel.text = [self numberChangeToString:entity.bePraisedNum];
        [_iconBtn setImageWithURL:[NSURL URLWithString:entity.headImageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"lead_nor"]options:SDWebImageRetryFailed];
        [_levelImageView setImageWithURL:[NSURL URLWithString:entity.userDegreeImageUrl]];
        _nickName.text = entity.userNickname;
        _goalLabel.text = entity.manifesto;
        _topicLabel.text = [entity.topic name];
        [self setUserArticleDownRecImageView:entity.recommendState];
        [self setUserArticleUpRecImageView:entity.recommendState];
        
        [_iconBtn addTarget:self action:@selector(readUserInfo) forControlEvents:UIControlEventTouchUpInside];
        [_topicBtn addTarget:self action:@selector(pushToTopicVC) forControlEvents:UIControlEventTouchUpInside];
  
    }
    if (style == deleteArticle) {
        _lookAndLikeBgView.hidden = YES;
        _iconBgView.hidden = YES;
        _upRecImageView.hidden = YES;
        _downRecImageView.hidden = YES;
        _topicBtn.hidden = YES;
        _topicLabel.hidden = YES;
        _discoverArrow.hidden = YES;
        
    } else if (style == myDraft) {
        _iconBgView.hidden = YES;
        _upRecImageView.hidden = YES;
        _downRecImageView.hidden = NO;
        _topicBtn.hidden = YES;
        _topicLabel.hidden = YES;
        _discoverArrow.hidden = YES;
        
    } else if (style == myArticle) {
        _iconBgView.hidden = YES;
        _upRecImageView.hidden = YES;
        _downRecImageView.hidden = NO;
        _topicBtn.hidden = NO;
        _topicLabel.hidden = NO;
        _discoverArrow.hidden = NO;
        
    } else if (style == othersShareArticle) {
        _iconBgView.hidden = YES;
        _upRecImageView.hidden = NO;
        _downRecImageView.hidden = YES;
        _topicBtn.hidden = NO;
        _topicLabel.hidden = NO;
        _discoverArrow.hidden = NO;
        
    } else if (style == recommendArticle) {
        _iconBgView.hidden = NO;
        _upRecImageView.hidden = YES;
        _downRecImageView.hidden = YES;
        _topicBtn.hidden = NO;
        _topicLabel.hidden = NO;
        _discoverArrow.hidden = NO;
        
    } else if (style == topicArticle) {
        _iconBgView.hidden = NO;
        _downRecImageView.hidden = YES;
        _upRecImageView.hidden = NO;
        _topicBtn.hidden = YES;
        _topicLabel.hidden = YES;
        _discoverArrow.hidden = YES;
        
    } else if (style == likeArticle) {
        _lookAndLikeBgView.hidden = NO;
        _iconBgView.hidden = NO;
        _downRecImageView.hidden = YES;
        _upRecImageView.hidden = NO;
        _topicBtn.hidden = NO;
        _topicLabel.hidden = NO;
        _discoverArrow.hidden = NO;
        
    }else if(style == FitShare){
        _downRecImageView.hidden = YES;
        _upRecImageView.hidden = NO;
        _iconBgView.hidden = NO;
        _discoverArrow.hidden = NO;
    }

}

- (void)setUserArticleDownRecImageView:(XKRWUserArticleStatus)status {
    
    if (status == XKRWUserArticleStatusDraft) {
        [_downRecImageView setImage:[UIImage imageNamed:@"wfb_image"]];
        
    } else if (status == XKRWUserArticleStatusDeleteByAdmin) {
        [_downRecImageView setImage:[UIImage imageNamed:@"wgnr_image"]];
        
    } else if (status == XKRWUserArticleStatusRecommended) {
        [_downRecImageView setImage:[UIImage imageNamed:@"ytj_image"]];
        
    } else {
        [_downRecImageView setImage:[UIImage createImageWithColor:XKClearColor]];
    }

}

- (void)setUserArticleUpRecImageView:(XKRWUserArticleStatus)status {
    
    if (status == XKRWUserArticleStatusRecommended) {
        [_upRecImageView setImage:[UIImage imageNamed:@"share_recommend_badge"]];
        
    } else {
        [_upRecImageView setImage:[UIImage createImageWithColor:XKClearColor]];
    }
}

- (NSString *)numberChangeToString:(NSInteger)num {
    
    NSString *numStr;
    if (num/10000) {
        numStr = [NSString stringWithFormat:@"%d 万+",(int)num/10000];
    } else {
        numStr = [NSString stringWithFormat:@"%ld",(long)num];
    }
    return numStr;
}

- (void)readUserInfo {
    XKRWUserInfoVC *userInfoVC = [[XKRWUserInfoVC alloc] init];
    userInfoVC.userNickname = _selfEntity.userNickname;
    [_superVC.navigationController pushViewController:userInfoVC animated:YES];
}

- (void)pushToTopicVC {
    XKRWTopicVC *topicVC = [[XKRWTopicVC alloc] init];
    topicVC.topicId = [NSNumber numberWithInteger:[_selfEntity.topic topicId]];
    topicVC.topicStr = [_selfEntity.topic name];
    [_superVC.navigationController pushViewController:topicVC animated:YES];
}

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _iconBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [_topicBtn setBackgroundImage:[UIImage createImageWithColor:colorSecondary_e6e6e6] forState:UIControlStateHighlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
