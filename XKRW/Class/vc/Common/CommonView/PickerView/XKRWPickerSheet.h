//
//  XKRWPickerSheet.h
//  XKRW
//
//  Created by XiKang on 14-7-18.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWPickerControlView.h"
/*
 自定义底部sheet
 功能：
 
    自定义Sheet ，实现浮动式Picker
    可通过外部数据源调整内容，
    选择操作反馈给代理类

*/

typedef void (^DidDoneCallback)();

@protocol PickerSheetViewDelegate;

@interface XKRWPickerSheet : UIView
//回调协议
@property (nonatomic,weak) id <PickerSheetViewDelegate> pickerSheetDelegate;
//显示区域
@property(nonatomic,retain)UIView* view;
//顶部功能条
@property(nonatomic,retain)UIView * toolBar;
//Picker可外部试用自定义
-(id)initWithSheetTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle reminder:(NSString *)reminder;

-(id)initWithSheetTitle:(NSString *)title AndUnit:(NSString *)unit;
//弹出窗 标题
- (void) setSheetTtitle:(NSString *)title;
//显示
- (void) showInView:(UIView *)view;
//外部调用 初始化选中条目
- (void) pickerSelectRow:(NSInteger) row inCol:(NSInteger) colun;

- (void) setPointHidden:(BOOL) status;

-(void) setCancelTitle:(NSString *) title;

-(void)removeFromView;

- (void)removeFromViewNOAnimation;

- (id)initShowTransparentView:(BOOL) show;

- (void)showInViewNoAnimaton:(UIView *)theView;

@property (nonatomic, strong) XKRWPickerControlView *pickerView;
@end



//协议方法
@protocol PickerSheetViewDelegate <NSObject>

//数据源
- (NSInteger)   pickerSheetNumberOfColumns;
- (NSInteger)   pickerSheetNumberOfRowsInColumn:(NSInteger) column;
- (NSString *)  pickerSheetTitleInRow:(NSInteger) row andColum:(NSInteger)colum;
//顶部按钮回调
- (void)        pickerSheetCancelBackUserBtn:(BOOL)status;
- (void)        pickerSheetDoneBack:(DidDoneCallback) caback;

//协议方法
@optional
- (void) pickerSheetReloadAtColum: (NSInteger) colum;
- (void) pickerSheetRowHeightInColum:(NSInteger) colum;
- (void) pickerSheet:(XKRWPickerControlView *) picker DidSelectRowAtRow:(NSInteger) row AndCloum:(NSInteger) colum;


@end