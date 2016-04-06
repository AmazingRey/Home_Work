//
//  XKRWWeightRecordPullView.m
//  XKRW
//
//  Created by ss on 16/4/6.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWWeightRecordPullView.h"

@implementation XKRWWeightRecordPullView
@synthesize btnWeight,btnContain,btnGraph;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = LOAD_VIEW_FROM_BUNDLE(@"XKRWWeightRecordPullView");
    }
    return self;
}
- (IBAction)actWeight:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pressWeight)]) {
        [self.delegate pressWeight];
    }
}

- (IBAction)actContain:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pressContain)]) {
        [self.delegate pressContain];
    }
}

- (IBAction)actGraph:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pressGraph)]) {
        [self.delegate pressGraph];
    }
}
@end