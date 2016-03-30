//
//  UncaughtExceptionHandler.h
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

#import <UIKit/UIKit.h>

// --> add by liaor on 20130419
// 因为工程中引入的友盟的libMobClickLibrary.a也使用了本第三方代码，导致类名、函数名和常量名编译时发生冲突，
// 所以把类名、函数名和常量名加上了"XK_"前缀
// <-- add by liaor on 20130419

// --> add by liaor on 20130419
OBJC_EXTERN BOOL XK_UncaughtExceptionHandlerShouldPopupDebugInfo;

OBJC_EXTERN void (^XK_UncaughtExceptionHandlerFinalTask)(void);
// <-- add by liaor on 20130419

@interface XK_UncaughtExceptionHandler : NSObject
{
	BOOL dismissed;
}

@end

void XK_InstallUncaughtExceptionHandler();
