//
//  XKRWTitleAndDescribeCell.swift
//  XKRW
//
//  Created by 忘、 on 16/1/27.
//  Copyright © 2016年 XiKang. All rights reserved.
//

import UIKit

class XKRWTitleAndDescribeCell: UITableViewCell {

    @IBOutlet weak var readNumLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var describeLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
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
