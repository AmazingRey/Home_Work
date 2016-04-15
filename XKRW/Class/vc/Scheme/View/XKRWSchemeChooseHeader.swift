//
//  XKRWSchemeChooseHeader.swift
//  XKRW
//
//  Created by XiKang on 15/5/25.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

@objc protocol XKRWSchemeChooseHeaderDelegate {
    
    func clickButtonAtIndex(index: Int) -> Void
}

class XKRWSchemeChooseHeader: UIView {
    
    var selectedIndex: Int = 2
    
    var animateLine: UIView!
    
    weak var delegate: protocol<XKRWSchemeChooseHeaderDelegate>?

    override init(frame: CGRect) {
        
        self.animateLine = UIView(frame: CGRectMake(frame.size.width / 3, frame.size.height - 3.5, frame.size.width / 3, 2))
        self.animateLine.backgroundColor = XKMainSchemeColor
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        let sportButton: UIButton = UIButton(type: .Custom)
        sportButton.setTitle("运动方案", forState: .Normal)
        sportButton.titleLabel?.font = UIFont.systemFontOfSize(17)
        
        sportButton.setTitleColor(XK_TITLE_COLOR, forState: .Normal)
        sportButton.setTitleColor(XKMainSchemeColor, forState: .Selected)
        sportButton.frame = CGRectMake(0, 0, frame.size.width / 3, frame.size.height)
        sportButton.tag = 1
        
        sportButton.addTarget(self, action: #selector(XKRWSchemeChooseHeader.cilckButton(_:)), forControlEvents: .TouchUpInside)
        
        let mealButton: UIButton = UIButton(type: .Custom)
        mealButton.setTitle("饮食方案", forState: .Normal)
        mealButton.titleLabel?.font = UIFont.systemFontOfSize(17)
        
        mealButton.frame = CGRectMake(frame.size.width / 3, 0, frame.size.width / 3, frame.size.height)
        mealButton.setTitleColor(XK_TITLE_COLOR, forState: .Normal)
        mealButton.setTitleColor(XKMainSchemeColor, forState: .Selected)
        mealButton.tag = 2

        mealButton.addTarget(self, action: #selector(XKRWSchemeChooseHeader.cilckButton(_:)), forControlEvents: .TouchUpInside)
        
        let habitButton: UIButton = UIButton(type: .Custom)
        habitButton.setTitle("习惯改善", forState: .Normal)
        habitButton.titleLabel?.font = UIFont.systemFontOfSize(17)
        
        habitButton.frame = CGRectMake(frame.size.width * 2 / 3, 0, frame.size.width / 3, frame.size.height)
        habitButton.setTitleColor(XK_TITLE_COLOR, forState: .Normal)
        habitButton.setTitleColor(XKMainSchemeColor, forState: .Selected)
        habitButton.tag = 3

        habitButton.addTarget(self, action: Selector("cilckButton:"), forControlEvents: .TouchUpInside)
        
        self.addSubview(sportButton)
        self.addSubview(mealButton)
        self.addSubview(habitButton)
        
        self.addSubview(animateLine)
        
        let bottomLine: UIView = UIView(frame: CGRectMake(0, frame.size.height - 1.5, UI_SCREEN_WIDTH, 1.5))
        bottomLine.backgroundColor = XKMainSchemeColor
        
        self.addSubview(bottomLine)
        
        mealButton.selected = true
        
//        let line = UIView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5))
//        line.backgroundColor = XK_ASSIST_LINE_COLOR
        
//        self.addSubview(line)
    }
    
    func cilckButton(sender: UIButton) {
        
        if selectedIndex == sender.tag {
            return
        }
        
        self.selectButtonWithTag(sender.tag)
        
        if (self.delegate != nil) {
            self.delegate?.clickButtonAtIndex(sender.tag)
        }
    }
    
    func selectButtonWithTag(tag: Int) -> Void {
        
        let sender = self.viewWithTag(tag) as! UIButton
        
        sender.selected = true
//        sender.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
        
        if let unselected: UIButton = self.viewWithTag(self.selectedIndex) as? UIButton {
            
            unselected.selected = false
            self.selectedIndex = sender.tag
            unselected.titleLabel?.font = UIFont.systemFontOfSize(17)
        }
        
        UIView.animateWithDuration(0.2, animations: {[weak self] () -> Void in
            
            if let strongSelf = self {
                strongSelf.animateLine.setX(sender.left)
            }
        })
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
}
