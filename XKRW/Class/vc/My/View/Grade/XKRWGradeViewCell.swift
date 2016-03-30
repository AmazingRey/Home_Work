//
//  XKRWGradeViewCell.swift
//  XKRW
//
//  Created by 忘、 on 15/9/24.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWGradeViewCell: UITableViewCell {


    @IBOutlet weak var degreeDescribeLabel: NZLabel!
    @IBOutlet weak var nextDegreeImageView: UIImageView!
    @IBOutlet weak var nowDegreeImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
