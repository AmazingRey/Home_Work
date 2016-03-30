//
//  XKBarChartView.m
//  calorie
//
//  Created by Rick Liao on 12-12-22.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XKVerticalAlignableLabel.h"
#import "XKCuiUtil.h"
#import "XKBarChartView.h"

#pragma mark - declaration of all
static const NSUInteger  kAnimationKeyFPS = 60;
static const CFTimeInterval kAnimationDuration = 0.75;


@interface XKBCVChartLayer : CALayer

@property (nonatomic, assign) XKBarChartViewStyle chartStyle;

@property (nonatomic) NSArray *chartData; // 数组中元素为XKBCVBarData类型

@property (nonatomic, assign) float barFullValue;

@property (nonatomic, assign) CGFloat barMargin;

- (UIColor *)barColorForStyle:(NSString *)style;
- (void)setBarColor:(UIColor *)color forStyle:(NSString *)style;

@end


@interface XKBCVChartLayer ()

@property (nonatomic) NSMutableDictionary *barColors;

@end


@interface XKBCVChart : UIView

@property (nonatomic, assign) XKBarChartViewStyle chartStyle;

@property (nonatomic) NSArray *chartData; // 数组中元素为XKBCVBarData类型

@property (nonatomic, assign) CGFloat barMargin;

@property (nonatomic) UIColor *chartBackgroundColor;

@property (nonatomic) BOOL allowBackgroundCreatingForAnimationData;

- (void)setChartData:(NSArray *)chartData animated:(BOOL)animated;  // chartData数组中元素为XKBCVBarData类型

- (UIColor *)barColorForStyle:(NSString *)style;
- (void)setBarColor:(UIColor *)color forStyle:(NSString *)style;

@end


@interface XKBCVChart ()

@property (nonatomic, readonly) XKBCVChartLayer *chartLayer;

// 缓存动画插入桢值的对象数组的原因：插值时大量的值对象的内存申请的总体时间开销过大
@property (nonatomic) NSMutableArray *animationFrameValues;

@property (nonatomic) dispatch_queue_t animationDataBackgroundCreator;
@property (atomic) NSUInteger dataSettingCount;

@end


@interface XKBCVCoord : UIView

@property (nonatomic) NSArray *coordData; // 数组中元素要求为NSString类型，要求至少有两个元素

@property (nonatomic) UIFont *coordFont;
@property (nonatomic) UIColor *coordColor;

@property (nonatomic) UIColor *coordBackgroundColor;

@end


@interface XKBarChartView ()

@property (nonatomic) XKBCVChart *chart;
@property (nonatomic) XKBCVCoord *bottomCoord;

@end


#pragma mark - implementation of XKBarChartView
@implementation XKBarChartViewBarData

@synthesize value = _value;
@synthesize style = _style;

- (id)initWithValue:(float)value style:(NSString *)style {
    self = [super init];
    
    if (self) {
        self.value = value;
        self.style = style;
    } // else NOP
    
    return self;
}

@end


#pragma mark - implementation of XKBarChartView
@implementation XKBarChartView

@synthesize barChartViewStyle = _barChartViewStyle;

@synthesize chart = _chart;
@synthesize bottomCoord = _bottomCoord;

@synthesize bottomCoordHeight = _bottomCoordHeight;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    } // else NOP
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if (self) {
        [self setup];
    } // else NOP
    
    return self;
}

- (void)setup {
    _barChartViewStyle = XKBarChartViewStyleYAxisPointToTop;
    
    _chart = [[XKBCVChart alloc] initWithFrame:self.bounds];
    _bottomCoord = [[XKBCVCoord alloc] initWithFrame:self.bounds];
    
    [self addSubview:_chart];
    [self addSubview:_bottomCoord];
    
    self.barMargin = 0;
    _bottomCoordHeight = 0;
    
    self.backgroundColor = UIColor.clearColor;
    
    self.allowBackgroundCreatingForAnimationData = YES;
}

- (void)layoutSubviews {
    [self doLayoutSubviews];
}

