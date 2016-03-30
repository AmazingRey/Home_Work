//
//  XKRWFoodRecordCell.swift
//  XKRW
//
//  Created by Klein Mioke on 15/7/9.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWFoodRecordCell: UITableViewCell {

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
        self.logo.setImageWithURL(NSURL(string: logoURL), placeholderImage: UIImage(named:"food_default"))
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
