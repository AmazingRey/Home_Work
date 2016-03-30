//
//  XKRWAppRecommendCell.swift
//  XKRW
//
//  Created by 忘、 on 15/12/24.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWAppRecommendCell: UITableViewCell {

    @IBOutlet weak var headImageView: UIImageView!
   
    @IBOutlet weak var appDescribe: UILabel!
    @IBOutlet weak var appName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
