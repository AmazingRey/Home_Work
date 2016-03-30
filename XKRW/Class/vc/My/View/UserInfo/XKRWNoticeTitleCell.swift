//
//  XKRWNoticeTitleCell.swift
//  XKRW
//
//  Created by 忘、 on 15/9/29.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWNoticeTitleCell: UITableViewCell {

    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.sizeToFit()
   
        // Initialization code
    }

    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
