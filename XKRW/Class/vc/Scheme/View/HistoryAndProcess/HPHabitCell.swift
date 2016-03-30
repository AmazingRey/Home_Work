//
//  HPHabitCell.swift
//  XKRW
//
//  Created by Klein Mioke on 15/7/20.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class HPHabitCell: UITableViewCell {

    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var recordViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var habitNumLabel: UILabel!
    @IBOutlet weak var sealImageView: UIImageView!
    @IBOutlet weak var noBadHabitLabel: UILabel!
    
    weak var oldEntity: XKRWRecordEntity4_0?
    
    var clickModifyAction: (()->())?
    
    func setContent(viewModel: XKRWHistoryAndProcessModel) -> Void {
        
        self.oldEntity = viewModel.oldRecord
        
        var sealImage: UIImage?
        switch viewModel.habitTag! {
        case .Perfect:
            sealImage = UIImage(named: "progress_emblem_perfect")
        case .Other:
            sealImage = UIImage(named: "progress_emblem_onestep")
        default:
            sealImage = UIImage(named: "progress_emblem_ownway")
            break
        }
        self.sealImageView.image = sealImage
        
        if viewModel.numOfHabit == 0 {
            
            self.habitNumLabel.text = "  "
            if viewModel.isSelf {
                self.noBadHabitLabel.text = "您的习惯保持的很好，请继续保持"
            } else {
                self.noBadHabitLabel.text = "ta没有不良习惯哦~"
            }
        } else {
            self.habitNumLabel.text = "\(viewModel.amendNumOfHabit)个"
            self.noBadHabitLabel.text = ""
            
        }
        if viewModel.canModified && viewModel.numOfHabit != 0 {
            self.recordViewHeight.constant = 44
        } else {
            self.recordViewHeight.constant = 0
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
    
    @IBAction func clickModifyButton(sender: AnyObject) {
        
        self.clickModifyAction?()
    }
    
}
