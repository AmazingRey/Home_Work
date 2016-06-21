//
//  KMImageItem.swift
//  XKRW
//
//  Created by Klein Mioke on 15/9/22.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class KMImageItem: UIImageView {

    var actionButton: UIButton!
    
    var clickAction: ((Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let width = self.frame.size.width / 5
        
        if self.actionButton == nil {
            self.actionButton = UIButton(frame: CGRectMake(width * 4, 0, width, width))
            self.actionButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
            self.actionButton.addTarget(self, action: #selector(KMImageItem.clickActionButton(_:)), forControlEvents: .TouchUpInside)
            
            self.addSubview(self.actionButton)
        }
        self.userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clickActionButton(sender: UIButton) -> Void {
        self.clickAction?(self.tag)
        print("click action button")
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func drawRect(rect: CGRect) {
//    
//    
//    }
}
