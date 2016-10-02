//
//  XKRWThinBodyAssess_5_3VC.swift
//  XKRW
//
//  Created by ss on 16/4/1.
//  Copyright © 2016年 XiKang. All rights reserved.
//

import UIKit

class XKRWThinBodyAssess_5_3VC: XKRWBaseVC,XKRWPlan_5_3ViewDelegate {
 

    var scrollView: UIScrollView!
    var headView: UIView!
    var targetView: UIView!
    var targetSeparateLabel: UILabel!
    var targetLabel: UILabel!
    var targetTimeLabel: UILabel!
    var targetWeightLabel: UILabel!
    
    var fromWhichVC: FromWhichVC?
    var dicData = NSMutableDictionary()
    var isHeavyType : Bool = false
    
    override func viewDidLoad() {
        MobClick.event("pg_plan")
        super.viewDidLoad()
        let labor : XKPhysicalLabor = XKRWUserService.sharedService().getUserLabor()
        isHeavyType = labor == eHeavy ? true : false;
        self.title = "我的瘦身计划"
        self.edgesForExtendedLayout = .All;
        self.automaticallyAdjustsScrollViewInsets = false
        self.addNaviBarLeftButtonWithNormalImageName("back_white", highlightedImageName: "back_p_trans", selector: #selector(popView))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadDataAndReload()
        scrollView.contentOffset = CGPointZero
        let nav : XKRWNavigationController = self.navigationController as! XKRWNavigationController
        nav.navigationBarChangeFromBlackHalfTransNavigationBarToTransparencyNavigationBar()
//        self.navigationController!.setNavigationBarHidden(false, animated: animated)
    }
    
    func targetTime() -> String {
        let planFinishDate = NSDate.today().offsetDay(XKRWAlgolHelper.remainDayToAchieveTargetWithDate(nil))
        let timeStr = String(format:"将于%d年%d月%d日达到",planFinishDate.year,planFinishDate.month,planFinishDate.day)
        return timeStr
    }
    
    func targetWeight() -> String {
        let weight : NSInteger = XKRWUserService.sharedService().getUserDestiWeight()
        let target_weight = CGFloat(weight)/1000.0
        let weightStr = String(format:"%.1fkg",target_weight)
        return weightStr
    }
    
    func initView(){
        scrollView = UIScrollView()
        scrollView.frame = self.view.bounds
        scrollView.contentSize=CGSizeMake(
            UI_SCREEN_WIDTH,2*UI_SCREEN_HEIGHT)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        headView = UIImageView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 100))
        let image : UIImage = UIImage(named:"plan_topImg")!
        headView = UIImageView(image: image)
        headView.layer.masksToBounds = false
        scrollView.addSubview(headView)
        
