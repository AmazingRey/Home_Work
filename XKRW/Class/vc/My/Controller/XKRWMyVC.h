//
//  XKRWMoreVC.h
//  XKRW
//
//  Created by yaowq on 13-12-11.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "XKRWMoreCells.h"
#import "XKRWHeaderView.h"
#import "XKRWUITableViewBase.h"
@protocol XKRWCheckMoreRedDotDelegate <NSObject>

- (void)clearRedDotFromMore;

@end

@interface XKRWMyVC : XKRWBaseVC <UITableViewDelegate,UITableViewDataSource,XKRWUserInfoDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,XKRWHeaderViewDelegate>
{
    NSInteger numOfNewReplies;
    UIImageView  *adImgView;
}
@property (nonatomic,readwrite) NSMutableArray *data;
@property (nonatomic,strong) XKRWUITableViewBase *tableView;
@property (strong, nonatomic) NSArray *appArray;
@property (nonatomic,assign) id <XKRWCheckMoreRedDotDelegate> delegate;

@end
