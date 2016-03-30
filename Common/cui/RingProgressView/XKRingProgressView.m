//
//  XKRingouterBorderView.m
//  calorie
//
//  Created by Rick Liao on 12-11-30.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <CoreText/CTFont.h>
#import "XKRingProgressView.h"

#pragma mark - declaration of all
static const CGFloat kUnused = -1.f;


@interface XKRPVRingLayout : NSObject

@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;

@property(nonatomic) CGFloat innermostRadius;
@property(nonatomic) CGFloat trackInnerRadius;
@property(nonatomic) CGFloat progressInnerRadius;
@property(nonatomic) CGFloat progressOuterRadius;
@property(nonatomic) CGFloat trackOuterRadius;
@property(nonatomic) CGFloat outermostRadius;

+ (XKRPVRingLayout *)newWithCenterX:(CGFloat)centerX
                            centerY:(CGFloat)centerY
                    innermostRadius:(CGFloat)innermostRadius
                   trackInnerRadius:(CGFloat)trackInnerRadius
                progressInnerRadius:(CGFloat)progressInnerRadius
                progressOuterRadius:(CGFloat)progressOuterRadius
                   trackOuterRadius:(CGFloat)trackOuterRadius
                    outermostRadius:(CGFloat)outermostRadius;

- (XKRPVRingLayout *)initWithCenterX:(CGFloat)centerX
                             centerY:(CGFloat)centerY
                     innermostRadius:(CGFloat)innermostRadius
                    trackInnerRadius:(CGFloat)trackInnerRadius
                 progressInnerRadius:(CGFloat)progressInnerRadius
                 progressOuterRadius:(CGFloat)progressOuterRadius
                    trackOuterRadius:(CGFloat)trackOuterRadius
                     outermostRadius:(CGFloat)outermostRadius;

@end


@protocol XKRPVRingLayouter <NSObject>

- (XKRPVRingLayout *)calculateRingLayout:(CGRect)baseRect fan:(BOOL)fan;

@end


@interface XKRPVTrackLayer : CALayer

@property(nonatomic, weak) id<XKRPVRingLayouter> layoutDelegate;
 
@property(nonatomic) CGColorRef trackTintColor;
@property(nonatomic) CGColorRef innerBorderTintColor;
@property(nonatomic) CGColorRef outerBorderTintColor;
@property(nonatomic) CGColorRef centerTintColor;

@end


@interface XKRPVProgressLayer : CALayer

@property(nonatomic, weak) id<XKRPVRingLayouter> layoutDelegate;

@property(nonatomic) float progress;

@property(nonatomic) CGColorRef progressTintColor;

@property(nonatomic) XKProgressCapStyle progressCapStyle;

@end


@interface XKRPVTextLayer : CATextLayer

@property(nonatomic, weak) id<XKRPVRingLayouter> layoutDelegate;

@property(nonatomic) XKProgressTextMode progressTextMode;
@property(nonatomic,retain) id<XKProgressTextFormatter> progressTextFormatter;

@property(nonatomic) float progress;

- (void)resizeFrameToSingleLine;

- (void)setProgress:(float)progress;

@end


@interface XKRingProgressView () <XKRPVRingLayouter>

@property (nonatomic, retain) XKRPVTrackLayer *trackLayer;
@property (nonatomic, retain) XKRPVProgressLayer *progressLayer;
@property (nonatomic, retain) XKRPVTextLayer *textLayer;

@end


#pragma mark - implementation of XKRingProgressView
@implementation XKRingProgressView

@synthesize trackLayer;
@synthesize progressLayer;
@synthesize textLayer;

@synthesize progressRatio = _progressRatio;
@synthesize trackRatio = _trackRatio;
@synthesize innerBorderRatio = _innerBorderRatio;
@synthesize outerBorderRatio = _outerBorderRatio;

