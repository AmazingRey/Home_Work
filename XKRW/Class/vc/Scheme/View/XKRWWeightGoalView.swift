//
//  XKRWWeightGoalView.swift
//  XKRW
//
//  Created by XiKang on 15/5/25.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWWeightGoalView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    let trackBase: UIImageView = UIImageView(image: UIImage(named: "home_racetrack_base"))
    let trackTop: UIImageView = UIImageView(image: UIImage(named: "home_racetrack_top"))
    let trackBar: UIImageView = UIImageView(image: UIImage(named: "home_racetrack_full"))
    
    let originWeight = UIButton(type: UIButtonType.Custom)
    let currentWeight = UIButton(type: UIButtonType.Custom)
    let destinationWeight = UIButton(type: UIButtonType.Custom)
    
    let predictLabel = UILabel(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 25))
    let monkeyRunning = FLAnimatedImageView()
    
    //MARK: - initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let container = UIView(frame: trackTop.frame)
        container.clipsToBounds = true
        
        container.center.x = UI_SCREEN_WIDTH / 2
        container.setY(5)
        
        trackBase.backgroundColor = UIColor.clearColor()
        trackTop.backgroundColor = UIColor.clearColor()
        trackBar.backgroundColor = UIColor.clearColor()
        
        self.addSubview(container)
        container.addSubview(trackBase)
        container.addSubview(trackBar)
        container.addSubview(trackTop)
        
        let monkeyImg: FLAnimatedImage = FLAnimatedImage(animatedGIFData: NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("monkey_run", ofType: "gif")!))
        monkeyRunning.animatedImage = monkeyImg
        
        let ratio: CGFloat = trackTop.height / 41
        monkeyRunning.size = CGSizeMake(27.5 * ratio, 34 * ratio)

        monkeyRunning.bottom = trackBar.bottom - 3

        trackBar.right = trackBar.right + 27.5
        monkeyRunning.right = trackBar.right
        container.addSubview(monkeyRunning)
        
        let originImg = UIImage(named: "home_popup_left")
        let currentImg = UIImage(named: "home_popup_mid")
        let destImg = UIImage(named: "home_popup_right")
        
        originWeight.size = originImg!.size
        currentWeight.size = currentImg!.size
        destinationWeight.size = destImg!.size
        
        originWeight.setBackgroundImage(originImg, forState: UIControlState.Normal)
        originWeight.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 20)
        originWeight.userInteractionEnabled = false
        
        currentWeight.setBackgroundImage(currentImg, forState: UIControlState.Normal)
        currentWeight.userInteractionEnabled = false
        currentWeight.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 36)
        
        destinationWeight.setBackgroundImage(destImg, forState: UIControlState.Normal)
        destinationWeight.userInteractionEnabled = false
        destinationWeight.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 20)
        
        currentWeight.center.x = container.center.x
        currentWeight.top = container.bottom + 5
        
        originWeight.center.y = currentWeight.center.y
        originWeight.left = container.left
        originWeight.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        
        destinationWeight.center.y = currentWeight.center.y
        destinationWeight.right = container.right
        destinationWeight.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        
        self.addSubview(currentWeight)
        self.addSubview(originWeight)
        self.addSubview(destinationWeight)
        
        self.setOriginWeight(80.3, curWeight: 67.9, destWeight: 60.1)
        
//        var pointLine: UIImageView
//        if UI_SCREEN_WIDTH == 320 {
//            pointLine = UIImageView(image: UIImage(named: "home_bg_point_5s"))
//        } else {
//            pointLine = UIImageView(image: UIImage(named: "home_bg_point_6_above"))
//        }
//        pointLine.top = self.destinationWeight.bottom + 10
//        pointLine.left = 15
        
//        self.addSubview(pointLine)
        
        self.predictLabel.top = self.destinationWeight.bottom + 10
        self.predictLabel.textAlignment = NSTextAlignment.Center
        self.predictLabel.textColor = XKMainSchemeColor
        self.predictLabel.font = UIFont(name: "Roboto-Regular", size:15)
        self.addSubview(self.predictLabel)
        
        self.height = self.predictLabel.bottom + 10
        
        let downLine = UIView(frame: CGRectMake(0, self.height - 0.5, UI_SCREEN_WIDTH, 0.5))
        downLine.backgroundColor = XK_ASSIST_LINE_COLOR
        self.addSubview(downLine)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Other functions
    
    func setProgress(percent percent: CGFloat, animate: Bool) {
        if percent > 1 || percent < 0 {
            return
        }
        var duration = 0.0
        if animate {
            duration = 5
        }
        
        self.trackBar.setX(-self.trackTop.width)
        self.monkeyRunning.right = self.trackBar.right
        
        UIView.animateWithDuration(duration, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: { () -> Void in
            
            let x = (self.trackBar.width -  27.5) * percent + 27.5
            self.trackBar.setX(x - self.trackTop.width)
            self.monkeyRunning.right = self.trackBar.right
            
        }, completion: nil)
    }
    
    func setOriginWeight(oriWeight: CGFloat, curWeight: CGFloat, destWeight: CGFloat) -> Void {
        let change = (Float(curWeight) - Float(oriWeight))
        let str = change <= 0 ? (String(format:"比初始体重减重%.1fkg",fabsf(change))):(String(format:"比初始体重增重%.1fkg",change))
        self.predictLabel.text = str
        
        originWeight.setTitle(String(format: "%0.1f", oriWeight), forState: UIControlState.Normal)
        destinationWeight.setTitle(String(format: "%0.1f", destWeight), forState: UIControlState.Normal)
        
        let text = NSMutableAttributedString(string: String(format: "%0.1fkg", curWeight))
        let attributes = [NSFontAttributeName: UIFont(name: "Roboto-Regular", size: 30)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        text.addAttributes(attributes, range: NSMakeRange(0, text.length))
        text.addAttribute(NSFontAttributeName, value: UIFont(name: "Roboto-Regular", size: 20)!, range: NSMakeRange(text.length - 2, 2))
        
        currentWeight.setAttributedTitle(text, forState: UIControlState.Normal)
        
        var persent: CGFloat = (oriWeight - curWeight) / (oriWeight - destWeight)
        
        if oriWeight == destWeight {
            persent = 1
        }
        if persent < 0 {
            persent = 0
        }
        self.setProgress(percent: persent, animate: true)
    }
    
//    func setPredictDays(days: Int) -> Void {
//        
//        let text = NSMutableAttributedString(string: "预计还需\(days)天达到目标")
//        let attributes = [NSFontAttributeName: UIFont(name: "Roboto-Regular", size: 14)!,
//               NSForegroundColorAttributeName: XKMainSchemeColor]
//        
//        text.addAttributes(attributes, range: NSMakeRange(0, text.length))
//        
//        text.addAttribute(NSForegroundColorAttributeName, value: XKMainSchemeColor, range: NSMakeRange(4, ("\(days)" as NSString).length))
//        self.predictLabel.attributedText = text
//    }
    
    func reload(action: ()->()) -> Void {
        action()
    }
}
