//
//  SDSportSchemeCell.swift
//  XKRW
//
//  Created by Klein Mioke on 15/8/13.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class SDSportSchemeCell: UITableViewCell {
    
    @IBOutlet weak var sportName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sportImageView: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    var clickToSportDetail: (Void -> Void)?
    
    @IBAction func toSportDetail(sender: AnyObject) {
        self.clickToSportDetail?()
    }
    
    func setContentWithEntity(entity: XKRWSportEntity) -> Void {
        self.sportName.text = entity.sportName
        
        if entity.sportActionPic.isEmpty {
            self.imageHeight.constant = UI_SCREEN_WIDTH * 9 / 16
            
        } else {

            self.imageHeight.constant = UI_SCREEN_WIDTH * 0.75
            
            if entity.sportActionPic == nil || entity.sportActionPic.isEmpty {
                
                self.sportImageView.image = UIImage(named: "sport_detail_defalut")
            } else {
                self.sportImageView.setImageWithURL(NSURL(string: entity.sportActionPic), placeholderImage: UIImage(named: "sport_detail_defalut"))
            }
        }
        
        if entity.sportTime == 0 {
            
            let calorie = XKRWAlgolHelper.dailyConsumeSportEnergy() * Float(entity.scale) / 100.0
            let minute = XKRWAlgolHelper.sportTimeWithCalorie(calorie, mets: entity.sportMets)
            
            self.timeLabel.text = "\(minute)分钟"
        } else {
            self.timeLabel.text = "\(entity.sportTime)分钟"
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
