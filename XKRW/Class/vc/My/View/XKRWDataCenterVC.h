//
//  XKRWDataCenterVC.h
//  XKRW
//
//  Created by 忘、 on 15/7/10.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"

typedef NS_ENUM(NSInteger, DateType) {
    sevenDay =1,
    thirtyDay,
};

@interface XKRWDataCenterVC : XKRWBaseVC
{
    UINib *weightNib;
    UINib *dietNib;
    UINib *sportNib;
    UINib *habitNib;

}
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (assign, nonatomic) NSInteger selectedIndex;

- (NSInteger)getSignIndays;
@end
