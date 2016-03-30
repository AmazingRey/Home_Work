//
//  CustomDisplayerController.m
//  CityList
//
//  Created by Leng on 14-4-30.
//
//

#import "CustomDisplayerController.h"
/*
    table的resultTable重写
 */

@implementation CustomDisplayerController
-(void)setActive:(BOOL)visible animated:(BOOL)animated
{
    [super setActive:visible animated:animated];
    [self.searchContentsController.navigationController setNavigationBarHidden: NO animated: NO];
}
@end