- (void)doLayoutSubviews {
    CGRect chartFrame = _chart.frame;
    chartFrame.size.height = self.frame.size.height - _bottomCoordHeight;
    _chart.frame = chartFrame;
    
    CGRect coordFrame = _bottomCoord.frame;
    coordFrame.origin.y = chartFrame.size.height;
    coordFrame.size.height = _bottomCoordHeight;
    _bottomCoord.frame = coordFrame;
}

- (XKBarChartViewStyle)barChartViewStyle {
    return _chart.chartStyle;
}

- (void)setBarChartViewStyle:(XKBarChartViewStyle)barChartViewStyle {
    _chart.chartStyle = barChartViewStyle;
}

- (void)setChartData:(NSArray *)chartData animated:(BOOL)animated {
    [_chart setChartData:chartData animated:animated];
}

- (NSArray *)chartData {
    return _chart.chartData;
}

- (void)setChartData:(NSArray *)chartData {
    _chart.chartData = chartData;
}

- (NSArray *)bottomCoordData {
    return _bottomCoord.coordData;
}

- (void)setBottomCoordData:(NSArray *)coordData {
    _bottomCoord.coordData = coordData;
}

- (UIColor *)barColorForStyle:(NSString *)style {
    return [_chart barColorForStyle:style];
}

- (void)setBarColor:(UIColor *)color forStyle:(NSString *)style {
    [_chart setBarColor:color forStyle:style];
}

- (CGFloat)barMargin {
    return _chart.barMargin;
}

- (void)setBarMargin:(CGFloat)barMargin {
    _chart.barMargin = barMargin;
}

- (void)setBottomCoordHeight:(CGFloat)coordHeight {
    _bottomCoordHeight = MIN(MAX(coordHeight, 0.f), self.frame.size.height);
    [self doLayoutSubviews];
}

- (UIFont *)bottomCoordFont {
    return _bottomCoord.coordFont;
}

- (void)setBottomCoordFont:(UIFont *)coordFont {
    _bottomCoord.coordFont = coordFont;
}

- (UIColor *)bottomCoordColor {
    return _bottomCoord.coordColor;
}

- (void)setBottomCoordColor:(UIColor *)coordColor {
    _bottomCoord.coordColor = coordColor;
}

- (UIColor *)chartBackgroundColor {
    return _chart.chartBackgroundColor;
}

- (void)setChartBackgroundColor:(UIColor *)chartBackgroundColor {
    _chart.chartBackgroundColor = chartBackgroundColor;
}

- (UIColor *)bottomCoordBackgroundColor {
    return _bottomCoord.coordBackgroundColor;
}

- (void)setBottomCoordBackgroundColor:(UIColor *)coordBackgroundColor {
    _bottomCoord.coordBackgroundColor = coordBackgroundColor;
}

- (BOOL)allowBackgroundCreatingForAnimationData {
    return _chart.allowBackgroundCreatingForAnimationData;
}

- (void)setAllowBackgroundCreatingForAnimationData:(BOOL)allowBackgroundCreatingForAnimationData {
    _chart.allowBackgroundCreatingForAnimationData = allowBackgroundCreatingForAnimationData;
}

@end


#pragma mark - implementation of XKBCVChart
@implementation XKBCVChart

@synthesize animationFrameValues = _animationFrameValues;

@synthesize allowBackgroundCreatingForAnimationData = _allowBackgroundCreatingForAnimationData;

@synthesize animationDataBackgroundCreator = _animationDataBackgroundCreator;
@synthesize dataSettingCount = _dataSettingCount;

+ (Class)layerClass {
    return [XKBCVChartLayer class];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.chartBackgroundColor = UIColor.whiteColor;
        
        self.animationFrameValues = nil;
        
        self.animationDataBackgroundCreator = dispatch_queue_create([@"XKBarChartView_AnimationDataBackgroundCreator" cStringUsingEncoding:NSASCIIStringEncoding], NULL);
        self.dataSettingCount = 0;
    } // else NOP
    
    return self;
}

- (XKBCVChartLayer *)chartLayer {
    return (XKBCVChartLayer *) self.layer;
}

