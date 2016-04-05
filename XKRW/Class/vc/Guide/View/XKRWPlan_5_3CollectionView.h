//
//  XKRWPlan_5_3CollectionView.h
//  XKRW
//
//  Created by ss on 16/4/1.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWPlan_5_3CollectionViewCell.h"
#import "XKRWPlan_5_3CollectionReusableView.h"

@interface XKRWPlan_5_3CollectionView : UICollectionView <UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) NSArray *arrData;
@end
