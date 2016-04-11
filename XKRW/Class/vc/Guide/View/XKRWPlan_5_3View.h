//
//  XKRWPlan_5_3View.h
//  XKRW
//
//  Created by ss on 16/3/31.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZLabel.h"
#import "XKRWPlan_5_3CollectionView.h"

typedef NS_ENUM(int, PlanType) {
    Food,
    Sport,
    Habit
};

@interface XKRWPlan_5_3View : UIView
@property (strong, nonatomic) IBOutlet UIImageView *numImg;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet NZLabel *detailLab;
@property (strong, nonatomic) IBOutlet UIImageView *tipsImg;
@property (weak, nonatomic) IBOutlet UILabel *tipsLab;
@property (strong, nonatomic) IBOutlet UILabel *calTypeLab;
@property (strong, nonatomic) IBOutlet UIView *fuseView;


@property (assign, nonatomic) enum PlanType type;
@property (strong, nonatomic) NSMutableDictionary *dicCollection;
@end
