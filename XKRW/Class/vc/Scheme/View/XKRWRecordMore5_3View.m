//
//  XKRWRecordMore5_3View.m
//  XKRW
//
//  Created by ss on 16/4/18.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWRecordMore5_3View.h"

@implementation XKRWRecordMore5_3View
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = LOAD_VIEW_FROM_BUNDLE(@"XKRWRecordMore5_3View");
        self.frame = frame;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}
- (IBAction)actChange:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pressChangeEatPercent)]) {
        [self.delegate pressChangeEatPercent];
    }
}

- (IBAction)actSet:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pressSetEatNotify)]) {
        [self.delegate pressSetEatNotify];
    }
}
@end
