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
    var fromWhichVC: FromWhichVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的瘦身计划"
        
        let viewHeight : Int = 400
        scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, CGFloat(viewHeight)*2+600)
        
        var frame = CGRectZero
        
        for index in 0...2 {
            let view = loadViewFromBundle("XKRWPlan_5_3View", owner: self) as! XKRWPlan_5_3View
            switch index {
            case 0:
                view.type = .Food
                break
            case 1:
                view.type = .Sport
                break
            case 2:
                view.type = .Habit
                break
            default:
                break
            }
            frame = CGRectMake(0, CGFloat(index*viewHeight) , UI_SCREEN_WIDTH, CGFloat(viewHeight))
            view.frame = frame
//            view.layoutIfNeeded()
            scrollView.addSubview(view)
        }
        if(fromWhichVC == FromWhichVC.MyVC)
        {
            let rightNaviBarButton:UIButton = UIButton(type: UIButtonType.Custom)
            rightNaviBarButton.setTitle("修改方案", forState: UIControlState.Normal)
            rightNaviBarButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            rightNaviBarButton.setTitleColor(XKGrayDefaultColor, forState: .Highlighted)
            rightNaviBarButton.titleLabel!.font = UIFont.systemFontOfSize(14)
            rightNaviBarButton.frame = CGRectMake(0, 0, 60, 20)
            rightNaviBarButton.addTarget(self, action: #selector(XKRWThinBodyAssess_5_3VC.doClickNaviBarRightButton as (XKRWThinBodyAssess_5_3VC) -> () -> ()), forControlEvents:UIControlEvents.TouchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNaviBarButton)
        }else{
            let myFirstButton = UIButton(type:UIButtonType.Custom)
            myFirstButton.setTitle("开始瘦身", forState: .Normal)
            myFirstButton.backgroundColor = UIColor.greenColor()
            myFirstButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            myFirstButton.frame = CGRectMake(15, scrollView.contentSize.height-80, UI_SCREEN_WIDTH-30, 40)
            myFirstButton.addTarget(self, action: #selector(XKRWThinBodyAssess_5_3VC.pressed(_:)), forControlEvents:UIControlEvents.TouchUpInside)
            
            scrollView.addSubview(myFirstButton)
        }

    }
    func setFromWhichVC(type:FromWhichVC){
        fromWhichVC = type
    }
    
    func doClickNaviBarRightButton(){
        if (XKUtil.isNetWorkAvailable() == false) {
            XKRWCui.showInformationHudWithText("没有网络，请检查网络设置")
            return;
        }
        
        let schemeInfoVC:XKRWChangeSchemeInfoVC = XKRWChangeSchemeInfoVC()
        self.navigationController?.pushViewController(schemeInfoVC, animated: true);
    }
    
    func pressed(sender: UIButton!) {
        let alertView = UIAlertView();
        alertView.addButtonWithTitle("Ok");
        alertView.title = "title";
        alertView.message = "message";
        alertView.show();
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
