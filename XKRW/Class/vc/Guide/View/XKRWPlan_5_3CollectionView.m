//
//  XKRWPlan_5_3CollectionView.m
//  XKRW
//
//  Created by ss on 16/4/1.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWPlan_5_3CollectionView.h"
#import "XKRWFatReasonService.h"

@implementation XKRWPlan_5_3CollectionView
@synthesize dicData = _dicData;

-(id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        
//        [self registerClass:[XKRWPlan_5_3CollectionViewCell class] forCellWithReuseIdentifier:@"myCollectionCell"];
        UINib *cellNib = [UINib nibWithNibName:@"XKRWPlan_5_3CollectionViewCell" bundle:nil];
        [self registerNib:cellNib forCellWithReuseIdentifier:@"myCollectionCell"];
        
        [self registerClass:[XKRWPlan_5_3CollectionReusableView class]
                forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                       withReuseIdentifier:@"Separator"];
//        _dicData = [self getUserHabit];
    }
    return self;
}

- (NSArray *)getUserHabit
{
    NSArray *array = [[XKRWFatReasonService sharedService] getQuestionAnswer];
    
    return [[XKRWFatReasonService sharedService] getHabitEntitiesWithFatReasonEntities:array];
}

-(void)setDicData:(NSDictionary *)dicData{
    if (_dicData != dicData) {
        _dicData = dicData;
        _arrText = [dicData allKeys];
        _arrImg = [dicData allValues];
        [self reloadData];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrText.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"myCollectionCell";
    XKRWPlan_5_3CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.lab.text = [NSString stringWithFormat:@"%@",_arrText[indexPath.row]];
    cell.lab.preferredMaxLayoutWidth = cell.frame.size.width;
    cell.lab.hidden = YES;
    
    [cell.imgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",_arrImg[indexPath.row]]]];
    [cell.imgView layoutIfNeeded];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 95);
}

//footer的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(10, 10);
//}

//header的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(10, 10);
//}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 0, -50, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 30;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    return CGSizeMake(XKAppWidth, 80);
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    XKRWPlan_5_3CollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Separator" forIndexPath:indexPath];
        reusableView.backgroundColor =[UIColor greenColor];
    }
    return reusableView;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XKRWPlan_5_3CollectionViewCell *cell = (XKRWPlan_5_3CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *msg = cell.lab.text;
    NSLog(@"%@",msg);
}
@end
