//
//  DrawerView.m
//  DrawerDemo
//
//  Created by Zhouhaifeng on 12-3-27.
//  Copyright (c) 2012年 CJLU. All rights reserved.
//

#import "DrawerView.h"

@implementation DrawerView
@synthesize contentView,parentView,drawState;
@synthesize arrow;

- (id)initWithView:(UIView *) contentview parentView :(UIView *) parentview;
{
    self = [super initWithFrame:CGRectMake(0,0,contentview.frame.size.width, contentview.frame.size.height+30)];
    if (self) {
        // Initialization code        
        contentView = contentview;
        parentView = parentview;
        
        XKLog(@"%@", NSStringFromCGRect(parentview.frame));
        
        //一定要开启
        [parentView setUserInteractionEnabled:YES];
        
        //嵌入内容区域的背景
//        UIImage *drawer_bg = [UIImage imageNamed:@"drawer_content.png"];
//        UIImageView *view_bg = [[UIImageView alloc]initWithImage:drawer_bg];
//        [view_bg setFrame:CGRectMake(0,30,contentview.frame.size.width, contentview.bounds.size.height+30)];
//        [self addSubview:view_bg];
    
        //头部拉拽的区域背景
        UIImage *drawer_handle = [UIImage imageNamed:@"pullup"];
        pullImgView = [[UIImageView alloc]initWithImage:drawer_handle];
        [pullImgView setFrame:CGRectMake(0,0,XKAppWidth,30)];
        [self addSubview:pullImgView];
        
        //嵌入内容的UIView
        [contentView setFrame:CGRectMake(0,30,contentview.frame.size.width, contentview.bounds.size.height+30)];
        [self addSubview:contentview];
        
        //移动的手势
//        UIPanGestureRecognizer *panRcognize=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];  
//        panRcognize.delegate=self;
//        [panRcognize setEnabled:YES];  
//        [panRcognize delaysTouchesEnded];  
//        [panRcognize cancelsTouchesInView]; 
//        [self addGestureRecognizer:panRcognize];
        
        //单击的手势
        UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];  
        tapRecognize.numberOfTapsRequired = 1;  
        tapRecognize.delegate = self;  
        [tapRecognize setEnabled :YES];  
        [tapRecognize delaysTouchesBegan];  
        [tapRecognize cancelsTouchesInView];  
        
        [self addGestureRecognizer:tapRecognize];
        
        //设置两个位置的坐标
//        downPoint = CGPointMake(parentview.frame.size.width/2, parentview.frame.size.height+contentview.frame.size.height/2-30);
//        upPoint = CGPointMake(parentview.frame.size.width/2, parentview.frame.size.height-contentview.frame.size.height/2-30);
        
        if ([UIDevice currentDevice].systemVersion.floatValue < 9.0) {
            downPoint = CGPointMake(0, parentview.height - 30);
            upPoint = CGPointMake(0, parentview.height - contentView.height - 30);
        } else {
            downPoint = CGPointMake(0, parentview.height - 30 - 64);
            upPoint = CGPointMake(0, parentview.height - contentView.height - 30 - 64);
        }
        self.origin = downPoint;
        
        //设置起始状态
        drawState = DrawerViewStateDown;
    }
    return self;
}


#pragma UIGestureRecognizer Handles  
/*    
 *  移动图片处理的函数 
 *  @recognizer 移动手势 
 */  
//- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
   
//    CGPoint translation = [recognizer translationInView:parentView]; 
//    if (self.center.y + translation.y < upPoint.y) {
//        self.center = upPoint;
//    }else if(self.center.y + translation.y > downPoint.y)
//    {
//        self.center = downPoint;
//    }else{
//        self.center = CGPointMake(self.center.x,self.center.y + translation.y);  
//    }
//    [recognizer setTranslation:CGPointMake(0, 0) inView:parentView];  
//    
//    if (recognizer.state == UIGestureRecognizerStateEnded) {  
//        [UIView animateWithDuration:0.45 delay:0.15 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                if (self.center.y < downPoint.y*4/5) {
//                    self.center = upPoint;
//                    [self transformArrow:DrawerViewStateUp];
//                }else
//                {
//                    self.center = downPoint;
//                    [self transformArrow:DrawerViewStateDown];
//                }
//
//        } completion:nil];  
// 
//    }    
//}  

/* 
 *  handleTap 触摸函数 
 *  @recognizer  UITapGestureRecognizer 触摸识别器 
 */  
-(void) handleTap:(UITapGestureRecognizer *)recognizer  
{
    CGPoint point = [recognizer locationInView:self];
    if (point.y < 30) {
        [UIView animateWithDuration:0.45 delay:0.15 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            if (drawState == DrawerViewStateDown) {
                self.origin = upPoint;
                [self transformArrow:DrawerViewStateUp];
//                pullImgView.image = [UIImage imageNamed:@"pullDown"];

            }else
            {
                self.origin = downPoint;
                [self transformArrow:DrawerViewStateDown];
//                pullImgView.image = [UIImage imageNamed:@"pullUp"];
            }
        } completion:^(BOOL finish)
        {
            if (drawState == DrawerViewStateUp){
                pullImgView.image = [UIImage imageNamed:@"pulldown"];
                
            }else
            {
                pullImgView.image = [UIImage imageNamed:@"pullup"];
                
            }

        }];
    }
} 

/* 
 *  transformArrow 改变箭头方向
 *  state  DrawerViewState 抽屉当前状态 
 */ 
-(void)transformArrow:(DrawerViewState) state
{
        //XKLog(@"DRAWERSTATE :%d  STATE:%d",drawState,state);
        [UIView animateWithDuration:0.3 delay:0.35 options:UIViewAnimationOptionCurveEaseOut animations:^{  
           if (state == DrawerViewStateUp){   
//                    pullImgView.transform = CGAffineTransformMakeRotation(M_PI);
               pullImgView.image = [UIImage imageNamed:@"pullup"];

                } else {
//                     pullImgView.transform = CGAffineTransformMakeRotation(0);
                    pullImgView.image = [UIImage imageNamed:@"pulldown"];

                }
        } completion:^(BOOL finish){
               drawState = state;
        }];  
        
   
}


@end
