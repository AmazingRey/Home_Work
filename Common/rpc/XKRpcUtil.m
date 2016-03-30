//
//  XKRpcUtil.m
//  calorie
//
//  Created by JiangRui on 13-1-16.
//  Copyright (c) 2013年 neusoft. All rights reserved.
//

#import <CommonCrypto/CommonHMAC.h>
#import "OpenUDID.h"
#import "XKConfigUtil.h"
#import "XKUtil.h"
#import "XKRpcAuthConst.h"
#import "XKRpcUtil.h"

@implementation XKRpcUtil

//生成Digest认证模式下的CommArgs
+ (CommArgs *)commArgsForDigestAuth {
    return [XKRpcUtil generateComArgForDigest:YES];
}

//生成None认证模式下的CommArgs
+ (CommArgs *)commArgsForNoneAuth {
    return [XKRpcUtil generateComArgForDigest:NO];
}

+(CommArgs *)generateComArgForDigest:(BOOL)isDigest
{
    NSString *str_deviceId = [OpenUDID value];
    TerminalInfo* terminalinfo = [[TerminalInfo alloc] initWithDeviceType:DeviceType_IOS deviceId:str_deviceId OsVersion:[[UIDevice currentDevice] systemVersion]];
    
    AppInfo *appinfo = [[AppInfo alloc] initWithAppId:[XKConfigUtil stringForKey:@"XKAppId"] appVersion:[XKConfigUtil stringForKey:@"XKAppVersion"]];
    
    I18nInfo *internationalinfo = [[I18nInfo alloc] initWithRegion:Region_CN language:Language_ZH_CN];
    CommArgs *commparam = nil;
    
    if (isDigest) {
        NSMutableDictionary *loginDic = [[[XKUtil defaultUserDefaults] valueForKey:@"loginResult"] mutableCopy];
        int initialCount = ((NSNumber *)[loginDic valueForKey:@"initialCount"]).intValue + 1;
        
        
        NSString *accessToken = [XKRpcUtil get_accessToken:DeviceType_IOS deviceId:str_deviceId
                                                     AppId:appinfo.appId
                                                appVersion:appinfo.appVersion
                                                    userId:[loginDic valueForKey:@"userId"]
                                              clientRandom:@"test"
                                                  ClientId:[loginDic valueForKey:@"clientId"]
                                              initialToken:[loginDic valueForKey:@"initialToken"]
                                               clientCount:initialCount];
        
        
        
        
        
        
        DigestAuthenticationReq *diggest = [[DigestAuthenticationReq alloc]initWithClientId:[loginDic valueForKey:@"clientId"]
                                                                                clientCount:initialCount
                                                                               clientRandom:@"test"
                                                                                accessToken:accessToken];
        
        
        commparam = [[CommArgs alloc] initWithTerminalInfo:terminalinfo
                                                   appInfo:appinfo
                                                    userId:[loginDic valueForKey:@"userId"]
                                                  i18nInfo:internationalinfo
                                                  authMode:AuthMode_DIGEST
                                   digestAuthenticationReq:diggest
                                              checkVersion:YES];
        
        [loginDic setValue:[[NSNumber alloc]initWithInt:initialCount] forKey:@"initialCount"];
        [[XKUtil defaultUserDefaults] setValue:loginDic forKey:@"loginResult"];
        [[XKUtil defaultUserDefaults] synchronize];
        
    }
    else
    {
        commparam = [[CommArgs alloc] initWithTerminalInfo:terminalinfo
                                                   appInfo:appinfo userId:nil
                                                  i18nInfo:internationalinfo
                                                  authMode:AuthMode_NONE
                                   digestAuthenticationReq:nil
                                              checkVersion:YES];
    }
    return commparam;
    
}

+(NSString *)get_accessToken: (int) deviceType
                    deviceId: (NSString *) deviceId
                       AppId: (NSString *) appId
                  appVersion: (NSString *) appVersion
                      userId: (NSString *) userId
                clientRandom: (NSString *) cRandom
                    ClientId: (NSString *) clientId
                initialToken: (NSString *)initToken
                 clientCount: (int)cCount
{
    NSString *HS1 = [XKRpcUtil H_sha256:[XKRpcUtil H_concat_7:[XKRpcUtil H_itoa:deviceType]
                                                             :deviceId
                                                             :appId
                                                             :appVersion
                                                             :userId
                                                             :cRandom
                                                             :clientId]];
    
    NSString *HS2 = [XKRpcUtil H_sha256:[XKRpcUtil H_concat_3_HS2:initToken
                                                                 :[XKRpcUtil H_itoa:cCount]
                                                                 :[XKRpcUtil H_get128]]];
    
    return [XKRpcUtil H_sha256:[XKRpcUtil H_concat_3:HS1
                                                    :@"DIGEST001"
                                                    :HS2]];
}

+(BOOL)is_resSign: (NSString *) userAccount ClientId: (NSString *) clientId  UserID: (NSString *) userID Server_resSign:(NSString *) resSign
{
    NSString * str_ = [NSString stringWithFormat:@"%@:%@:%@:%@",userAccount,clientId,XKCCSS1,userID];
    
    NSString *str_local = [XKRpcUtil H_sha256:str_];
    
    return [str_local isEqualToString:resSign];
}

+(NSString *)H_itoa:(NSInteger)int_
{
    return [NSString stringWithFormat:@"%ld",(long)int_];
}

+(NSString *)H_concat_3_HS2:(NSString *)str_1 :(NSString *)str_2 :(NSString *)str_3
{
    return [NSString stringWithFormat:@"%@||%@||%@",str_1,str_2,str_3];
}

+(NSString *)H_concat_3:(NSString *)str_1 :(NSString *)str_2 :(NSString *)str_3
{
    return [NSString stringWithFormat:@"%@%@%@",str_1,str_2,str_3];
}

+(NSString *)H_concat_7:(NSString *)str_1
                       :(NSString *)str_2
                       :(NSString *)str_3
                       :(NSString *)str_4
                       :(NSString *)str_5
                       :(NSString *)str_6
                       :(NSString *)str_7
{
    return [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@",str_1,str_2,str_3,str_4,str_5,str_6,str_7];
}

+(NSString *)H_sha256:(NSString *)clear
{
    
    const char *s=[clear cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, (uint32_t)keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}

+(NSString *)H_get128
{
    NSString *str_128 = XKCCSS2;
    return str_128;
}

@end