@synthesize progressWidth = _progressWidth;
@synthesize trackWidth = _trackWidth;
@synthesize innerBorderWidth = _innerBorderWidth;
@synthesize outerBorderWidth = _outerBorderWidth;

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
    // assemble layers
    trackLayer = [XKRPVTrackLayer layer];
    trackLayer.contentsScale = [UIScreen mainScreen].scale;
    trackLayer.needsDisplayOnBoundsChange = YES;
    trackLayer.layoutDelegate = self;
    
    progressLayer = [XKRPVProgressLayer layer];
    progressLayer.contentsScale = [UIScreen mainScreen].scale;
    progressLayer.needsDisplayOnBoundsChange = YES;
    progressLayer.layoutDelegate = self;

    textLayer = [XKRPVTextLayer layer];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.needsDisplayOnBoundsChange = YES;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.layoutDelegate = self;
    textLayer.progressTextFormatter = nil;
    
    self.layer.needsDisplayOnBoundsChange = YES;
    [self.layer addSublayer:trackLayer];
    [self.layer addSublayer:progressLayer];
    [self.layer addSublayer:textLayer];
    
    // config default
    self.progress = 0.f;
    
    self.progressRatio = 0.33f;
    self.trackRatio = 0.33f;
    self.innerBorderRatio = 0.07f;
    self.outerBorderRatio = 0.07f;
    
    self.trackTintColor = UIColor.whiteColor;
    self.progressTintColor = UIColor.lightGrayColor;
    self.innerBorderTintColor = UIColor.darkGrayColor;
    self.outerBorderTintColor = UIColor.darkGrayColor;
    self.centerTintColor = UIColor.clearColor;
    
    self.progressCapStyle = kXKProgressCapStyleButt;
    
    self.progressTextMode = kXKProgressTextModeAuto;
    self.progressTextFormatter = nil;
    self.progressTextFont = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
    self.progressTextColor = UIColor.darkGrayColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    trackLayer.frame = self.layer.bounds;
    progressLayer.frame = self.layer.bounds;
    textLayer.frame = self.layer.bounds;
    [textLayer resizeFrameToSingleLine];
}

- (XKRPVRingLayout *)calculateRingLayout:(CGRect)baseRect fan:(BOOL)fan {
    CGFloat centerX = baseRect.origin.x + baseRect.size.width / 2.f;
    CGFloat centerY = baseRect.origin.y + (fan ? -1.f:1.f) * baseRect.size.height / 2.f;
    
    CGFloat outermostRadius = MIN(baseRect.size.height, baseRect.size.width) / 2.f;
    
    CGFloat drawnTrackWidth = (self.trackRatio == kUnused ? self.trackWidth : outermostRadius * self.trackRatio);
    drawnTrackWidth = MIN(MAX(drawnTrackWidth, 0.f), outermostRadius);
    
    CGFloat drawnInnerBorderWidth =  (self.innerBorderRatio == kUnused ? self.innerBorderWidth : outermostRadius * self.innerBorderRatio);
    drawnInnerBorderWidth = MAX(drawnInnerBorderWidth, 0.f);
    CGFloat drawnOuterBorderWidth =  (self.outerBorderRatio == kUnused ? self.outerBorderWidth : outermostRadius * self.outerBorderRatio);
    drawnOuterBorderWidth = MAX(drawnOuterBorderWidth, 0.f);
    CGFloat expectedBorderWidth = drawnInnerBorderWidth + drawnOuterBorderWidth;
    CGFloat maxBorderWidth = outermostRadius - drawnTrackWidth;
    if (expectedBorderWidth > maxBorderWidth) {
        drawnInnerBorderWidth = maxBorderWidth * drawnInnerBorderWidth / expectedBorderWidth;
        drawnOuterBorderWidth = maxBorderWidth * drawnOuterBorderWidth / expectedBorderWidth;
    }
    
    CGFloat drawnProgressWidth = (self.progressRatio == kUnused ? self.progressWidth : outermostRadius * self.progressRatio);
    drawnProgressWidth = MIN(MAX(drawnProgressWidth, 0.f), drawnTrackWidth);
    
    CGFloat innermostRadius = outermostRadius - drawnTrackWidth - drawnOuterBorderWidth - drawnInnerBorderWidth;
    CGFloat trackInnerRadius = innermostRadius + drawnInnerBorderWidth;
    CGFloat trackOuterRadius = trackInnerRadius + drawnTrackWidth;
    CGFloat progressInnerRadius = (trackInnerRadius + trackOuterRadius - drawnProgressWidth) / 2.f;
    CGFloat progressOuterRadius = (trackInnerRadius + trackOuterRadius + drawnProgressWidth) / 2.f;
    
    XKRPVRingLayout *rpLayout = [XKRPVRingLayout newWithCenterX:centerX
                                                        centerY:centerY
                                                innermostRadius:innermostRadius
                                               trackInnerRadius:trackInnerRadius
                                            progressInnerRadius:progressInnerRadius
                                            progressOuterRadius:progressOuterRadius
                                               trackOuterRadius:trackOuterRadius
                                                outermostRadius:outermostRadius];
    return rpLayout;
}

