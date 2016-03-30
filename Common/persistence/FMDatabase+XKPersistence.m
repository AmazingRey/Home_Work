//
//  FMDatabase+XKPersistence.m
//  XKCommon
//
//  Created by Rick Liao on 13-3-30.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "JSONKit.h"
#import "FMDatabase+XKPersistence.h"

@implementation FMDatabase (XKPersistence)

- (BOOL)executeUpdate:(NSString *)sql withParameterObject:(id)arguments {
    NSMutableDictionary *argDict = [self createParameterDictionaryWithObject:arguments ForSql:sql];
    return [self executeUpdate:sql withParameterDictionary:argDict];
}

- (NSMutableDictionary *)createParameterDictionaryWithObject:(id)arguments ForSql:(NSString *)sql {
    NSMutableDictionary *argDict = [NSMutableDictionary dictionary];
    
    BOOL inQuotes = NO;
    BOOL inEscapeQuotes = NO;
    BOOL inArg = NO;
    
    NSString *argName = nil;
    id argValue = nil;
    
    NSMutableCharacterSet *argCharSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [argCharSet addCharactersInString:@"_"];
    
    NSUInteger l = sql.length;
    unichar c = 0;
    NSRange r = NSMakeRange(0, 0);
    
    for (NSUInteger i = 0; i < l; ++i) {
        c = [sql characterAtIndex:i];
        
        if (inEscapeQuotes) {
            inEscapeQuotes = NO;
        } else if (inQuotes) {
            if (c == '\'') {
                if ((i < l - 1) && [sql characterAtIndex:i + 1] == '\'') {
                    inEscapeQuotes = YES;
                } else {
                    inQuotes = NO;
                }
            } // else NOP
        } else if (inArg) {
            if (![argCharSet characterIsMember:c]) {
                inArg = NO;
                r.length = i - r.location;
                argName = [sql substringWithRange:r];
                argValue = [arguments valueForKey:argName];
                argDict[argName] = [self dbValueForObject:argValue];
                
                --i;
            } // else NOP
        } else {
            if (c == '\'') {
                if ((i < l - 1) && [sql characterAtIndex:i + 1] == '\'') {
                    inEscapeQuotes = YES;
                } else {
                    inQuotes = YES;
                }
            } else if (c == ':') {
                inArg = YES;
                r.location = i + 1;
            } // else NOP
        }
    }
    
    if (inArg) {
        r.length = l - r.location;
        argName = [sql substringWithRange:r];
        argValue = [arguments valueForKey:argName];
        argDict[argName] = [self dbValueForObject:argValue];
    } // else NOP
    
    return argDict;
}

- (BOOL)executeUpdate:(NSString *)sql withParameterObject:(id)arguments parameterValuesAndNames:(id)firstArgumentValue, ... {
    NSMutableDictionary *argDict = [NSMutableDictionary dictionary];
    
    if (firstArgumentValue) {
        id name = nil;
        id value = firstArgumentValue;
        
        va_list args;
        va_start(args, firstArgumentValue);
        
        do {
            name = va_arg(args, id);
            argDict[name] = [self dbValueForObject:value];  // 如果name为nil，会抛出例外
            value = va_arg(args, id);
        } while (value);
        
        va_end(args);
    }
    
    BOOL inQuotes = NO;
    BOOL inEscapeQuotes = NO;
    BOOL inArg = NO;
    
    NSString *argName = nil;
    id argValue = nil;
    
    NSMutableCharacterSet *argCharSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [argCharSet addCharactersInString:@"_"];
    
    NSUInteger l = sql.length;
    unichar c = 0;
    NSRange r = NSMakeRange(0, 0);
    
    for (NSUInteger i = 0; i < l; ++i) {
        c = [sql characterAtIndex:i];
        
        if (inEscapeQuotes) {
            inEscapeQuotes = NO;
        } else if (inQuotes) {
            if (c == '\'') {
                if ((i < l - 1) && [sql characterAtIndex:i + 1] == '\'') {
                    inEscapeQuotes = YES;
                } else {
                    inQuotes = NO;
                }
            } // else NOP
        } else if (inArg) {
            if (![argCharSet characterIsMember:c]) {
                inArg = NO;
                r.length = i - r.location;
                
                argName = [sql substringWithRange:r];
                if (!argDict[argName]) {
                    argValue = [arguments valueForKey:argName];
                    argDict[argName] = [self dbValueForObject:argValue];
                } // else NOP
                
                --i;
            } // else NOP
        } else {
            if (c == '\'') {
                if ((i < l - 1) && [sql characterAtIndex:i + 1] == '\'') {
                    inEscapeQuotes = YES;
                } else {
                    inQuotes = YES;
                }
            } else if (c == ':') {
                inArg = YES;
                r.location = i + 1;
            } // else NOP
        }
    }
    
    if (inArg) {
        r.length = l - r.location;
        
        argName = [sql substringWithRange:r];
        if (!argDict[argName]) {
            argValue = [arguments valueForKey:argName];
            argDict[argName] = [self dbValueForObject:argValue];
        } // else NOP
    } // else NOP
    
    return [self executeUpdate:sql withParameterDictionary:argDict];
}

- (id)dbValueForObject:(id)object {
    id dbValue = nil;
    
    if (!object) {
        dbValue = [NSNull null];
    } else if ([object isKindOfClass:NSArray.class]
               || [object isKindOfClass:NSDictionary.class]){
        dbValue = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
//        dbValue = [object JSONString];
    } else {
        dbValue = object;
    }
    
    return dbValue;
}

@end
