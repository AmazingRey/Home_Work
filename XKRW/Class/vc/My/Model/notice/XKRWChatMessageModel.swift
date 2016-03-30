//
//  XKRWChatMessageModel.swift
//  XKRW
//
//  Created by 忘、 on 16/2/19.
//  Copyright © 2016年 XiKang. All rights reserved.
//

import UIKit

class XKRWChatMessageModel: NSObject {
    
    var message = ""
    var time:NSTimeInterval = 0
    var senderType:MessgeSendType = .FromMain
    var redirect = ""
    var imageUrl:String?
    
}
