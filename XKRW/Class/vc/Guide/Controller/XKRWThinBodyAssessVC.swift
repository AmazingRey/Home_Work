//
//  XKRWThinBodyAssessVC.swift
//  XKRW
//
//  Created by 忘、 on 15/5/29.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWThinBodyAssessVC: XKRWBaseVC {
    
    var fromWhichVC:FromWhichVC?
    var dietTipView:Tips?
    var sportTipView:Tips?
    var habitTipView:Tips?

    @IBOutlet weak var describeLabel: UILabel!
    @IBOutlet weak var sportBackgroundView: UIView!
    @IBOutlet weak var dietBackgroundView: UIView!

    @IBOutlet weak var imageRightConstraint: NSLayoutConstraint!
 
    @IBOutlet weak var imageLeftConstraint: NSLayoutConstraint!
  
    @IBOutlet weak var changeHabitView: UIView!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var sexImage: UIImageView!
    @IBOutlet weak var lossWeight: UILabel!
    @IBOutlet weak var lossTime: UILabel!
    @IBOutlet weak var intakeCal: UILabel!
    @IBOutlet weak var sportCal: UILabel!

    @IBOutlet weak var BMILabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var sportDetailLabel: NZLabel!
    @IBOutlet weak var dietDetailLabel: NZLabel!
 


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.addNaviBarBackButton()
        self.title = "我的瘦身评估"
        
        MobClick.event("in_SlimDiag")
        
        self.setViewUpAndDownLine()
        
        let topLine:UIView = UIView.init(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5))
        topLine.backgroundColor = XK_ASSIST_LINE_COLOR
        let bottomLine:UIView = UIView.init(frame: CGRectMake(0, 50.5, UI_SCREEN_WIDTH, 0.5))
        bottomLine.backgroundColor = XK_ASSIST_LINE_COLOR
        nextButton!.addSubview(topLine)
        nextButton!.addSubview(bottomLine)
        nextButton!.titleLabel?.font = XKDEFAULFONT
    
        
        if(fromWhichVC == FromWhichVC.MyVC)
        {
            nextButton.hidden = true
            describeLabel.hidden = true
            let rightNaviBarButton:UIButton = UIButton(type: UIButtonType.Custom)
            rightNaviBarButton.setTitle("修改方案", forState: UIControlState.Normal)
            rightNaviBarButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            rightNaviBarButton.setTitleColor(XKGrayDefaultColor, forState: .Highlighted)
            rightNaviBarButton.titleLabel!.font = UIFont.systemFontOfSize(14)
            rightNaviBarButton.frame = CGRectMake(0, 0, 60, 20)
            rightNaviBarButton.addTarget(self, action: "doClickNaviBarRightButton", forControlEvents:UIControlEvents.TouchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNaviBarButton)
        }
         scrollView.contentSize =  CGSizeMake(UI_SCREEN_WIDTH, 830)
        
        if(UI_SCREEN_WIDTH == 320){
            imageLeftConstraint.constant = 48
            imageRightConstraint.constant = 30
        }
        
        dietBackgroundView.layer.masksToBounds = true
        dietBackgroundView.layer.cornerRadius = 2.5
        dietBackgroundView.backgroundColor = XK_BACKGROUND_COLOR
        
        sportBackgroundView.layer.masksToBounds = true
        sportBackgroundView.layer.cornerRadius = 2.5
        sportBackgroundView.backgroundColor = XK_BACKGROUND_COLOR
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setUserData()
        
        if(NSUserDefaults.standardUserDefaults().objectForKey(DailyIntakeSize) != nil)
        {
            let dailyIntake:Float =  NSUserDefaults.standardUserDefaults().objectForKey(DailyIntakeSize)!.floatValue
            let nowDailyIntake:Float = XKRWAlgolHelper.dailyIntakeRecomEnergy()
            
            let answer =   XKRWUserService.sharedService().isNeedChangeScheme(dailyIntake, andNowDailyIntake: nowDailyIntake)
            if(answer){
                let alertView =   UIAlertView(title: "您已进入新的减重阶段，可获取新方案", message: "请到“方案”页面的食谱和运动方案中，点击“换一组”获取新方案", delegate: nil, cancelButtonTitle: "知道了")
                alertView.show()
            }
        }
    }
    
    func setUserData(){
        if(XKRWUserService.sharedService().getSex().rawValue == eSexMale.rawValue )
        {
            sexImage.image = UIImage(named:"male_640")
        }else{
            sexImage.image = UIImage(named:"female_640")
        }
        lossWeight.text = NSString(format: "%.1fkg", Float(XKRWUserService.sharedService().getUserOrigWeight() - XKRWUserService.sharedService().getUserDestiWeight())/1000) as String;
        
        BMILabel.text =  NSString(format: "%.2f", self.getWeightBMI(XKRWUserService.sharedService().getUserOrigWeight())) as String
        
        lossTime.text = NSString(format: "%d天", XKRWAlgolHelper.dayOfAchieveTarget()) as String
        
        intakeCal.text = XKRWAlgolHelper.getDailyIntakeSize()
        
        if(self.getWeightBMI(XKRWUserService.sharedService().getUserOrigWeight()) < XKRWUserService.sharedService().getBMIFromAge(XKRWUserService.sharedService().getAge(), andSex: XKRWUserService.sharedService().getSex(), andBMItype: BMIType.eLowest))
        {
            stateLabel.text = "偏瘦";

        }else if(self.getWeightBMI(XKRWUserService.sharedService().getUserOrigWeight()) > XKRWUserService.sharedService().getBMIFromAge(XKRWUserService.sharedService().getAge(), andSex: XKRWUserService.sharedService().getSex(), andBMItype: BMIType.eHighest)){
            stateLabel.text = "偏胖";

        }else{
            stateLabel.text = "正常";
       
        }
        
        
        if(Int(XKRWAlgolHelper.dailyConsumeSportEnergy()) == 0)
        {
            sportCal.text = "0kcal"
        }else
        {
            sportCal.text =  NSString(format: "%dkcal", Int(XKRWAlgolHelper.dailyConsumeSportEnergy())) as String
        }

        
        dietDetailLabel.attributedText =  XKRWUtil.createAttributeStringWithString(XKRWAlgolHelper.getDailyIntakeTipsContent(), font:XKDefaultFontWithSize(12), color: XK_ASSIST_TEXT_COLOR, lineSpacing: 4,alignment: NSTextAlignment.Left)
        
        dietDetailLabel.setFontColor(XK_MAIN_TONE_COLOR, string:XKRWAlgolHelper.getDailyIntakeSize())
        
        sportDetailLabel.attributedText = XKRWUtil.createAttributeStringWithString(XKRWAlgolHelper.getSportTipsContent(sportCal.text), font:XKDefaultFontWithSize(12), color: XK_ASSIST_TEXT_COLOR, lineSpacing: 4,alignment: NSTextAlignment.Left)
        
        sportDetailLabel.setFontColor(XK_MAIN_TONE_COLOR, string:sportCal.text)
    
    }
    
 
    @IBAction func changeHabitAction(sender: UIButton) {
        
        self .changeHabit()
    }
    
    func changeHabit(){
        let fatReasonReviewVC = XKRWFatReasonReviewVC(nibName:"XKRWFatReasonReviewVC", bundle: nil)
        fatReasonReviewVC.setFromWhichVC(FromWhichVC.AssessmentReport)
        self.navigationController?.pushViewController(fatReasonReviewVC, animated: true)
    
    }
    
    @IBAction func nextAction(sender: UIButton) {
        MobClick.event("clk_Start")
        if (self.navigationController?.tabBarController != nil){
            XKRWSchemeNotificationService.shareService().registerLocalNotification()
            self.navigationController?.tabBarController?.navigationController?.popToRootViewControllerAnimated(false)
        }else{
            self.navigationController?.popToRootViewControllerAnimated(false);
        }
    }
    
    //获取目标体重时的BMI
    func getWeightBMI(Weight:NSInteger)->CGFloat{
        let weight:CGFloat = CGFloat(Weight)/1000
        let height:CGFloat = CGFloat(XKRWUserService.sharedService().getUserHeight())/100
        return weight/(height*height)
    }
    
    func setViewUpAndDownLine(){
        XKRWUtil.addViewUpLineAndDownLine(changeHabitView, andUpLineHidden: false, downLineHidden: false)
    }
    
    
    func doClickNaviBarRightButton(){
        if (XKUtil.isNetWorkAvailable() == false) {
            XKRWCui.showInformationHudWithText("没有网络，请检查网络设置")
            return;
        }
        
        let schemeInfoVC:XKRWChangeSchemeInfoVC = XKRWChangeSchemeInfoVC()
        self.navigationController?.pushViewController(schemeInfoVC, animated: true);
    }
    
    
    func setFromWhichVC(type:FromWhichVC){
        fromWhichVC = type
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func getLossWeek()->NSInteger{
//        let day = XKRWAlgolHelper.dayOfAchieveTarget()
//        return day/7 + 1
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
