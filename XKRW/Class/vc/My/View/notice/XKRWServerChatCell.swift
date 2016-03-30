//
//  XKRWServerChatCell.swift
//  XKRW
//
//  Created by 忘、 on 16/2/18.
//  Copyright © 2016年 XiKang. All rights reserved.
//

import UIKit

@objc enum MessgeSendType :Int{
    case FromOther
    case FromMain
}


class XKRWServerChatCell: UITableViewCell {

    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightContentLabel: UILabel!
    @IBOutlet weak var rightContentView: UIView!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var rightHeadImageView: UIImageView!
    @IBOutlet weak var leftContentLabel: UILabel!
    @IBOutlet weak var leftContentView: UIView!
    @IBOutlet weak var leftArrowImageView: UIImageView!
    @IBOutlet weak var leftheadImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var timeView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        rightHeadImageView.layer.masksToBounds = true
        rightHeadImageView.layer.cornerRadius = 20
        
        leftheadImageView.layer.masksToBounds = true
        leftheadImageView.layer.cornerRadius = 20

        
        leftContentView.layer.masksToBounds = true
        leftContentView.layer.cornerRadius = 5
        
        rightContentView.layer.masksToBounds = true
        rightContentView.layer.cornerRadius = 5
        
        timeView.layer.masksToBounds = true
        timeView.layer.cornerRadius = 5
        // Initialization code
    }
    
    func setMessage(msgModel:XKRWChatMessageModel) -> Void{
        if(msgModel.time > 0){
            
            let date = NSDate(timeIntervalSince1970: msgModel.time)
            
            timeLabel.text = NSDate.stringFromDate(date, withFormat: "yyyy-MM-dd hh:mm:ss")
            if(msgModel.senderType == .FromMain){
                leftContentView.hidden = true
                leftArrowImageView.hidden = true
                leftheadImageView.hidden = true
                rightContentView.hidden = false
                rightArrowImageView.hidden = false
                rightHeadImageView.hidden = false
                rightContentLabel.text = msgModel.message
                rightHeadImageView .setImageWithURL(NSURL(string: msgModel.imageUrl!), placeholderImage: nil)
                rightContentLabel.preferredMaxLayoutWidth = UI_SCREEN_WIDTH - 140
            }else{
                rightContentView.hidden = true
                rightArrowImageView.hidden = true
                rightHeadImageView.hidden = true
                leftContentView.hidden = false
                leftArrowImageView.hidden = false
                leftheadImageView.hidden = false
                leftContentLabel.text = msgModel.message
                leftheadImageView .setImageWithURL(NSURL(string: msgModel.imageUrl!), placeholderImage: nil)
                leftContentLabel.preferredMaxLayoutWidth = UI_SCREEN_WIDTH - 140
            }
            
        }else{
        
            timeLabel.hidden = true
            if(msgModel.senderType == .FromMain){
                leftContentView.hidden = true
                leftArrowImageView.hidden = true
                leftheadImageView.hidden = true
                rightContentView.hidden = false
                rightArrowImageView.hidden = false
                rightHeadImageView.hidden = false
                rightContentLabel.text = msgModel.message
                rightContentLabel.preferredMaxLayoutWidth = UI_SCREEN_WIDTH - 140
            }else{
                rightContentView.hidden = true
                rightArrowImageView.hidden = true
                rightHeadImageView.hidden = true
                leftContentView.hidden = false
                leftArrowImageView.hidden = false
                leftheadImageView.hidden = false
                leftContentLabel.text = msgModel.message
                leftContentLabel.preferredMaxLayoutWidth = UI_SCREEN_WIDTH - 140
            }
            
            contentHeightConstraint.constant = 10

        }
    
    }
    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
