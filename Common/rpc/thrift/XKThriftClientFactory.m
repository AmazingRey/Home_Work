//
//  XKThriftClientFactory.m
//  calorie
//
//  Created by Jiang Rui on 12-11-12.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import "THTTPClient.h"
#import "TBinaryProtocol.h"
#import "XKConfigUtil.h"
#import "XKConfigException.h"
#import "XKThriftClientFactory.h"

@implementation XKThriftClientFactory

static XKThriftClientFactory* _sharedInstance;
static NSMutableDictionary *protocolDictionary;

+(XKThriftClientFactory *)sharedFactory
{
    if (_sharedInstance == nil) {
        _sharedInstance = [[XKThriftClientFactory alloc]init];
        protocolDictionary = [[NSMutableDictionary alloc]init];
//        [protocolDictionary setObject:[TBinaryProtocol alloc] forKey:@"BINARY"];
    }
    return _sharedInstance;
}

// 根据类创建client实例
- (id)createClientInstanceByClass:(Class)class {
    NSString *className = NSStringFromClass(class);
    NSString *hostNameKey = [@"HostFor" stringByAppendingString:className];
    NSString *hostName = [XKConfigUtil stringForKey:hostNameKey];
    
    if (hostName.length <= 0) {
        @throw [XKConfigException exceptionForMissedConfigWithConfigKey:hostNameKey];
    }
    
    THTTPClient *myTransport = [[THTTPClient alloc] initWithURL:[NSURL URLWithString:[self generateUrlByClassName:className andHostName:hostName]]];
    TBinaryProtocol *myProtocol = [[TBinaryProtocolFactory sharedFactory] newProtocolOnTransport:myTransport];
    
    id client = [[class alloc] performSelector:@selector(initWithProtocol:) withObject:myProtocol];
    return client;
}

////根据类名创建client类实例
//-(id)createClientInstanceByClassName:(NSString *)className
//{
//    Class class = NSClassFromString(className);
//    THTTPClient *myTransport = [[THTTPClient alloc] initWithURL:[NSURL URLWithString:[self generateUrlByClassName:className]]];
//    TBinaryProtocol *myProtocol = [[TBinaryProtocolFactory sharedFactory] newProtocolOnTransport:myTransport];
//    id client = [[class alloc] performSelector:@selector(initWithProtocol:) withObject:myProtocol];
//    return client;
//}
//
//-(id)createClientInstanceByClassName:(NSString *)className andHostName:(NSString *)hostName
//{
//    Class class = NSClassFromString(className);
//    THTTPClient *myTransport = [[THTTPClient alloc] initWithURL:[NSURL URLWithString:[self generateUrlByClassName:className andHostName:hostName]]];
//    TBinaryProtocol *myProtocol = [[TBinaryProtocolFactory sharedFactory] newProtocolOnTransport:myTransport];
//    id client = [[class alloc] performSelector:@selector(initWithProtocol:) withObject:myProtocol];
//    return client;
//}
////根据class名称取得对应服务url
//-(NSString *)generateUrlByClassName:(NSString *)className
//{
//    NSString * str = @"";
//    str = [NSString stringWithFormat:@"http://%@/rpc/thrift/%@.bin",[XKConfiguration stringForKey:className],[self convertToURLServiceString:className]];
//    return str;
//    
//}

//根据class名称取得对应服务url
-(NSString *)generateUrlByClassName:(NSString *)className andHostName:(NSString *)hostName
{
    NSString * str = @"";
    str = [NSString stringWithFormat:@"http://%@/rpc/thrift/%@.bin",[XKConfigUtil stringForKey:hostName],[self convertToURLServiceString:className]];
    return str;
    
}

-(NSString *)convertToURLServiceString:(NSString *)string
{
    NSError *error = NULL;
    NSString *result = @"";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[A-Z][a-z_]+"
                                                                           options:NSRegularExpressionAllowCommentsAndWhitespace
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:string
                                      options:0
                                        range:NSMakeRange(0, [string length])];
    int i = 0;
    for (i=0;i<[matches count];i++) {
        NSTextCheckingResult *match = [matches objectAtIndex:i];
        NSRange matchRange = [match range];
        NSString *str = [string substringWithRange:matchRange];
        if ([str isEqualToString:@"Client"]) {
            break;
        }
        else if (i == 0) {
            result = [result stringByAppendingFormat:@"%@",[str lowercaseString]];
        }
        else
        {
            result = [result stringByAppendingFormat:@"-%@",[str lowercaseString]];
        }
    }
    return result;
}

@end
