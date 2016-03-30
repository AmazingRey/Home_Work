//
//  XKRWCircleView.m
//  XKRW
//
//  Created by y on 15-1-22.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWCircleView.h"

@implementation XKRWCircleView  //88 *  88
@synthesize radian,circleColor;


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor =  [UIColor clearColor];
        
//        radian = 0.81 + M_PI_2 ;
    }
    
    return self;
    
}


- (void)drawRect:(CGRect)rect
{
    [self drawRound];
    [self drawArcshaped];
    
}


-(void)drawRound
{
    CGContextRef context = UIGraphicsGetCurrentContext();
   // UIColor *color =   RGB(53, 195, 161, 1);
    CGContextSetRGBStrokeColor(context, 53/255.0, 195/255.0, 161/255.0, 1);
    CGContextSetLineWidth(context, 3);
    
//    CGContextSetShadowWithColor(context,CGSizeMake(0, 0) , 0.9,color.CGColor );
    CGContextStrokeEllipseInRect(context, CGRectMake(2, 2, 91, 91));
    CGContextStrokePath(context);
}

-(void)drawArcshaped
{
    NSMutableArray *rgb = [self changeUIColorToRGB:self.circleColor];
    
    CGContextRef conte = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(conte, [[rgb firstObject] floatValue]/255.0, [[rgb objectAtIndex:1] floatValue]/255.0, [[rgb lastObject] floatValue]/255.0,1);
    CGContextSetLineWidth(conte, 3);
        CGContextAddArc(conte,47.5,47.5,45.5,M_PI/2, radian ,0); //最后一个参数为画弧方向 0为

  //最后一个参数为画弧方向 0为顺时针，弧度为0开始，倒数第二个参数为结尾弧度
    CGContextStrokePath(conte);
    
    
}

- (NSMutableArray *) changeUIColorToRGB:(UIColor *)color
{
    NSMutableArray *RGBStrValueArr = [[NSMutableArray alloc] init];
    NSString *RGBStr = nil;
    //获得RGB值描述
    NSString *RGBValue = [NSString stringWithFormat:@"%@",color];
    //将RGB值描述分隔成字符串
    NSArray *RGBArr = [RGBValue componentsSeparatedByString:@" "];
    //获取红色值
    float r = [[RGBArr objectAtIndex:1] floatValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%f",r];
    [RGBStrValueArr addObject:RGBStr];
    //获取绿色值
    float g = [[RGBArr objectAtIndex:2] floatValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%f",g];
    [RGBStrValueArr addObject:RGBStr];
    //获取蓝色值
    float b = [[RGBArr objectAtIndex:3] floatValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%f",b];
    [RGBStrValueArr addObject:RGBStr];
    //返回保存RGB值的数组
    return RGBStrValueArr ;
}


@end
