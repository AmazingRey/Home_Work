//
//  XKRWAnalyzeCell.swift
//  XKRW
//
//  Created by 忘、 on 15/5/28.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWAnalyzeCell: UITableViewCell {

    //图片离顶端距离的依赖关系

    @IBOutlet weak var imageConstraints: NSLayoutConstraint!
    @IBOutlet weak var analyzeImageView: UIImageView!
    @IBOutlet weak var analyzeDescribe: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
