//
//  XKThriftClientFactory.h
//  calorie
//
//  Created by Jiang Rui on 12-11-12.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

typedef enum ProtocolType : NSInteger{
    kBINARY,
} ProtocolType;

@interface XKThriftClientFactory : NSObject

//单例
+(XKThriftClientFactory *)sharedFactory;

// 工厂方法
- (id)createClientInstanceByClass:(Class)class;
////工厂方法
//-(id)createClientInstanceByClassName:(NSString *)className andHostName:(NSString *)hostName;
////工厂方法
//-(id)createClientInstanceByClassName:(NSString *)className;

@end
