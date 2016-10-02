//
//  XKRWSetVC.swift
//  XKRW
//
//  Created by 忘、 on 15/9/18.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWSetVC: XKRWBaseVC,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate {

    @IBOutlet weak var setTableView: UITableView!
    
    var dataArray = [NSArray]()
    var cache:UInt64 = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        self.initView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setTableView.reloadData()
    }
    
    func initData(){
        dataArray = [["提醒开关"],["隐私密码"],["体脂率自动填写"],["缓存","帮助与反馈"],["一分钟了解减肥","投票支持","关于"],["退出登录"]];
        cache = SDImageCache.sharedImageCache().getSize()
    }
    
    
    func initView(){
        self.addNaviBarBackButton()
        self.title = "设置"
        setTableView.dataSource = self
        setTableView.delegate = self
        setTableView.rowHeight = 44.0
        setTableView.separatorStyle = .None
        setTableView.backgroundColor = UIColor.clearColor()
        
     
        
        //   添加退出按钮
//        let btn:UIButton = UIButton(type: .Custom)
//        btn.frame = CGRectMake(UI_SCREEN_WIDTH / 2 - 125, 25, 250.0, 40.0);
//        btn.addTarget(self, action: "exitTheAccount", forControlEvents: .TouchUpInside)
//        btn.setBackgroundImage(UIImage(named: "buttonRed"), forState:.Normal)
//        btn.setTitle("退出登录", forState:.Normal)
//        btn.setTitleColor(UIColor.whiteColor(), forState:.Normal)
//        btn.titleLabel?.font = XKDefaultFontWithSize(16)
//        btn.layer.cornerRadius = 4.0;
        
//        let footerView:UIView = UIView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 75))
//        footerView.backgroundColor = UIColor.clearColor()
//        footerView.addSubview(btn)
//        
//        setTableView.tableFooterView = footerView
    }
    
    // MARK:   -TableViewDelegate TableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            var switchCell:XKRWSwitchCell? = tableView.dequeueReusableCellWithIdentifier("switchCell") as? XKRWSwitchCell
            if(switchCell == nil){
                switchCell = XKRWSwitchCell.init(style:.Default, reuseIdentifier: "switchCell")
            }
            
            switchCell?.selectionStyle = .None
            switchCell!.label.text = dataArray[indexPath.section][indexPath.row] as? String
            switchCell!.passwordSwithBtn.addTarget(self, action: #selector(XKRWSetVC.closeAllAlertValueChanged(_:)), forControlEvents: .TouchUpInside)
            if(XKRWLocalNotificationService.shareInstance().haveEnabledNotice()){
                switchCell!.passwordSwithBtn.setOn(true, animated: true)
            }else{
                switchCell!.passwordSwithBtn.setOn(false, animated: true)
            }
            switchCell!.upLineView.hidden = false
            switchCell!.downLineView.hidden = false
            return switchCell!
        }
        else if(indexPath.section == 1){
            var privacyPasswordCell:XKRWSwitchCell? = tableView.dequeueReusableCellWithIdentifier("privacyPasswordCell") as? XKRWSwitchCell
            if(privacyPasswordCell == nil){
                privacyPasswordCell = XKRWSwitchCell.init(style:.Default, reuseIdentifier: "privacyPasswordCell")
            }
            
            privacyPasswordCell?.selectionStyle = .None
            privacyPasswordCell!.label.text = dataArray[indexPath.section][indexPath.row] as? String
            privacyPasswordCell!.passwordSwithBtn.addTarget(self, action: #selector(XKRWSetVC.swichPrivacyPassword(_:)), forControlEvents: .ValueChanged)
            
            if XKRWUserDefaultService.getPrivacyPassword() == nil{
                privacyPasswordCell!.passwordSwithBtn.setOn(false, animated: true)
            }else{
                privacyPasswordCell!.passwordSwithBtn.setOn(true, animated: true)
            }
            privacyPasswordCell!.upLineView.hidden = false
            privacyPasswordCell!.downLineView.hidden = false
            return privacyPasswordCell!
            
        } else if(indexPath.section == 2){
            var fatRateSettingcell:XKRWNoImageCommonCell? = tableView.dequeueReusableCellWithIdentifier("fatRateSettingcell") as? XKRWNoImageCommonCell
            if(fatRateSettingcell == nil){
                fatRateSettingcell = XKRWNoImageCommonCell.init(style: .Default, reuseIdentifier: "fatRateSettingcell")
                fatRateSettingcell!.titleLabel.font = XKDefaultFontWithSize(16);
                fatRateSettingcell!.titleLabel.textColor = XK_TEXT_COLOR;
            }
            
            fatRateSettingcell!.titleLabel.text = dataArray[indexPath.section][0] as? String;
            fatRateSettingcell!.upLineView.hidden = true
            fatRateSettingcell!.downLineView.hidden = false
            fatRateSettingcell?.descriptionLabel.text = XKRWAlgolHelper.isSetFatRateWriteAuto() ? "开启" : "关闭";

            return fatRateSettingcell!
            
        } else if(indexPath.section == 3){
            if(indexPath.row == 0){
                var cacheCell:XKRWCacheCell? = tableView.dequeueReusableCellWithIdentifier("catchCell") as? XKRWCacheCell
                if(cacheCell == nil){
                    cacheCell = XKRWCacheCell.init(style: .Default, reuseIdentifier: "catchCell")
                    cacheCell!.selectionStyle = .None
                    cacheCell!.clearCacheBtn.addTarget(self, action:#selector(XKRWSetVC.clickClearCacheBtn(_:)), forControlEvents:.TouchUpInside);
                }

                var cacheStr:String?
                if(Float(cache)/1024.0 > 1.0 && Float(cache)/1024.0/1024.0 < 102.4){
                    let cacheNum =  Float(cache)/1024.0
                    cacheStr = NSString(format: "%.1fKB", cacheNum) as String
                }else if(Float(cache)/1024.0/1024.0 >= 102.4){
                    let cacheNum =  Float(cache)/1024.0/1024.0
                    cacheStr = NSString(format: "%.1fM", cacheNum) as String
                }
                
                cacheCell!.cacheLabel.text = cacheStr
                
                if(cacheStr == nil || cacheStr?.characters.count == 0 )
                {
                    cacheCell?.clearCacheBtn.hidden = true
                }else{
                    cacheCell?.clearCacheBtn.hidden = false
                }
                return cacheCell!
            }else{
                var feedbackCell:XKRWFeedbackCell? = tableView.dequeueReusableCellWithIdentifier("feedbackCell") as?  XKRWFeedbackCell
                if(feedbackCell == nil){
                    feedbackCell = XKRWFeedbackCell.init(style: .Default, reuseIdentifier: "feedbackCell")
                }
                feedbackCell?.upLineView.hidden = true
                feedbackCell?.downLineView.hidden = false
                
                if(XKRWUserDefaultService.isShowMoreredDot()){
                    feedbackCell?.moreRedDotView.hidden = false
                }else{
                    feedbackCell?.moreRedDotView.hidden = true
                }
                return feedbackCell!
            }
        }else if(indexPath.section == 5){
            var feedbackCell:XKRWNoImageCommonCell? = tableView.dequeueReusableCellWithIdentifier("commonCell") as?  XKRWNoImageCommonCell
            let loginOut:UILabel = UILabel.init()
            
            if(feedbackCell == nil){
                feedbackCell = XKRWNoImageCommonCell.init(style: .Default, reuseIdentifier: "commonCell")
                feedbackCell!.titleLabel.hidden = true
                feedbackCell!.rightImg.hidden = true
                feedbackCell!.upLineView.hidden = false
            }
            loginOut.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, feedbackCell!.height);
            loginOut.textAlignment = .Center;
            loginOut.textColor = UIColor.redColor();
            loginOut.text = "退出登录";
            loginOut.font = XKDefaultFontWithSize(16);
            feedbackCell!.addSubview(loginOut)
            return feedbackCell!
            
        }else {
            var commonCell:XKRWNoImageCommonCell? = tableView.dequeueReusableCellWithIdentifier("commonCell") as? XKRWNoImageCommonCell
            if(commonCell == nil){
                commonCell = XKRWNoImageCommonCell.init(style: .Default, reuseIdentifier: "commonCell")
                commonCell!.titleLabel.font = XKDefaultFontWithSize(16);
                commonCell!.titleLabel.textColor = XK_TEXT_COLOR;
            }
            
            commonCell!.titleLabel.text = dataArray[indexPath.section][indexPath.row] as? String;

            if(indexPath.row == 0){
                commonCell!.upLineView.hidden = false
            }
            commonCell!.downLineView.hidden = false
            
            return commonCell!
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 2 {
            let fatRateSetVC:XKRWFatRateSetVC = XKRWFatRateSetVC()
            self.navigationController?.pushViewController(fatRateSetVC, animated: true)
            
        } else if(indexPath.section == 3){
            if(indexPath.row == 1){
                let feedbackVC:XKRWUserFeedbackVC = XKRWUserFeedbackVC(nibName:"XKRWUserFeedbackVC", bundle: nil)
                self.navigationController?.pushViewController(feedbackVC, animated: true)
            }
        }else if(indexPath.section == 4){
            if(indexPath.row == 0){
                MobClick.event("in_RptOneMin")

                let oneMinVC:XKRWOneMinUndLoseFat = XKRWOneMinUndLoseFat(nibName:"XKRWOneMinUndLoseFat",bundle:nil)
                oneMinVC.hidesBottomBarWhenPushed = true;
                oneMinVC.setFromWhichVC(.MyVC);
                self.navigationController?.pushViewController(oneMinVC, animated: true)
                
            }else if(indexPath.row == 1){
                UIApplication.sharedApplication().openURL(NSURL(string: STR_APPSTORE_URL_IOS7 as String)!)
                
            } else {
                let aboutVC:XKRWAboutVC = XKRWAboutVC()
                 self.navigationController?.pushViewController(aboutVC, animated: true)
            }
        }else if(indexPath.section == 5){
        
            self.exitTheAccount();
        }
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3{
            return 20
        }
        return 10.0
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:UIView = UIView.init(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 10))
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    
    //TODO:  Action
    
    func clickClearCacheBtn(button:UIButton)->(){
        
        SDImageCache.sharedImageCache().clearDisk()
        XKRWCommHelper.cleanCache()
        NSUserDefaults.standardUserDefaults().removeObjectForKey("RecommendAppListRefresh")
        XKRWCui.showInformationHudWithText("清除成功")
        cache = 0
        setTableView .reloadData()
    }
    
    func swichPrivacyPassword(swtch:UISwitch) -> () {
        let privacyPasswordVC : XKRWPrivacyPassWordVC = XKRWPrivacyPassWordVC(nibName: "XKRWPrivacyPassWordVC" , bundle: nil)
        privacyPasswordVC.privacyType = swtch.on ? .configue : .terminate
        self.navigationController?.pushViewController(privacyPasswordVC, animated: true)
    }

    func closeAllAlertValueChanged(_switch:UISwitch)->(){
        let alartArray:NSMutableArray =  XKRWLocalNotificationService.shareInstance().getAllNotice()
        
        if(alartArray.count == 0){
            XKRWCui.showInformationHudWithText("未设置提醒")
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.35 * CGFloat(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                    _switch.on = true
            }
            return
        }
        
        if(_switch.on != true){
            for i in 0..<alartArray.count {
                let entity:XKRWAlarmEntity = alartArray[i] as! XKRWAlarmEntity
                entity.enabled = 0
            }
        }else{
            for i in 0..<alartArray.count {
                let entity:XKRWAlarmEntity = alartArray[i] as! XKRWAlarmEntity
                entity.enabled = 1
            }
        }
        let isSuccess:Bool = XKRWLocalNotificationService.shareInstance().updateNotice(alartArray as [AnyObject])
        if (isSuccess) {
            XKRWCui.showInformationHudWithText("保存成功")
            NSNotificationCenter.defaultCenter().postNotificationName("SCHEME_RELOAD_NOTICE", object: nil)
        }else{
            XKRWCui.showInformationHudWithText("保存失败")
        }
    }
    
    func exitTheAccount(){
        MobClick.event("clk_LogOut")
        if(XKRWUserService.sharedService().checkSyncData()) {
            let actionSheet = UIActionSheet(title: "你还有数据未同步", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "取消同步并退出")
            actionSheet.tag = actionSheet.addButtonWithTitle("同步")
            actionSheet.showInView(self.view)
        }else{
           self.logOut()
        }
    }
    
    func logOut(){
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "DailyIntakeSize")
        NSUserDefaults.standardUserDefaults().synchronize()
        NSNotificationCenter.defaultCenter().postNotificationName("Exit", object: nil)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        if (buttonIndex == actionSheet.tag) {
            self.commitTheData()
            
        } else if(buttonIndex == actionSheet.destructiveButtonIndex) {
            self.logOut()
        }
    }
    
    func commitTheData()  {
        guard XKRWUtil.isNetWorkAvailable() else {
            XKRWCui.showInformationHudWithText("没有网络，请检查网络")
            return
        }
        
        self.uploadWithTask({ () -> Void in
            if(XKRWCommHelper .syncDataToRemote()){
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    XKRWCui.showInformationHudWithText("数据同步完成")
                })
                self.logOut()
            }else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    XKRWCui.showInformationHudWithText("同步失败")
                })
            }
        }, message: "数据同步中...")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller!.
    }
    */

}
