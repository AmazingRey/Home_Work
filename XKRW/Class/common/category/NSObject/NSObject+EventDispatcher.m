//
//  NSObject+EventDispatcher.m
//  vik_learning_ios
//
//  Created by Yang Lijuan on 13-3-12.
//  Copyright (c) 2013年 neu. All rights reserved.
//

#import "NSObject+EventDispatcher.h"

@implementation NSEvent

+(NSEvent*)eventWithKey:(NSString*)key withObject:(id)data{
	NSEvent *event=[NSNotification notificationWithName:key object:data];
	return event;
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		
	}
	return self;
}

@end

@implementation NSObject (EventDispatcher)

-(void)dispathcerEvent:(NSEvent*)event{
	NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
	[nc postNotification:event];
}
-(void)addEventListener:(id)target forKey:(NSString*)key withFunction:(SEL)func{
	NSAssert([target respondsToSelector:func],@"Target does not respondsToSelector");
	NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
	[nc addObserver:target selector:func name:key object:nil];
}
-(void)removeEventListener:(id)target forKey:(NSString*)key{
	NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
	[nc removeObserver:target name:key object:nil];
}

@end
