//
//  XKRWTargetWeightVC.swift
//  XKRW
//
//  Created by 忘、 on 15/5/29.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit



class XKRWTargetWeightVC: XKRWBaseVC,UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    @IBOutlet weak var viewVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickerViewVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var weightDescriptionLabel: UILabel!
    @IBOutlet weak var showLabel: UILabel!
    @IBOutlet weak var weightLineConstraint: NSLayoutConstraint!
    @IBOutlet weak var highestLocationConstraint: NSLayoutConstraint!
    @IBOutlet weak var lowestLocationConstraint: NSLayoutConstraint!
    @IBOutlet weak var weightLocationConstraint: NSLayoutConstraint!
    @IBOutlet weak var highestWeightLabel: UILabel!
    @IBOutlet weak var lowestWeightLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var targetWeightLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    var kilogramArray = NSMutableArray()  //整数数组
    var decimalsArray = NSMutableArray()  //小数数组
    var bmiEnity:XKRWBMIEntity?
    
    
    var minStageKilogram:Int?  //阶段体重最低值 整数
    
    
    var healthKilogram:Int?   //健康体重最低值的整数
    var overKilogram:Int?  //健康体重最高值的整数
    var highestKilogram:Int? //目标体重最高值的整数
    
     var minStagedecimals:Int?  //阶段体重最低值 小数
    var healthdecimals:Int?   //健康体重最低值的小数
    var overdecimals:Int?     //健康体重最高值的小数
    var highestdecimals:Int?  //目标体重最高值的小数
    
    var overWeight:Int?     //健康体重的最高值
    var healthWeigth:Int?   //健康体重的最低值
    
    var stateWightMin:Int?  //阶段体重最少值
    
    var sex:XKSex! = XKRWUserService.sharedService().getSex()
    var age:NSInteger! = XKRWUserService.sharedService().getAge()
    //    var highestWeight:Int?  //目标体重最高值
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.addNaviBarBackButton()

        
        if(UI_SCREEN_HEIGHT == 480){
            weightLineConstraint.constant = 120
        }
        
        let height:NSInteger = XKRWUserService.sharedService().getUserHeight()
        
        bmiEnity = XKRWAlgolHelper.calcBMIInfoWithSex(sex, age: age, andHeight: height)
        overWeight = bmiEnity?.overWeight   //健康体重最高值
        healthWeigth = bmiEnity?.healthyWeight  //健康体重最低值

        let statewight = XKRWUserService.sharedService().getUserOrigWeight() - (Int)(((98 * (XKRWAlgolHelper.dailyIntakEnergyOfOrigin() - XKRWAlgolHelper.dailyIntakeRecomEnergyOfOrigin() + XKRWAlgolHelper.dailyConsumeSportEnergyOfOrigin())/7700.0))*1000)
        
        stateWightMin = statewight <= healthWeigth ? healthWeigth :statewight
        
        
        if(XKRWUserService.sharedService().getUserOrigWeight() >= healthWeigth)
        {
            MobClick.event("in_RgstGoal")
            self.title = "目标体重"
            weightDescriptionLabel.text = "目标体重"
            showLabel.hidden = true
            if(IOS8 == 0 && UI_SCREEN_HEIGHT == 480)
            {
                pickerViewVerticalConstraint.constant = 35
            }
        }else{
            MobClick.event("in_NoNeed")
            self.title = "偏瘦"
            pickerView.hidden = true
            weightDescriptionLabel.text = "当前体重"
            nextButton.setTitle("返回重新填写", forState: UIControlState.Normal)
            if(IOS8 == 0 && UI_SCREEN_HEIGHT == 480)
            {
                viewVerticalConstraint.constant = 35
            }
        }
        
        
        highestKilogram = XKRWUserService.sharedService().getUserOrigWeight()/1000
        highestdecimals = XKRWUserService.sharedService().getUserOrigWeight()/100 - highestKilogram!*10
        
        
        if (overWeight != nil){
            highestWeightLabel.text = NSString(format: "%.1fkg", Double(overWeight!)/1000) as String
            overKilogram = overWeight!/1000
            overdecimals = overWeight!/100 - overKilogram!*10
        }
        
        if (healthWeigth != nil){
            lowestWeightLabel.text = NSString(format: "%.1fkg", Double(healthWeigth!)/1000) as String
            healthKilogram = healthWeigth!/1000
            healthdecimals = overWeight!/100 - healthKilogram!*10
        }
        
        
        if (stateWightMin != nil){
            minStageKilogram = stateWightMin!/1000
            minStagedecimals = stateWightMin!/100 - stateWightMin!*10
        }
        
        if(highestKilogram != nil && minStageKilogram != nil){
            
            for i in 0 ... highestKilogram!-minStageKilogram! {
                kilogramArray.addObject(NSString(format: "%d",i+minStageKilogram!))
            }
        }
        
        for i in 0  ..< 10 {
            decimalsArray.addObject(NSString(format: "%d", i))
        }
        
        lowestLocationConstraint.constant = (UI_SCREEN_WIDTH-60)/4+30-25
        highestLocationConstraint.constant = (UI_SCREEN_WIDTH-60)/4*2+30-25
        
        if(XKRWUserService.sharedService().getUserOrigWeight() > self.getWeightFromBMI(XKRWUserService.sharedService().getBMIFromAge(age, andSex: sex, andBMItype: BMIType.eStandard), userHeight: XKRWUserService.sharedService().getUserHeight())){
            self.setTargetWeightlocation(self.getWeightBMI(stateWightMin!))
            self.setDefaultLocationAndDefaultTargetweight()
        }else{
            let BMI =  self.getWeightBMI(XKRWUserService.sharedService().getUserOrigWeight())
            self.setTargetWeightlocation(BMI)
            targetWeightLabel.text = NSString(format: "%d.%d", XKRWUserService.sharedService().getUserOrigWeight()/1000,XKRWUserService.sharedService().getUserOrigWeight()/100-XKRWUserService.sharedService().getUserOrigWeight()/1000*10) as String
        }
        
     
       let alert = UIAlertView(title: "设置阶段减重目标", message: "开启分阶段减重目标，请选择当前阶段的减重目标", delegate: nil, cancelButtonTitle: "知道了")
        
        alert .show()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextAction(sender: UIButton) {
        
        if(XKRWUserService.sharedService().getUserOrigWeight() >= healthWeigth)
        {
            
            if(self.getWeight() < stateWightMin ){
                if((stateWightMin) != nil){
                    XKRWUserService.sharedService().setUserDestiWeight(stateWightMin!)
                }
            }else if(self.getWeight() > XKRWUserService.sharedService().getUserOrigWeight()){
                
                XKRWUserService.sharedService().setUserDestiWeight(XKRWUserService.sharedService().getUserOrigWeight())
                
            }else{
                XKRWUserService.sharedService().setUserDestiWeight(self.getWeight())
            }
            
           
            
            let  cityVC:XKRWGetUserCityVC = XKRWGetUserCityVC(nibName: "XKRWGetUserCityVC", bundle: nil)
            self.navigationController?.pushViewController(cityVC, animated: true)
        }else{
            MobClick.event("clk_NoNeedBack")
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component{
        case 0:
            return kilogramArray.objectAtIndex(row) as? String
        default:
            let decimals:NSString = decimalsArray.objectAtIndex(row) as! NSString
            return NSString(format: ".%@  kg",  decimals) as String
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(self.getWeight() < stateWightMin){
            XKRWCui.showInformationHudWithText("不能低于阶段体重最低值")
            let BMI:CGFloat =   self.getWeightBMI(self.getWeight())
            self.setTargetWeightlocation(BMI)
            targetWeightLabel.text = NSString(format: "%.1fKg", Double(stateWightMin!)/1000) as String
        }else if (self.getWeight() > XKRWUserService.sharedService().getUserOrigWeight() ){
            XKRWCui.showInformationHudWithText("不能增肥哦")
            targetWeightLabel.text = NSString(format: "%.1fKg", Double(XKRWUserService.sharedService().getUserOrigWeight())/1000) as String
            let BMI:CGFloat = self.getWeightBMI(XKRWUserService.sharedService().getUserOrigWeight())
            self.setTargetWeightlocation(BMI)
        }else{
            targetWeightLabel.text = NSString(format: "%d.%dKg",kilogramArray.objectAtIndex(pickerView.selectedRowInComponent(0)).integerValue, decimalsArray.objectAtIndex(pickerView.selectedRowInComponent(1)).integerValue) as String
            
            let BMI:CGFloat =   self.getWeightBMI(self.getWeight())
            self.setTargetWeightlocation(BMI)
        }
        
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 2
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        switch component{
        case 0:
            return kilogramArray.count
        default:
            return decimalsArray.count
        }
        
    }
    
    
    func getWeight()->NSInteger{
        let row1 =  pickerView.selectedRowInComponent(0)
        let row2 =  pickerView.selectedRowInComponent(1)
        
        return  kilogramArray.objectAtIndex(row1).integerValue*1000 + decimalsArray.objectAtIndex(row2).integerValue*100
    }
    
    
    //设置目标体重 图标位置
    func setTargetWeightlocation(bmi:CGFloat){
        if(bmi < 13){
            weightLocationConstraint.constant = 30 + 37/2
        }else if(bmi > 35){
            weightLocationConstraint.constant = UI_SCREEN_WIDTH-30 + 37/2
        }else{
            
            let lowestBMI =  XKRWUserService.sharedService().getBMIFromAge(age, andSex: sex, andBMItype: BMIType.eLowest)
            
            let highestBMI = XKRWUserService.sharedService().getBMIFromAge(age, andSex: sex, andBMItype: BMIType.eHighest)
            
            if(bmi <= lowestBMI)
            {
                weightLocationConstraint.constant =  (bmi-13)/(lowestBMI-13)*(UI_SCREEN_WIDTH-60)/4 + 37/2 ;
            }else if(bmi >= lowestBMI && bmi < highestBMI)
            {
                weightLocationConstraint.constant =  (bmi - lowestBMI)/(highestBMI-lowestBMI)*(UI_SCREEN_WIDTH-60)/4 + 37/2 +  (UI_SCREEN_WIDTH-60)/4 ;
            }else{
                weightLocationConstraint.constant =  (bmi-highestBMI)/(35-highestBMI)*(UI_SCREEN_WIDTH-60)/4 + 37/2 + (UI_SCREEN_WIDTH-60)/2;
            }
            
        }
    }
    
    //获取目标体重时的BMI
    func getWeightBMI(Weight:NSInteger)->CGFloat{
        let weight:CGFloat = CGFloat(Weight)/1000
        let height:CGFloat = CGFloat(XKRWUserService.sharedService().getUserHeight())/100
        return weight/(height*height)
    }
    
    //通过bmi 获取用户体重
    func getWeightFromBMI(bmi:CGFloat,userHeight:NSInteger)->NSInteger{
        return Int(bmi*CGFloat(userHeight)*CGFloat(userHeight)/10000*1000)
    }
    
    
    //设置默认的目标体重位置与默认的目标体重
    func setDefaultLocationAndDefaultTargetweight(){
//        let defaultWeight = self.getWeightFromBMI(XKRWUserService.sharedService().getBMIFromAge(age, andSex: sex, andBMItype: BMIType.eStandard), userHeight: XKRWUserService.sharedService().getUserHeight())
//
        let defaultWeightRow1 = stateWightMin!/1000 - minStageKilogram!
        let defaultWeightRow2 = stateWightMin!/100 - stateWightMin!/1000*10
        
        pickerView.selectRow(defaultWeightRow1, inComponent: 0, animated: true)
        pickerView.selectRow(defaultWeightRow2, inComponent: 1, animated: true)
        
        targetWeightLabel.text = NSString(format: "%d.%dKg",stateWightMin!/1000, stateWightMin!/100-stateWightMin!/1000*10) as String
    }
    
  

    
}
