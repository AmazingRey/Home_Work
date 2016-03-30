//
//  XKRWMealSchemeCell.swift
//  XKRW
//
//  Created by XiKang on 15/5/25.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWMealSchemeCell: UITableViewCell {

    @IBOutlet weak var mealLabel: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var button_left: UIButton!
    @IBOutlet weak var button_center: UIButton!
    @IBOutlet weak var button_right: UIButton!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    @IBOutlet weak var arrow: UIImageView!
    
    @IBOutlet weak var sealImageView: UIImageView!
    @IBOutlet weak var pointLine: UIImageView!
    
    @IBOutlet weak var buttonWidth: NSLayoutConstraint!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    
    var schemeEntity: XKRWSchemeEntity_5_0?
    var recordEntity: XKRWRecordSchemeEntity?
    
    var schemeType: XKRWSchemeType?
    var clickAction: ((index: Int, cellType: XKRWSchemeType) -> ())?
    var totalCalorie:Float = 0
    
    var isSealed: Bool = false {
        didSet {
            if isSealed {
                self.sealImageView.alpha = 1
            } else {
                self.sealImageView.alpha = 0.0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.arrow.alpha = 1
        self.buttonWidth.constant = (UI_SCREEN_WIDTH - 20) / 3
        
        if UI_SCREEN_WIDTH > 320 {
            
            self.pointLine.image = UIImage(named: "home_bg_point_6_above")
        }
        
        if UI_SCREEN_WIDTH > 375 {
            self.buttonHeight.constant = 45.3333
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(schemeEntity schemeEntity: XKRWSchemeEntity_5_0?, recordEntity: XKRWRecordSchemeEntity?) {
        
        if schemeEntity != nil {
            self.schemeEntity = schemeEntity!
            
            self.finishLoading(animate: true)
            self.schemeType = schemeEntity!.schemeType
            
            var foodsNameString = " "
//            totalCalorie = 0
            for entitys in (schemeEntity?.foodCategories)! {
                foodsNameString.appendContentsOf(entitys.categoryName)
                foodsNameString.appendContentsOf("+")
//                totalCalorie += Float(entitys.calorie)
            }
            
            //MARK: 卡路里计算
            var ratio = 0.0
            switch self.schemeEntity!.schemeType {
            case .Breakfast:
                ratio = 0.3
            case .Lunch:
                ratio = 0.5
            case .Dinner:
                ratio = 0.2
                
            default:
                break
            }
            let LMax = Int(2200 * ratio)
            let LMin = Int(1800 * ratio)
            let MMin = Int(1400 * ratio)
            let SMin = Int(1200 * ratio)
            
            var mealSize = "";
            let Large = "\(LMin)-\(LMax)kcal"
            let Middle = "\(MMin)-\(LMin)kcal"
            let Small = "\(SMin)-\(MMin)kcal"
            switch self.schemeEntity!.size {
            case 1:
                mealSize = Large
            case 2:
                mealSize = Middle
            case 3:
                mealSize = Small
            default:
                mealSize = Small
            }

            if schemeEntity!.schemeType == .Sport {
                self.type.text = schemeEntity!.schemeName
                //                self.mealLabel.text = schemeEntity!.schemeName
            } else {
                //                self.type.text = XKRWSchemeService_5_0.getDescriptionBySize(schemeEntity!.size)
                self.mealLabel.text = schemeEntity!.schemeName
                self.type.text = mealSize
            }

            foodsNameString.removeAtIndex(foodsNameString.endIndex.predecessor())
            let whiteSpace = NSCharacterSet.whitespaceAndNewlineCharacterSet()
            foodsNameString = foodsNameString.stringByTrimmingCharactersInSet(whiteSpace)
            
            let attributeString = XKRWUtil.createAttributeStringWithString(foodsNameString, font: UIFont.systemFontOfSize(14), color: XK_TITLE_COLOR, lineSpacing: 3.5,alignment: NSTextAlignment.Left)
            attributeString.addAttribute(NSKernAttributeName, value: 0.5, range: NSMakeRange(0, attributeString.length))
            
            self.contentLabel.attributedText = attributeString
            
            if recordEntity != nil {
                self.recordEntity = recordEntity!
                self.setRecordValue(recordEntity!.record_value)
            }
        }
    }
    
    func setRecordValue(value: Int) -> Void {
        
        if value == 0 {
            self.sealImageView.image = nil
            self.setButtonSelecteWithIndex(-1)
            return
        }
        
        let temple = (value, self.schemeType)
        var image: UIImage = UIImage()
        
        switch temple {
        case (2, _):
            image = UIImage(named: "emblem_get")!
            self.setButtonSelecteWithIndex(1)
        case (1, let x):
            if x == .Breakfast {
                image = UIImage(named: "emblem_nobf")!
            } else if x == .Lunch {
                image = UIImage(named: "emblem_nolunchn")!
            } else if x == .Dinner {
                image = UIImage(named: "emblem_nodinner")!
            } else if x == .Sport {
                image = UIImage(named: "emblem_lazy")!
            }
            self.setButtonSelecteWithIndex(0)
        case (3, let x):
            if x == .Sport {
                image = UIImage(named: "emblem_doother")!
            } else {
                image = UIImage(named: "emblem_other")!
            }
            self.setButtonSelecteWithIndex(2)
        case (4, let x):
            
            if x == .Sport {
                image = UIImage(named: "emblem_myself")!
            } else {
                image = UIImage(named: "emblem_toomuch")!
            }
            self.setButtonSelecteWithIndex(2)
        case (5, let x):
            
            if x == .Sport {
                image = UIImage(named: "emblem_myself")!
            } else {
                image = UIImage(named: "emblem_toomuch")!
            }
            self.setButtonSelecteWithIndex(2)
        default:
            break
        }
        self.sealImageView.image = image
        self.sealImageView.alpha = 1.0
    }
    
    func setButtonSelecteWithIndex(index: Int) -> Void {
        
        let array = [button_left, button_center, button_right]
        
        for button in array {
            button.enabled = true
            if button.tag == index {
                button.selected = true
            } else {
                button.selected = false
            }
        }
    }
    
    func setType(schemeType: XKRWSchemeType, clickAction: (index: Int, cellType: XKRWSchemeType) -> ()) -> Void {
        
        self.schemeType = schemeType
        self.clickAction = clickAction
        
        if(UI_SCREEN_WIDTH == 320)
        {
            self.button_right.setImage(UIImage(named: "home_btn_mark_640"), forState: UIControlState.Normal)
            self.button_right.setImage(UIImage(named: "home_btn_mark_p_640"), forState: UIControlState.Selected)

        }else{
            self.button_right.setImage(UIImage(named: "home_btn_mark_"), forState: UIControlState.Normal)
            self.button_right.setImage(UIImage(named: "home_btn_mark_p_"), forState: UIControlState.Selected)
        }
        
        if(UI_SCREEN_WIDTH == 320)
        {
            self.button_center.setImage(UIImage(named: "home_btn_perfect_640"), forState: UIControlState.Normal)
            self.button_center.setImage(UIImage(named: "home_btn_perfect_p_640"), forState: UIControlState.Selected)
            
        }else{
            self.button_center.setImage(UIImage(named: "home_btn_perfect"), forState: UIControlState.Normal)
            self.button_center.setImage(UIImage(named: "home_btn_perfect_p"), forState: UIControlState.Selected)
        }

        
        
        switch schemeType {
            
        case .Breakfast:
            self.mealLabel.text = "早餐"
            if(UI_SCREEN_WIDTH == 320){
                self.button_left.setImage(UIImage(named: "home_btn_breakfast_640"), forState: UIControlState.Normal)
                self.button_left.setImage(UIImage(named: "home_btn_breakfast_p_640"), forState: UIControlState.Selected)
            }else{
                self.button_left.setImage(UIImage(named: "home_btn_breakfast"), forState: UIControlState.Normal)
                self.button_left.setImage(UIImage(named: "home_btn_breakfast_p"), forState: UIControlState.Selected)
            }
        case .Lunch:
            self.mealLabel.text = "午餐"
            if(UI_SCREEN_WIDTH == 320){
                self.button_left.setImage(UIImage(named: "home_btn_lunch_640"), forState: UIControlState.Normal)
                self.button_left.setImage(UIImage(named: "home_btn_lunch_p_640"), forState: UIControlState.Selected)
            }else{
                self.button_left.setImage(UIImage(named: "home_btn_lunch"), forState: UIControlState.Normal)
                self.button_left.setImage(UIImage(named: "home_btn_lunch_p"), forState: UIControlState.Selected)
            }
        case .Dinner:
            self.mealLabel.text = "晚餐"
            if(UI_SCREEN_WIDTH == 320){
                self.button_left.setImage(UIImage(named: "home_btn_dinner_640"), forState: UIControlState.Normal)
                self.button_left.setImage(UIImage(named: "home_btn_dinner_640_p"), forState: UIControlState.Selected)
            }else{
            self.button_left.setImage(UIImage(named: "home_btn_dinner"), forState: UIControlState.Normal)
            self.button_left.setImage(UIImage(named: "home_btn_dinner_p"), forState: UIControlState.Selected)
            }
        case .Sport:
            self.mealLabel.text = "运动"
            if(UI_SCREEN_WIDTH == 320){
                self.button_left.setImage(UIImage(named: "home_btn_laze_640"), forState: UIControlState.Normal)
                self.button_left.setImage(UIImage(named: "home_btn_laze_640_p"), forState: UIControlState.Selected)
                
//                self.button_right.setImage(UIImage(named: "home_btn_myself_640"), forState: UIControlState.Normal)
//                self.button_right.setImage(UIImage(named: "home_btn_myself_p_640"), forState: UIControlState.Selected)
                
            }else{
                self.button_left.setImage(UIImage(named: "home_btn_laze"), forState: UIControlState.Normal)
                self.button_left.setImage(UIImage(named: "home_btn_laze_p"), forState: UIControlState.Selected)
                
//                self.button_right.setImage(UIImage(named: "home_btn_myself"), forState: UIControlState.Normal)
//                self.button_right.setImage(UIImage(named: "home_btn_myself_p"), forState: UIControlState.Selected)
            }
        default:
            break
        }
    }
    
    func loading(animate animate: Bool) -> Void {
        
        if self.indicator.isAnimating() {
            return
        }
        self.indicator.startAnimating()
//        self.arrow.alpha = 0.1
        
        var duration = 0.0
        if animate {
            duration = 0.15
        }
        UIView.animateWithDuration(duration, animations: { () -> Void in
            
            self.contentLabel.alpha = 0.01
            
            }, completion: { (finished) -> Void in
                
                self.contentLabel.text = "载入中..."
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    self.contentLabel.alpha = 1
                })
        })
        button_left.enabled = false
        button_center.enabled = false
        button_right.enabled = false
    }
    
    func finishLoading(animate animate: Bool) -> Void {
        
        if !self.indicator.isAnimating() {
            return
        }
        
        self.indicator.stopAnimating()
        
        var duration = 0.0
        if animate {
            duration = 0.15
        }
        UIView.animateWithDuration(duration, animations: { () -> Void in
            
            self.contentLabel.alpha = 0.01
            self.arrow.alpha = 1
            
            }, completion: { (finished) -> Void in
                
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    self.contentLabel.alpha = 1
                })
        })
        
        button_left.enabled = true
        button_center.enabled = true
        button_right.enabled = true
    }
    
    @IBAction func clickIndex0(sender: AnyObject) {
        
        if(NSUserDefaults.standardUserDefaults().boolForKey("needResetScheme_\(XKRWUserService.sharedService().getUserId())"))
        {
            XKRWCui.showInformationHudWithText("当前方案已结束，请重置方案！")
            return
        }
        
        if (sender as! UIButton).selected == true {
            return
        }
        button_left.selected = true
        button_center.selected = false
        button_right.selected = false
        
        if self.clickAction != nil {
            self.clickAction!(index: 0, cellType: self.schemeType!)
        }
    }

    @IBAction func clickIndex1(sender: AnyObject) {
        if(NSUserDefaults.standardUserDefaults().boolForKey("needResetScheme_\(XKRWUserService.sharedService().getUserId())"))
        {
            XKRWCui.showInformationHudWithText("当前方案已结束，请重置方案！")
            return
        }
        if (sender as! UIButton).selected == true {
            return
        }
        button_left.selected = false
        button_center.selected = true
        button_right.selected = false
        if self.clickAction != nil {
            self.clickAction!(index: 1, cellType: self.schemeType!)
        }
    }
    @IBAction func clickIndex2(sender: AnyObject) {
//        if (sender as! UIButton).selected == true {
//            return
//        }
        if(NSUserDefaults.standardUserDefaults().boolForKey("needResetScheme_\(XKRWUserService.sharedService().getUserId())"))
        {
            XKRWCui.showInformationHudWithText("当前方案已结束，请重置方案！")
            return
        }
        button_left.selected = false
        button_center.selected = false
        button_right.selected = true
        if self.clickAction != nil {
            self.clickAction!(index: 2, cellType: self.schemeType!)
        }
    }
}
