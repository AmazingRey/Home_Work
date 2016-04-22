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
            int cal = [XKRWAlgolHelper dailyConsumeSportEnergy];
            
            _calTypeLab.text = cal != 0?[NSString stringWithFormat:@"每日运动消耗热量:%dkcal",cal]:@"无需额外运动";
         
            _detailLab.attributedText = [XKRWUtil createAttributeStringWithString:@"今天开始，\n通过记录来控制自己每日消耗热量。\n或者，你可以通过【推荐方案】\n来学习合理的运动方法。" font:XKDefaultFontWithSize(15) color:colorSecondary_666666 lineSpacing:4 alignment:NSTextAlignmentCenter];
            [_detailLab setFontColor:XKMainToneColor_29ccb1 string:@"【推荐方案】"];
            _tipsLab.text = @"Tips:瘦瘦会按照你的体力活动水平，为你量身推荐运动计划。稍后，可以在\"运动-推荐方案\"中查看。";
            break;
        case Habit:
            [_numImg setImage:[UIImage imageNamed:@"num3"]];
            _titleLab.text = @"不良习惯";
            _calTypeLab.text = _dicCollection.count == 0?@"你的习惯很好，请保持。": @"为了达到减重目标，请改掉以下不良习惯:";
            _calTypeLab.preferredMaxLayoutWidth = XKAppWidth- 30;
            
            _detailLab.hidden = YES;
            _tipsLab.hidden = YES;
            _tipsImg.hidden = YES;
            _fuseView.hidden = YES;
            
            CGFloat numLines = ceilf((CGFloat)_dicCollection.count/4);
            
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.itemSize = CGSizeMake(80, 95);
            layout.minimumInteritemSpacing = 0;
            layout.minimumLineSpacing = 30;
            
            XKRWPlan_5_3CollectionView *habitCollectionView = [[XKRWPlan_5_3CollectionView alloc] initWithFrame:CGRectMake(15, 70, XKAppWidth-30, 180*numLines) collectionViewLayout:layout];
            
            habitCollectionView.dicData = _dicCollection;
            habitCollectionView.arrText = [_dicCollection allKeys];
            habitCollectionView.arrImg = [_dicCollection allValues];
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

- (IBAction)pressStart:(id)sender {
}
@end