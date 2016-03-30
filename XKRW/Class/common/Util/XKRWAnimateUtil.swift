//
//  XKRWAnimateUtil.swift
//  XKRW
//
//  Created by Klein Mioke on 15/6/9.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWAnimateUtil: NSObject {

    class func doSealAnimation(view: UIView!, completion: () -> ()) {
        
        let zoom = UI_SCREEN_WIDTH / view.frame.width

        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [zoom, 1]
        scale.keyTimes = [0, 1]
        scale.duration = 0.4

        
        let shake = CAKeyframeAnimation(keyPath: "position.x")
        let x = view.center.x
        shake.values = [x, x+10, (x-10), x+10, x];
        shake.keyTimes = [0, (1 / 6.0), (3 / 6.0), (5 / 6.0), 1];
        shake.duration = 0.1;
        shake.beginTime = 0.4
        
        let group = CAAnimationGroup()
        group.animations = [scale, shake]
        group.duration = 0.5
        
        view.layer.addAnimation(group, forKey: "shake")
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * CGFloat(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in

        }
    }
    
    class func doSealAnimationWithImage(image: UIImage, toPoint: CGPoint, completion: () -> ()) {
        
        let imageView: UIImageView = UIImageView(image: image)
        imageView.center = UIApplication.sharedApplication().keyWindow!.center
        
        let zoom = UI_SCREEN_WIDTH / imageView.frame.width
        
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [zoom, 1]
        scale.keyTimes = [0, 1]
        scale.duration = 0.4
        
        let move = CAKeyframeAnimation(keyPath: "position")
        move.values = [NSValue(CGPoint: imageView.center), NSValue(CGPoint: toPoint)]
        move.keyTimes = [0, 1]
        move.duration = 0.4
        move.beginTime = 0.0
        
        let shake = CAKeyframeAnimation(keyPath: "position.x")
        let x = toPoint.x
        shake.values = [x, x+10, (x-10), x+10, x];
        shake.keyTimes = [0, (1 / 6.0), (3 / 6.0), (5 / 6.0), 1];
        shake.duration = 0.1;
        shake.beginTime = 0.4
        
        let group = CAAnimationGroup()
        group.animations = [scale, move, shake]
        group.duration = 0.5
        
        UIApplication.sharedApplication().keyWindow!.addSubview(imageView)
        imageView.layer.addAnimation(group, forKey: "shake")
        imageView.center = toPoint
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * CGFloat(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            
            completion()
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                imageView.alpha = 0.0
            }, completion: { (finished) -> Void in
                imageView.removeFromSuperview()
            })
        }
    }
}
