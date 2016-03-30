//
//  GroupHeaderDetailView.h
//  AFN_Test
//
//  Created by Seth Chen on 16/1/13.
//  Copyright © 2016年 xikang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWGroupViewController.h"

@protocol GroupHeaderDetailDelegate <NSObject>

@required
- (void)buttonClickHandler:(groupAuthType)type;

@end

@interface GroupHeaderDetailView : UIView

@property (weak, nonatomic) IBOutlet UILabel *memberNumLabel;
@property (weak, nonatomic) id<GroupHeaderDetailDelegate>delegate;
@property (nonatomic, assign) groupAuthType  groupAuthType;
@end