- (float)progress {
    return progressLayer.progress;
}

- (void)setProgress:(float)progress {
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {    
    if (animated) {
        CABasicAnimation *progressLayerAnimation = [self createProgressAnimationWithKey:@"progress" newProgress:progress];
        [progressLayer addAnimation:progressLayerAnimation forKey:@"progress"];
        
        CABasicAnimation *textLayerAnimation = [self createProgressAnimationWithKey:@"progress" newProgress:progress];
        [textLayer addAnimation:textLayerAnimation forKey:@"progress"];
    } // else NOP
    
    progressLayer.progress = progress;
    textLayer.progress = progress;
}

- (CABasicAnimation*)createProgressAnimationWithKey:(NSString *)key newProgress:(float)newProcess {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:key];
    
    animation.duration = fabsf(newProcess - self.progress);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSNumber numberWithFloat:self.progress];
    animation.toValue = [NSNumber numberWithFloat:newProcess];
    
    return animation;
}

- (void)setProgressRatio:(CGFloat)progressRatio {
    _progressRatio = progressRatio;
    _progressWidth = kUnused;
}

- (void)setTrackRatio:(CGFloat)trackRatio {
    _trackRatio = trackRatio;
    _trackWidth = kUnused;
}

- (void)setInnerBorderRatio:(CGFloat)innerBorderRatio {
    _innerBorderRatio = innerBorderRatio;
    _innerBorderWidth = kUnused;
}

- (void)setOuterBorderRatio:(CGFloat)outerBorderRatio {
    _outerBorderRatio = outerBorderRatio;
    _outerBorderWidth = kUnused;
}

- (void)setProgressWidth:(CGFloat)progressWidth {
    _progressWidth = progressWidth;
    _progressRatio = kUnused;
}

- (void)setTrackWidth:(CGFloat)trackWidth {
    _trackWidth = trackWidth;
    _trackRatio = kUnused;
}

- (void)setInnerBorderWidth:(CGFloat)innerBorderWidth {
    _innerBorderWidth = innerBorderWidth;
    _innerBorderRatio = kUnused;
}

- (void)setOuterBorderWidth:(CGFloat)outerBorderWidth {
    _outerBorderWidth = outerBorderWidth;
    _outerBorderRatio = kUnused;
}

- (UIColor *)progressTintColor {
    return [UIColor colorWithCGColor:progressLayer.progressTintColor];
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    progressLayer.progressTintColor = progressTintColor.CGColor;
    [progressLayer setNeedsDisplay];
}

- (UIColor *)trackTintColor {
    return [UIColor colorWithCGColor:trackLayer.trackTintColor];
}

- (void)setTrackTintColor:(UIColor *)trackTintColor {
    trackLayer.trackTintColor = trackTintColor.CGColor;
    [trackLayer setNeedsDisplay];
}

- (UIColor *)innerBorderTintColor {
    return [UIColor colorWithCGColor:trackLayer.innerBorderTintColor];
}

- (void)setInnerBorderTintColor:(UIColor *)innerBorderTintColor {
    trackLayer.innerBorderTintColor = innerBorderTintColor.CGColor;
    [trackLayer setNeedsDisplay];
}

- (UIColor *)outerBorderTintColor {
    return [UIColor colorWithCGColor:trackLayer.outerBorderTintColor];
}

