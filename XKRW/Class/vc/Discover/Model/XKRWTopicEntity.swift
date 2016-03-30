//
//  XKRWTopicEntity.swift
//  XKRW
//
//  Created by Klein Mioke on 15/10/10.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWTopicEntity: NSObject {

    var topicId: Int
    var name: String
    var enabled: Bool
    
    init(id: Int, name: String, enabled: Bool) {
        
        self.topicId = id
        self.name = name
        self.enabled = enabled
        super.init()
    }
}
