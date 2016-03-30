//
//  XKRWUserInfoContentCell.swift
//  XKRW
//
//  Created by 忘、 on 15/9/24.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWUserInfoContentCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentNumLabel: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
