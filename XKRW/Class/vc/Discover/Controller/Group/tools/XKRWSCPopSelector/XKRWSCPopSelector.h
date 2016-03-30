//
//  XKRWSCPopSelector.h
//  XKRW
//
//  Created by Seth Chen on 16/1/22.
//  Copyright © 2016年 XiKang. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XKRWGroupItem.h"
@protocol XKRWSCPopSelectorDelegate <NSObject>

@required
- (void)popSelectorData:(NSArray<NSString *>*)data;
@end

@interface XKRWSCPopSelector : UIView

@property (nonatomic, strong) UIColor * backGroudColor; ///<
@property (nonatomic, copy) NSArray * dataSource; ///<
@property (nonatomic, copy) NSString * title; ///<

@property (nonatomic, weak) id<XKRWSCPopSelectorDelegate>delegate; ///<


- (id)initWithFrame:(CGRect)frame;

- (void)show;

@end
