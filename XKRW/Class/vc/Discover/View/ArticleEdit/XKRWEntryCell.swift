//
//  XKRWEntryCell.swift
//  XKRW
//
//  Created by Klein Mioke on 15/9/21.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWEntryCell: UITableViewCell {

    @IBOutlet weak var topLine: UIView!
    var bottomLine: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var enterImageView: UIImageView!
    
    @IBOutlet weak var topLineLeadingSpace: NSLayoutConstraint!
    
    var bottomLineLeadingSpace: CGFloat {
        set {
            self.bottomLine.left = newValue
        }
        get {
            return self.bottomLine.left
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.bottomLine = UIView(frame: CGRectMake(0, 43.5, UI_SCREEN_WIDTH, 0.5))
        self.bottomLine.backgroundColor = XK_ASSIST_LINE_COLOR
        self.addSubview(self.bottomLine)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
