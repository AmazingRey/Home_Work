//
//  HPMealCell.swift
//  XKRW
//
//  Created by Klein Mioke on 15/7/17.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

@objc protocol HPMealCellDelegate: NSObjectProtocol {
    
    func HPMealCellClickAction(cell: HPMealCell, clickButtonTag tag: Int) -> Void
    func HPMealCellClickAnalsisButton(cell: HPMealCell) -> Void
    
    optional func HPMealCellClickActionToRecord(cell: HPMealCell) -> Void
}

class HPMealCell: XKRWUITableViewCellbase {
    
    weak var delegate: HPMealCellDelegate?
    
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var sealImageView: UIImageView!
    
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var recordViewHeight: NSLayoutConstraint!
    @IBOutlet weak var analysisViewHeight: NSLayoutConstraint!
    
    
    weak var viewModel: XKRWHistoryAndProcessModel?
    
    func setCellContent(viewModel: XKRWHistoryAndProcessModel) -> Void {
        
        self.viewModel = viewModel
        
        for view in self.content.subviews {
            view.removeFromSuperview()
        }
        
        var image: UIImage?
        
        switch viewModel.mealTag! {
        case .Perfect:
            image = UIImage(named: "progress_get")
        case .Bad:
            image = UIImage(named: "progress_stuffed")
        case .Other:
            
            // if the data is self, then show the piechart
            if viewModel.haveOtherRecord && viewModel.isSelf {
                // draw circle
                
                let pieChart = self.createPieChart()
                self.contentHeight.constant = pieChart.height
                
                self.content.addSubview(pieChart)
                pieChart.strokeChart()
                
                image = nil
                
            } else {
                image = UIImage(named: "progress_eatother")
            }
            
        default:
            image = nil
            break
        }
        
        if !viewModel.canModified {
            self.recordViewHeight.constant = 0
            
        } else {
            self.recordViewHeight.constant = 132
            
            // set button state
            
            self.resetRecordView()
            
            if viewModel.breakfast != nil {
                
                let value = viewModel.breakfast!.record_value > 3 ? 3 : viewModel.breakfast!.record_value
                let button =  self.recordView.viewWithTag(100 + value) as? UIButton
                
                button?.selected = true
            }
            if viewModel.lunch != nil {
                
                let value = viewModel.lunch!.record_value > 3 ? 3 : viewModel.lunch!.record_value
                let button =  self.recordView.viewWithTag(200 + value) as? UIButton
                
                button?.selected = true
            }
            if viewModel.dinner != nil {
                
                let value = viewModel.dinner!.record_value > 3 ? 3 : viewModel.dinner!.record_value
                let button =  self.recordView.viewWithTag(300 + value) as? UIButton
                
                button?.selected = true
            }
        }
        
        if image != nil {
            
            let imageView = UIImageView(image: image!)
            self.contentHeight.constant = image!.size.height
            imageView.center = self.content.center
            imageView.setY(0)
            imageView.setX(UI_SCREEN_WIDTH / 2 - image!.size.width / 2)
            self.content.addSubview(imageView)
            
        } else {
            
            if viewModel.isSelf {
                
                if viewModel.isToday && !viewModel.haveOtherRecord {
                    
                    self.contentHeight.constant = 129
                    
                    let label = UILabel(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 20))
                    label.center = self.content.center
                    label.setY(40)
                    
                    label.textAlignment = .Center
                    label.textColor = XK_TEXT_COLOR
                    label.font = UIFont.systemFontOfSize(14)
                    
                    label.text = "小主，我不知道你吃了什么!"
                    self.content.addSubview(label)
                    
                    let button = UIButton(type: UIButtonType.Custom)
                    button.backgroundColor = UIColor.whiteColor()
                    button.titleLabel?.font = UIFont.systemFontOfSize(14)
                    button.setTitle("去记上", forState: UIControlState.Normal)
                    button.setTitleColor(XKMainSchemeColor, forState: .Normal)
                    button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
                    button.setBackgroundImage(UIImage.createImageWithColor(XKMainSchemeColor), forState: .Highlighted)
                    button.layer.cornerRadius = 3.5
                    button.layer.masksToBounds = true
                    button.layer.borderWidth = 1
                    button.layer.borderColor = XKMainSchemeColor.CGColor
                    
                    button.addTarget(self, action: "clickRecordButton", forControlEvents: UIControlEvents.TouchUpInside)
                    button.frame = CGRectMake(0, 0, 70, 26)
                    button.center = self.content.center
                    button.setY(label.bottom + 25)
                    
                    self.content.addSubview(button)
                    
                } else if !viewModel.isToday && !viewModel.haveOtherRecord {
                    
                    image = UIImage(named: "progress_nofood")
                    
                    let imageView = UIImageView(image: image!)
                    self.contentHeight.constant = image?.size.height ?? 200
                    imageView.center = self.content.center
                    imageView.setY(0)
                    
                    self.content.addSubview(imageView)
                }
            }
            else {
                self.contentHeight.constant = 99
                
                if !viewModel.haveOtherRecord {
                    
                    let label = UILabel(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 20))
                    label.center = self.content.center
                    label.setX(0)
                    label.setY(40)
                    
                    label.textAlignment = .Center
                    label.textColor = XK_TEXT_COLOR
                    label.font = UIFont.systemFontOfSize(14)
                    
                    label.text = "ta今天没有饮食记录哦"
                    self.content.addSubview(label)
                }
            }
        }
        
        var sealImage: UIImage?
        
        switch viewModel.mealTag! {
        case .Perfect:
            sealImage = UIImage(named: "progress_emblem_perfect")
        case .Bad:
            sealImage = UIImage(named: "progress_emblem_stuffed")
        case .Other:
            sealImage = UIImage(named: "progress_emblem_myself")
        default:
            sealImage = nil
            break
        }
        
        self.sealImageView.image = sealImage
        
        if viewModel.isShowMealAnalysis {
            self.analysisViewHeight.constant = 44
        } else {
            self.analysisViewHeight.constant = 0
        }
        if viewModel.isSelf {
            
            if !viewModel.predictAttention!.isEmpty {
                
                let label = UILabel(frame: CGRectMake(0, self.contentHeight.constant + 5, UI_SCREEN_WIDTH, 30))
                label.text = "规律的饮食才有助于减肥，请务必吃饭哦"
                label.font = UIFont.systemFontOfSize(12)
                label.textColor = XK_TEXT_COLOR
                label.textAlignment = .Center
                
                self.content.addSubview(label)
                
                self.contentHeight.constant += 30
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func clickButton(sender: AnyObject) {
        
        if sender is UIButton {
            let button = sender as! UIButton
            
            if button.selected && button.tag % 100 != 3 {
                return
            }
            let typeNum = Int(button.tag / 100)
            
            for i in 1...3 {
                let tag = typeNum * 100 + i
                if tag == button.tag {
                    continue
                }
                let temp = self.recordView.viewWithTag(tag) as! UIButton
                temp.selected = false
            }
            button.selected = true
            
            if self.delegate != nil {
                self.delegate!.HPMealCellClickAction(self, clickButtonTag: button.tag)
            }
        }
    }
    
    func resetRecordView() -> Void {
        for i in 1...3 {
            
            for j in 1...3 {
                let tag = i * 100 + j
                
                let button = self.recordView.viewWithTag(tag) as! UIButton
                button.selected = false
            }
        }
    }
    
    func clickRecordButton() -> Void {
        
        if self.delegate != nil {
            if self.delegate!.respondsToSelector("HPMealCellClickActionToRecord:") {
                self.delegate!.HPMealCellClickActionToRecord!(self)
            }
        }
    }
    
    func createPieChart() -> PNPieChart {
        
        var items = [PNPieChartDataItem]()
        
        var colors = [UIColor(fromHexString: "#ff6b6b"), UIColor(fromHexString: "#29ccb1"), UIColor(fromHexString: "#ffc555")]
        
        items.append(PNPieChartDataItem(value: CGFloat(self.viewModel!.nutriPersentage![kFat] as! NSNumber) * 2.25, color: colors[0], description: "脂肪"))
        items.append(PNPieChartDataItem(value: CGFloat(self.viewModel!.nutriPersentage![kCarbohydrate] as! NSNumber), color: colors[1], description: "碳水化合物"))
        items.append(PNPieChartDataItem(value: CGFloat(self.viewModel!.nutriPersentage![kProtein] as! NSNumber), color: colors[2], description: "蛋白质"))
        
        let pieChart = PNPieChart(frame: CGRectMake((UI_SCREEN_WIDTH - 163) / 2, 0, 163, 163), items: items)
        pieChart.shouldHighlightSectorOnTouch = false
        pieChart.innerCircleRadius = 0
        
        pieChart.hideDescription = true
        
        return pieChart
    }
    
    @IBAction func clickAnalysisButton(sender: AnyObject) {
        self.delegate?.HPMealCellClickAnalsisButton(self)
    }
}


