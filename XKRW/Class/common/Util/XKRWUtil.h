//
//  XKRWUtil.h
//  XKRW
//
//  Created by zhanaofan on 13-12-18.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "define.h"
#import "XKUtil.h"
#import "NSDate+Helper.h"
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "XKRWFoodEntity.h"

@interface XKRWUtil : XKUtil


//根据时间戳，获取对应的格式
+ (NSString *) dateFormatWithTime:(NSUInteger)time;


+ (NSString *) dateFormatWithString:(NSString *)dateStr format:(NSString *)fromatStr;

+ (NSString *) dateFormateWithDate:(NSDate *)date format:(NSString *)formatStr;

/*生成随机数*/
+ (int)getRandomNumber:(int)from to:(int)to;
/*将数组或者字典转换成JSON对象*/
+ (NSData *)toJSONData:(id)theData;
/*将json对象转换成数组和字典*/
+ (id)toArrayOrNSDictionary:(NSData *)jsonData;
+ (NSNumber*) sumOfArray:(NSArray*)arr;
/*将目前的三餐餐次转换成对应的贴士类型*/
+ (uint32_t) tipTypeWithMealType:(uint32_t)mealType;
/*根据时间戳，获取年龄*/
+ (uint32_t) ageWithTimestamp:(NSTimeInterval)timestamp;

+ (CGSize) sizeOfStringWithFont:(NSString *) str withFont:(UIFont*)font;
//获取文本的尺寸
+ (CGSize) stringSizeWithWidth:(CGFloat) width fontSize:(CGFloat)fontSize str:(NSString*)str;
+ (CGSize) stringSizeWithWidth:(CGFloat) width font:(UIFont *)font lineBreak:(NSLineBreakMode)mode alignment:(NSTextAlignment )alignme str:(NSString*)str;
//合并2张图片
+ (UIImage *)mergeImages:(UIImage *)firstImage theSecondImage:(UIImage *)secondImage withSize:(CGSize)size;
//px转换成pt
+ (CGFloat)pixelToPoints:(CGFloat)px;
+ (CGSize) sizeOfStringWithFont:(NSString *)text width:(float)width font:(UIFont *)font;
+ (CGSize) measureFrame: (CTFrameRef) frame forContext: (CGContextRef *) cgContext;
+ (int)getAttributedStringHeightWithString:(NSAttributedString *)  string  WidthValue:(int) width;
//播放指定的文件
+ (void) playAudioWithPath:(NSString *)file;

+ (void) shakeDevice;
+ (NSMutableArray*) getFileListWithPath:(NSString *)path;
//根据数值，获取对应频率中文描述
+ (NSString *)getFrequencyStr:(uint32_t)frequency;
//获取餐次名字
+ (NSString *)getMealName:(MealType)mealType;
+ (MealType) curMealType;
//获取度量单位名称
//+ (NSString *)getUnitName:(uint32_t) unitType;

//单位转换
+ (NSUInteger ) JouleToCalorie:(NSUInteger)Joule;

+ (NSUInteger)  weightToCalorie:(NSUInteger)weight foodEntity:(XKRWFoodEntity *) foodEntity;

/**
 *  创建属性字符串
 *
 *  @param string  原字符串
 *  @param font    字体
 *  @param color   颜色
 *  @param spacing 行间距
 *
 *  @return 属性字符串
 */
+ (NSMutableAttributedString *)createAttributeStringWithString:(NSString *)string
                                                          font:(UIFont *)font
                                                         color:(UIColor *)color
                                                   lineSpacing:(CGFloat)spacing
                                                     alignment:(NSTextAlignment)alignment;

+ (UIColor *)getStatusColorWithFlag:(int)flag;

/**
 *  AutoLayout
 */
+ (CGSize)getViewSize:(UIView *)view;



+ (void)setLabelColor:(UILabel *)lable colorFlag:(NSInteger )flag;

+ (void)setLabelBackgroundColor:(UILabel *)lable colorFlag:(NSInteger )flag;

+ (void)setButtonBackgroundColor:(UIButton *)button colorFlag:(NSInteger )flag;

/**
 *  UIColor 转 UIImage
 */

+ (UIImage*)createImageWithColor:(UIColor*)color;

/**
 *  判断一个path是本地路径还是网络路径
 *
 *  @param path 路径String
 *
 *  @return 是否是本地路径
 */
+ (BOOL)pathIsNative:(NSString *)path;

+ (void)clearButtonSelectedState:(UIView *)view;

//给一个View添加视图线
+ (void)addViewUpLineAndDownLine:(UIView *)view andUpLineHidden:(BOOL) upLineHidden DownLineHidden:(BOOL)downLineHidden;

//给一个View添加视图线
+ (void)addViewUpLineAndDownLine:(UIView *)view andUpLineXPoint:(CGFloat)upx andUpLineHidden:(BOOL) upLineHidden  andDownLineXPoint:(CGFloat)downx DownLineHidden:(BOOL)downLineHidden;

+ (NSInteger)getLengthOfTheNumber:(NSInteger)num;

+ (NSString *)calculateTimeShowStr:(NSInteger) time;

/**
 *  是否打开了通知
 *
 *  @return <#return value description#>
 */
+ (BOOL) isAllowedNotification;

@end
