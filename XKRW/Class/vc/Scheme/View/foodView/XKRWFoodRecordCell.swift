//
//  XKRWFoodRecordCell.swift
//  XKRW
//
//  Created by Klein Mioke on 15/7/9.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWFoodRecordCell: XKRWUITableViewCellbase {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var logo: UIImageView!
    
    var clickDetail: ((NSIndexPath?) -> ())?
    var clickRecord: ((NSIndexPath?) -> ())?
    
    var indexPath: NSIndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTitle(title: String, logoURL: String, clickDetail: (indexPath: NSIndexPath?)->(), clickRecord:(indexPath: NSIndexPath?)->()) -> Void {
        self.title.text = title
        if logoURL == "food_default" {
            self.logo.image = UIImage.init(named: "food_default01")
        } else if logoURL == "sport_default" {
            self.logo.image = UIImage.init(named: "sport_default")
        } else {
           self.logo.setImageWithURL(NSURL(string: logoURL), placeholderImage: UIImage(named:"food_default"),options:.RetryFailed)
        }
        
        self.clickDetail = clickDetail
        self.clickRecord = clickRecord
    }
    
    @IBAction func clickDetail(sender: AnyObject) {
        self.clickDetail?(self.indexPath)
    }

    @IBAction func clickRecord(sender: AnyObject) {
        self.clickRecord?(self.indexPath)
    }
}
