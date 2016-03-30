//
//  XKRWSlimPartView.h
//  XKRW
//
//  Created by 忘、 on 14-9-3.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
//协议方法
typedef void (^DidDoneCallback)();
@protocol XKRWSlimPartViewDelegate <NSObject>
//顶部按钮回调
- (void)   pickerSheetCancelBackUserBtn:(BOOL)status;
- (void)   pickerSheetDoneBack:(DidDoneCallback) caback;

- (void)  getCurrentBodylose:(NSSet *) set;

-(void)savePersonSlimParts;
@end


@interface XKRWSlimPartView : UIView
@property(nonatomic,assign)CGRect rect;
//回调协议
@property (nonatomic,weak) id <XKRWSlimPartViewDelegate> XKRWSlimPartViewDelegate;
//显示区域
@property(nonatomic,retain)UIView* view;
//顶部功能条
@property(nonatomic,retain)UIView * toolBar;
//Picker可外部试用自定义
- (id) initWithSheetTitle:(NSString*)title;

-(void)removeFromView;

- (void)removeFromViewNoAnimation;

- (void)showInViewNoAnimation:(UIView *)theView;

-(id)initWithSheetTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle;
//弹出窗 标题
- (void) setSheetTtitle:(NSString *)title;
//显示
- (void) showInView:(UIView *)view;

@property (nonatomic, strong) UIView *choiceView;
//判断是从哪个VC而来
@property(nonatomic,assign) BOOL isIllnessView;
@property(nonatomic,assign) BOOL isSlimPartView;
@property(nonatomic,assign) BOOL isPersonalInfo;
//疾病数组
@property (nonatomic,strong) NSMutableArray *checkBoxArray;
@property (nonatomic,strong) NSMutableSet *slimPartsSet;
@property (nonatomic,strong) UIButton *noticeButton;
@end