- (XKBarChartViewStyle)chartStyle {
    return self.chartLayer.chartStyle;
}

- (void)setChartStyle:(XKBarChartViewStyle)chartStyle {
    self.chartLayer.chartStyle = chartStyle;
}

- (void)setChartData:(NSArray *)chartData animated:(BOOL)animated {
    NSUInteger settingCount = ++_dataSettingCount;
    
    for (XKBarChartViewBarData *barData in chartData) {
        barData.value = MAX(barData.value, 0.f);
    }
    
    NSArray *oldChartData = self.chartData;
    NSUInteger frameCount = kAnimationKeyFPS * kAnimationDuration;
    
    if (animated && (oldChartData.count > 0 || chartData.count > 0) && frameCount > 0) {
        if (_allowBackgroundCreatingForAnimationData) {
            dispatch_async(_animationDataBackgroundCreator, ^{
                [self makeAnimationFrameValuesByOldChartData:oldChartData
                                                newChartData:chartData
                                                  frameCount:frameCount];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (settingCount == _dataSettingCount) {
                        [self doSetChartData:chartData withAnimationForFrameCount:frameCount];
                    } // else NOP
                });
            });
        } else {
            [self makeAnimationFrameValuesByOldChartData:oldChartData
                                                newChartData:chartData
                                                  frameCount:frameCount];
            [self doSetChartData:chartData withAnimationForFrameCount:frameCount];
        }
    } else {
        self.chartLayer.barFullValue = [self maxBarValue:chartData];
        self.chartLayer.chartData = chartData;
    }
}

- (void)makeAnimationFrameValuesByOldChartData:(NSArray *)oldChartData
                                  newChartData:(NSArray *)newChartData
                                    frameCount:(NSUInteger)frameCount {
    if (!_animationFrameValues) {
        _animationFrameValues = [NSMutableArray arrayWithCapacity:frameCount];
    }
    
    float baseValue = 0;
    float valueChange = 0;
    
    XKBarChartViewBarData *barData = nil;
    
    if (newChartData.count == oldChartData.count) { // 新老数据都不空且个数相同
        [self prepareAnimationFrameValuesByBaseValue:newChartData forFrameCount:frameCount];
        
        for (NSInteger i = 0; i < newChartData.count; ++i) {
            baseValue = ((XKBarChartViewBarData *) oldChartData[i]).value;
            valueChange = ((XKBarChartViewBarData *) newChartData[i]).value - baseValue;
            
            for (NSUInteger j = 0; j < frameCount; ++j) {
                barData = _animationFrameValues[j][i];
                barData.value = baseValue + valueChange * (j + 1) / frameCount;
                // 不复制style的原因：插值时大量的值对象的内存申请的总体时间开销过大
                barData.style = ((XKBarChartViewBarData *) newChartData[i]).style;
            }
        }
    } else if (newChartData.count == 0) {          // 老数据不空新数据空
        [self prepareAnimationFrameValuesByBaseValue:oldChartData forFrameCount:frameCount];
        
        for (NSInteger i = 0; i < newChartData.count; ++i) {
            baseValue = ((XKBarChartViewBarData *) oldChartData[i]).value;
            valueChange = 0 - baseValue;
            
            for (NSUInteger j = 0; j < frameCount; ++j) {
                barData = _animationFrameValues[j][i];
                barData.value = baseValue + valueChange * (j + 1) / frameCount;
                // 不复制style的原因：插值时大量的值对象的内存申请的总体时间开销过大
                barData.style = ((XKBarChartViewBarData *) oldChartData[i]).style;
            }
        }
    } else {                                    // 老数据空且新数据不空，或新老数据都不空且个数不同
        [self prepareAnimationFrameValuesByBaseValue:newChartData forFrameCount:frameCount];
        
        for (NSInteger i = 0; i < newChartData.count; ++i) {
            valueChange = ((XKBarChartViewBarData *) newChartData[i]).value;
            
            for (NSUInteger j = 0; j < frameCount; ++j) {
                barData = _animationFrameValues[j][i];
                barData.value = valueChange * (j + 1) / frameCount;
                // 不复制style的原因：插值时大量的值对象的内存申请的总体时间开销过大
                barData.style = ((XKBarChartViewBarData *) newChartData[i]).style;
            }
        }
    }
}

