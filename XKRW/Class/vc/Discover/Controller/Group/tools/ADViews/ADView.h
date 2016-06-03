//
//  ADView.h
//  Yoohoo
//
//  Created by Seth Chen on 14-9-18.
//  Copyright (c) 2014年 ideacp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADModel;
@protocol ChangeNotice <NSObject>
- (void)adItemClick:(ADModel *)model;
@end

@interface ADModel : NSObject
@property(nonatomic,retain) NSString        *banner_id;
@property(nonatomic,retain) NSString        *banner_name;
@property(nonatomic,retain) NSString        *banner_tp;
@property(nonatomic,retain) NSString        *banner_bdate;
@property(nonatomic,retain) NSString        *banner_edate;
@property(nonatomic,retain) NSString        *banner_picture;
@property(nonatomic,retain) NSString        *productId;
@property(nonatomic,retain) NSString        *cType;
@property(nonatomic,retain) NSString        *tType;
@property(nonatomic,retain) NSString        *linkUrl;
@property(nonatomic,retain) NSString        *imgUrl;
@end

@interface ADView : UIView
@property(nonatomic,retain)NSArray      *adlist;///<   ADModel列表
@property(nonatomic,strong)id<ChangeNotice>noticeDelegate;

- (void)reloadData;
@end