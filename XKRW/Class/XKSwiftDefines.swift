//
//  XKSwiftDefines.swift
//  XKRW
//
//  Created by XiKang on 15/5/8.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import Foundation

let UI_SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let UI_SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height

//远程通知的内容
let RemoteNotificationContent    =   "RemoteNotificationContent"
//用来记录每次Http请求重要消息的消息ID
let HttpImportantNoticeID      =     "HttpImportantNoticeID"

let DailyIntakeSize = "DailyIntakeSize"

let MSG_APPKEY = "7a1f10938d60"

let KNOWLEDGR_NID = "KnowlegdeNId"

let SPORTRECOMMEND_NID = "sportRecommendNid"

let ENCOURAGEMENT_NID = "encouragementNid"

let PK_NID = "pkNid"

let SCHEMEPAGE = "schemePage"

let ANALYZEPAGE = "analyzePage"

//主色调
let XKMainSchemeColor = UIColor(fromHexString: "#29CCB1")
//灰色调
let XKGrayDefaultColor = UIColor(fromHexString: "#ececec")

// iOS系统版本
let IOS_VERSION   =  atof(UIDevice.currentDevice().systemVersion)
let IOS8          =  (IOS_VERSION > 8.0) ? 1 : 0


let XK_TITLE_COLOR          = UIColor(fromHexString: "#333333")
let XK_TEXT_COLOR           = UIColor(fromHexString: "#666666")
let XK_ASSIST_TEXT_COLOR    = UIColor(fromHexString: "#999999")
let XK_LINEAR_ICON_COLOR    = UIColor(fromHexString: "#C7C7CC")
let XK_ASSIST_LINE_COLOR    = UIColor(fromHexString: "#E0E0E0")
let XK_PRESSED_COLOR        = UIColor(fromHexString: "#E6E6E6")
let XK_BACKGROUND_COLOR     = UIColor(fromHexString: "#F4F4F4")
let XK_NAV_TITLE_COLOR      = UIColor(fromHexString: "#FEFEFE")
let XK_MAIN_TONE_COLOR      = UIColor(fromHexString: "#29ccb1")

// 极少 -3
let XK_STATUS_COLOR_FEW     = UIColor(fromHexString: "#FF6B6B")
//*  较少 -2F
let XK_STATUS_COLOR_LESS    = UIColor(fromHexString: "#FF7F7F")
//*  正常 -1
let XK_STATUS_COLOR_NORMAL  = UIColor(fromHexString: "#FF884C")
//*  达标 0
let XK_STATUS_COLOR_STANDARD = UIColor(fromHexString: "#29CCB1")
//*  完美 2
let XK_STATUS_COLOR_PERFECT = UIColor(fromHexString: "#AAC814")

let XKDEFAULFONT = UIFont.systemFontOfSize(16)

enum SchemeCompletionState: Int {
    case Complete
    case NotComplete
    case OwnPlan
}

//var NEW_TOKEN: String {
//    if let token = NSUserDefaults.standardUserDefaults().objectForKey("NEW_TOKEN") as? String {
//        return token
//    }
//    return ""
//}

//var OLD_TOKEN: String {
//    if let token = NSUserDefaults.standardUserDefaults().objectForKey("OLD_TOKEN") as? String {
//        return token
//    }
//    return ""
//}

func loadViewFromBundle(name: String!,owner: AnyObject!) -> UIView? {
    
    if let array = NSBundle.mainBundle().loadNibNamed(name, owner: owner, options:nil) {
        if array.count > 0 {
            return array.last! as? UIView
        }
    }
    return nil
}

func XKDefaultFontWithSize(fontSize: CGFloat) -> UIFont {
//    let version:NSString =  UIDevice.currentDevice().systemVersion
//    if version.floatValue >= 7.0 {
//        return UIFont(name: "Heiti SC", size: fontSize)!
//    }else{
        return UIFont.systemFontOfSize(fontSize)
//    }
}

func XKDefaultNumFontWithSize(size: CGFloat) -> UIFont {
    
    return UIFont(name: "Roboto-Regular", size: size)!
}

func scope(name: String, closure: () -> ()) -> Void {
    closure()
}

class Log {
    
    class func debug_println<T>(value: T) -> Void {
        #if DEBUG
            print(value)
        #endif
    }
}

let STR_APPSTORE_URL =   NSString(format: "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", XKRWAPPID)


//Appstore评分 iOS7  and later
let STR_APPSTORE_URL_IOS7 = NSString(format: "itms-apps://itunes.apple.com/app/id%@", XKRWAPPID)




