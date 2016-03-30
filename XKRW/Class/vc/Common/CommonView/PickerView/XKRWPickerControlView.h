//
//  XKRWPickerControlView.h
//  XKRW
//
//  Created by XiKang on 14-7-18.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol XKPickerControlDelegate;

@interface XKRWPickerControlView : UIView
@property (nonatomic, weak) id <XKPickerControlDelegate>delegate;



@property (nonatomic, strong) UIPickerView *picker;
- (void) controlSelectRow:(NSInteger)row andColum:(NSInteger)colum;

- (void) reloadData:(NSInteger)colum;

@end

@protocol XKPickerControlDelegate <NSObject>
- (NSInteger)  controlGetNumberOfColum;
- (NSInteger)  controlGetRowsInColum:(NSInteger) colum;
- (NSString *) controlGetTitleAtRow:(NSInteger) row InColum:(NSInteger) colum;
- (void)       controlDidSelectedRow:(NSInteger) row andColum:(NSInteger)colum;
@end