//
//  KMSimpleMenu.swift
//  XKRW
//
//  Created by Klein Mioke on 15/10/13.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

enum KMSimpleMenuType: Int {
    case Landscape = 1, Portrait
}

struct KMSimpleMenuOption {
    let backgroundColor: UIColor
    let textColor: UIColor
    let font: UIFont
}

class KMSimpleMenu: UIView {
    
    var transparentButton: UIButton!
    
    private var titles: [String]
    var type: KMSimpleMenuType
    
    var rowHeight: CGFloat = 35.0
    var rowWidth: CGFloat = 70.00
    
    var clickAction: ((index:Int) -> Void)?
    private var showedDirection: KMDirection?

    init(titles: [String], type: KMSimpleMenuType, option: KMSimpleMenuOption) {
        self.titles = titles
        self.type = type
        
        switch self.type {
        case .Landscape:
            super.init(frame: CGRectMake(0, 0, CGFloat(self.titles.count) * rowWidth, rowHeight))
        case .Portrait:
            super.init(frame: CGRectMake(0, 0, rowWidth, CGFloat(self.titles.count) * rowHeight))
        }
        self.layer.cornerRadius = rowWidth / 7
        self.layer.masksToBounds = true
        self.backgroundColor = option.backgroundColor
        
        var x: CGFloat = 0, y: CGFloat = 0
        var tag = 100
        
        for title in titles {
            let button = UIButton(frame: CGRectMake(x, y, rowWidth, rowHeight))
            button.setTitle(title, forState: UIControlState.Normal)
            button.setTitleColor(option.textColor, forState: UIControlState.Normal)
            
            button.titleLabel?.font = option.font
            button.tag = tag++
            button.addTarget(self, action: #selector(KMSimpleMenu.handleClickAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            self.addSubview(button)
            
            switch self.type {
            case .Landscape:
                x += rowWidth
            case .Portrait:
                y += rowHeight
            }
        }
    }
    
    func showAtPoint(origin: CGPoint, direction: KMDirection, inView view: UIView) {
        
        self.transparentButton = {
            let button = UIButton(frame: view.bounds)
            button.backgroundColor = UIColor.clearColor()
            button.addTarget(self, action: #selector(KMSimpleMenu.hide), forControlEvents: UIControlEvents.TouchUpInside)
            
            return button
        }()
        
        view.addSubview(self.transparentButton)
        
        self.showedDirection = direction

        let begin: CGPoint
        let xSpace = self.width * 0.1, ySpace = self.height * 0.1
        
        switch direction {
        case .Up:
            begin = CGPointMake(origin.x, origin.y + ySpace / 0.8)
        case .Down:
            begin = CGPointMake(origin.x, origin.y - ySpace / 0.8)
        case .Left:
            begin = CGPointMake(origin.x + xSpace / 0.8, origin.y)
        case .Right:
            begin = CGPointMake(origin.x - xSpace / 0.8, origin.y)
        }
        
        self.frame.origin = begin
        self.transform = CGAffineTransformMakeScale(0.8, 0.8)
        self.alpha = 0.1
        
        view.addSubview(self)
        
        UIView.animateWithDuration(0.2) { () -> Void in
            self.alpha = 1
            self.transform = CGAffineTransformMakeScale(1, 1)
            self.frame.origin = origin
        }
    }
    
    func hide() {
        guard self.showedDirection != nil else {
            return
        }
        let end: CGPoint
        let xSpace = self.width * 0.1, ySpace = self.height * 0.1
        
        switch self.showedDirection! {
        case .Up:
            end = CGPointMake(origin.x, origin.y + ySpace / 0.8)
        case .Down:
            end = CGPointMake(origin.x, origin.y - ySpace / 0.8)
        case .Left:
            end = CGPointMake(origin.x + xSpace / 0.8, origin.y)
        case .Right:
            end = CGPointMake(origin.x - xSpace / 0.8, origin.y)
        }
        
        self.transparentButton.removeFromSuperview()
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.alpha = 0.1
            // 这两句先后顺序会对效果有影响
            self.frame.origin = end
            self.transform = CGAffineTransformMakeScale(0.8, 0.8)
        }) { (finished: Bool) -> Void in
            self.removeFromSuperview()
        }
    }
    
    func handleClickAction(sender: UIButton) {
        
        let index = sender.tag - 100
        self.clickAction?(index: index)
        self.hide()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
