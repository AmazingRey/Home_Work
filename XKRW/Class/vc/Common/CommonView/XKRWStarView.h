//
//  XKRWStarView.h
//  XKRW
//
//  Created by y on 15-1-14.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol getStarCountDelegate <NSObject>

@optional
-(void)getStarCount:(NSInteger)count;

@end
@interface XKRWStarView : UIView

@property(nonatomic,strong)NSMutableArray *starBtnArr;
@property(nonatomic,assign)NSInteger    count;
@property(nonatomic,assign)id<getStarCountDelegate>delegate;

-(id)initWithFrame:(CGRect)frame withColorCount:(NSInteger)count isEnable:(BOOL) enable isUserComment:(BOOL)allComment;

-(void)loadStarCount:(NSInteger)count;


- (void)closeUserInterFaced;
@end
