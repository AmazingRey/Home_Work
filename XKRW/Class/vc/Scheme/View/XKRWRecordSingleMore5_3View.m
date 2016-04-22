//
//  XKRWRecordSingleMore5_3View.m
//  XKRW
//
//  Created by ss on 16/4/21.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWRecordSingleMore5_3View.h"

@implementation XKRWRecordSingleMore5_3View
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = LOAD_VIEW_FROM_BUNDLE(@"XKRWRecordSingleMore5_3View");
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

- (IBAction)actSet:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pressSetSportNotify)]) {
        [self.delegate pressSetSportNotify];
    }
}
@end
