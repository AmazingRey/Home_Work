//
//  XKRWRecordsCell_V5.swift
//  XKRW
//
//  Created by Klein Mioke on 15/7/14.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWRecordsCell_V5: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    func setTitle(title: String, detail: String) -> Void {
        
        self.title.text = title
        self.detail.text = detail
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
