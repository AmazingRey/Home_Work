//
//  XKRWGradeRuleDetailCell.swift
//  XKRW
//
//  Created by 忘、 on 15/9/25.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWGradeRuleDetailCell: UITableViewCell {

    @IBOutlet weak var superRuleImageView: UIView!
    @IBOutlet weak var ruleImageView: UIImageView!
    @IBOutlet weak var ruleThreeLabel: UILabel!
    @IBOutlet weak var ruleTwoLabel: UILabel!
    @IBOutlet weak var ruleOneLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
