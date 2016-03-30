//
//  HPChangeHabitView.swift
//  XKRW
//
//  Created by Klein Mioke on 15/8/5.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class HPChangeHabitView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    weak var oldEntity: XKRWRecordEntity4_0?
    var clickConfirmAction: (()->())?
    
    init() {
        super.init(frame: CGRectMake(0, 0, 270, 0))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func setContent(oldEntity: XKRWRecordEntity4_0) -> Void {

        self.oldEntity = oldEntity
        
        var x: CGFloat = 0
        var y: CGFloat = 5
        
        var tag = 1
        for habit in oldEntity.habitArray {
            
            if habit is XKRWHabbitEntity {
                
                let entity = habit as! XKRWHabbitEntity
                
                let button = UIButton(frame: CGRectMake(x, y, 90, 90))
                button.setImage(UIImage(named: entity.getButtonImages()[0] as! String), forState: .Normal)
                button.setImage(UIImage(named: entity.getButtonImages()[1] as! String), forState: .Selected)
                
                button.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
                button.tag = tag++
                
                self.addSubview(button)
                
                if entity.situation == 1 {
                    button.selected = true
                } else {
                    button.selected = false
                }
                x += 90
                if x >= 270 {
                    x = 0
                    y += 90
                }
            }
        }
        
        let topline = UIView.init(frame: CGRectMake(0, 0, self.width, 0.5))// initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
        topline.backgroundColor = XK_ASSIST_LINE_COLOR
        let button = UIButton(frame: CGRectMake(0 , y + 90, self.width, 50))
//        button.layer.borderColor = XKMainSchemeColor.CGColor
//        button.layer.borderWidth = 1
//        button.layer.cornerRadius = 1.5
        button.addSubview(topline)
        
        button.setTitle("确定", forState: .Normal)
        button.setTitleColor(XKMainSchemeColor, forState: .Normal)
        button.addTarget(self, action: "clickConfirmButton", forControlEvents: .TouchUpInside)
        button.titleLabel?.font = UIFont.systemFontOfSize(16)
        button.setBackgroundImage(UIImage.createImageWithColor(XK_ASSIST_LINE_COLOR), forState:.Highlighted )
        self.layer.masksToBounds = true
        self.addSubview(button)
        
        self.height = y + 90 + 35 + 15
    }
    
    func clickButton(button: UIButton) -> Void {
        
        button.selected = !button.selected
        
        if let habit = self.oldEntity?.habitArray[button.tag - 1] as? XKRWHabbitEntity {
            habit.situation = Int(button.selected)
        }
    }
    
    func clickConfirmButton() -> Void {
        self.clickConfirmAction?()
    }
}
