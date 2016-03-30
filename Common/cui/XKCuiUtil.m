//
//  XKCuiUtil.m
//  calorie
//
//  Created by Rick Liao on 12-12-28.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import "UITextField+XKCui.h"
#import "WCAlertView.h"
#import "XKCuiUtil.h"

@implementation XKCuiUtil

+ (void)limitTextField:(UITextField *)textField maxInputLengthTo:(NSInteger)maxInputLength {
    if (maxInputLength >= 0) {
        NSUInteger currentLength = textField.text.length - [textField offsetFromPosition:textField.markedTextRange.start toPosition:textField.markedTextRange.end];
        
        if (currentLength > maxInputLength) {
            textField.text = [textField.text substringToIndex:maxInputLength];
        } // else NOP
    } // else NOP
}

+ (BOOL)limitTextField:(UITextField *)textField
        maxInputLengthTo:(NSInteger)maxInputLength
beforeChangingCharsInRange:(NSRange)range
     replacementString:(NSString *)string {
    BOOL ret = YES;
    
    if (maxInputLength >= 0) {
        NSUInteger newLength = textField.text.length + string.length - range.length;
        
        if (newLength > maxInputLength) {
            textField.text = [[textField.text stringByReplacingCharactersInRange:range withString:string] substringToIndex:maxInputLength];
            
            NSUInteger caret = range.location + string.length;
            if (caret < maxInputLength) {
                [textField setSelectedRange:NSMakeRange(caret, 0)];
            } // else NOP
            
            ret = NO;
        } // else NOP
    } // else NOP
    
    return ret;
}

+ (NSArray *)createEaseInEaseOutTimesForTotalTime:(float)totalTime
                                       totalCount:(NSUInteger)totalCount {
    return  [XKCuiUtil createCenterBalancedTimesForTotalTime:totalTime
                                                  totalcount:totalCount
                                                 centerCount:roundf(totalCount * 0.6f)
                                             centerTimeRatio:0.4];
}

+ (NSArray *)createCenterBalancedTimesForTotalTime:(float)totalTime
                                        totalcount:(NSUInteger)totalCount
                                       centerCount:(NSUInteger)centerCount   // 有效区间［1，totalCount］
                                   centerTimeRatio:(float)centerTimeRatio {  // 有效区间［0，1］
    NSMutableArray *times = [NSMutableArray arrayWithCapacity:totalCount];
    
    if (totalCount >= 4) {
        centerCount = MIN(MAX(centerCount, 1.f), totalCount);
        centerTimeRatio = MIN(MAX(centerTimeRatio, 0.f), 1.f);
        
        NSUInteger fadeCount = floorf((totalCount - centerCount - 1.f) / 2.f);
        centerCount = totalCount - 2 * fadeCount - 1;
        
        float centerUnit = 0.f;
        float fadeTotal = 0.f;
        float fadeEndUnit = 0.f;
        float fadeChange = 0.f;
        
        if (fadeCount > 0) {
            centerUnit = totalTime * centerTimeRatio / centerCount;
            fadeTotal = totalTime * (1.f - centerTimeRatio);
            
            fadeEndUnit = (fadeTotal + centerUnit - fadeCount * centerUnit) / (fadeCount + 1.f);
            fadeChange = (fadeCount == 0) ? 0 : (fadeTotal - 2.f * fadeCount * centerUnit) / (fadeCount * fadeCount + fadeCount);
        } else {
            centerUnit = totalTime / centerCount;
        }
        
        float time = 0.f;
        
        for (int i = 0; i < fadeCount; ++i) {
            [times addObject:[NSNumber numberWithFloat:time]];
            time += (fadeEndUnit - i * fadeChange);
        }
        
        for (int i = 0; i < centerCount; ++i) {
            [times addObject:[NSNumber numberWithFloat:time]];
            time += centerUnit;
        }
        
        for (int i = 0; i < fadeCount; ++i) {
            [times addObject:[NSNumber numberWithFloat:time]];
            time += (fadeEndUnit - (fadeCount - 1 - i) * fadeChange);
        }
        
        [times addObject:[NSNumber numberWithFloat:totalTime]];
    } else if (totalCount == 3) {
        [times addObject:[NSNumber numberWithFloat:0.f]];
        [times addObject:[NSNumber numberWithFloat:(0.5f * totalTime)]];
        [times addObject:[NSNumber numberWithFloat:totalTime]];
    } else if (totalCount == 2) {
        [times addObject:[NSNumber numberWithFloat:0.f]];
        [times addObject:[NSNumber numberWithFloat:totalTime]];
    } else if (totalCount == 1) {
        [times addObject:[NSNumber numberWithFloat:totalTime]];
    } // else NOP
    
    return times;
}

