//
//  XKRWMyViewPraiseCell.swift
//  XKRW
//
//  Created by 忘、 on 15/9/22.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

@objc protocol XKRWMyViewPraiseCellDelagate {
     func entrybePraisedVC()    //进入被赞页面
     func entrythumpUpVC()      //进入点赞页面
}

class XKRWMyViewPraiseCell: UITableViewCell {
  
    weak var praiseCellDelegate: (protocol<XKRWMyViewPraiseCellDelagate>)?
    
    
    @IBOutlet weak var unreadBePraisedLable: UILabel!
    @IBOutlet weak var bePraisedRedImageView: UIImageView!
    @IBOutlet weak var bePraisedNumLabel: UIButton!
    @IBOutlet weak var thumpUpNumLabel: UIButton!
    
    @IBOutlet weak var beiLikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.beiLikeButton.setBackgroundImage(UIImage.createImageWithColor(UIColor.darkGrayColor()), forState: .Highlighted)
        self.likeButton.setBackgroundImage(UIImage.createImageWithColor(UIColor.darkGrayColor()), forState: .Highlighted)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    

    @IBAction func entryBePraisedVC(sender: AnyObject) {
        if((self.praiseCellDelegate ) != nil){
            self.praiseCellDelegate?.entrybePraisedVC()
        }
    }

    @IBAction func entryThumpUpVC(sender: AnyObject) {
        if((self.praiseCellDelegate ) != nil){
            self.praiseCellDelegate?.entrythumpUpVC()
        }
    
    }
 
    

}
