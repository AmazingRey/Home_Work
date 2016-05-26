//
//  XKRWGetUserCityVC.swift
//  XKRW
//
//  Created by 忘、 on 15/6/16.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWGetUserCityVC: XKRWBaseVC,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var pickerViewVerticalConstraint: NSLayoutConstraint!
    var provience:NSArray = NSArray()
    var city:NSArray = NSArray()
    var pid = 0
    var cid = 0
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        MobClick.event("pg_region")
        self.title = "所在城市"
        self.view.backgroundColor = UIColor.whiteColor()
        self.addNaviBarBackButton()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        if(IOS8 == 0 && UI_SCREEN_HEIGHT == 480)
        {
            pickerViewVerticalConstraint.constant = 0
        }
        
        self.initCityData()
    }
    
    func initCityData(){
        pid = 1
        provience = XKRWCityControlService.shareService().getPorvience()
        
        city = XKRWCityControlService.shareService().getCityWithPrivence(pid)
        if(city.count != 0){
            cid = city.objectAtIndex(0).objectForKey("id") as! NSInteger
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 2
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if component == 0{
            return provience.count
        }else{
            return city.count
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (component == 0){
            let dic:NSDictionary = provience.objectAtIndex(row) as! NSDictionary
            return dic.objectForKey("name") as? String
            }else{
            let dic:NSDictionary = city.objectAtIndex(row) as! NSDictionary
            return dic.objectForKey("name") as? String
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0){
            let dic:NSDictionary = provience.objectAtIndex(row) as! NSDictionary
            pid = dic.objectForKey("id") as! NSInteger
            city = XKRWCityControlService.shareService().getCityWithPrivence(pid)
            cid = city.objectAtIndex(0).objectForKey("id") as! NSInteger
            pickerView.reloadAllComponents()
        }else{
            cid = city.objectAtIndex(row).objectForKey("id") as! NSInteger
        }
    }
    

    @IBAction func nextAction(sender: UIButton) {
        XKRWUserService.sharedService().setUserCity(NSString(format: "%d,%d,0", pid,cid) as String)
        XKRWUserService.sharedService().saveUserInfo()
        XKRWCui.showProgressHud()
        self.saveUserInfoToRemoteServer()
    }
    
    
    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {
        XKRWCui.hideProgressHud()
        if(taskID == "saveUserInfoToRemoteServer")
        {
            XKRWUserService.sharedService().saveUserInfo()
            let meal_ratio:NSDictionary = ["meal_ratio":["breakfast":30,"lunch":40,"supper":10,"snack":20]];
            NSUserDefaults.standardUserDefaults().setObject(meal_ratio.objectForKey("meal_ratio"), forKey: NSString(format: "meal_ratio_%ld",XKRWUserService.sharedService().getUserId()) as String)
            NSUserDefaults.standardUserDefaults().synchronize()
            self.setSchemeStartData()
        }
        
        if(taskID == "saveSchemeStartData"){
            /**设置预期天数*/
            let time = result["data"]
            XKRWAlgolHelper.setExpectDayOfAchieveTarget(XKRWUserService.sharedService().getUserOrigWeight(), andStartTime: time)
            let  thinAssesssVC:XKRWThinBodyAssess_5_3VC = XKRWThinBodyAssess_5_3VC(nibName: "XKRWThinBodyAssess_5_3VC", bundle: nil)
            self.navigationController?.pushViewController(thinAssesssVC, animated: true)
        }
        
    }
    
    override func handleDownloadProblem(problem: AnyObject!, withTaskID taskID: String!) {
        XKRWCui.hideProgressHud()
        if(taskID == "saveUserInfoToRemoteServer")
        {
//            println("保存用户信息失败")
        }
    }
    
    
    override func shouldRespondForDefaultNotificationForDetailName(detailName: String!) -> Bool {
        return true
    }
    

    
    
    //保存用户信息到远程服务器
    func saveUserInfoToRemoteServer(){
        
        let questionString:NSString = XKRWFatReasonService .sharedService().getFatReasonFromDB()
        let sex  = XKRWUserService.sharedService().getSex()
        let birthday = XKRWUserService.sharedService().getBirthdayString()
        let height = XKRWUserService.sharedService().getUserHeight()
        let labor = XKRWUserService.sharedService().getUserLabor()
        
        //新版服务器这边是KG
        let weight = XKRWUserService.sharedService().getUserOrigWeight()
        
        let targetWeight = XKRWUserService.sharedService().getUserDestiWeight()
        
        let userweight:Float = Float(weight)/1000
        let userTargetWeight:Float = Float(targetWeight)/1000
        
        //为了兼容 安卓的版本   以下为设置的默认值
        let address = XKRWUserService.sharedService().getCityAreaString()
        
        XKRWUserService.sharedService().defaultSetPlanCount()
        
        let solutionDifficulty:XKDifficulty = XKRWUserService.sharedService().getUserPlanDifficulty()
        let group = eGroupOther
        let slimPart = "1,2,3,4,5,6"
        

        let slim_plan:NSDictionary = ["meal_ratio":["breakfast":30,"lunch":40,"supper":10,"snack":20],
            "degree":NSNumber(unsignedInt: solutionDifficulty.rawValue),
            "target_weight":userTargetWeight,
            "part":slimPart]
        
        let data:NSDictionary = ["address":address,
            "birthday":birthday,
            "height":height,
            "slim_plan": slim_plan,
            "slim_qa":questionString,
            "labor_level":NSNumber(unsignedInt:labor.rawValue),
            "weight":userweight,
            "gender":NSNumber(unsignedInt:sex.rawValue),
            "crowd_type":NSNumber(int: group.rawValue)
        ]
        
        let dataJson:NSData = try! NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions.PrettyPrinted)
        
        let dataString:NSString = NSString(data: dataJson, encoding: NSUTF8StringEncoding)!
        
        let paramers = ["data": dataString]
        
        self.downloadWithTaskID("saveUserInfoToRemoteServer", outputTask: { () -> AnyObject! in
            // If comes from reset all data, it should check today's weight record, if exists, change it to new original weight
            XKRWRecordService4_0.sharedService().resetCurrentUserWeight(Float(Float(weight) / 1000.0))
            
            // save user info to remote
            return XKRWUserService.sharedService().saveUserInfoToRemoteServer(paramers as [NSObject : AnyObject])
        })
        
        
        
    }
    
    
    func setSchemeStartData(){
        if(XKRWUtil.isNetWorkAvailable()){
            self.downloadWithTaskID("saveSchemeStartData") { () -> AnyObject! in
                return XKRWUserService.sharedService().setSchemeStartData()
            }
        }else{
            XKRWCui.showInformationHudWithText("请检查网络后尝试")
        }
       
    }
    
    
    func getFatReason(entity:XKRWFatReasonEntity)->NSString{
        
        return NSString(format: "%d_%d_%d",entity.question,entity.answer,entity.type)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
