//
//  KMSwitchCell.swift
//  XKRW
//
//  Created by Klein Mioke on 15/9/14.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class KMSwitchCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var switchUnit: UISwitch!
    
    var clickSwitchAction: (Bool -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setTitle(title: String, clickSwitchAction: Bool -> Void) -> Void {
        
        self.title.text = title
        self.clickSwitchAction = clickSwitchAction
    }
    
    @IBAction func clickSwitch(sender: AnyObject) {
        
        self.clickSwitchAction?(self.switchUnit.on)
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