- (void)setOuterBorderTintColor:(UIColor *)outerBorderTintColor {
    trackLayer.outerBorderTintColor = outerBorderTintColor.CGColor;
    [trackLayer setNeedsDisplay];
}

- (UIColor *)centerTintColor {
    return [UIColor colorWithCGColor:trackLayer.centerTintColor];
}

- (void)setCenterTintColor:(UIColor *)centerTintColor {
    trackLayer.centerTintColor = centerTintColor.CGColor;
    [trackLayer setNeedsDisplay];
}

- (XKProgressCapStyle)progressCapStyle {
    return progressLayer.progressCapStyle;
}

- (void)setProgressCapStyle:(XKProgressCapStyle)progressCapStyle {
    progressLayer.progressCapStyle = progressCapStyle;
    [progressLayer setNeedsDisplay];
}

- (id<XKProgressTextFormatter>)progressTextFormatter {
    return textLayer.progressTextFormatter;
}

- (void)setProgressTextFormatter:(id<XKProgressTextFormatter>)progressFormat {
    textLayer.progressTextFormatter = progressFormat;
}

- (XKProgressTextMode)progressTextMode {
    return textLayer.progressTextMode;
}

- (void)setProgressTextMode:(XKProgressTextMode)progressTextMode {
    textLayer.progressTextMode = progressTextMode;
}

- (NSString *)progressText {
    return textLayer.string;
}

- (void)setProgressText:(NSString *)progressText {
    textLayer.string = progressText;
}

- (UIFont *)progressTextFont {
    return [UIFont fontWithName:(NSString *)CFBridgingRelease(CTFontCopyName(textLayer.font, kCTFontPostScriptNameKey))
                           size:textLayer.fontSize];
}

- (void)setProgressTextFont:(UIFont *)progressTextFont {
    CFStringRef fontName = (CFStringRef)CFBridgingRetain(progressTextFont.fontName);
    
    textLayer.font = CTFontCreateWithName(fontName, progressTextFont.pointSize, NULL);
    textLayer.fontSize = progressTextFont.pointSize;
    
    CFRelease(fontName);
}

- (UIColor *)progressTextColor {
    return [UIColor colorWithCGColor:textLayer.foregroundColor];
}

- (void)setProgressTextColor:(UIColor *)progressTextColor {
    textLayer.foregroundColor = progressTextColor.CGColor;
}

@end


#pragma mark - implementation of XKRPVTrackLayer
@implementation XKRPVTrackLayer

@dynamic layoutDelegate;

@dynamic trackTintColor;
@dynamic innerBorderTintColor;
@dynamic outerBorderTintColor;
@dynamic centerTintColor;

- (void)drawInContext:(CGContextRef)context {
    XKRPVRingLayout *rpLayout = [self.layoutDelegate calculateRingLayout:self.bounds fan:NO];
    
    [self drawRoundWithContext:context
                       centerX:rpLayout.centerX
                       centerY:rpLayout.centerY
                        radius:rpLayout.innermostRadius
                         color:self.centerTintColor];
    
    [self drawRingWithContext:context
                      centerX:rpLayout.centerX
                      centerY:rpLayout.centerY
                  innerRadius:rpLayout.innermostRadius
                  outerRadius:rpLayout.trackInnerRadius
                        color:self.innerBorderTintColor];

    [self drawRingWithContext:context
                      centerX:rpLayout.centerX
                      centerY:rpLayout.centerY
                  innerRadius:rpLayout.trackInnerRadius
                  outerRadius:rpLayout.trackOuterRadius
                        color:self.trackTintColor];
    
    [self drawRingWithContext:context
                      centerX:rpLayout.centerX
                      centerY:rpLayout.centerY
                  innerRadius:rpLayout.trackOuterRadius
                  outerRadius:rpLayout.outermostRadius
                        color:self.outerBorderTintColor];
}

- (void) drawRoundWithContext:(CGContextRef)ctx
                      centerX:(CGFloat)cenX
                      centerY:(CGFloat)cenY
                       radius:(CGFloat)r
                        color:(CGColorRef)color {
    if (r > 0) {
        CGContextSetFillColorWithColor(ctx, color);
        CGContextBeginPath(ctx);
        CGContextAddArc(ctx, cenX, cenY, r, -M_PI_2, 3 * M_PI_2, NO);
        CGContextClosePath (ctx);
        CGContextEOFillPath(ctx);
    } // else NOP
}

