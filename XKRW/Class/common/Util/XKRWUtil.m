//
//  XKRWUtil.m
//  XKRW
//
//  Created by zhanaofan on 13-12-18.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import "XKRWUtil.h"
#import <AVFoundation/AVFoundation.h>

@implementation XKRWUtil:XKUtil
//根据时间戳，获取对应的时间格式
+ (NSString *) dateFormatWithTime:(NSUInteger)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    return [date stringDaysAgoAgainstMidnight:YES];
    
//    return time_str;
}

+ (NSString *) dateFormatWithString:(NSString *)dateStr format:(NSString *)formatStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:dateStr];
    [formatter setDateFormat:formatStr];
    return [formatter stringFromDate:date];
}


+ (NSString *) dateFormateWithDate:(NSDate *)date format:(NSString *)formatStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    [formatter setDateFormat:formatStr];
    return [formatter stringFromDate:date];
}


+ (uint32_t) ageWithTimestamp:(NSTimeInterval)timestamp
{
    NSTimeInterval now_t = [[NSDate date] timeIntervalSince1970];
    return floor((now_t - timestamp)/(86400*365));
}
/*将目前的三餐餐次转换成对应的贴士类型*/
+ (uint32_t) tipTypeWithMealType:(uint32_t)mealType
{
    uint32_t tipType;
    switch (mealType) {
        case eMealBreakfast:
        case eMealLunch :
            tipType = mealType;
            break;
        case eMealSnack:
            tipType = 3;
            break;
        case eMealDinner:
            tipType = 7;
            break;
        case 0:
            tipType = 4;
            break;
        default:
            break;
    }
    return mealType;
}
/*将数组或者字典转换成JSON对象*/
+ (NSData *)toJSONData:(id)theData{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}
/*将json对象转换成数组和字典*/
+ (id)toArrayOrNSDictionary:(NSData *)jsonData{
    
    NSError *error = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        return nil;
    }
}
+ (NSNumber*) sumOfArray:(NSArray*)arr
{
    NSNumber* sum = [arr valueForKeyPath: @"@sum.self"];
    return sum;
}
/*生成随机数*/
+ (int)getRandomNumber:(int)from to:(int)to

{
    return (int)(from + (arc4random() % (to - from )));
}

//获取字体的尺寸
+ (CGSize) sizeOfStringWithFont:(NSString *) str withFont:(UIFont*)font
{
    CGSize size = {0.f,0.f};
    float version = XKSystemVersion;
    if ([str length] > 0) {
        if (version >=7.0) {
            NSDictionary *attributes = @{NSFontAttributeName: font};
            size = [str sizeWithAttributes:attributes];
        }else{
            size = [str sizeWithFont:font];
        }
    }
    return size;
    
}

+ (CGSize) stringSizeWithWidth:(CGFloat) width fontSize:(CGFloat)fontSize str:(NSString*)strContent
{
    UIFont *strFont = XKDefaultFontWithSize(fontSize);
    //计算文本内容的高度
    return [self stringSizeWithWidth:width font:strFont lineBreak:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft str:strContent];
}
+ (CGSize) stringSizeWithWidth:(CGFloat) width font:(UIFont *)font lineBreak:(NSLineBreakMode)mode alignment:(NSTextAlignment )alignme str:(NSString*)str{
    CGSize size = CGSizeZero;
    
    float version = XKSystemVersion;
    //计算文本内容的高度
    if ([str length] > 0) {
        //IOS版本大于7.0
        if (version >= 7.0) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = mode;
            paragraphStyle.alignment = NSTextAlignmentLeft;
            
            size = [str boundingRectWithSize:CGSizeMake(280.f, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,paragraphStyle, NSParagraphStyleAttributeName,nil]  context:nil].size;
        } else {
            size = [str sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:mode];
        }
    }

    return size;
}
+ (CGSize) sizeOfStringWithFont:(NSString *)text width:(float)width font:(UIFont *)font
{
    CGSize size = {0.f,0.f};
    float version = XKSystemVersion;
    if ([text length] > 0) {
        if (version >= 7.0) {
            CGSize constrainedSize = CGSizeMake(width, CGFLOAT_MAX);
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            paragraphStyle.alignment = NSTextAlignmentLeft;
            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  font, NSFontAttributeName,
//                                                  paragraphStyle, NSParagraphStyleAttributeName,
                                                  nil];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:attributesDictionary];
//            float attrString = [[self class] getAttributedStringHeightWithString:string WidthValue:280];

            CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) context:nil];
            if (requiredHeight.size.width > width) {
                requiredHeight = CGRectMake(0, 0, width, requiredHeight.size.height);
            }
            size = requiredHeight.size;
        }else{
            size = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        }
    }
    return size;
}

