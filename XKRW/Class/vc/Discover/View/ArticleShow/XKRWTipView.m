//
//  XKRWTipView.m
//  XKRW
//
//  Created by Shoushou on 15/12/17.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWTipView.h"

@interface XKRWTipView ()
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) NSArray *myTitleArray;
@end

@implementation XKRWTipView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, XKAppWidth, XKAppHeight);
        self.backgroundColor = XKClearColor;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelf)];
        [self addGestureRecognizer:tap];
        
        self.segment = [[UISegmentedControl alloc] init];
        [self.segment addTarget:self action:@selector(selectedWithIndex:) forControlEvents:UIControlEventValueChanged];
        self.segment.size = CGSizeMake(150, 30);
        self.segment.momentary = YES;
        self.segment.layer.masksToBounds = YES;
        self.segment.layer.borderWidth = 2.0;
        self.segment.layer.cornerRadius = 2.5;
        self.segment.layer.borderColor = [UIColor colorFromHexString:@"#6e6e6e"].CGColor;
        self.tintColor = [UIColor whiteColor];
        self.segment.backgroundColor = [UIColor colorFromHexString:@"#6e6e6e"];
        [self addSubview:self.segment];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.hidden = YES;
    }
    
    return self;
}


- (void)hideSelf {
    self.hidden = YES;
}

- (void)showUpView:(UIView *)view titles:(NSArray *)titles {
    _myTitleArray = [NSArray arrayWithArray:titles];
    [self.segment removeAllSegments];
    for (int i = 0; i < titles.count; i++) {
        [self.segment insertSegmentWithTitle:titles[i] atIndex:i animated:NO];
    }
    
    CGFloat y = view.frame.origin.y;
    while (view != nil) {
        view = view.superview;
        y += view.frame.origin.y;
        if ([view isKindOfClass:[UIScrollView class]]) {
            y -= ((UIScrollView *)view).contentOffset.y;
        }
    }
    
    self.segment.center = CGPointMake(XKAppWidth/2, y - 15);
    self.hidden = NO;
}

- (void)selectedWithIndex:(UISegmentedControl *)segmentCtl {
    typeof(self) __weak weakSelf = self;
    if (self.delegate) {
        if ([_myTitleArray[segmentCtl.selectedSegmentIndex] isEqualToString:@"删除"]) {
            [_delegate tipView:weakSelf delectCommentWithCommentId:weakSelf.commentId];
        } else if ([_myTitleArray[segmentCtl.selectedSegmentIndex] isEqualToString:@"举报"]) {
            [_delegate tipView:weakSelf reportCommentWithCommentId:weakSelf.commentId];
        } else if ([_myTitleArray[segmentCtl.selectedSegmentIndex] isEqualToString:@"复制"]) {
            if (weakSelf.indexArray.count == 1) {
                [_delegate tipView:weakSelf copyAtIndexPath:weakSelf.indexArray[0] subIndexPath:nil];
            } else if (weakSelf.indexArray.count == 2) {
                [_delegate tipView:weakSelf copyAtIndexPath:weakSelf.indexArray[0] subIndexPath:weakSelf.indexArray[1]];
            }
    
        }
    }
    [self hideSelf];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