- (void) drawRingWithContext:(CGContextRef)ctx
                     centerX:(CGFloat)cenX
                     centerY:(CGFloat)cenY
                 innerRadius:(CGFloat)ir
                 outerRadius:(CGFloat)or
                       color:(CGColorRef)color {
    if (or - ir > 0) {
        CGContextSetFillColorWithColor(ctx, color);
        CGContextBeginPath(ctx);
        CGContextAddArc(ctx, cenX, cenY, ir, -M_PI_2, 3 * M_PI_2, NO);
        CGContextAddArc(ctx, cenX, cenY, or, -M_PI_2, 3 * M_PI_2, NO);
        CGContextClosePath (ctx);
        CGContextEOFillPath(ctx);
    } // else NOP
}

@end


#pragma mark - implementation of XKRPVProgressLayer
@implementation XKRPVProgressLayer

@dynamic layoutDelegate;

@dynamic progress;

@dynamic progressTintColor;
@dynamic progressCapStyle;

+ (BOOL)needsDisplayForKey:(NSString *)key {
    return [key isEqualToString:@"progress"] || [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)context {
    XKRPVRingLayout *rpLayout = [self.layoutDelegate calculateRingLayout:self.bounds fan:NO];
    
    CGFloat drawnProgress = MIN(MAX(self.progress, 0.f), 1.f);
    CGFloat radian = (drawnProgress * 2 * M_PI);
    
    CGLineCap progressCap = kCGLineCapButt;
    if (self.progressCapStyle == kXKProgressCapStyleRound) {
        progressCap = kCGLineCapRound;
    } // else nop
    
    [self strokeArcWithContext:context
                       centerX:rpLayout.centerX
                       centerY:rpLayout.centerY
                            radius:((rpLayout.progressInnerRadius + rpLayout.progressOuterRadius) / 2)
                        startAngle:-M_PI_2
                          endAngle:(-M_PI_2 + radian)
                             color:self.progressTintColor
                         lineWidth:(rpLayout.progressOuterRadius - rpLayout.progressInnerRadius)
                           lineCap:progressCap];
}

- (void) strokeArcWithContext:(CGContextRef)ctx
                      centerX:(CGFloat)cenX
                      centerY:(CGFloat)cenY
                       radius:(CGFloat)r
                   startAngle:(CGFloat)sa
                     endAngle:(CGFloat)ea
                        color:(CGColorRef)color
                    lineWidth:(CGFloat)width
                      lineCap:(CGLineCap)cap {
    if (width > 0 && sa != ea) {
        CGContextSetStrokeColorWithColor(ctx, color);
        CGContextSetLineWidth(ctx, width);
        CGContextSetLineCap(ctx, cap);
        CGContextBeginPath(ctx);
        CGContextAddArc(ctx, cenX, cenY, r, sa, ea, NO);
        CGContextStrokePath(ctx);
    } // else NOP
}

@end


#pragma mark - implementation of XKRPVTextLayer
@implementation XKRPVTextLayer

@dynamic layoutDelegate;

+ (BOOL)needsDisplayForKey:(NSString *)key {
    return [key isEqualToString:@"progress"] || [super needsDisplayForKey:key];
}

- (void)resizeFrameToSingleLine {
    // 微调原因：原来的设置导致文本在垂直方向略微偏上而不居中
//    CGFloat fontHeight = CTFontGetAscent(self.font) + CTFontGetDescent(self.font) + CTFontGetLeading(self.font);
    CGFloat fontHeight = CTFontGetAscent(self.font) + CTFontGetDescent(self.font);
    
    CGRect rect = self.frame;
    if (fontHeight < rect.size.height) {
        CGFloat newY = rect.origin.y + rect.size.height / 2 - fontHeight / 2;
        rect.origin.y = newY;
        rect.size.height = fontHeight;
    }
    
    self.frame = rect;
}

- (void)updateProgressText {
    if (self.progressTextMode == kXKProgressTextModeAuto) {
        if (self.progressTextFormatter) {
            self.string = [self.progressTextFormatter fomatProgress:self.progress];
        } else {
            self.string = [self defaultFormatProgressText:self.progress];
        }
    } // else NOP
}

- (NSString *)defaultFormatProgressText:(float)progress {
    return [NSString stringWithFormat:@"%.0f%%", progress * 100];
}

- (float)getProgress {
    return ((NSNumber *)[self valueForKey:@"_progress"]).floatValue;
}

- (void)setProgress:(float)progress {
    [self setValue:[NSNumber numberWithFloat:progress] forKey:@"_progress"];
    
    [self updateProgressText];
}

- (XKProgressTextMode)progressTextMode {
    XKProgressTextMode result;
    
    [((NSValue *)[self valueForKey:@"_progressTextMode"]) getValue:&result];
    
    return result;
}

- (void)setProgressTextMode:(XKProgressTextMode)progressTextMode {
    [self setValue:[NSValue value:&progressTextMode withObjCType:@encode(enum XKProgressTextMode)]
            forKey:@"_progressTextMode"];
    
    self.hidden = (progressTextMode == kXKProgressTextModeNone ? YES : NO);
    
    [self updateProgressText];
}

- (id<XKProgressTextFormatter>)progressTextFormatter {
    return [self valueForKey:@"_progressTextFormatter"];
}

- (void)setProgressTextFormatter:(id<XKProgressTextFormatter>)progressTextFormatter {
    [self setValue:progressTextFormatter forKey:@"_progressTextFormatter"];
    [self updateProgressText];
}

@end


#pragma mark - implementation of XKRPVRingLayout
@implementation XKRPVRingLayout

@synthesize centerX = _centerX;
@synthesize centerY = _centerY;

@synthesize innermostRadius = _innermostRadius;
@synthesize trackInnerRadius = _trackInnerRadius;
@synthesize progressInnerRadius = _progressInnerRadius;
@synthesize progressOuterRadius = _progressOuterRadius;
@synthesize trackOuterRadius = _trackOuterRadius;
@synthesize outermostRadius = _outermostRadius;

+ (XKRPVRingLayout *)newWithCenterX:(CGFloat)centerX
                            centerY:(CGFloat)centerY
                    innermostRadius:(CGFloat)innermostRadius
                   trackInnerRadius:(CGFloat)trackInnerRadius
                progressInnerRadius:(CGFloat)progressInnerRadius
                progressOuterRadius:(CGFloat)progressOuterRadius
                   trackOuterRadius:(CGFloat)trackOuterRadius
                    outermostRadius:(CGFloat)outermostRadius {
    return [[XKRPVRingLayout alloc] initWithCenterX:centerX
                                            centerY:centerY
                                    innermostRadius:innermostRadius
                                   trackInnerRadius:trackInnerRadius
                                progressInnerRadius:progressInnerRadius
                                progressOuterRadius:progressOuterRadius
                                   trackOuterRadius:trackOuterRadius
                                    outermostRadius:outermostRadius];
}

- (XKRPVRingLayout *)initWithCenterX:(CGFloat)centerX
                             centerY:(CGFloat)centerY
                     innermostRadius:(CGFloat)innermostRadius
                    trackInnerRadius:(CGFloat)trackInnerRadius
                 progressInnerRadius:(CGFloat)progressInnerRadius
                 progressOuterRadius:(CGFloat)progressOuterRadius
                    trackOuterRadius:(CGFloat)trackOuterRadius
                     outermostRadius:(CGFloat)outermostRadius {
    self = [super init];
    
    if (self) {
        self.centerX = centerX;
        self.centerY = centerY;
        self.innermostRadius = innermostRadius;
        self.trackInnerRadius = trackInnerRadius;
        self.progressInnerRadius = progressInnerRadius;
        self.progressOuterRadius = progressOuterRadius;
        self.trackOuterRadius = trackOuterRadius;
        self.outermostRadius = outermostRadius;
    }
    
    return self;
}

@end
