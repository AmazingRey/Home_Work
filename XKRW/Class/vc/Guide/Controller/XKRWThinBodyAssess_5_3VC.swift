//
//  XKRWThinBodyAssess_5_3VC.swift
//  XKRW
//
//  Created by ss on 16/4/1.
//  Copyright © 2016年 XiKang. All rights reserved.
//

import UIKit

class XKRWThinBodyAssess_5_3VC: XKRWBaseVC,XKRWPlan_5_3ViewDelegate {
 

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var headLabel: UILabel!
    
    var fromWhichVC: FromWhichVC?
    var dicData = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的瘦身计划"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadDataAndReload()
        scrollView.contentOffset = CGPointZero
        
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
    }
    
    func loadDataAndReload(){
        self.initHabitData()
        let viewHeight : Int = 450
        let numLines = ceilf(Float(dicData.count)/4)
        var nonHabitHeight : CGFloat = 30
        if numLines == 0 {
            nonHabitHeight = 100;
        }
        
        scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, headView.frame.size.height+CGFloat(viewHeight)*2+CGFloat(numLines*180)+nonHabitHeight)
        var frame = CGRectZero
        
        for view in scrollView.subviews {
            if view.isKindOfClass(XKRWPlan_5_3View) {
                view.removeFromSuperview()
            }
        }
        
        for index in 0...2 {
            let view = loadViewFromBundle("XKRWPlan_5_3View", owner: self) as! XKRWPlan_5_3View
            switch index {
            case 0:
                view.type = .Food
                frame = CGRectMake(0, CGFloat(index*viewHeight)+headView.frame.size.height, UI_SCREEN_WIDTH, CGFloat(viewHeight))
                break
            case 1:
                view.type = .Sport
                frame = CGRectMake(0, CGFloat(index*viewHeight)+headView.frame.size.height, UI_SCREEN_WIDTH, CGFloat(viewHeight))
                break
            case 2:
                view.dicCollection = dicData
                view.type = .Habit
                view.delegate = self
                frame = CGRectMake(0, CGFloat(index*viewHeight)+headView.frame.size.height, UI_SCREEN_WIDTH, CGFloat(numLines*180))
                break
            default:
                break
            }
            
            view.frame = frame
            //            view.layoutIfNeeded()
            scrollView.addSubview(view)
        }
        if(fromWhichVC == FromWhichVC.MyVC)
        {
            self.addNaviBarRightButtonWithText("修改方案", action: #selector(XKRWThinBodyAssess_5_3VC.doClickNaviBarRightButton as (XKRWThinBodyAssess_5_3VC) -> () -> ()))
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
    func tapCollectionView() {
        let fatReasonVC = XKRWFoundFatReasonVC(nibName:"XKRWFoundFatReasonVC", bundle:nil)
        fatReasonVC.fromWhichVC = FromWhichVC.ThinBodyAssesssVC
        navigationController?.pushViewController(fatReasonVC, animated: true)
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
    
    func initHabitData(){
        let questionArray:NSArray = XKRWFatReasonService.sharedService().getQuestionAnswer();
        dicData.removeAllObjects()
        for i in 0  ..< questionArray.count  {
            let entity:XKRWFatReasonEntity = questionArray.objectAtIndex(i) as! XKRWFatReasonEntity
            let reason = XKRWFatReasonService.sharedService().getReasonDescriptionWithID(entity.question, andAID: entity.answer)
            
            let arrKeys : NSArray = dicData.allKeys
            switch reason{
            case 1:
                if(!arrKeys.containsObject("饮食油腻")){
                    dicData.setObject("habit_ic_oily_p_", forKey: "饮食油腻")
                }
            case 2:
                if(!arrKeys.containsObject("吃零食")){
                    dicData.setObject("habit_ic_snacks_p_", forKey: "吃零食")
                }
            case 3:
                if(!arrKeys.containsObject("喝饮料")){
                    dicData.setObject("habit_ic_drink_p_", forKey: "喝饮料")
                }
            case 4...6:
                if(!arrKeys.containsObject("饮酒")){
                    dicData.setObject("habit_ic_alcohol_p_", forKey: "饮酒")
                }
            case 7:
                if(!arrKeys.containsObject("吃肥肉")){
                    dicData.setObject("habit_ic_fat_p_", forKey: "吃肥肉")
                }
            case 8:
                if(!arrKeys.containsObject("吃坚果")){
                    dicData.setObject("habit_ic_nut_p_", forKey: "吃坚果")
                }
            case 9:
                if(!arrKeys.containsObject("吃宵夜")){
                    dicData.setObject("habit_ic_nightsnack_p_", forKey: "吃宵夜")
                }
            case 10:
                if(!arrKeys.containsObject("吃饭晚")){
                    dicData.setObject("habit_ic_late_p_", forKey: "吃饭晚")
                }
            case 11:
                if(!arrKeys.containsObject("吃饭快")){
                    dicData.setObject("habit_ic_fast_p_", forKey: "吃饭快")
                }
            case 12:
                if(!arrKeys.containsObject("饭量时多时少")){
                    dicData.setObject("habit_ic_inordinate_p_", forKey: "饭量时多时少")
                }
            case 13:
                if(!arrKeys.containsObject("活动量少")){
                    dicData.setObject("habit_ic_hypomotility_p_", forKey: "活动量少")
                }
            case 14:
                if(!arrKeys.containsObject("缺乏锻炼")){
                    dicData.setObject("habit_ic_littlepractice_p_", forKey: "缺乏锻炼")
                }
            default:
                break
                //                    println("习惯很好，不需要改善")
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
