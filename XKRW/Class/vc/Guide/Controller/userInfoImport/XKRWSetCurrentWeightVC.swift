//
//  XKRWSetCurrentWeightVC.swift
//  XKRW
//
//  Created by 忘、 on 15/5/29.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWSetCurrentWeightVC: XKRWBaseVC,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var pickerViewVerticalConstraint: NSLayoutConstraint!
    var kilogramArray = NSMutableArray()  //整数数组
    var decimalsArray = NSMutableArray()  //小数数组
    
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "当前体重"
        MobClick.event("pg_wt")
        
//        let topLine:UIView = UIView.init(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5))
//        topLine.backgroundColor = XK_ASSIST_LINE_COLOR
//        let bottomLine:UIView = UIView.init(frame: CGRectMake(0, 50.5, UI_SCREEN_WIDTH, 0.5))
//        bottomLine.backgroundColor = XK_ASSIST_LINE_COLOR
//        nextButton!.setTitleColor(XKMainSchemeColor, forState: UIControlState.Normal)
//        nextButton!.addSubview(topLine)
//        nextButton!.addSubview(bottomLine)
//        nextButton!.titleLabel?.font = XKDEFAULFONT
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.addNaviBarBackButton()
        pickerView.delegate = self;
        pickerView.dataSource = self;
        
        for  var i = 0; i<=180;i += 1 {
            kilogramArray.addObject(NSString(format: "%d",i+20))
        }
        
        for i in 0  ..< 10 {
            decimalsArray.addObject(NSString(format: "%d", i))
        }
        
        let sex:XKSex  =  XKRWUserService.sharedService().getSex()
        if sex.rawValue == eSexMale.rawValue {
            pickerView.selectRow(60, inComponent: 0, animated: true)
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }else{
            pickerView.selectRow(40, inComponent: 0, animated: true)
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }
        
        if(IOS8 == 0 && UI_SCREEN_HEIGHT == 480)
        {
            pickerViewVerticalConstraint.constant = 0
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 2
    }
    

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        switch component{
        case 0:
            return kilogramArray.count
        default:
            return decimalsArray.count
        }
    }
    

    @IBAction func nextAction(sender: UIButton) {
        
        XKRWUserService.sharedService().setUserOrigWeight(self.getWeight())
        XKRWUserService.sharedService().setCurrentWeight(self.getWeight())
        
        let setTargetWeight =  XKRWTargetWeightVC(nibName: "XKRWTargetWeightVC", bundle: nil)
        self.navigationController?.pushViewController(setTargetWeight, animated: true)
    }
    
    
    func getWeight()->NSInteger{
        let row1 =  pickerView.selectedRowInComponent(0)
        let row2 =  pickerView.selectedRowInComponent(1)
        
       return  kilogramArray.objectAtIndex(row1).integerValue*1000 + decimalsArray.objectAtIndex(row2).integerValue*100
        
    
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