        targetView = UIView()
        targetView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH - 20, 100)
        targetView.backgroundColor = UIColor.whiteColor()
        targetView.layer.cornerRadius = 6
        targetView.layer.shadowColor = UIColor.blackColor().CGColor
        targetView.layer.shadowOpacity = 0.5
        targetView.layer.shadowOffset = CGSize.zero
        targetView.layer.shadowRadius = 3
        targetView.center = CGPointMake(headView.center.x, headView.frame.size.height)
        
        targetSeparateLabel = UILabel()
        targetSeparateLabel.backgroundColor = UIColor.blackColor()
        
        targetLabel = UILabel()
        targetLabel.text = "按照以下计划执行预计"
        targetLabel.textAlignment = .Right
        targetLabel.textColor = UIColor.blackColor()
        targetLabel.frame.size = CGSizeMake(50, 50)
        
        targetTimeLabel = UILabel()
        targetTimeLabel.textAlignment = .Right
        targetTimeLabel.textColor = UIColor.blackColor()
        targetTimeLabel.frame.size = CGSizeMake(targetView.frame.size.width, 40)
        
        targetWeightLabel = UILabel()
        targetWeightLabel.textColor = UIColor.blackColor()
        targetWeightLabel.font = targetWeightLabel.font.fontWithSize(30)
        targetWeightLabel.frame.size = CGSizeMake(50, 50)
        
    }
    
    func makeMasonryLayout(){
        self.targetSeparateLabel.mas_makeConstraints { (make) in
            make.centerX.mas_equalTo()(self.targetView.mas_centerX).offset()(self.targetView.frame.size.height/2.5)
            make.centerY.mas_equalTo()(self.targetView.mas_centerY)
            make.width.mas_equalTo()(0.5)
            make.height.mas_equalTo()(self.targetView.frame.size.height/2)
            self.targetView.addSubview(self.targetSeparateLabel)
        }
        self.targetLabel.mas_makeConstraints { (make) in
            make.right.mas_equalTo()(self.targetSeparateLabel.mas_left).offset()(-20)
            make.centerY.mas_equalTo()(self.targetView.mas_centerY).offset()(-15)
            make.height.mas_equalTo()(30)
            self.targetView.addSubview(self.targetLabel)
        }
        self.targetTimeLabel.mas_makeConstraints { (make) in
            make.right.mas_equalTo()(self.targetSeparateLabel.mas_left).offset()(-20)
            make.centerY.mas_equalTo()(self.targetView.mas_centerY).offset()(15)
            make.height.mas_equalTo()(30)
            self.targetView.addSubview(self.targetTimeLabel)
        }
        self.targetWeightLabel.mas_makeConstraints { (make) in
            make.left.mas_equalTo()(self.targetSeparateLabel.mas_right).offset()(20)
            make.centerY.mas_equalTo()(self.targetView.mas_centerY)
            make.width.and().height().mas_equalTo()(100)
            self.targetView.addSubview(self.targetWeightLabel)
        }
    }
    
    func loadDataAndReload(){
        //判断是否在5.2重置过
        let date = NSUserDefaults.standardUserDefaults().objectForKey(String(format:"StartTime_%ld",XKRWUserService.sharedService().getUserId()))
        self.initView()
        
        if (date == nil || XKRWAlgolHelper .remainDayToAchieveTargetWithDate(nil) == -1 )
        {
            //未重置过
            targetTimeLabel.text = ""
            var frame = headView.frame
            frame.size.height -= 50
            headView.frame = frame
        }else{
            targetTimeLabel.text = self.targetTime()
            targetWeightLabel.text = self.targetWeight()
        }
        
        self.initHabitData()
        let viewHeight : Int = 450
        let heavyHeight : Int = 200
        let numLines = ceilf(Float(dicData.count)/4)
        var nonHabitHeight : CGFloat = 30
        if numLines == 0 {
            nonHabitHeight = 100
        }
        var btnStartHeight : CGFloat = 0
        if(fromWhichVC != FromWhichVC.MyVC && fromWhichVC != FromWhichVC.PlanVC)
        {
            btnStartHeight = 80
        }
        var scrollContentSize = CGSizeMake(UI_SCREEN_WIDTH, headView.frame.size.height+nonHabitHeight + btnStartHeight)
        
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
                
                if isHeavyType {
                    frame =  CGRectMake(0, CGFloat(index*viewHeight)+headView.frame.size.height, UI_SCREEN_WIDTH, CGFloat(heavyHeight))
                }else{
                    frame = CGRectMake(0, CGFloat(index*viewHeight)+headView.frame.size.height, UI_SCREEN_WIDTH, CGFloat(viewHeight))
                }
                break
            case 2:
                view.dicCollection = dicData
                view.type = .Habit
                view.delegate = self
                if isHeavyType{
                    frame = CGRectMake(0, CGFloat(viewHeight + heavyHeight)+headView.frame.size.height, UI_SCREEN_WIDTH, CGFloat(numLines*100) + 150)
                }else{
                    frame = CGRectMake(0, CGFloat(index*viewHeight)+headView.frame.size.height, UI_SCREEN_WIDTH, CGFloat(numLines*100) + 100)
                }
                break
            default:
                break
            }
            
            view.frame = frame
//            scrollView.addSubview(view)
            scrollContentSize.height += frame.size.height
        }
        
        headView.addSubview(targetView)
        
        if(fromWhichVC == FromWhichVC.MyVC || fromWhichVC == FromWhichVC.PlanVC)
        {
            self.addNaviBarRightButtonWithText("修改计划", action: #selector(XKRWThinBodyAssess_5_3VC.doClickNaviBarRightButton as (XKRWThinBodyAssess_5_3VC) -> () -> ()),withColor: UIColor.whiteColor())
        }else{
            let myFirstButton = UIButton(type:UIButtonType.Custom)
            myFirstButton.setTitle("开始瘦身", forState: .Normal)
            myFirstButton.backgroundColor = XKMainSchemeColor
            myFirstButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            myFirstButton.frame = CGRectMake(15, scrollContentSize.height-80, UI_SCREEN_WIDTH-30, 40)
            myFirstButton.addTarget(self, action: #selector(XKRWThinBodyAssess_5_3VC.pressed(_:)), forControlEvents:UIControlEvents.TouchUpInside)
            
            scrollView.addSubview(myFirstButton)
        }
        scrollView.contentSize = scrollContentSize
        self.makeMasonryLayout()
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
        let nav : XKRWNavigationController = self.navigationController as! XKRWNavigationController
        nav.navigationBarChangeFromTransparencyNavigationBarToDefaultNavigationBar()
        let schemeInfoVC:XKRWChangeSchemeInfoVC = XKRWChangeSchemeInfoVC()
        self.navigationController?.pushViewController(schemeInfoVC, animated: true);
    }
    
    func pressed(sender: UIButton!) {
        MobClick.event("btn_start")
        if (self.navigationController?.tabBarController != nil){
            XKRWLocalNotificationService.shareInstance().registerMetamorphosisTourAlarms()
            XKRWLocalNotificationService.shareInstance().setWeekAnalyzeNotification()
            self.navigationController?.tabBarController?.navigationController?.popToRootViewControllerAnimated(false)
        }else{
            self.navigationController?.popToRootViewControllerAnimated(false);
        }
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
