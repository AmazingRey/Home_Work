//
//  XKRWPickerViewVC.h
//  XKRW
//
//  Created by 忘、 on 14-9-2.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 自定义底部sheetView
 功能：
 
 自定义Sheet ，实现浮动式PickerView
 
 可通过外部数据源调整内容，
 
 选择操作反馈给代理类
 
 */
//协议方法
typedef void (^DidDoneCallback)();
@protocol XKRWPickerViewVCDelegate <NSObject>

//顶部按钮回调
- (void)        pickerSheetCancelBackUserBtn:(BOOL)status;
- (void)        pickerSheetDoneBack:(DidDoneCallback) caback;

- (void)  getCurrentIllNum:(NSSet *) set;

@optional

-(void)savePersonInfo;
@end

@interface XKRWPickerViewVC : UIView

@property(nonatomic,assign)CGRect rect;
//回调协议
@property (nonatomic,weak) id <XKRWPickerViewVCDelegate> PickerViewVCDelegate;
//显示区域
@property(nonatomic,retain)UIView* view;
//顶部功能条
@property(nonatomic,retain)UIView * toolBar;
//Picker可外部试用自定义
- (id) initWithSheetTitle:(NSString*)title;

- (id)initWithSheetTitle:(NSString *)title cancelTitle:(NSString *)cancle sureTitle:(NSString *)sureTitle;
//弹出窗 标题
- (void) setSheetTtitle:(NSString *)title;
//显示
- (void) showInView:(UIView *)view;
//外部调用 初始化选中条目
-(void)removeFromView;

- (void)removeFromViewNoAnimation;

- (void)showInViewNoAnimation:(UIView *)theView;


@property (nonatomic, strong) UIView *choiceView;
//判断是从哪个VC而来
@property(nonatomic,assign) BOOL isIllnessView;
@property(nonatomic,assign) BOOL isSlimPartView;
@property(nonatomic,assign) BOOL isPersonalInfo;
//疾病数组
@property (nonatomic,strong) NSMutableArray *checkBoxArray;
@property (nonatomic,strong) NSMutableSet *illnessResultSet;
@property (nonatomic,strong) UIButton *noticeButton;


@end




