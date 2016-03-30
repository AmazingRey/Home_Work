//
//  FMResultSet+XKPersistence.h
//  XKCommon
//
//  Created by Rick Liao on 13-4-1.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "FMResultSet.h"

@interface FMResultSet (XKPersistence)

// 注意：1.本方法要求结果集中的所有DB列数据，在obj中都有相应属性，如果属性不足，会导致例外发生
//        因此为便于发现错误，通常应该使用本方法
//      2.由于FMDB本身的不支持，在本方法的实现中，日期/时间的DB类型的值，会被转为字符串保存入obj
//      3.对于obj中类型为Array或Dictionary的属性，在对其设值时会把从DB取来的数据作为JSON字符串进行反序列化，以得到相应Array或Dictionary进行设值
- (void)setResultToObject:(id)obj;
// 注意：1.本方法不要求结果集中的所有DB列数据，在obj中都有相应属性，如果属性不足，所缺的属性不会被设置
//        因此为便于发现错误，通常应该使用上面的setResultToObject:方法
//      2.3.同上一个方法
- (void)setResultIgnoreAbsentPropertiesToObject:(id)obj;

@end
