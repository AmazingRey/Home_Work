//
//  XKRWSegmentedControl.swift
//  XKRW
//
//  Created by XiKang on 15/5/27.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWSegmentedControl: UIView {
    
    let BUTTON_WIDTH: CGFloat = 90.0
    
    var scrollView: UIScrollView
    var animationView: UIView
    
    /// 1 less than button's tag
    var selectedIndex: Int = 0
    
    var num: Int = 0
    
    var titles: [String]!
    
    var clickAction: ((Int) -> Void)?
    // MARK: - Initialization
    
    init(frame: CGRect, titles: [String]) {
        
        
        self.scrollView = UIScrollView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, frame.height))
        
        self.animationView = UIView(frame: CGRectMake(0, frame.size.height - 3, BUTTON_WIDTH, 2))
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        self.scrollView.clipsToBounds = false
        
        self.loadSubviewsWithTitles(titles)
        
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(self.scrollView)
        
        let line = UIView(frame: CGRectMake(0, frame.size.height - 1, UI_SCREEN_WIDTH, 1))
        line.backgroundColor = XKMainSchemeColor
        
        self.addSubview(line)
        
        self.animationView.backgroundColor = XKMainSchemeColor
        self.scrollView.addSubview(self.animationView)
    }
    
    func loadSubviewsWithTitles(titles: [String]) -> Void {
        
        if self.num > 0 {
            
            for i in 1...self.num {
                if let button = self.scrollView.viewWithTag(i) as? UIButton {
                    button.removeFromSuperview()
                }
            }
        }
        self.num = 0
        self.selectedIndex = 0
        self.animationView.left = 0

        let width = CGFloat(titles.count) * BUTTON_WIDTH
        
        if width > UI_SCREEN_WIDTH {
            self.scrollView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, frame.height)
        } else {
            self.scrollView.frame = CGRectMake(UI_SCREEN_WIDTH / 2 - width / 2, 0, width, self.frame.height)
        }
        self.titles = titles
        
        for title in titles {
            let frame : CGRect = CGRectMake(CGFloat(num++) * BUTTON_WIDTH , 0, BUTTON_WIDTH, self.frame.size.height)
            self.createButton(title, frame: frame)
        }
        self.setButton(self.selectedIndex, isSelected: true)
        
        self.scrollView.contentSize = CGSizeMake(CGFloat(num) * BUTTON_WIDTH, 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.scrollView = UIScrollView()
        self.animationView = UIView()
        super.init(coder: aDecoder)
    }
    
    internal func createButton(title: String, frame: CGRect) {
        
        let button: UIButton = UIButton(type: .Custom)
        button.setTitle(title, forState: .Normal)
        button.frame = frame
        button.tag = num
        button.titleLabel?.font = XKDefaultFontWithSize(15)
        button.setTitleColor(XK_TITLE_COLOR, forState: .Normal)
        button.setTitleColor(XKMainSchemeColor, forState: .Selected)
        
        button.addTarget(self, action: #selector(XKRWSegmentedControl.clickButtonAtIndex(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.scrollView.addSubview(button)
    }
    //MARK: - Actions
    func clickButtonAtIndex(sender: UIButton) {
        
        if sender.selected {
            return
        }
        self.setButton(self.selectedIndex, isSelected: false)
        self.selectedIndex = sender.tag - 1
        
        sender.selected = true
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.animationView.left = sender.left
        })
        self.handleAnimation(sender.tag)
        
        if self.clickAction != nil {
            self.clickAction!(sender.tag)
        }
    }
    
    internal func handleAnimation() {
        self.handleAnimation(self.selectedIndex + 1)
    }
    
    internal func handleAnimation(buttonTag: Int) {
        
        if CGFloat(self.titles.count) * BUTTON_WIDTH > UI_SCREEN_WIDTH {
            
            let offset: CGFloat = CGFloat(buttonTag) * BUTTON_WIDTH - UI_SCREEN_WIDTH / 2 - BUTTON_WIDTH / 2
            let rightDistance: CGFloat = CGFloat(num - buttonTag) * BUTTON_WIDTH + BUTTON_WIDTH / 2 - UI_SCREEN_WIDTH / 2
            
            if offset > 0 && rightDistance > 0 {
                self.scrollView.setContentOffset(CGPointMake(offset, 0), animated: true)
                
            } else if offset < 0 && self.scrollView.contentOffset.x != 0 {
                self.scrollView.setContentOffset(CGPointZero, animated: true)
                
            } else if rightDistance < 0 && self.scrollView.contentOffset.x != CGFloat(num * Int(BUTTON_WIDTH)) - UI_SCREEN_WIDTH {
                self.scrollView.setContentOffset(CGPointMake(CGFloat(num * Int(BUTTON_WIDTH)) - UI_SCREEN_WIDTH, 0), animated: true)
            }
        }
        
    }
    
    func handleClickAction(clickAction: (index: Int) -> Void) {
        self.clickAction = clickAction
    }
    
    func setButton(index: Int, isSelected: Bool) {
        
        if let button = self.scrollView.viewWithTag(self.selectedIndex + 1) as? UIButton {
            button.selected = isSelected
        }
    }
    /**
    When scrollView in cell scrolling, also will scroll animationView in this view
    
    - parameter scrollView: the scrollView is scrolling
    */
    func handleScrollAnimation(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x / scrollView.contentSize.width * self.scrollView.contentSize.width
        self.animationView.left = offset
    }
    /**
    When scrollView did end decelerating, call this method to correct animationView's position
    
    - parameter scrollView: the scrollView did end decelerating
    */
    func handleEndScrollAnimation(scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x / scrollView.contentSize.width * self.scrollView.contentSize.width
        
//        UIView.animateWithDuration(0.08, animations: { () -> Void in
//            
//            self.animationView.left = offset
//        })
        
        if let button = self.scrollView.viewWithTag(Int(offset / BUTTON_WIDTH + 1)) as? UIButton {
            
            self.clickButtonAtIndex(button)
        }
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
