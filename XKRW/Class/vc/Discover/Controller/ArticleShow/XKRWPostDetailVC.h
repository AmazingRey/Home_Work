//
//  XKRWPostDetailVC.h
//  XKRW
//
//  Created by 忘、 on 16/1/21.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "XKRWGroupViewController.h"

@interface XKRWPostDetailVC : XKRWBaseVC

@property(nonatomic,assign) BOOL likePostDeleted;
;

@property (nonatomic,assign) BOOL postDeleted;

@property (strong,nonatomic) XKRWGroupItem *groupItem;
@property (nonatomic, assign) groupAuthType groupAuthType;
@property (strong,nonatomic) NSString *postID;

@end