- (void)prepareAnimationFrameValuesByBaseValue:(NSArray *)baseValue
                                 forFrameCount:(NSUInteger)frameCount {
    if (_animationFrameValues.count != frameCount || ((NSArray *) _animationFrameValues[0]).count != baseValue.count) {
        _animationFrameValues = [NSMutableArray arrayWithCapacity:frameCount];
        
        NSMutableArray *frameValue = nil;
        XKBarChartViewBarData *dst = nil;
        
        for (NSInteger i = 0; i < frameCount; ++i) {
            frameValue = [NSMutableArray arrayWithCapacity:baseValue.count];
            
            for (XKBarChartViewBarData *src in baseValue) {
                NSLog(@"%@",src);
                dst = [XKBarChartViewBarData new];
                [frameValue addObject:dst];
            }
            
            [_animationFrameValues addObject:frameValue];
        }
    } // else NOP
}

- (void)doSetChartData:(NSArray *)chartData withAnimationForFrameCount:(NSUInteger)frameCount {
    float newMaxBarValue = [self maxBarValue:chartData];
    if (newMaxBarValue > self.chartLayer.barFullValue) {
        self.chartLayer.barFullValue = newMaxBarValue;
    } // else NOP
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"chartData"];
    animation.duration = kAnimationDuration;
    animation.calculationMode = kCAAnimationDiscrete;
    animation.values = _animationFrameValues;
    animation.keyTimes = [XKCuiUtil createEaseInEaseOutTimesForTotalTime:1.f totalCount:frameCount];
    
    [self.chartLayer addAnimation:animation forKey:@"chartData"];
    self.chartLayer.chartData = chartData;
}

- (float)maxBarValue:(NSArray *)chartData {
    CGFloat maxBarValue = 0.f;
    
    for (XKBarChartViewBarData *barData in chartData) {
        maxBarValue = MAX(barData.value, maxBarValue);
    }
    
    return maxBarValue;
}

- (NSArray *)chartData {
    return self.chartLayer.chartData;
}

- (void)setChartData:(NSArray *)chartData {
    [self setChartData:chartData animated:NO];
}

- (CGFloat)barMargin {
    return self.chartLayer.barMargin;
}

- (void)setBarMargin:(CGFloat)barMargin {
    self.chartLayer.barMargin = barMargin;
}

- (UIColor *)barColorForStyle:(NSString *)style {
    return [self.chartLayer barColorForStyle:style];
}

- (void)setBarColor:(UIColor *)color forStyle:(NSString *)style {
    [self.chartLayer setBarColor:color forStyle:style];
}

- (UIColor *)chartBackgroundColor {
    return [UIColor colorWithCGColor:self.chartLayer.backgroundColor];
}

- (void)setChartBackgroundColor:(UIColor *)chartBackgroundColor {
    self.chartLayer.backgroundColor = chartBackgroundColor.CGColor;
}

@end


#pragma mark - implementation of XKBCVChartLayer
@implementation XKBCVChartLayer

@dynamic chartStyle;

@dynamic chartData;

@dynamic barFullValue;

@dynamic barMargin;

+ (BOOL)needsDisplayForKey:(NSString *)key {
    return [key isEqualToString:@"chartData"]
        || [key isEqualToString:@"barFullValue"]
        || [key isEqualToString:@"barMargin"]
        || [key isEqualToString:@"chartStyle"]
        || [super needsDisplayForKey:key];
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.barFullValue = 0;
        self.barColors = [NSMutableDictionary dictionary];
    } // else NOP
    
    return self;
}

