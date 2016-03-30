//
//  XKRWPraiseCell.swift
//  XKRW
//
//  Created by 忘、 on 15/9/22.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWPraiseCell: UITableViewCell {

    @IBOutlet weak var newChatInfoLabel: UILabel!
    @IBOutlet weak var degreeImageView: UIImageView!
    @IBOutlet weak var praiseContentLabel: UILabel!
    @IBOutlet weak var praiseTimeLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var headButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        newChatInfoLabel.layer.masksToBounds = true
        newChatInfoLabel.layer.cornerRadius = 5
        newChatInfoLabel.hidden = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
