//
//  AssessmentProgressBar.m
//  XKRW
//
//  Created by XiKang on 15-1-23.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "AssessmentProgressBar.h"

@interface AssessmentProgressBar ()
@property (nonatomic, strong) NSMutableArray *stageViews;
@property (nonatomic, assign) NSInteger currentStage;
@property (nonatomic, assign) NSInteger numberOfStages;
@end

@implementation AssessmentProgressBar

- (instancetype)initWithFrame:(CGRect)frame numberOfStage:(NSInteger)stage {
    if ([super initWithFrame:frame]) {
        _stageViews = [NSMutableArray array];
        
        _numberOfStages = stage;
        
        CGFloat width = frame.size.width / stage;
        CGFloat height = frame.size.height;
        for (int i = 0; i < stage; i ++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
//            view.hidden = YES;
            view.tag = i;
            [self addSubview:view];
            [_stageViews addObject:view];
        }
    }
    return self;
}

- (void)setStageColors:(NSArray *)colorArray {
    
    NSInteger index = 0;
    for (UIView *view in _stageViews) {
        if ([colorArray[index] isKindOfClass:[UIColor class]]) {
            view.backgroundColor = colorArray[index++];
        }
    }
}
/**
 *  Begin from 1
 */
- (void)setToStage:(NSInteger)stage {
    for (int i = 0; i < _numberOfStages; i ++) {
        UIView *view = _stageViews[i];
        if (i <= stage - 1) {
            view.alpha = 1.f;
        } else {
            view.alpha = 0.4;
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
