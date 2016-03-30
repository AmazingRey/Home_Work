//
//  KMScreenTopMarginHint.swift
//  XKRW
//
//  Created by Klein Mioke on 15/10/23.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class KMScreenTopMarginHint: UIView {
    
    var textLabel: UILabel!
    
    var timer: NSTimer!
    var isStatusBarHiddenBefore: Bool = false

    init(text: String) {
        
        super.init(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 20))
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        
        self.textLabel = {
            let label = UILabel(frame: self.bounds)
            label.text = text
            label.textAlignment = .Center
            
            label.font = UIFont.systemFontOfSize(12)
            label.textColor = UIColor.whiteColor()
            
            self.addSubview(label)
            
            return label
        }()
    }
    
    func show() -> Void {
        if self.timer != nil {
            self.timer.invalidate()
        }
        self.alpha = 0
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
        
        self.isStatusBarHiddenBefore = UIApplication.sharedApplication().statusBarHidden
        
        if !self.isStatusBarHiddenBefore {
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
        }
        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.alpha = 1
        }
        self.timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "hide", userInfo: nil, repeats: false)
    }
    
    func hide() -> Void {
        if !self.isStatusBarHiddenBefore {
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
        }
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.alpha = 0
        }) { (finished: Bool) -> Void in
            self.removeFromSuperview()
            self.timer?.invalidate()
            self.timer = nil
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
