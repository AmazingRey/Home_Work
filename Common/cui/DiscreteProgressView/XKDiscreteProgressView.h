//
//  XKDiscreteProgressView.h
//  calorie
//
//  Created by Rick Liao on 12-12-22.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

// 目前仅支持从左到右类型，其余类型留待后续开发。
typedef enum {
    XKDiscreteProgressViewStyleLeftToRight = 0,
//    XKDiscreteProgressViewStyleRightToLeft,
//    XKDiscreteProgressViewStyleTopToBottom,
//    XKDiscreteProgressViewStyleBottomToTop,
} XKDiscreteProgressViewStyle;

// 注意：对progress或setProgress的设置必需在其它各项配置之后，且只有对progress或setProgress第一次设置后画面才被实质性显示。
@interface XKDiscreteProgressView : UIView

@property(nonatomic) XKDiscreteProgressViewStyle progressViewStyle UI_APPEARANCE_SELECTOR;

@property(nonatomic) NSInteger progress;
@property(nonatomic) NSInteger track;

// 暂不提供progressView和trackView的设置方式，将来如有需要，可以通过类似于DataSource的代理方式来实现。

@property(nonatomic, retain) UIImage *progressImage UI_APPEARANCE_SELECTOR;
@property(nonatomic, retain) UIImage *trackImage UI_APPEARANCE_SELECTOR;

@property(nonatomic, retain) NSString *progressImageName UI_APPEARANCE_SELECTOR;
@property(nonatomic, retain) NSString *trackImageName UI_APPEARANCE_SELECTOR;

- (void)setProgress:(NSInteger)progress animated:(BOOL)animated;

@end
