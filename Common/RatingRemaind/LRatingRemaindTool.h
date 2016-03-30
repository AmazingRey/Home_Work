//
//  LRatingRemaindTool.h
//  RulerPart
//
//  Created by Leng on 14-4-21.
//  Copyright (c) 2014年 Leng. All rights reserved.
//

typedef enum RemindType_{
    RemindType_NoLimit = 0, //默认无限制
    RemindType_ForEFive ,   //每启动5次提示一次
    RemindType_ForETen  ,   //每10次
    RemindType_Custome      //自定义
}RemindType;

#define LR_appID 622478622

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface LRatingRemaindTool : NSObject <UIAlertViewDelegate,SKStoreProductViewControllerDelegate>
@property (nonatomic,weak) id delegate;
@property (nonatomic,assign) BOOL needPassOnce;

+(id)shareTool;

-(void) setRatingRemindType:( RemindType ) type;

-(void)setRatingRemindFrequency:(int32_t) frequency;

-(void) checkIfNeedShow;

-(void) checkShowOnly;


@end