+ (NSArray *)convertTimesToDurations:(NSArray *)times {
    NSMutableArray *durations = nil;
    
    if (times.count >= 2) {
        durations = [NSMutableArray arrayWithCapacity:times.count - 1];
        float duration = 0.f;
        
        for (NSUInteger i = 0; i < times.count - 1; ++i) {
            duration = ((NSNumber *) times[i + 1]).floatValue - ((NSNumber *) times[i]).floatValue;
            [durations addObject:[NSNumber numberWithFloat:duration]];
        }
    } else if (times.count == 1) {
        durations = [NSMutableArray arrayWithObject:[((NSNumber *) times[0]) copyWithZone:NULL]];
    } else if (times) {
        durations = [NSMutableArray arrayWithCapacity:0];
    } // else NOP
    
    return durations;
}

+ (UIButton *)createButtonWithNormalImageName:(NSString *)normalImageName
                         highlightedImageName:(NSString *)highlightedImageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    
    [button setFrame:CGRectMake(0, 0, normalImage.size.width, normalImage.size.height)];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    if (highlightedImageName) {
        [button setBackgroundImage:[UIImage imageNamed:highlightedImageName]
                          forState:UIControlStateHighlighted];
    }
    
    return button;
}

+ (UIButton *)createButtonWithNormalImageName:(NSString *)normalImageName
                         highlightedImageName:(NSString *)highlightedImageName
                                       target:(id)target
                                       action:(SEL)action {
    UIButton *button = [self createButtonWithNormalImageName:normalImageName
                                        highlightedImageName:highlightedImageName];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIBarButtonItem *)createBarButtonItemWithNormalImageName:(NSString *)normalImageName
                                       highlightedImageName:(NSString *)highlightedImageName
                                                     target:(id)target
                                                     action:(SEL)action {
    UIButton *barButton = [self createButtonWithNormalImageName:normalImageName
                                           highlightedImageName:highlightedImageName
                                                         target:target
                                                         action:action];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    return barButtonItem;
}

+ (void)showAlertWithMessage:(NSString *)message
               okButtonTitle:(NSString *)okButtonTitle
                   onOKBlock:(void (^)(void))onOKBlock {
    [self showAlertWithTitle:nil
                     message:message
               okButtonTitle:okButtonTitle
                   onOKBlock:onOKBlock];
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
             okButtonTitle:(NSString *)okButtonTitle
                 onOKBlock:(void (^)(void))onOKBlock {
    [WCAlertView showAlertWithTitle:title
                            message:message
                 customizationBlock:nil
                    completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        if (onOKBlock) {
                            onOKBlock();
                        }
                    } cancelButtonTitle:nil
                  otherButtonTitles:okButtonTitle, nil];
}

+ (void)showConfirmWithMessage:(NSString *)message
                 okButtonTitle:(NSString *)okButtonTitle
             cancelButtonTitle:(NSString *)cancelButtonTitle
                     onOKBlock:(void (^)(void))onOKBlock {
    [self showConfirmWithTitle:nil
                       message:message
                 okButtonTitle:okButtonTitle
             cancelButtonTitle:cancelButtonTitle
                     onOKBlock:onOKBlock];
}

+ (void)showConfirmWithTitle:(NSString *)title
                     message:(NSString *)message
               okButtonTitle:(NSString *)okButtonTitle
           cancelButtonTitle:(NSString *)cancelButtonTitle
                   onOKBlock:(void (^)(void))onOKBlock {
    [WCAlertView showAlertWithTitle:title
                            message:message
                 customizationBlock:nil
                    completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        if (buttonIndex != alertView.cancelButtonIndex && onOKBlock) {
                            onOKBlock();
                        } // else NOP
                    } cancelButtonTitle:cancelButtonTitle
                  otherButtonTitles:okButtonTitle, nil];
}
+ (void)showConfirmWithTitle:(NSString *)title
                     message:(NSString *)message
               okButtonTitle:(NSString *)okButtonTitle
           cancelButtonTitle:(NSString *)cancelButtonTitle
                   onOKBlock:(void (^)(void))onOKBlock
               onCancelBlock:(void (^)(void)) onCancelBlock{
    [WCAlertView showAlertWithTitle:title
                            message:message
                 customizationBlock:nil
                    completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        if (buttonIndex != alertView.cancelButtonIndex && onOKBlock) {
                            onOKBlock();
                        } else {
                            
                            if (onCancelBlock) {
                                onCancelBlock();
                            }
                        }
                    } cancelButtonTitle:cancelButtonTitle
                  otherButtonTitles:okButtonTitle, nil];
}
@end
