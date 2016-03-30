//
//  XKRWNoticeEntryCell.swift
//  XKRW
//
//  Created by Klein Mioke on 15/7/7.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWNoticeEntryCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    func setTitle(title: String, descripton desc: String) -> Void {
        self.title.text = title
        self.descLabel.text = desc
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
