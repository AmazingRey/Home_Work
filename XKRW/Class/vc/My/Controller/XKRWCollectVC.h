//
//  XKRWCollectVC.h
//  XKRW
//
//  Created by 忘、 on 15/9/7.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "XKRWCollectionEntity.h"
@interface XKRWCollectVC : XKRWBaseVC<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger segmentedSelectIndex;
    
    NSMutableArray  *dataArray;
    
    XKRWCollectionEntity *entity;
    
    NSIndexPath *deleteIndexPath;
    
    UIImageView *noCollectionImageView;
   
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *collectTableView;

@end