- (void)drawInContext:(CGContextRef)context {    
    CGContextClearRect(context, self.bounds);
    CGContextSetShouldAntialias(context, false);
    
    if (self.chartData.count > 0) {
        CGFloat barWidth = MAX((self.bounds.size.width - (self.chartData.count - 1) * self.barMargin), 0.f) / self.chartData.count;
                
        if (self.barFullValue > 0) {
            // 为性能而不能直接使用barColorForStyle：
            NSDictionary *barColors = [self barColors];
            
            CGRect barRect = CGRectZero;
            barRect.size.width = barWidth;
            
            for (XKBarChartViewBarData *barData in self.chartData) {
                barRect.size.height = self.bounds.size.height * barData.value / self.barFullValue;
                barRect.origin.y = self.bounds.size.height - barRect.size.height;
                
                CGContextSetFillColorWithColor(context, ((UIColor *) barColors[barData.style]).CGColor);
                CGContextFillRect(context, barRect);
                
                barRect.origin.x += (barWidth + self.barMargin);
            }
        } // else NOO
    } // else NOP
}

- (UIColor *)barColorForStyle:(NSString *)style {
    return self.barColors[style];
}

- (void)setBarColor:(UIColor *)color forStyle:(NSString *)style {
    self.barColors[style] = color;
    [self setNeedsDisplay];
}

- (NSMutableDictionary *)barColors {
    return [self valueForKey:@"_barColors"];
}

- (void)setBarColors:(NSMutableDictionary *)barColors {
    [self setValue:barColors forKey:@"_barColors"];
}

@end


#pragma mark - implementation of XKBCVCoord
@implementation XKBCVCoord

@synthesize coordData = _coordData;

@synthesize coordFont = _coordFont;
@synthesize coordColor = _coordColor;

@synthesize coordBackgroundColor = _coordBackgroundColor;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.coordBackgroundColor = UIColor.whiteColor;
    }
    
    return self;
}

- (void)setCoordData:(NSArray *)coordData {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    NSUInteger count = coordData.count;

    if (count >= 2) {
        XKVerticalAlignableLabel *coord = nil;
        
        CGRect rect = self.bounds;
        CGFloat margin = rect.size.width / (count - 1);
        
        rect.size.width = margin / 2;
        coord = [self createCoordWithFrame:rect Text:coordData[0] horizontalAlignment:NSTextAlignmentLeft];
        [self addSubview:coord];
        
        rect.origin.x = margin / 2;
        rect.size.width = margin;
        
        for (NSUInteger i = 1; i < count - 1; ++i) {
            coord = [self createCoordWithFrame:rect Text:coordData[i] horizontalAlignment:NSTextAlignmentCenter];
            [self addSubview:coord];
            rect.origin.x += margin;
        }
        
        rect.size.width = margin / 2;
        coord = [self createCoordWithFrame:rect Text:coordData[count - 1] horizontalAlignment:NSTextAlignmentRight];
        [self addSubview:coord];
    } // else NOP
}

- (XKVerticalAlignableLabel *)createCoordWithFrame:(CGRect)frame
                                              Text:(NSString *)text
                               horizontalAlignment:(NSTextAlignment)horizontalAlignment {
    XKVerticalAlignableLabel *coord = [[XKVerticalAlignableLabel alloc]initWithFrame:frame];
    
    coord.text = text;
    coord.font = _coordFont;
    coord.textColor = _coordColor;
    
    coord.textAlignment = horizontalAlignment;
    coord.textVerticalAlignment = XKTextVerticalAlignmentBottom;
    
    coord.backgroundColor = _coordBackgroundColor;
    
    return coord;
}

- (void)setCoordFont:(UIFont *)coordFont {
    _coordFont = coordFont;
    
    for (UILabel *coord in self.subviews) {
        coord.font = _coordFont;
    }
}

- (void)setCoordColor:(UIColor *)coordColor {
    _coordColor = coordColor;
    
    for (UILabel *coord in self.subviews) {
        coord.textColor = coordColor;
    }
}

- (void)setCoordBackgroundColor:(UIColor *)coordBackgroundColor {
    _coordBackgroundColor = coordBackgroundColor;
    
    for (UIView *subView in self.subviews) {
        subView.backgroundColor = coordBackgroundColor;
    }
}

@end
