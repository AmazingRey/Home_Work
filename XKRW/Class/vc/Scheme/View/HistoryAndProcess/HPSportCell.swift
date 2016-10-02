//
//  HPSportCell.swift
//  XKRW
//
//  Created by Klein Mioke on 15/7/20.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

@objc protocol HPSportCellDelegate: NSObjectProtocol {
    
    func SportCell(cell: HPSportCell, clickModifyButtonIndex index: Int) -> Void
    
    optional func SportCellClickToRecordButton(cell: HPSportCell) -> Void
}

class HPSportCell: XKRWUITableViewCellbase {

    @IBOutlet weak var content: UIView!
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var recordViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var sealImageView: UIImageView!
    
    weak var delegate: HPSportCellDelegate?
    
    func setCellContent(viewModel: XKRWHistoryAndProcessModel) -> Void {
        
        for view in self.content.subviews {
            view.removeFromSuperview()
        }
        
        if viewModel.sportState == .Show {
            
            let barBase = UIImageView(image: UIImage(named: "progress_bar_base"))
            let bar = UIImageView(image: UIImage(named: "progress_bar_full"))
            let barTop = UIImageView(image: UIImage(named: "progress_bar_top"))
            
            let barView = UIView(frame: CGRectMake(0, 0, barBase.size.width, barBase.size.height))
            barView.center = self.content.center
            barView.setY(20)
            barView.setX(UI_SCREEN_WIDTH / 2 - barBase.size.width / 2)
            barView.clipsToBounds = true
            
            self.content.addSubview(barView)
            barView.addSubview(barBase)
            barView.addSubview(bar)
            barView.addSubview(barTop)
            
            bar.setX(bar.width * CGFloat(viewModel.sportPercentage ?? 0) - bar.width)
            
            if viewModel.isSelf {
                
                let label = UILabel(frame: CGRectMake(0, barView.bottom + 10, UI_SCREEN_WIDTH, 40))
                label.textAlignment = .Center
                label.numberOfLines = 0
                
                let normalAttribute = [NSFontAttributeName: UIFont.systemFontOfSize(12), NSForegroundColorAttributeName: XK_TEXT_COLOR]
                let highlight = [NSFontAttributeName: UIFont.systemFontOfSize(12), NSForegroundColorAttributeName: XKMainSchemeColor]
                
                let attributeString = NSMutableAttributedString(string: "效果将持续到明天早上，睡觉时也能消耗热量\n预计消耗")
                attributeString.addAttributes(normalAttribute, range: NSMakeRange(0, attributeString.length))
                
                let number = NSAttributedString(string: "\(viewModel.costCalorie)kcal", attributes: highlight)
                
                attributeString.appendAttributedString(number)
                attributeString.appendAttributedString(NSAttributedString(string: "，大约能瘦", attributes: normalAttribute))
                
                let gString = String(format: "%0.1fg", Float(viewModel.costCalorie) / 7.7);
                
                attributeString.appendAttributedString(NSAttributedString(string: gString, attributes: highlight))
                
                label.attributedText = attributeString
                self.content.addSubview(label)
            }
            
        } else {
            
            if viewModel.isSelf {
                
                let label = UILabel(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 20))
                label.center = self.content.center
                label.setY(20)
                
                label.textAlignment = .Center
                label.textColor = XK_TEXT_COLOR
                label.font = UIFont.systemFontOfSize(14)
                
                label.text = "小主，你真的有运动吗？"
                self.content.addSubview(label)
                
                let button = UIButton(type: UIButtonType.Custom)
                 button.backgroundColor = UIColor.clearColor()
                button.titleLabel?.font = UIFont.systemFontOfSize(14)
                button.setTitle("去记上", forState: UIControlState.Normal)
                button.setTitleColor(XKMainSchemeColor, forState: .Normal)
                button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
                button.setBackgroundImage(UIImage.createImageWithColor(XKMainSchemeColor), forState: .Highlighted)
                button.layer.cornerRadius = 3.5
                button.layer.masksToBounds = true
                button.layer.borderWidth = 1
                button.layer.borderColor = XKMainSchemeColor.CGColor

                button.addTarget(self, action: #selector(HPSportCell.clickRecordButton), forControlEvents: UIControlEvents.TouchUpInside)
                button.frame = CGRectMake(0, 0, 70, 26)
                button.center = self.content.center
                button.setY(label.bottom + 25)
                
                self.content.addSubview(button)
            }
            else {
                let label = UILabel(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 20))
                label.center = CGRectGetCenter(self.content.bounds)
                label.setX(0)
                
                label.textAlignment = .Center
                label.textColor = XK_TEXT_COLOR
                label.font = UIFont.systemFontOfSize(14)
                
                label.text = "ta今天没有运动记录哦"
                self.content.addSubview(label)
            }
        }
        
        if !viewModel.canModified {
            self.recordViewHeight.constant = 0
        } else {
            self.recordViewHeight.constant = 44
            
            let selectedTag = viewModel.sport!.record_value
            
            for tag in 1...3 {
                let button = self.recordView.viewWithTag(tag) as! UIButton
                if tag == selectedTag {
                    button.selected = true
                } else {
                    button.selected = false
                }
            }
        }
        
        var image: UIImage?
        
        if viewModel.sportTag != nil {
            
            switch viewModel.sportTag! {
            case .Perfect:
                image = UIImage(named: "progress_emblem_perfect")
            case .Bad:
                image = UIImage(named: "progress_emblem_lazy")
            case .Other:
                image = UIImage(named: "progress_emblem_myself")
            default:
                image = nil
                break
            }
        }
        self.sealImageView.image = image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func clickRecordButton() -> Void {
        if self.delegate != nil {
            if self.delegate!.respondsToSelector(#selector(HPSportCellDelegate.SportCellClickToRecordButton(_:))) {
                
                self.delegate?.SportCellClickToRecordButton!(self)
            }
        }
    }
    
    @IBAction func clickButton(sender: AnyObject) {
        
        if sender is UIButton {
            
            let button = sender as! UIButton
            if button.selected == true && button.tag != 3 {
                return
            }
            for tag in 1...3 {
                let button = self.recordView.viewWithTag(tag) as! UIButton
                button.selected = false
            }
            self.delegate?.SportCell(self, clickModifyButtonIndex: button.tag)
            button.selected = true
        }
    }
}
