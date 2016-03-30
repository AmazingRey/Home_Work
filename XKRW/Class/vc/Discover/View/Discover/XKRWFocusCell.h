//
//  XKRWFocusCell.h
//  XKRW
//
//  Created by Shoushou on 15/11/16.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWUITableViewCellbase.h"
#import "XKRWShareAdverEntity.h"

typedef void(^imgLoadCompleteBlock)(BOOL isComplete);
typedef void(^adverClickBlock)(NSString *adverUrlStr, NSString *title);

@interface XKRWFocusCell : XKRWUITableViewCellbase<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) imgLoadCompleteBlock isShowBlock;
@property (nonatomic, strong) adverClickBlock adverClickedBlock;

@end