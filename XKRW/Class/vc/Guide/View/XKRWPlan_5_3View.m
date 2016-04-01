//
//  XKRWPlan_5_3View.m
//  XKRW
//
//  Created by ss on 16/3/31.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWPlan_5_3View.h"
#import "XKRWAlgolHelper.h"
#import "XKRWUtil.h"

@implementation XKRWPlan_5_3View
@synthesize type = _type;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = LOAD_VIEW_FROM_BUNDLE(@"XKRWPlan_5_3View");
    }
    return self;
}


- (void)awakeFromNib{
   
    
}

-(void)setType:(enum PlanType)type{
    switch (_type) {
        case Food:
            [_numImg setImage:[UIImage imageNamed:@"1_"]];
            _titleLab.text = @"饮食摄入";
            _calTypeLab.text = @"每日饮食摄入热量:";
            _calRangeLab.text = [XKRWAlgolHelper getDailyIntakeSize];
            
            _detailLab.attributedText = [XKRWUtil createAttributeStringWithString:@"今天开始，\n通过记录来控制自己每日摄入热量。\n或者，你可以通过【推荐食谱】\n来学习健康的饮食搭配。" font:XKDefaultFontWithSize(12) color:XK_ASSIST_TEXT_COLOR lineSpacing:4 alignment:NSTextAlignmentLeft];
            [_detailLab setFontColor:XKMainToneColor_00b4b4 string:@"【推荐食谱】"];
            
            _detailLab.preferredMaxLayoutWidth = XKAppWidth - 50;
            _tipsLab.text = @"瘦瘦的推荐食谱由瘦瘦营养师按照你的饮食摄入量和营养比例，/n为你量身定制。稍后，可以在\"饮食-推荐食谱\"中查看。";
            break;
        case Sport:
            [_numImg setImage:[UIImage imageNamed:@"2_"]];
            _titleLab.text = @"运动消耗";
            _calTypeLab.text = @"每日运动消耗热量:";
            int cal = [XKRWAlgolHelper dailyConsumeSportEnergy];
            
            _calRangeLab.text = cal == 0 ? @"0kcal":[NSString stringWithFormat:@"%dkcal",cal];
            _detailLab.attributedText = [XKRWUtil createAttributeStringWithString:@"今天开始，\n通过记录来控制自己每日消耗热量。\n或者，你可以通过【推荐方案】\n来学习合理的运动方法。" font:XKDefaultFontWithSize(12) color:XK_ASSIST_TEXT_COLOR lineSpacing:4 alignment:NSTextAlignmentLeft];
            [_detailLab setFontColor:XKMainToneColor_00b4b4 string:@"【推荐食谱】"];
            _tipsLab.text = @"Tips:瘦瘦会按照你的体力活动水平，/n为你量身推荐运动计划。稍后，可以在\"运动-推荐方案\"中查看。";
            
            break;
        default:
            break;
    }
    [self updateConstraints];
    [self layoutIfNeeded];
}

@end