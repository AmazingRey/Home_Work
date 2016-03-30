//
//  SDChangeSizeCell.swift
//  XKRW
//
//  Created by Klein Mioke on 15/8/13.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class SDChangeSizeCell: UITableViewCell {

    @IBOutlet weak var schemeDescription: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    /**
    根据entity给Cell赋值
    
    - parameter entity: 方案实例
    */
    func setContentWithEntity(entity: XKRWSchemeEntity_5_0) -> Void {
        
        if entity.schemeType != .Sport {
            self.schemeDescription.text = "当前食谱份量为"
            
            let sizeString: String = XKRWSchemeService_5_0.getDescriptionBySize(entity.size)
            
            self.sizeLabel.text = sizeString
        }
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
