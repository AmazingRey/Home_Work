//
//  XKRWThinBodyAssess_5_3VC.swift
//  XKRW
//
//  Created by ss on 16/4/1.
//  Copyright © 2016年 XiKang. All rights reserved.
//

import UIKit

class XKRWThinBodyAssess_5_3VC: XKRWBaseVC {
 

    @IBOutlet weak var scrollView: UIScrollView!
   

    var eatView    : XKRWPlan_5_3View!
    var sportView  : XKRWPlan_5_3View!
    var habitView  : XKRWPlan_5_3CollectionView?
    var fromWhichVC: FromWhichVC?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的瘦身计划"
        
        scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, 300)
        
        eatView = loadViewFromBundle("XKRWPlan_5_3View", owner: self) as! XKRWPlan_5_3View
        eatView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 300)
        eatView.type = .Food
        eatView.layoutIfNeeded()
        scrollView.addSubview(eatView)
        
//        sportView = XKRWPlan_5_3View.init(frame: CGRectMake(0, eatView.frame.size.height, 375, 300))
//        sportView.type = .Sport
//        sportView.layoutIfNeeded()
//        scrollView.addSubview(sportView)
        
        
//        let view = XKRWPlan_5_3View.init(frame: CGRectMake(0, 0, 375, 300))
     
//        for index in 0...2 {
//            switch index {
//            case 0:
//                view.type = .Food
//                break
//            case 1:
//                view.type = .Sport
//                break
//            case 2:
//                view.type = .Habit
//                break
//            default:
//                break
//            }
//            view.layoutIfNeeded()
//            scrollView.addSubview(view)
//        }
        
        if(fromWhichVC == FromWhichVC.MyVC)
        {   
            //            nextButton.hidden = true
            //            describeLabel.hidden = true
            let rightNaviBarButton:UIButton = UIButton(type: UIButtonType.Custom)
            rightNaviBarButton.setTitle("修改方案", forState: UIControlState.Normal)
            rightNaviBarButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            rightNaviBarButton.setTitleColor(XKGrayDefaultColor, forState: .Highlighted)
            rightNaviBarButton.titleLabel!.font = UIFont.systemFontOfSize(14)
            rightNaviBarButton.frame = CGRectMake(0, 0, 60, 20)
            rightNaviBarButton.addTarget(self, action: #selector(XKRWThinBodyAssessVC.doClickNaviBarRightButton as (XKRWThinBodyAssessVC) -> () -> ()), forControlEvents:UIControlEvents.TouchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNaviBarButton)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
