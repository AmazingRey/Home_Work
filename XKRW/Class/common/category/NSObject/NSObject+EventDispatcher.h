//
//  NSObject+EventDispatcher.h
//  vik_learning_ios
//
//  Created by Yang Lijuan on 13-3-12.
//  Copyright (c) 2013年 neu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSEvent:NSNotification{
	
}

+(NSEvent*)eventWithKey:(NSString*)key withObject:(id)data;

@end

@interface NSObject (EventDispatcher)

-(void)dispathcerEvent:(NSEvent*)event;
-(void)addEventListener:(id)target forKey:(NSString*)key withFunction:(SEL)func;
-(void)removeEventListener:(id)target forKey:(NSString*)key;

@end
