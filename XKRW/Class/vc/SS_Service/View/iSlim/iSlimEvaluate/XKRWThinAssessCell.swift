//
//  XKRWThinAssessCell.swift
//  XKRW
//
//  Created by XiKang on 15/5/13.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWThinAssessCell: UITableViewCell {
    
    @IBOutlet weak var stepFourView: UIView!
    @IBOutlet weak var heightOfStepFour: NSLayoutConstraint!
    
    @IBOutlet weak var stepFourImageView: UIImageView!
    
    func loadText(islimModel: XKRWIslimModel) {
        
        var yPoint = stepFourImageView.bottom + 10
        
        yPoint += 30
        var hasHabit = false
        
        if islimModel.habitModel.reduceCalArray != nil {
            
            for descModel in islimModel.habitModel.reduceCalArray {
                
                if !hasHabit {
                    hasHabit = true
                }
                
                let titleText = descModel.result as String
                
                let titleLabel: UILabel = UILabel(frame: CGRectMake(15, yPoint, UI_SCREEN_WIDTH - 30, 20))
                yPoint += 30
                
                titleLabel.text = titleText
                titleLabel.font = UIFont.systemFontOfSize(14)
                titleLabel.textColor = XKMainSchemeColor
                
                self.stepFourView.addSubview(titleLabel)
                
                let descText: NSAttributedString = XKRWUtil.createAttributeStringWithString(self.getDetailTextBy(titleText), font: UIFont.systemFontOfSize(14), color: XK_TEXT_COLOR, lineSpacing: 3.5,alignment: NSTextAlignment.Left)
                let descSize = descText.boundingRectWithSize(CGSizeMake(UI_SCREEN_WIDTH - 30, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
                
                let descLabel: UILabel = UILabel(frame: CGRectMake(15, yPoint, UI_SCREEN_WIDTH - 30, descSize.height))
                yPoint += descSize.height + 15
                
                descLabel.attributedText = descText
                descLabel.numberOfLines = 0
                
                self.stepFourView.addSubview(descLabel)
            }
        }
        
        
        
        if islimModel.habitModel.bodyConsumeArray != nil {
            
            for descModel in islimModel.habitModel.bodyConsumeArray {
                
                if !hasHabit {
                    hasHabit = true
                }
                
                let titleText = descModel.result as String
                
                let titleLabel: UILabel = UILabel(frame: CGRectMake(15, yPoint, UI_SCREEN_WIDTH - 30, 20))
                yPoint += 30
                
                titleLabel.text = titleText
                titleLabel.font = UIFont.systemFontOfSize(14)
                titleLabel.textColor = XKMainSchemeColor
                
                self.stepFourView.addSubview(titleLabel)
                
                let descText: NSAttributedString = XKRWUtil.createAttributeStringWithString(self.getDetailTextBy(titleText), font: UIFont.systemFontOfSize(14), color: XK_TEXT_COLOR, lineSpacing: 3.5,alignment: NSTextAlignment.Left)
                let descSize = descText.boundingRectWithSize(CGSizeMake(UI_SCREEN_WIDTH - 30, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
                
                let descLabel: UILabel = UILabel(frame: CGRectMake(15, yPoint, UI_SCREEN_WIDTH - 30, descSize.height))
                yPoint += descSize.height + 15
                
                descLabel.attributedText = descText
                descLabel.numberOfLines = 0
                
                self.stepFourView.addSubview(descLabel)
            }
        }
        if islimModel.habitModel.secretionArray != nil {
            
            for descModel in islimModel.habitModel.secretionArray {
                
                if !hasHabit {
                    hasHabit = true
                }
                
                let titleText = descModel.result as String
                
                let titleLabel: UILabel = UILabel(frame: CGRectMake(15, yPoint, UI_SCREEN_WIDTH - 30, 20))
                yPoint += 30
                
                titleLabel.text = titleText
                titleLabel.font = UIFont.systemFontOfSize(14)
                titleLabel.textColor = XKMainSchemeColor
                
                self.stepFourView.addSubview(titleLabel)
                
                let descText: NSAttributedString = XKRWUtil.createAttributeStringWithString(self.getDetailTextBy(titleText), font: UIFont.systemFontOfSize(14), color: XK_TEXT_COLOR, lineSpacing: 3.5,alignment: NSTextAlignment.Left)
                let descSize = descText.boundingRectWithSize(CGSizeMake(UI_SCREEN_WIDTH - 30, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
                
                let descLabel: UILabel = UILabel(frame: CGRectMake(15, yPoint, UI_SCREEN_WIDTH - 30, descSize.height))
                yPoint += descSize.height + 15
                
                descLabel.attributedText = descText
                descLabel.numberOfLines = 0
                
                self.stepFourView.addSubview(descLabel)
            }
        }
        if !hasHabit {
            
            let title: String = "继续加油"
            let text : String = "经过刚才的测评，你的生活习惯还不错，请继续保持哦，并且在今后的生活中培养更多的好习惯！"
            
            let titleLabel: UILabel = UILabel(frame: CGRectMake(15, yPoint, UI_SCREEN_WIDTH - 30, 20))
            yPoint += 30
            
            titleLabel.text = title
            titleLabel.font = UIFont.systemFontOfSize(14)
            titleLabel.textColor = XKMainSchemeColor
            
            self.stepFourView.addSubview(titleLabel)
            
            let descText: NSAttributedString = XKRWUtil.createAttributeStringWithString(text, font: UIFont.systemFontOfSize(14), color: XK_TEXT_COLOR, lineSpacing: 3.5,alignment: NSTextAlignment.Left)
            let descSize = descText.boundingRectWithSize(CGSizeMake(UI_SCREEN_WIDTH - 30, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
            
            let descLabel: UILabel = UILabel(frame: CGRectMake(15, yPoint, UI_SCREEN_WIDTH - 30, descSize.height))
            yPoint += descSize.height + 15
            
            descLabel.attributedText = descText
            descLabel.numberOfLines = 0
            
            self.stepFourView.addSubview(descLabel)
        }
        self.heightOfStepFour.constant = yPoint + 15.0
    }
    
    func getDetailTextBy(title: String) -> String {
        
        var detail: String = ""
        
        if title == "饮酒频繁" {
            detail = "计算近一个月内喝酒的次数，克制自己，减少喝酒频率，在接下来的一个月次数减半；度数越高热量越高，实在忍不住尽量选择红酒，但一定要控制量。"
        } else if title == "经常零食" {
            detail = "看电视、看电影时千万不要给自己准备一大堆零食，这样你会不知不觉中吃进去大量脂肪；办公室内不要储备零食哦；不要受别人的影响和干预，尽量远离零食党。"
        } else if title == "饮料" {
            detail = "计算近一个月内喝饮料的次数，克制自己，减少喝饮料频率，在接下来的一个月次数减半；最好用白开水代替，实在忍不住尽量选择低糖或无糖饮料，或者茶、黑咖啡、低脂牛奶等。"
        } else if title == "体力活动少" {
            detail = "饭后至少二十分钟不要坐下来，尽量站着或散步；跟朋友聊天的时候边走边聊；"
        } else if title == "娱乐活动少" {
            detail = "多培养自己一些兴趣点，积极参加感兴趣的活动，如：学校的社团、公益组织；多参与社交活动，千万不要宅哦！"
        } else if title == "熬夜频繁" {
            detail = "从今天开始睡前选择听音乐或看书，让自己安静下来，平静心率和脑电波，身心放松，进入睡眠状态；每天提前5~10分钟入睡，一直坚持到能在23:00前入睡为止。"
        }
        return detail
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
