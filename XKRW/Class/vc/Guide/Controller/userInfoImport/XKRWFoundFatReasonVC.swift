//
//  XKRWFoundFatReasonVC.swift
//  XKRW
//
//  Created by 忘、 on 15/5/28.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWFoundFatReasonVC: XKRWBaseVC {
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var spaceRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var spaceConstraint: NSLayoutConstraint!
    var fromWhichVC:FromWhichVC?
    var userfatReasonNoSet:Bool = false
    var rightNaviButton: UIButton!
    var originalfatReason:NSMutableArray = NSMutableArray()
    
    var fatReason:NSMutableArray = NSMutableArray()
    
    
    //    override func viewWillAppear(animated: Bool) {
    //        super.viewWillAppear(animated)
    //        self.navigationController?.setNavigationBarHidden(false, animated: true)
    //    }
    
    override func viewDidLoad() {
        MobClick.event("pg_scanwhyfat")
        
        self.forbidAutoAddPopButton = true
        super.viewDidLoad()
        
        // hide back button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
        
        if(fromWhichVC == FromWhichVC.SchemeInfoChangeVC)
        {
            self.addNaviBarBackButton()
            self.addNaviBarRightButtonWithText("保存", action: #selector(XKRWFoundFatReasonVC.rightNaviBarButtonClicked),withColor: XKMainSchemeColor)
            nextButton.hidden = true
        }else if(fromWhichVC == FromWhichVC.ThinBodyAssesssVC){
            self.addNaviBarBackButton()
            nextButton.hidden = true
        }else{
            nextButton.hidden = false
            UIBarButtonItem.appearance().setTitlePositionAdjustment(UIOffsetMake(0, -100), forBarMetrics: UIBarMetrics.Default)
        }
        self.title = "找出肥胖原因"
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        let fatReasonStr:NSString =  XKRWFatReasonService.sharedService().getFatReasonFromDB() as String
        self.initFatReasonButtonSelectStyle(fatReasonStr)
        
        originalfatReason = NSMutableArray(array: fatReasonStr.componentsSeparatedByString(";"))
        
        
        if(originalfatReason.count==0 || originalfatReason == ["1_5_1","7_13_1","8_18_1","9_21_1"]){
            nextButton.setTitle("以上都没有", forState: UIControlState.Normal)
        }else{
            if(fromWhichVC == FromWhichVC.SchemeInfoChangeVC){
                nextButton.setTitle("保存", forState: UIControlState.Normal)
            }else{
                nextButton.setTitle("继续", forState: UIControlState.Normal)
            }
        }
        
        if(UI_SCREEN_WIDTH == 375){
            spaceConstraint.constant = 25;
            spaceRightConstraint.constant = 25;
        }else if(UI_SCREEN_WIDTH == 414 ){
            spaceConstraint.constant = 32;
            spaceRightConstraint.constant = 32;
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //下一步
    @IBAction func nextAction(sender: UIButton) {
        self.rightNaviBarButtonClicked()
    }
    
    func rightNaviBarButtonClicked(){
        
        if(fatReason.count == 0 ){
            fatReason = ["1_5_1","7_13_1","8_18_1","9_21_1"];
        }else{
            self.checkFatReasonAndPerfectFatReason()
        }
        
        if(XKRWUtil.isNetWorkAvailable()){
            XKRWCui.showProgressHud()
            
            self.downloadWithTaskID("saveFatReason", task: { () -> Void in
                XKRWFatReasonService .sharedService().saveFatReasonToDB(self.fatReason as [AnyObject], andUserId: XKRWUserService.sharedService().getUserId(), andSync: 0);
                XKRWFatReasonService .sharedService().saveFatReasonToRemoteServer()
                
            })
        }else{
            XKRWCui.showInformationHudWithText("网络错误，请稍后再试")
        }
    }
    
    //选择与取消肥胖原因
    @IBAction func selectFatReason(sender: UIButton) {
        
        switch sender.tag{
        case 1001:
            self.setButtonSelectStateAndSetFatReason("7_9_1")
            self.setButtonSelectStateAndSetFatReason("1_1_1")
        case 1002:
            self.setButtonSelectStateAndSetFatReason("7_11_1")
            self.setButtonSelectStateAndSetFatReason("1_2_1")
        case 1003:
            self.setButtonSelectStateAndSetFatReason("2_5_0")
            self.setButtonSelectStateAndSetFatReason("1_4_1")
        case 1004:
            self.setButtonSelectStateAndSetFatReason("6_4_0")
            self.setButtonSelectStateAndSetFatReason("1_3_1")
        case 1007:
            self.setButtonSelectStateAndSetFatReason("7_10_1")
        case 1008:
            self.setButtonSelectStateAndSetFatReason("7_12_1")
        case 1009:
            self.setButtonSelectStateAndSetFatReason("8_14_1")
        case 1010:
            self.setButtonSelectStateAndSetFatReason("8_15_1")
        case 1011:
            self.setButtonSelectStateAndSetFatReason("8_16_1")
        case 1012:
            self.setButtonSelectStateAndSetFatReason("8_17_1")
        case 1013:
            self.setButtonSelectStateAndSetFatReason("9_19_1")
        case 1014:
            self.setButtonSelectStateAndSetFatReason("9_20_1")
        default:
            break
        }
        sender.selected =  !sender.selected
        
        if(fatReason.count==0 || fatReason == ["1_5_1","7_13_1","8_18_1","9_21_1"]){
            nextButton.setTitle("以上都没有", forState: UIControlState.Normal)
        }else{
            if(fromWhichVC == FromWhichVC.SchemeInfoChangeVC){
                nextButton.setTitle("保存", forState: UIControlState.Normal)
            }else{
                nextButton.setTitle("继续", forState: UIControlState.Normal)
            }
        }
        
        //        println(fatReason)
    }
    
    func setButtonSelectStateAndSetFatReason(fat:NSString){
        if(fatReason.containsObject(fat)){
            fatReason.removeObject(fat)
        }else{
            fatReason.addObject(fat)
        }
    }
    
    func setFromWhichVC(type:FromWhichVC){
        fromWhichVC = type
    }
    
    
    func initFatReasonButtonSelectStyle(fatReasonString:NSString){
        let fatReasonArray:NSArray =  fatReasonString.componentsSeparatedByString(";") as NSArray
        
        for  i in 0  ..< contentView.subviews.count  {
            let view: AnyObject = contentView.subviews[i]
            
            
            if let btn = view as? UIButton {
                
                switch btn.tag{
                case 1001:
                    if(fatReasonArray.containsObject("7_9_1")||fatReasonArray.containsObject("1_1_1")){
                        
                        self.selectFatReason(btn)
                    }
                case 1002:
                    if(fatReasonArray.containsObject("7_11_1")||fatReasonArray.containsObject("1_2_1")){
                        
                        self.selectFatReason(btn)
                    }
                case 1003:
                    if(fatReasonArray.containsObject("2_5_0")||fatReasonArray.containsObject("1_4_1")){
                        
                        self.selectFatReason(btn)
                    }
                case 1004:
                    if(fatReasonArray.containsObject("6_4_0")||fatReasonArray.containsObject("1_3_1")){
                        
                        self.selectFatReason(btn)
                    }
                case 1007:
                    if(fatReasonArray.containsObject("7_10_1")){
                        
                        self.selectFatReason(btn)
                    }
                case 1008:
                    if(fatReasonArray.containsObject("7_12_1")){
                        
                        self.selectFatReason(btn)
                    }
                case 1009:
                    if(fatReasonArray.containsObject("8_14_1")){
                        
                        self.selectFatReason(btn)
                    }
                case 1010:
                    if(fatReasonArray.containsObject("8_15_1")){
                        
                        self.selectFatReason(btn)
                    }
                case 1011:
                    if(fatReasonArray.containsObject("8_16_1")){
                        
                        self.selectFatReason(btn)
                    }
                case 1012:
                    if(fatReasonArray.containsObject("8_17_1")){
                        
                        self.selectFatReason(btn)
                    }
                case 1013:
                    if(fatReasonArray.containsObject("9_19_1")){
                        
                        self.selectFatReason(btn)
                    }
                case 1014:
                    if(fatReasonArray.containsObject("9_20_1")){
                        self.selectFatReason(btn)
                    }
                    
                default:
                    break
                }
                
            }
            
            
            
        }
    }
    
    
    func checkFatReasonAndPerfectFatReason(){
        if(!fatReason.containsObject("1_1_1") && !fatReason.containsObject("1_2_1") && !fatReason.containsObject("1_4_1") && !fatReason.containsObject("1_3_1")){
            fatReason.addObject("1_5_1")
        }
        
        if(!fatReason.containsObject("7_11_1") && !fatReason.containsObject("7_9_1") && !fatReason.containsObject("7_10_1") && !fatReason.containsObject("7_12_1")){
            fatReason.addObject("7_13_1")
        }
        
        
        if(!fatReason.containsObject("8_14_1") && !fatReason.containsObject("8_15_1") && !fatReason.containsObject("8_16_1") && !fatReason.containsObject("8_17_1")){
            fatReason.addObject("8_18_1")
        }
        
        
        if(!fatReason.containsObject("9_19_1") && !fatReason.containsObject("9_20_1")){
            fatReason.addObject("9_21_1")
        }
    }
    
    
    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {
        XKRWCui.hideProgressHud()
        if(taskID == "saveFatReason")
        {
            XKRWFatReasonService .sharedService().saveFatReasonToDB(fatReason as [AnyObject], andUserId: XKRWUserService.sharedService().getUserId(), andSync: 1);
            XKRWRecordService4_0.sharedService().deleteTodaysRecord_4_0FatReseans()
    
            if((!userfatReasonNoSet)){
                NSNotificationCenter.defaultCenter().postNotificationName(EnergyCircleDataNotificationName, object: nil)
                
            }
            
            if(fromWhichVC == FromWhichVC.SchemeInfoChangeVC)
            {
                self.navigationController?.popViewControllerAnimated(true)
            }
            else{
                let analyzeVC = XKRWFatReasonReviewVC(nibName:"XKRWFatReasonReviewVC", bundle: nil)
                self.navigationController?.pushViewController(analyzeVC, animated: true)
            }
        }
    }
    
    override func handleDownloadProblem(problem: AnyObject!, withTaskID taskID: String!) {
        XKRWCui.hideProgressHud()
        super.handleDownloadProblem(problem, withTaskID: taskID)
    }
    
    override func shouldRespondForDefaultNotificationForDetailName(detailName: String!) -> Bool {
        return true
    }
}



