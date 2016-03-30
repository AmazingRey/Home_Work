//
//  XKRWCalendarTitleCell.swift
//  XKRW
//
//  Created by Klein Mioke on 15/7/17.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWCalendarTitleCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    var clickBeforeAction: (()->())?
    var clickAfterAction: (()->())?
    
    func setBeforeAction(before: ()->(), afterAction after: ()->()) -> Void {
        self.clickBeforeAction = before
        self.clickAfterAction = after
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickBefore(sender: AnyObject) {
        
        self.clickBeforeAction?()
    }
    
    @IBAction func clickAfter(sender: AnyObject) {
        
        self.clickAfterAction?()
    }
}
