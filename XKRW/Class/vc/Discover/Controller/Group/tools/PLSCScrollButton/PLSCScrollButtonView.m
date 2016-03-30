//
//  PLSCScrollButtonView.m
//  PeiLinRopeSkipping
//
//  Created by Seth Chen on 16/1/9.
//  Copyright © 2016年 Lunarsam. All rights reserved.
//

#import "PLSCScrollButtonView.h"

@interface PLSCScrollButtonView ()
{
    UIView * bottomline;        ///<    底线
    NSMutableArray * buttons;   ///<    按钮
    NSInteger selectIndex;
    void(^ __handler)();
    
    
    NSMutableArray<UILabel *> * __notices;    ///<  通知
}
@property (nonatomic, copy) NSArray *titles;            ///< tittles.
@property (nonatomic, strong) UIColor *norColor;        ///< normal Color.
@property (nonatomic, strong) UIColor *selectColor;     ///< select Color.
@property (nonatomic, assign) CGFloat buttonsGap;       ///< buttons Gap .
@property (nonatomic, assign) BOOL showBottomline;      ///< is show the bottom line.

@end


@implementation PLSCScrollButtonView

- (instancetype)initWithFrame:(CGRect)frame norColor:(UIColor *)norColor selectColor:(UIColor *)selectColor withGap:(const CGFloat)gap isShowBottomline:(BOOL)abool handler:(void(^)(NSInteger, UIButton*, UILabel*, PLSCScrollButtonView *, SEL ))handler
{
    self = [super initWithFrame:frame];
    if (self) {
        self.norColor = norColor;
        self.selectColor = selectColor;
        self.buttonsGap = gap>0 ? gap:0;
        self.showBottomline = abool;
        buttons = [NSMutableArray array];
        __notices = [NSMutableArray array];
        __handler = handler;

    }
    return self;
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    [self setup];
}

- (void)setup
{
#if 1 //正常的模式
    float totalWidth = self.frame.size.width - (_titles.count+1)*self.buttonsGap;
#else //为了实现特别的需求  假如使用的时候应该屏蔽
    float totalWidth = self.frame.size.width - 2*self.buttonsGap;
#endif
    
    
    for (int i = 0; i < _titles.count; i++) {
        UIButton * b__  = [UIButton buttonWithType:UIButtonTypeCustom];
        
#if 1 //正常的模式
        b__.frame = CGRectMake((totalWidth/_titles.count)*i + self.buttonsGap + self.buttonsGap*i, 0, (totalWidth/_titles.count), self.frame.size.height);
#else //为了实现特别的需求  假如使用的时候应该屏蔽
        b__.frame = CGRectMake((totalWidth/_titles.count)*i + self.buttonsGap, 0, (totalWidth/_titles.count), self.frame.size.height);
#endif
        
        
        b__.backgroundColor = [UIColor clearColor];
        b__.titleLabel.font = [UIFont systemFontOfSize:16];
        b__.tag = 100+i;
        [b__ setTitle:_titles[i] forState:UIControlStateNormal];
        [b__ setTitleColor:self.norColor forState:UIControlStateNormal];
        [b__ setTitleColor:self.selectColor forState:UIControlStateSelected];
        [b__ addTarget:self action:@selector(changeEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:b__];
        [buttons addObject:b__];
        
        if (i == 0) {
            b__.selected = YES;
            selectIndex = b__.tag;
        }
        
#if 0 //正常的模式
        
#else //为了实现特别的需求  假如使用的时候应该屏蔽
        UIImage * __noticeImage = [UIImage imageNamed:@"notice_new"];
        UILabel * __notice = [[UILabel alloc]initWithFrame:CGRectMake(b__.frame.size.width/2+15, (b__.frame.size.height - __noticeImage.size.height)/2 - 10, __noticeImage.size.width, __noticeImage.size.height)];
        __notice.text = @"0";
        __notice.textAlignment = NSTextAlignmentCenter;
        __notice.font = [UIFont systemFontOfSize:10];
        __notice.backgroundColor = [UIColor clearColor];
        __notice.textColor = [UIColor whiteColor];
        //        [__notice insertSubview:[[UIImageView alloc]initWithImage:__noticeImage] atIndex:0];
        [__notice setBackgroundColor:[UIColor colorWithPatternImage:__noticeImage]];
        [b__ addSubview:__notice];
        [__notices addObject:__notice];
        
        [self setNotices:@[@"0",@"0",@"0",@"0"]];
#endif
    }
    
    
    if (!bottomline) {
        bottomline = [UIView new];
        bottomline.frame = (CGRect){self.buttonsGap, self.frame.size.height-2, (totalWidth/_titles.count), 2};
//        bottomline.frame = (CGRect){0, self.frame.size.height-2, (XKAppWidth/_titles.count), 2};
        bottomline.backgroundColor = self.selectColor;
    }
    if (self.showBottomline) {
        [self addSubview:bottomline];
    }
}

- (void)changeEvent:(UIButton *)sender
{
    if (selectIndex == sender.tag) {
        return;
    }
    
    selectIndex = sender.tag;

    if (__handler) {
        __handler(sender.tag - 100, sender, __notices[sender.tag - 100], self, @selector(dismiss:));
    }
    [self changeStates:sender.tag];
}

- (void)dismiss:(NSInteger )num
{
    UILabel * L = __notices[selectIndex -100];
    L.text = [NSString stringWithFormat:@"%ld",(long)num];
    L.hidden = YES;
}

- (void)changeStates:(NSInteger)sender
{
    selectIndex = sender;
    for (UIButton *_B in buttons) {
        if (_B.tag == sender) {
            _B.selected = YES;
            [UIView animateWithDuration:0.1 animations:^{
                CGRect myFrame = bottomline.frame;
                myFrame.origin.x = _B.frame.origin.x;
                bottomline.frame = myFrame;
            }];
        }else _B.selected = NO;
    }
}

- (void)setNotices:(inout NSArray<NSString *> *)notices ///<    特殊需求  不用调此方法
{
    if (notices.count == buttons.count) {
        
        int index = 0;
        for (UILabel * L in __notices) {
            
            if (notices[index].intValue > 0) {
                if (notices[index].intValue > 99) {
                    L.text = @"99+";
                    L.hidden = NO;
                }else{
                    L.text = notices[index];
                    L.hidden = NO;
                }
            }else{
                L.hidden = YES;
            }
            
            index ++;
        }
    }else{
       
        for (UILabel * L in __notices) {
            L.hidden = YES;
        }
    }
}
@end