+ (NSMutableArray*) getFileListWithPath:(NSString *)path
{
    NSMutableArray *files = [[NSMutableArray alloc] init];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:path];
    NSString *file;
    while (file = [dirEnum nextObject]) {
        [files addObject:file];
    }
//    }
    return files;
}
+ (void) playAudioWithPath:(NSString *)file
{
    SystemSoundID     soundID;
    if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:file], &soundID);
        AudioServicesPlaySystemSound (soundID);
    }
}

+ (void) shakeDevice
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+(CGFloat)pixelToPoints:(CGFloat)px {
    CGFloat pointsPerInch = 72.0; // see: http://en.wikipedia.org/wiki/Point%5Fsize#Current%5FDTP%5Fpoint%5Fsystem
    CGFloat scale = 1; // We dont't use [[UIScreen mainScreen] scale] as we don't want the native pixel, we want pixels for UIFont - it does the retina scaling for us
    float pixelPerInch; // aka dpi
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        pixelPerInch = 132 * scale;
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        pixelPerInch = 163 * scale;
    } else {
        pixelPerInch = 160 * scale;
    }
    CGFloat result = px * pointsPerInch / pixelPerInch;
    return result;
}

+ (CGSize) measureFrame: (CTFrameRef) frame forContext: (CGContextRef *) cgContext
{
	CGPathRef framePath = CTFrameGetPath(frame);
	CGRect frameRect = CGPathGetBoundingBox(framePath);
    
	CFArrayRef lines = CTFrameGetLines(frame);
	CFIndex numLines = CFArrayGetCount(lines);
    
	CGFloat maxWidth = 0;
	CGFloat textHeight = 0;
    
	// Now run through each line determining the maximum width of all the lines.
	// We special case the last line of text. While we've got it's descent handy,
	// we'll use it to calculate the typographic height of the text as well.
	CFIndex lastLineIndex = numLines - 1;
	for(CFIndex index = 0; index < numLines; index++)
	{
		CGFloat ascent, descent, leading, width;
		CTLineRef line = (CTLineRef) CFArrayGetValueAtIndex(lines, index);
		width = CTLineGetTypographicBounds(line, &ascent,  &descent, &leading);
        
		if(width > maxWidth)
		{
			maxWidth = width;
		}
        
		if(index == lastLineIndex)
		{
			// Get the origin of the last line. We add the descent to this
			// (below) to get the bottom edge of the last line of text.
			CGPoint lastLineOrigin;
			CTFrameGetLineOrigins(frame, CFRangeMake(lastLineIndex, 1), &lastLineOrigin);
            
			// The height needed to draw the text is from the bottom of the last line
			// to the top of the frame.
			textHeight =  CGRectGetMaxY(frameRect) - lastLineOrigin.y + descent;
		}
	}
    
	// For some text the exact typographic bounds is a fraction of a point too
	// small to fit the text when it is put into a context. We go ahead and round
	// the returned drawing area up to the nearest point.  This takes care of the
	// discrepencies.
	return CGSizeMake(ceil(maxWidth), ceil(textHeight));
}
+ (int)getAttributedStringHeightWithString:(NSAttributedString *)  string  WidthValue:(int) width
{
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)string);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, 1000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (__bridge NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 1000 - line_y + (int) descent +1;    //+1为了纠正descent转换成int小数点后舍去的值
    
    CFRelease(textFrame);
    
    return total_height;
    
}
//合并2个图片
+(UIImage *)mergeImages:(UIImage *)firstImage theSecondImage:(UIImage *)secondImage withSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    
    [firstImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [secondImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return finalImage;
}
//获取提醒频率的中文描述
+ (NSString *)getFrequencyStr:(uint32_t)frequency
{
    if (frequency == 127) {
        return @"每天";
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSArray *weeks = weeksChs;
    for (uint32_t i=0; i<7; ++i) {
        uint32_t n = (1<<i);
        if ((frequency & n) == n) {
            NSString *obj = (NSString*)[weeks objectAtIndex:(i)];
            [arr addObject:obj];
        }
    }
    return [arr componentsJoinedByString:@","];
}

//获取餐次名称
+ (NSString *)getMealName:(MealType)mealType
{
    NSArray *mealNames = XKMealNames ;
    return (mealType > 0 && mealType < 5)  ? (NSString *)[mealNames objectAtIndex:(mealType-1)] : nil;
}

+ (MealType) curMealType
{
    return eMealBreakfast;
    
    MealType mealType = eMealBreakfast;
    NSDate *date = [NSDate date];
    uint32_t hour = [[NSDate stringFromDate:date withFormat:@"HH"] integerValue];
    if (hour > 10 && hour <= 14) {
        mealType = eMealLunch;
    }else if (hour > 14 && hour < 17){
        mealType = eMealSnack;
    }else {
        mealType = eMealDinner;
    }
    return mealType;
}


+ (NSUInteger ) JouleToCalorie:(NSUInteger)Joule
{
    float  calorie = Joule * 0.2389;
    return (int)calorie;
    
}


+ (NSUInteger)  weightToCalorie:(NSUInteger)weight foodEntity:(XKRWFoodEntity *) foodEntity
{
    float  calorie = foodEntity.foodEnergy*weight/100;
    return (int)calorie;
}

+ (NSMutableAttributedString *)createAttributeStringWithString:(NSString *)string
                                                          font:(UIFont *)font
                                                         color:(UIColor *)color
                                                   lineSpacing:(CGFloat)spacing
                                                     alignment:(NSTextAlignment)alignment
{
#if RELEASE
    if (string == nil) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
#endif
#if DEBUG
    NSAssert(string != nil, @"创建AttributeString时，传入String必须不为空！%s:%d", __FILE__, __LINE__);
#endif
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = spacing;
    style.alignment  = alignment;
    style.firstLineHeadIndent = 0.05;
    NSDictionary *attributes =
    @{NSFontAttributeName: font,
      NSParagraphStyleAttributeName: style,
      NSForegroundColorAttributeName: color};
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    
    return attributedString;
}

+ (UIColor *)getStatusColorWithFlag:(int)flag {
    
    UIColor *color = nil;
    switch (flag) {
        case -3:
            color = XK_STATUS_COLOR_FEW;
            break;
        case -2:
            color = XK_STATUS_COLOR_LESS;
            break;
        case -1:
            color = XK_STATUS_COLOR_NORMAL;
            break;
        case 0:
            color = XK_STATUS_COLOR_STANDARD;
            break;
        case 1:
            color = XK_STATUS_COLOR_GREAT;
            break;
        case 2:
            color = XK_STATUS_COLOR_PERFECT;
            break;
            
        default:
            break;
    }
    return color;
}

#pragma mark - AutoLayout

+ (CGSize)getViewSize:(UIView *)view {
    
    if (!view) {
        return CGSizeZero;
    }
//    return CGSizeMake(XKAppWidth, 150);
    return [view systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
}

#pragma mark
+ (void)setLabelColor:(UILabel *)lable colorFlag:(NSInteger )flag
{
    switch (flag) {
        case -3:
            lable.textColor = [UIColor colorFromHexString:@"ff6b6b"];
            break;
        case -2:
            lable.textColor = [UIColor colorFromHexString:@"ff7f7f"];
            break;
        case -1:
            lable.textColor = [UIColor colorFromHexString:@"ff884c"];
            break;
        case 0:
            lable.textColor = [UIColor colorFromHexString:@"29ccb1"];
            break;
        case 1:
            lable.textColor = [UIColor colorFromHexString:@"3cc52"];
            break;
        case 2:
            lable.textColor = [UIColor colorFromHexString:@"aac814"];
            break;
            
        default:
            break;
    }}

+ (void)setLabelBackgroundColor:(UILabel *)lable colorFlag:(NSInteger )flag
{
    switch (flag) {
        case -3:
            lable.backgroundColor = [UIColor colorFromHexString:@"ff6b6b"];
            break;
        case -2:
            lable.backgroundColor = [UIColor colorFromHexString:@"ff7f7f"];
            break;
        case -1:
            lable.backgroundColor = [UIColor colorFromHexString:@"ff884c"];
            break;
        case 0:
            lable.backgroundColor = [UIColor colorFromHexString:@"29ccb1"];
            break;
        case 1:
            lable.backgroundColor = [UIColor colorFromHexString:@"3cc52"];
            break;
        case 2:
            lable.backgroundColor = [UIColor colorFromHexString:@"aac814"];
            break;
            
        default:
            break;
    }}

+ (void)setButtonBackgroundColor:(UIButton *)button colorFlag:(NSInteger )flag
{
    switch (flag) {
        case -3:
            button.backgroundColor = [UIColor colorFromHexString:@"ff6b6b"];
            break;
        case -2:
            button.backgroundColor = [UIColor colorFromHexString:@"ff7f7f"];
            break;
        case -1:
            button.backgroundColor = [UIColor colorFromHexString:@"ff884c"];
            break;
        case 0:
            button.backgroundColor = [UIColor colorFromHexString:@"29ccb1"];
            break;
        case 1:
            button.backgroundColor = [UIColor colorFromHexString:@"3cc52"];
            break;
        case 2:
            button.backgroundColor = [UIColor colorFromHexString:@"aac814"];
            break;
            
        default:
            break;
    }}

/**
 *  UIColor 转 UIImage
 */
+ (UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (BOOL)pathIsNative:(NSString *)path {
    return [path rangeOfString:@"http" options:NSCaseInsensitiveSearch].location == NSNotFound;
}

+ (void)clearButtonSelectedState:(UIView *)view
{
   NSArray *viewArrays =   view.subviews;
    
    for (UIView *view in viewArrays) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            
            button.selected = NO;
        }
    }

}

+ (void)addViewUpLineAndDownLine:(UIView *)view andUpLineHidden:(BOOL) upLineHidden DownLineHidden:(BOOL)downLineHidden
{
    
    UIView *upLine  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
    upLine.backgroundColor = XK_ASSIST_LINE_COLOR;
    upLine.hidden = upLineHidden;
    [view addSubview:upLine];
    
    UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(0, view.height-0.5, XKAppWidth, 0.5)];
    downLine.backgroundColor = XK_ASSIST_LINE_COLOR;
    downLine.hidden = downLineHidden;
    [view addSubview:downLine];
}


+ (void)addViewUpLineAndDownLine:(UIView *)view andUpLineXPoint:(CGFloat)upx andUpLineHidden:(BOOL) upLineHidden  andDownLineXPoint:(CGFloat)downx DownLineHidden:(BOOL)downLineHidden{
    UIView *upLine  = [[UIView alloc]initWithFrame:CGRectMake(upx, 0, XKAppWidth, 0.5)];
    upLine.backgroundColor = XK_ASSIST_LINE_COLOR;
    upLine.hidden = upLineHidden;
    [view addSubview:upLine];
    
    UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(downx, view.height-0.5, XKAppWidth, 0.5)];
    downLine.backgroundColor = XK_ASSIST_LINE_COLOR;
    downLine.hidden = downLineHidden;
    [view addSubview:downLine];

}



