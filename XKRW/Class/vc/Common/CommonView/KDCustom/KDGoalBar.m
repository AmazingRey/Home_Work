
#import "KDGoalBar.h"

@implementation KDGoalBar
@synthesize    percentLabel;

#pragma Init & Setup
- (id)init
{
	if ((self = [super init]))
	{
		[self setup];
	}
    
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		[self setup];
	}
    
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		[self setup];
	}
    
	return self;
}

-(void)layoutSubviews {
    CGRect frame = self.frame;
    CGFloat percent = self.normalIntake;
    [percentLabel setText:[NSString stringWithFormat:@"每日所需能量%.0fkcal", percent]];
    
    
    CGRect labelFrame = percentLabel.frame;
    labelFrame.origin.x = frame.size.width / 2 - percentLabel.frame.size.width / 2;
    labelFrame.origin.y = frame.size.height / 2 - percentLabel.frame.size.height / 2;
    percentLabel.frame = labelFrame;
    
    [super layoutSubviews];
}

-(void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;

    percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -50, 100, 100)];
    [percentLabel setFont:[UIFont systemFontOfSize:14]];
    percentLabel.numberOfLines=0;
    [percentLabel setTextColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0]];
    [percentLabel setTextAlignment:NSTextAlignmentCenter];
    [percentLabel setBackgroundColor:[UIColor clearColor]];
    percentLabel.adjustsFontSizeToFitWidth = YES;
    percentLabel.minimumScaleFactor = 10;
    [self addSubview:percentLabel];
    
    thumbLayer = [CALayer layer];
    thumbLayer.contentsScale = [UIScreen mainScreen].scale;
    thumbLayer.contents = (id) thumb.CGImage;
    thumbLayer.frame = CGRectMake(self.frame.size.width / 2 - thumb.size.width/2, 0, thumb.size.width, thumb.size.height);
    thumbLayer.hidden = YES;

   
    
    percentLayer = [KDGoalBarPercentLayer layer];
    percentLayer.contentsScale = [UIScreen mainScreen].scale;
    percentLayer.percent = 0;
    percentLayer.frame = self.bounds;
    percentLayer.masksToBounds = NO;
    [percentLayer setNeedsDisplay];
    
    [self.layer addSublayer:percentLayer];
    [self.layer addSublayer:thumbLayer];
     
    
}

#pragma mark - Touch Events
- (void)moveThumbToPosition:(CGFloat)angle {
    CGRect rect = thumbLayer.frame;
    XKLog(@"%@",NSStringFromCGRect(rect));
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    angle -= (M_PI/2);
    XKLog(@"%f",angle);

    rect.origin.x = center.x + 75 * cosf(angle) - (rect.size.width/2);
    rect.origin.y = center.y + 75 * sinf(angle) - (rect.size.height/2);
    
    XKLog(@"%@",NSStringFromCGRect(rect));

    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    thumbLayer.frame = rect;
    
    [CATransaction commit];
}
#pragma mark - Custom Getters/Setters
- (void)setPercent:(CGFloat)percent animated:(BOOL)animated  andRecommandIntake:(CGFloat)RecommandIntake andNormalIntake:(CGFloat)normalIntake{
    self.recommandIntake=RecommandIntake;
    self.normalIntake=normalIntake;
    //[]
    CGFloat floatPercent = percent / 100.0;
    floatPercent = MIN(1, MAX(0, floatPercent));
    
    percentLayer.percent = floatPercent;
    [self setNeedsLayout];
    [percentLayer setNeedsDisplay];
    
    [self moveThumbToPosition:floatPercent * (2 * M_PI) - (M_PI/2)];
    
}

//- (void)dealloc{
//    //[percentLabel release];
//    [super dealloc];
//}

@end
