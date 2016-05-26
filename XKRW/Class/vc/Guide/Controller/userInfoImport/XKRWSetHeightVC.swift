//
//  XKRWSetHeightVC.swift
//  XKRW
//
//  Created by 忘、 on 15/5/29.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWSetHeightVC: XKRWBaseVC,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var pickerViewVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var sexImageView: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var continueButotn: UIButton!
    var sexImage:UIImage?
    var heightTitleArray:NSMutableArray =  NSMutableArray()
    var heightArray:NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        MobClick.event("pg_height")
        self.title = "选择身高"
         self.view.backgroundColor = UIColor.whiteColor()
        self.addNaviBarBackButton()
        pickerView.delegate = self
        pickerView.dataSource = self
        
//        let topLine:UIView = UIView.init(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5))
//        topLine.backgroundColor = XK_ASSIST_LINE_COLOR
//        let bottomLine:UIView = UIView.init(frame: CGRectMake(0, 50.5, UI_SCREEN_WIDTH, 0.5))
//        bottomLine.backgroundColor = XK_ASSIST_LINE_COLOR
//        continueButotn!.addSubview(topLine)
//        continueButotn!.addSubview(bottomLine)
//        continueButotn!.titleLabel?.font = XKDEFAULFONT
//        continueButotn!.setTitleColor(XKMainSchemeColor, forState: UIControlState.Normal)
    
        sexImageView.image = sexImage
        if XKRWUserService.sharedService().getSex().rawValue == eSexMale.rawValue {
            pickerView.selectRow(175-110, inComponent: 0, animated: true)
            heightLabel.text = NSString(format: "%d", 175) as String
        }else{
            pickerView.selectRow(165-110, inComponent: 0, animated: true)
            heightLabel.text = NSString(format: "%d", 165) as String
        }
        
        if(IOS8 == 0 && UI_SCREEN_HEIGHT == 480)
        {
            pickerViewVerticalConstraint.constant = 40
        }
    }
    
    
    func initData(){
        for var i = 0 ; i<=110 ;i++ {
            heightTitleArray.addObject(NSString(format: "%d cm", i+110))
            heightArray.addObject(NSNumber(integer: i+110))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func nextAction(sender: UIButton) {
        
        let selectedRow:Int =  pickerView.selectedRowInComponent(0)
        
        let height:NSNumber = heightArray.objectAtIndex(selectedRow) as! NSNumber
        
        XKRWUserService.sharedService().setUserHeight(height.integerValue)
        
        let setLaborVC =  XKRWLaborVC(nibName: "XKRWLaborVC", bundle: nil)
        self.navigationController?.pushViewController(setLaborVC, animated: true)
    }
    
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let row:Int =   pickerView.selectedRowInComponent(0)
        
        heightLabel.text = NSString(format: "%d", 110+row) as String

    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return heightTitleArray.objectAtIndex(row) as? String
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return heightTitleArray.count
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
