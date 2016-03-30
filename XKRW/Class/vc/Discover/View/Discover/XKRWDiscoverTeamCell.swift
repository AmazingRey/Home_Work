//
//  XKRWDiscoverTeamCell.swift
//  XKRW
//
//  Created by 忘、 on 16/1/14.
//  Copyright © 2016年 XiKang. All rights reserved.
//

import UIKit

class XKRWDiscoverTeamCell: UITableViewCell {

    @IBOutlet weak var teamNewPostImageView: UIImageView!
    @IBOutlet weak var showStatelabel: UILabel!
    @IBOutlet weak var teamDescribleLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        teamImageView.layer.masksToBounds = true
        teamImageView.layer.cornerRadius = 20
        showStatelabel.layer.masksToBounds = true
        showStatelabel.layer.cornerRadius = 8
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
