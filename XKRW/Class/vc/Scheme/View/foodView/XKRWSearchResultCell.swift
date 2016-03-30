//
//  XKRWSearchResultCell.swift
//  XKRW
//
//  Created by Klein Mioke on 15/7/9.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWSearchResultCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var arrowImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.logoImageView.layer.cornerRadius = 3
        self.logoImageView.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
