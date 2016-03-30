//
//  XKRWArticleSelecPicCell.swift
//  XKRW
//
//  Created by Klein Mioke on 15/9/21.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWArticleSelecPicCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
