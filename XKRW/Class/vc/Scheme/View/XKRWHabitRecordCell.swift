//
//  XKRWHabitRecordCell.swift
//  XKRW
//
//  Created by Klein Mioke on 15/7/8.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWHabitRecordCell: UITableViewCell {

    @IBOutlet weak var sealImageView: UIImageView!
    @IBOutlet weak var habitsView: UIView!
    
    @IBOutlet weak var habitsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var habitsViewWidth: NSLayoutConstraint!
    @IBOutlet weak var pointLine: UIImageView!
    
    var timer: NSTimer?
    var saveAction: (()->())?
    
    var numOfHabits: Int = 0
    var numOfAmend: Int = 0
    
    var record: XKRWRecordEntity4_0?
    
    var player: AVAudioPlayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .None
        self.habitsViewWidth.constant = UI_SCREEN_WIDTH
        
        if UI_SCREEN_WIDTH > 320 {
            self.pointLine.image = UIImage(named: "home_bg_point_6_above")
        }
    }
    
    func setRecordEntity(entity: XKRWRecordEntity4_0) -> Void {
        
        for view in self.habitsView.subviews {
            view.removeFromSuperview()
        }
        
        self.record = entity
        
        if entity.habitArray.count == 0 {
            
            self.sealImageView.image = UIImage(named: "emblem_noxie")
            
            self.habitsViewHeightConstraint.constant = 64
            
            let label = UILabel(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 64))
            label.textAlignment = .Center
            label.font = UIFont.systemFontOfSize(14)
            label.textColor = XKMainSchemeColor
            label.text = "你的习惯很好，请保持！"
            
            self.habitsView.addSubview(label)
            
        } else {
            
            var yPoint: CGFloat = 0.0
            var xPoint: CGFloat = 0.0
            
            for view in habitsView.subviews {
                view.removeFromSuperview()
            }
            
            var tag = 1
            self.numOfHabits = entity.habitArray.count
            self.numOfAmend = 0
            
            for temp in entity.habitArray {
                
                if temp is XKRWHabbitEntity {
                    
                    let hEntity = temp as! XKRWHabbitEntity
                    
                    let button = UIButton(frame: CGRectMake(xPoint, yPoint, self.habitsViewWidth.constant / 4, 63))
                    button.tag = tag++
                    
                    xPoint += self.habitsViewWidth.constant / 4
                    if xPoint == self.habitsViewWidth.constant {
                        yPoint += 63
                        xPoint = 0
                    }
                    
                    button.setImage(UIImage(named: hEntity.getButtonImages()[0] as! String), forState: UIControlState.Normal)
                    button.setImage(UIImage(named: hEntity.getButtonImages()[1] as! String), forState: UIControlState.Selected)
                    if hEntity.situation == 1 {
                        button.selected = true
                        numOfAmend++
                    }
                    
                    button.addTarget(self, action: "clickHabitButton:", forControlEvents: .TouchUpInside)
                    
                    self.habitsView.addSubview(button)
                }
            }
            
            if entity.habitArray.count % 4 == 0 && entity.habitArray.count != 0 {
                self.habitsViewHeightConstraint.constant = yPoint
            } else {
                self.habitsViewHeightConstraint.constant = yPoint + 63
            }
            
            var image: UIImage
            
            if numOfAmend == 0 {
                image = UIImage(named: "emblem_ownway")!
            } else if numOfAmend < numOfHabits {
                image = UIImage(named: "emblem_onestep")!
            } else {
                image = UIImage(named: "emblem_noxie")!
            }
            self.sealImageView.image = image
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func clickHabitButton(sender: UIButton) -> Void {
        
        if(NSUserDefaults.standardUserDefaults().boolForKey("needResetScheme_\(XKRWUserService.sharedService().getUserId())"))
        {
            XKRWCui.showInformationHudWithText("当前方案已结束，请重置方案！")
            return
        }
        
        sender.selected = !sender.selected
        
        let index = sender.tag - 1
        let beforeNum = self.numOfAmend
        
        if let entity = self.record?.habitArray[index] as? XKRWHabbitEntity {
            
            if sender.selected {
                entity.situation = 1
                self.numOfAmend++

                let path = NSBundle.mainBundle().pathForResource("habbit_button_ringtone", ofType: "m4a")
                if path != nil {
                    XKRWUtil.playAudioWithPath(path!)
                }
                
            } else {
                entity.situation = 0
                self.numOfAmend--
            }
        }
        
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        self.timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "save", userInfo: nil, repeats: false)
//        self.timer = NSTimer(fireDate: NSDate(), interval: 3, target: self, selector: "save", userInfo: nil, repeats: false)
        
        var y = self.frame.origin.y
        var v: UIView = self as UIView
        while v.superview != nil {
            
            v = v.superview!
            y += v.frame.origin.y
            
            if v is UIScrollView {
                y -= (v as! UIScrollView).contentOffset.y
            }
        }
        
        if self.numOfHabits == 1 {
            
            if self.numOfAmend == 1 {
                let image = UIImage(named: "emblem_noxie")!
                XKRWAnimateUtil.doSealAnimationWithImage(image, toPoint: CGPointMake(29, y + 29), completion: { () -> () in
                    self.sealImageView.image = image
                })
            } else {
                let image = UIImage(named: "emblem_ownway")!
                XKRWAnimateUtil.doSealAnimationWithImage(image, toPoint: CGPointMake(29, y + 29), completion: { () -> () in
                    self.sealImageView.image = image
                })
            }
        } else {
            
            if self.numOfAmend == 0 {
                let image = UIImage(named: "emblem_ownway")!
                XKRWAnimateUtil.doSealAnimationWithImage(image, toPoint: CGPointMake(29, y + 29), completion: { () -> () in
                    self.sealImageView.image = image
                })
            } else if self.numOfAmend == 1 && beforeNum == 0 {
                let image = UIImage(named: "emblem_onestep")!
                XKRWAnimateUtil.doSealAnimationWithImage(image, toPoint: CGPointMake(29, y + 29), completion: { () -> () in
                    self.sealImageView.image = image
                })
            } else if self.numOfAmend == self.numOfHabits {
                let image = UIImage(named: "emblem_noxie")!
                XKRWAnimateUtil.doSealAnimationWithImage(image, toPoint: CGPointMake(29, y + 29), completion: { () -> () in
                    self.sealImageView.image = image
                })
            } else if self.numOfAmend == self.numOfHabits - 1 && beforeNum == self.numOfHabits {
                let image = UIImage(named: "emblem_onestep")!
                XKRWAnimateUtil.doSealAnimationWithImage(image, toPoint: CGPointMake(29, y + 29), completion: { () -> () in
                    self.sealImageView.image = image
                })
            }
        }
    }
    
    func save() -> Void {
    
        self.saveAction?()
    }
}
