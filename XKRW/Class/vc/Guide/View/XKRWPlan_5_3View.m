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
#import "XKRWShowEnergy_5_3View.h"
#import "XKRWUserService.h"

@implementation XKRWPlan_5_3View
@synthesize type = _type;
@synthesize dicCollection=_dicCollection;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

//-(void)setDicCollection:(NSMutableDictionary *)dicCollection{
//    if (_dicCollection != dicCollection) {
//        _dicCollection = dicCollection;
//    }
//}

-(void)setType:(enum PlanType)type{
    switch (type) {
        case Food:
            [_numImg setImage:[UIImage imageNamed:@"num1"]];
            _titleLab.text = @"饮食摄入";
            _calTypeLab.text = [NSString stringWithFormat:@"每日饮食摄入热量:%@",[XKRWAlgolHelper getDailyIntakeSize]];
            
            _detailLab.attributedText = [XKRWUtil createAttributeStringWithString:@"今天开始，\n通过记录来控制自己每日摄入热量。\n或者，你可以通过【推荐食谱】\n来学习健康的饮食搭配。" font:XKDefaultFontWithSize(15) color:colorSecondary_666666 lineSpacing:4 alignment:NSTextAlignmentCenter];
            [_detailLab setFontColor:XKMainToneColor_29ccb1 string:@"【推荐食谱】"];
            _tipsLab.text = @"瘦瘦的推荐食谱由瘦瘦营养师按照你的饮食摄入量和营养比例，为你量身定制。稍后，可以在\"饮食-推荐食谱\"中查看。";
            break;
        case Sport:
            [_numImg setImage:[UIImage imageNamed:@"num2"]];
            _titleLab.text = @"运动消耗";
            
            XKPhysicalLabor labor = [[XKRWUserService sharedService]getUserLabor];
            BOOL heavyType = labor == eHeavy ? true : false;
            if (heavyType) {
                [_fuseView removeFromSuperview];
                [_tipsLab removeFromSuperview];
                [_tipsImg removeFromSuperview];
                _labDetailConstant.constant = 20;
                _calTypeLab.text = @"无需额外运动";
                _detailLab.attributedText = [XKRWUtil createAttributeStringWithString:@"由于你的日常活动水平是重体力，\n无需额外做运动。\n你可以通过【推荐方案】\n推荐的运动来轻微活动即可。" font:XKDefaultFontWithSize(15) color:colorSecondary_666666 lineSpacing:4 alignment:NSTextAlignmentCenter];
                 [_detailLab setFontColor:XKMainToneColor_29ccb1 string:@"【推荐方案】"];
            }else{
                int cal = [XKRWAlgolHelper dailyConsumeSportEnergy];
                _calTypeLab.text = [NSString stringWithFormat:@"每日运动消耗热量:%dkcal",cal];
                
                _detailLab.attributedText = [XKRWUtil createAttributeStringWithString:@"今天开始，\n通过记录来控制自己每日消耗热量。\n或者，你可以通过【推荐方案】\n来学习合理的运动方法。" font:XKDefaultFontWithSize(15) color:colorSecondary_666666 lineSpacing:4 alignment:NSTextAlignmentCenter];
                [_detailLab setFontColor:XKMainToneColor_29ccb1 string:@"【推荐方案】"];
                _tipsLab.text = @"Tips:瘦瘦会按照你的体力活动水平，为你量身推荐运动计划。稍后，可以在\"运动-推荐方案\"中查看。";
            }
            break;
        case Habit:
            [_numImg setImage:[UIImage imageNamed:@"num3"]];
            _titleLab.text = @"不良习惯";
            if (_dicCollection.count == 0) {
                _calTypeLab.text = @"你的习惯很好，请保持。";
                _calTypeLab.textAlignment = NSTextAlignmentCenter;
            }else{
                _calTypeLab.text = @"为了达到减重目标，请改掉以下不良习惯:";
                _calTypeLab.textAlignment = NSTextAlignmentLeft;
            }
            _calTypeLab.preferredMaxLayoutWidth = XKAppWidth- 30;
            
            _detailLab.hidden = YES;
            _tipsLab.hidden = YES;
            _tipsImg.hidden = YES;
            _fuseView.hidden = YES;
            
            CGFloat numLines = ceilf((CGFloat)_dicCollection.count/4);
            
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            CGFloat side = 80;
            layout.itemSize = CGSizeMake(side, side);
            layout.minimumInteritemSpacing = 0;
            layout.minimumLineSpacing = 20;
            
            XKRWPlan_5_3CollectionView *habitCollectionView = [[XKRWPlan_5_3CollectionView alloc] initWithFrame:CGRectMake(15, 70, XKAppWidth-30, 100*numLines) collectionViewLayout:layout];
            
            habitCollectionView.dicData = _dicCollection;
            habitCollectionView.arrText = [_dicCollection allKeys];
            habitCollectionView.arrImg = [_dicCollection allValues];
            
            UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToFatReason:)];
            ges.numberOfTapsRequired = 1;
            [habitCollectionView addGestureRecognizer:ges];
            [self addSubview:habitCollectionView];
            break;
//        default:
//            break;
    }
    _fuseView.type = type;
    _tipsLab.preferredMaxLayoutWidth = XKAppWidth - 30;
    _detailLab.preferredMaxLayoutWidth = XKAppWidth - 30;
    [self updateConstraints];
    [self setNeedsDisplay];
    [self layoutIfNeeded];
}

-(void)pushToFatReason:(UITapGestureRecognizer *)ges{
    if ([self.delegate respondsToSelector:@selector(tapCollectionView)]) {
        [self.delegate tapCollectionView];
    }
}


- (IBAction)pressStart:(id)sender {
}
@end