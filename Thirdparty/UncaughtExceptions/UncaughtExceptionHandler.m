//
//  UncaughtExceptionHandler.m
//  UncaughtExceptions
//
//  Created by Matt Gallagher on 2010/05/25.
//  Copyright 2010 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "UncaughtExceptionHandler.h"
#import "JSONKit.h"
#import "ASIFormDataRequest.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

// --> add by liaor on 20130419
// 因为工程中引入的友盟的libMobClickLibrary.a也使用了本第三方代码，导致类名、函数名和常量名编译时发生冲突，
// 所以把类名、函数名和常量名加上了"XK_"前缀
// <-- add by liaor on 20130419

// --> add by liaor on 20130419
BOOL XK_UncaughtExceptionHandlerShouldPopupDebugInfo = NO;

void (^XK_UncaughtExceptionHandlerFinalTask)(void) = nil;
// <-- add by liaor on 20130419

NSString * const XK_UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const XK_UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const XK_UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t XK_UncaughtExceptionCount = 0;
const int32_t XK_UncaughtExceptionMaximum = 10;

const NSInteger XK_UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger XK_UncaughtExceptionHandlerReportAddressCount = 5;

@implementation XK_UncaughtExceptionHandler

+ (NSArray *)backtrace
{
	 void* callstack[128];
	 int frames = backtrace(callstack, 128);
	 char **strs = backtrace_symbols(callstack, frames);
	 
	 int i;
	 NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
	 for (
	 	i = XK_UncaughtExceptionHandlerSkipAddressCount;
	 	i < XK_UncaughtExceptionHandlerSkipAddressCount +
			XK_UncaughtExceptionHandlerReportAddressCount;
		i++)
	 {
	 	[backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
	 }
	 free(strs);
	 
	 return backtrace;
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
{
	if (anIndex == 0)
	{
		dismissed = YES;
	}
}

- (void)validateAndSaveCriticalApplicationData
{
// --> add by liaor on 20130419
    if (XK_UncaughtExceptionHandlerFinalTask) {
        XK_UncaughtExceptionHandlerFinalTask();
    }
// <-- add by liaor on 20130419
}

- (void)handleException:(NSException *)exception
{
	[self validateAndSaveCriticalApplicationData];
    // add by jiangr on 20140114
    NSDictionary *exceptionDic = [NSDictionary dictionaryWithObjectsAndKeys:[exception reason],@"reason",[exception userInfo],@"callStack",nil];
    NSString *exStr = [exceptionDic JSONString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:@"http://127.0.0.1:3000/showexception"]];
    [request setPostValue:exStr forKey:@"exception"];
    [request startSynchronous];
	
// --> add by liaor on 20130419
if (XK_UncaughtExceptionHandlerShouldPopupDebugInfo) {
// <-- add by liaor on 20130419
    UIAlertView *alert =
    [[[UIAlertView alloc]
      initWithTitle:NSLocalizedString(@"Unhandled exception", nil)
      message:[NSString stringWithFormat:NSLocalizedString(
                                                           @"You can try to continue but the application may be unstable.\n\n"
                                                           @"Debug details follow:\n%@\n%@", nil),
               [exception reason],
               [[exception userInfo] objectForKey:XK_UncaughtExceptionHandlerAddressesKey]]
      delegate:self
      cancelButtonTitle:NSLocalizedString(@"Quit", nil)
      otherButtonTitles:NSLocalizedString(@"Continue", nil), nil]
     autorelease];
	[alert show];
	
	CFRunLoopRef runLoop = CFRunLoopGetCurrent();
	CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
	
	while (!dismissed)
	{
		for (NSString *mode in (NSArray *)allModes)
		{
			CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
		}
	}
	
	CFRelease(allModes);
// --> add by liaor on 20130419
} // else NOP
// <-- add by liaor on 20130419
	NSSetUncaughtExceptionHandler(NULL);
	signal(SIGABRT, SIG_DFL);
	signal(SIGILL, SIG_DFL);
	signal(SIGSEGV, SIG_DFL);
	signal(SIGFPE, SIG_DFL);
	signal(SIGBUS, SIG_DFL);
	signal(SIGPIPE, SIG_DFL);
	
	if ([[exception name] isEqual:XK_UncaughtExceptionHandlerSignalExceptionName])
	{
		kill(getpid(), [[[exception userInfo] objectForKey:XK_UncaughtExceptionHandlerSignalKey] intValue]);
	}
	else
	{
		[exception raise];
	}
}

@end

void HandleException(NSException *exception)
{
	int32_t exceptionCount = OSAtomicIncrement32(&XK_UncaughtExceptionCount);
	if (exceptionCount > XK_UncaughtExceptionMaximum)
	{
		return;
	}
	
	NSArray *callStack = [XK_UncaughtExceptionHandler backtrace];
	NSMutableDictionary *userInfo =
		[NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
	[userInfo
		setObject:callStack
		forKey:XK_UncaughtExceptionHandlerAddressesKey];
	
	[[[[XK_UncaughtExceptionHandler alloc] init] autorelease]
		performSelectorOnMainThread:@selector(handleException:)
		withObject:
			[NSException
				exceptionWithName:[exception name]
				reason:[exception reason]
				userInfo:userInfo]
		waitUntilDone:YES];
}

void SignalHandler(int signal)
{
	int32_t exceptionCount = OSAtomicIncrement32(&XK_UncaughtExceptionCount);
	if (exceptionCount > XK_UncaughtExceptionMaximum)
	{
		return;
	}
	
	NSMutableDictionary *userInfo =
		[NSMutableDictionary
			dictionaryWithObject:[NSNumber numberWithInt:signal]
			forKey:XK_UncaughtExceptionHandlerSignalKey];

	NSArray *callStack = [XK_UncaughtExceptionHandler backtrace];
	[userInfo
		setObject:callStack
		forKey:XK_UncaughtExceptionHandlerAddressesKey];
	
	[[[[XK_UncaughtExceptionHandler alloc] init] autorelease]
		performSelectorOnMainThread:@selector(handleException:)
		withObject:
			[NSException
				exceptionWithName:XK_UncaughtExceptionHandlerSignalExceptionName
				reason:
					[NSString stringWithFormat:
						NSLocalizedString(@"Signal %d was raised.", nil),
						signal]
				userInfo:
					[NSDictionary
						dictionaryWithObject:[NSNumber numberWithInt:signal]
						forKey:XK_UncaughtExceptionHandlerSignalKey]]
		waitUntilDone:YES];
}

void XK_InstallUncaughtExceptionHandler()
{
	NSSetUncaughtExceptionHandler(&HandleException);
	signal(SIGABRT, SignalHandler);
	signal(SIGILL, SignalHandler);
	signal(SIGSEGV, SignalHandler);
	signal(SIGFPE, SignalHandler);
	signal(SIGBUS, SignalHandler);
	signal(SIGPIPE, SignalHandler);
}

