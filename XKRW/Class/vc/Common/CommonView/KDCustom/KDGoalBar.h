
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "KDGoalBarPercentLayer.h"


@interface KDGoalBar : UIView {
    UIImage * thumb;
    
    KDGoalBarPercentLayer *percentLayer;
    CALayer *thumbLayer;
          
}

@property (nonatomic, strong) UILabel *percentLabel;
@property(nonatomic,assign)CGFloat recommandIntake;
@property(nonatomic,assign)CGFloat normalIntake;
- (void)setPercent:(CGFloat)percent animated:(BOOL)animated  andRecommandIntake:(CGFloat)RecommandIntake andNormalIntake:(CGFloat)normalIntake;


@end
