//
//  XKDiscreteProgressView.m
//  calorie
//
//  Created by Rick Liao on 12-12-22.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import "XKCuiUtil.h"
#import "XKDiscreteProgressView.h"

@interface XKDiscreteProgressView ()

@end


@implementation XKDiscreteProgressView

@synthesize progressViewStyle = _progressViewStyle;

@synthesize progress = _progress;
@synthesize track = _track;

@synthesize progressImage = _progressImage;
@synthesize trackImage = _trackImage;

@synthesize progressImageName = _progressImageName;
@synthesize trackImageName = _trackImageName;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    _progressViewStyle = XKDiscreteProgressViewStyleLeftToRight;
    
    _progress = 0;
    _track = 0;
}

- (void)layoutSubviews {
    [self buildView];
}

- (void)setProgress:(NSInteger)progress animated:(BOOL)animated {
    progress = MIN(MAX(progress, 0), _track);
    
    if (progress != _progress) {
        if (animated) {
            NSUInteger fromProgress = _progress + (progress < _progress ? -1 : 1);
            
            float totalTime = ((float) abs((int)(progress - _progress))) / ((float) _track);
            NSUInteger totalCount = abs((int)(progress - _progress)) + 1;
            NSArray *times = [XKCuiUtil createEaseInEaseOutTimesForTotalTime:totalTime totalCount:totalCount];
            NSArray *durations = [XKCuiUtil convertTimesToDurations:times];
            
            [self animateProgressFrom:fromProgress to:progress durations:durations currentIndex:0];
        } else {
            _progress = progress;
            [self setNeedsLayout];
        }
    } // else NOP
}

- (void)animateProgressFrom:(NSUInteger)fromProgress
                         to:(NSUInteger)toProgress
                  durations:(NSArray *)durations
               currentIndex:(NSUInteger)currentIndex
{
    [UIView transitionWithView:self
                      duration:((NSNumber *)durations[currentIndex]).floatValue
                        options:UIViewAnimationOptionAllowUserInteraction
                                | UIViewAnimationOptionBeginFromCurrentState
                                | UIViewAnimationOptionCurveLinear
                                | UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         _progress = fromProgress;
                         [self buildView];
                     }
                     completion:^(BOOL finished){
                         if (fromProgress < toProgress) {
                             [self animateProgressFrom:fromProgress + 1
                                                    to:toProgress
                                             durations:durations
                                          currentIndex:currentIndex + 1];
                         } else if (fromProgress > toProgress) {
                             [self animateProgressFrom:fromProgress - 1
                                                    to:toProgress
                                             durations:durations
                                          currentIndex:currentIndex + 1];
                         } // else NOP
                     }];
}

- (void)buildView {    
    UIView *unitView = nil;
    CGRect unitFrame = CGRectZero;
    
    for (unitView in self.subviews) {
        [unitView removeFromSuperview];
    }
    
    if (_track >= 2) {
        unitView = [self unitView:0];
        unitFrame = unitView.bounds;
        unitFrame.origin.y = (self.bounds.size.height - unitFrame.size.height) * 0.5;
        unitView.frame = unitFrame;
        [self addSubview:unitView];
        
        CGFloat trackUnitWidth = _trackImage.size.width;
        CGFloat margin = (self.bounds.size.width - trackUnitWidth * _track) / (_track - 1);
        for (NSUInteger i = 1; i < _track - 1; ++i) {
            unitView = [self unitView:i];
            unitFrame = unitView.bounds;
            unitFrame.origin.x = (trackUnitWidth + margin) * i + trackUnitWidth * 0.5 - unitFrame.size.width * 0.5;
            unitFrame.origin.y = (self.bounds.size.height - unitFrame.size.height) * 0.5;
            unitView.frame = unitFrame;
            [self addSubview:unitView];
        }
        
        unitView = [self unitView:_track - 1];
        unitFrame = unitView.bounds;
        unitFrame.origin.x = self.bounds.size.width - unitFrame.size.width;
        unitFrame.origin.y = (self.bounds.size.height - unitFrame.size.height) * 0.5;
        unitView.frame = unitFrame;
        [self addSubview:unitView];
    } else if (_track == 1) {
        unitView = [self unitView:0];
        unitFrame = unitView.bounds;
        unitFrame.origin.x = (self.bounds.size.width - unitFrame.size.width) * 0.5;
        unitFrame.origin.y = (self.bounds.size.height - unitFrame.size.height) * 0.5;
        unitView.frame = unitFrame;
        [self addSubview:unitView];
    } // else NOP
}

- (UIView *)unitView:(NSUInteger)index {
    return [[UIImageView alloc] initWithImage:(index < _progress ? _progressImage : _trackImage)];
}

- (void)setProgressViewStyle:(XKDiscreteProgressViewStyle)progressViewStyle {
    _progressViewStyle = progressViewStyle;
    [self setNeedsLayout];
}

- (void)setProgress:(NSInteger)progress {
    [self setProgress:progress animated:NO];
}

- (void)setTrack:(NSInteger)track {
    _track = MAX(track, 0);
    if (_progress > _track) {
        _progress = _track;
    }
    [self setNeedsLayout];
}

- (void)setProgressImage:(UIImage *)progressImage {
    _progressImage = progressImage;
    [self setNeedsLayout];
}

- (void)setTrackImage:(UIImage *)trackImage {
    _trackImage = trackImage;
    [self setNeedsLayout];
}

- (void)setProgressImageName:(NSString *)progressImageName {
    _progressImageName = progressImageName;
    
    UIImage *progressImage = [UIImage imageNamed:progressImageName];
    self.progressImage = progressImage;
}

- (void)setTrackImageName:(NSString *)trackImageName {
    _trackImageName = trackImageName;
    
    UIImage *trackImage = [UIImage imageNamed:trackImageName];
    self.trackImage = trackImage;
}

@end
