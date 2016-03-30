//
//  FMDatabase+XKPersistence.h
//  XKCommon
//
//  Created by Rick Liao on 13-3-30.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "FMDatabase.h"

@interface FMDatabase (XKPersistence)

// 注意：1.arguments中的各参数，使用sql中的:name来访问，:name的解析规则为：
//        (1)对于两个单引号之间的内容不解析（两个连续的单引号作为转义单引号，仍然被解析）
//        (2)name部分为:后的第一个字符开始，到后面第一个非字母非数字非_的字符之前
//        (3)目前未考虑注释，即对sql注释也会视作sql语句部分处理
//      2.对于arguments中的类型为Array或Dictionary的属性，在存入DB时使用的是对其序列化后得到的JSON字符串
//      3.本方法要求从sql解析出的所有参数，在obj中都有相应属性，如果属性不足，会导致例外发生
- (BOOL)executeUpdate:(NSString *)sql withParameterObject:(id)arguments;
// 注意：1. 2.同上一个方法
//      3.和2相似，对于arguments之后的各附加参数值，如果其类型为Array或Dictionary，在存入DB时使用的也是对其序列化后得到的JSON字符串
//      4.本方法要求从sql解析出的所有参数，在obj或firstArgumentValue,...中都有相应属性，如果属性不足，会导致例外发生
//      5.当设置了firstArgumentValue,...参数时，将优先使用该参数的value，而不使用arguments中的同名value
//      6.从firstArgumentValue开始，为各name/value对，设置顺序为（包括firstArgumentValue）：
//          value1,name1,value2,name2,......valueN,nameN,nil
//        最后一个参数设值一定要是nil
- (BOOL)executeUpdate:(NSString *)sql withParameterObject:(id)arguments parameterValuesAndNames:(id)firstArgumentValue, ... NS_REQUIRES_NIL_TERMINATION;

@end