+ (NSInteger)getLengthOfTheNumber:(NSInteger)num{
    NSInteger count = 0;
    do {
        num /= 10 ;
        count ++;
    }while(num);
    
    return count;
}



+ (NSString *)calculateTimeShowStr:(NSInteger) time{
    
    NSDate *nowDate = [NSDate date];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    //  时间差
    if ([timeDate isDayEqualToDate:nowDate]) {
        [dateFormatter setDateFormat:@"HH:mm"];
        return [dateFormatter stringFromDate:timeDate];
        
    } else if ([timeDate isDayEqualToDate:[nowDate offsetDay:-1]]) {
        return [NSString stringWithFormat:@"昨天"];
        
    } else if ([timeDate isWeekEqualToDate:nowDate]) {
        [dateFormatter setDateFormat:@"EE"];
        return  [dateFormatter stringFromDate:timeDate];
        
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        return [dateFormatter stringFromDate:timeDate];
    }
}


+ (BOOL) isAllowedNotification{
    if (IOS_8_OR_LATER) {// system is iOS8
            UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
             if (UIUserNotificationTypeNone != setting.types) {
                     return YES;
             }
        
         } else {//iOS7
             UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
             if(UIRemoteNotificationTypeNone != type){
                return YES;
             }
         }
        return NO;
}

@end
