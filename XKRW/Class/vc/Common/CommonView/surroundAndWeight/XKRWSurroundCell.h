//
//  XKRWSurroundCell.h
//  XKRW
//
//  Created by 忘、 on 15/7/10.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XKRWSurroundCellDelegate <NSObject>

- (void)entrySurroundVCDelegate:(NSInteger ) tag;

@end

//typedef void(^entrySurroundVCBlock)(NSInteger);

@interface XKRWSurroundCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIButton *armGirthButton;   //臂围
@property (weak, nonatomic) IBOutlet UIButton *hiplineButton;    //臀围
@property (weak, nonatomic) IBOutlet UIButton *calfGirthButton;  //小腿围
@property (weak, nonatomic) IBOutlet UIButton *bustGirthButton;  //胸围
@property (weak, nonatomic) IBOutlet UIButton *waistlineButton;  //腰围
@property (weak, nonatomic) IBOutlet UIButton *ThighlineButton;  //大腿围

@property (nonatomic,assign) id <XKRWSurroundCellDelegate>  entrySurroundDelegate;

@end
