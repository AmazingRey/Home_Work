//
//  XKRWSetAgeVC.swift
//  XKRW
//
//  Created by 忘、 on 15/5/29.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWSetAgeVC: XKRWBaseVC {
    
    var userAge:NSString?
   

    @IBOutlet weak var pickerViewVerticelConstraint: NSLayoutConstraint!
    @IBOutlet weak var sexImageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.calendar = NSCalendar.init(calendarIdentifier: NSGregorianCalendar)
        self.title = "出生日期"
        
//        let topLine:UIView = UIView.init(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5))
//        topLine.backgroundColor = XK_ASSIST_LINE_COLOR
//        let bottomLine:UIView = UIView.init(frame: CGRectMake(0, 50.5, UI_SCREEN_WIDTH, 0.5))
//        bottomLine.backgroundColor = XK_ASSIST_LINE_COLOR
//        nextButton!.setTitleColor(XKMainSchemeColor, forState: UIControlState.Normal)
//        nextButton!.addSubview(topLine)
//        nextButton!.addSubview(bottomLine)
        nextButton!.titleLabel?.font = XKDEFAULFONT
        
        MobClick.event("in_RgstBirth")
         self.view.backgroundColor = UIColor.whiteColor()
        self.addNaviBarBackButton()
        if XKRWUserService.sharedService().getSex().rawValue == eSexMale.rawValue{
            sexImageView.image = UIImage(named: "lead_gg_640×1136_")
        }else{
            sexImageView.image = UIImage(named: "lead_mm_640×1136_")
        }
        
        let now:NSDate = NSDate()
        ageLabel.text = NSString(format: "%d", now.year-1990) as String
        
        self.setMinAndMaxFatAge()
        datePicker.date = self.getCustomDate(1990, month: 1, day: 1, hour: 0, min: 0, sec: 0)
        for view in datePicker.subviews{
            if view.isKindOfClass(UIPickerView) {
                view.transform = CGAffineTransformMakeScale(1.35, 1.2);
            }
        }
        let dateFormat:NSDateFormatter = NSDateFormatter()
        dateFormat.calendar = NSCalendar.init(calendarIdentifier: NSGregorianCalendar)
        dateFormat.dateFormat = "yyyy-MM-dd"
        let theDate:String = dateFormat.stringFromDate( datePicker.date)
        userAge = theDate
        
        if(IOS8 == 0 && UI_SCREEN_HEIGHT == 480)
        {
            pickerViewVerticelConstraint.constant = 40
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //设置可以减肥的最大最小年龄  可以减肥的年龄范围是从7~70岁
    func setMinAndMaxFatAge(){
        let now:NSDate = NSDate()
        let maxYear = now.year-7
        let minYear = now.year-70
        
        datePicker.minimumDate = getCustomDate(minYear, month: now.month, day: now.day, hour: 0, min: 0, sec: 0)
        datePicker.maximumDate = getCustomDate(maxYear, month: now.month, day: now.day, hour: 0, min: 0, sec: 0)
    
    }
    
    //根据年月日  时分秒获取date
    func getCustomDate(year:NSInteger,month:NSInteger,day:NSInteger,hour:NSInteger,min:NSInteger,sec:NSInteger)->NSDate{
        let components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = min
        components.second = sec
        
        let gregorian = NSCalendar.init(calendarIdentifier: NSGregorianCalendar)!
        let date = gregorian.dateFromComponents(components)
        return date!
    }

    
    @IBAction func datePickerAction(sender: UIDatePicker) {
        let now:NSDate = NSDate()
        let selectDate:NSDate = datePicker.date;
        
        let dateFormat:NSDateFormatter = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        dateFormat.calendar = NSCalendar.init(calendarIdentifier: NSGregorianCalendar)
        let theDate:String = dateFormat.stringFromDate(selectDate)
        userAge = theDate
        
        ageLabel.text = NSString(format: "%d", now.year - selectDate.year) as String
    
    }
    
    @IBAction func nextAction(sender: UIButton) {
        
        let dateFormat:NSDateFormatter = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        dateFormat.calendar = NSCalendar.init(calendarIdentifier: NSGregorianCalendar)
        if userAge != nil && userAge?.length > 0 {
            
            let date:NSDate =  dateFormat.dateFromString(userAge as! String)!
            let time:NSInteger  = NSInteger(date.timeIntervalSince1970)
            
            XKRWUserService.sharedService().setBirthday(time)
            XKRWUserService.sharedService().setAge()
            let setHeightVC:XKRWSetHeightVC =  XKRWSetHeightVC(nibName: "XKRWSetHeightVC", bundle: nil)
            setHeightVC.sexImage = sexImageView.image
            self.navigationController?.pushViewController(setHeightVC, animated: true)
        }
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
