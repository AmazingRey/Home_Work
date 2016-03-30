//
//  HPSummaryCell.swift
//  XKRW
//
//  Created by Klein Mioke on 15/7/17.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class HPSummaryCell: UITableViewCell {

    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var attentionView: UIView!
    @IBOutlet weak var attentionViewHeight: NSLayoutConstraint!
    
    func setContent(viewModel: XKRWHistoryAndProcessModel) -> Void {
        
        let image = UIImage(named: "progress_indicate_summarize")
        self.backImageView.image = XKRWCui.resizeImageView(image!, withEdgeInset: UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10))
        
        self.summaryLabel.text = viewModel.summaryTitle
        self.attentionViewHeight.constant = 15
        
        var count: Int = 0
        if viewModel.mealTag == .Bad {
            count++
        }
        if viewModel.sportTag == .Bad {
            count++
        }
        if viewModel.habitTag == .Bad {
            count++
        }
        if count > 0 {
            // 公式：xPoint = (screenWidth - imageWidth * count - gapWidth * (count - 1)) / 2
            let gapWidth: CGFloat = 30
            let imageWidth: CGFloat = 60
            var xPoint = (UI_SCREEN_WIDTH - imageWidth * CGFloat(count) - gapWidth * CGFloat(count - 1)) / 2
            
            if viewModel.mealTag == .Bad {
                let imageView = UIImageView(image: UIImage(named: "progress_ic_attention_stuffed"))
                imageView.origin = CGPointMake(xPoint, 10)
                
                self.attentionView.addSubview(imageView)
                xPoint += imageWidth + gapWidth
            }
            if viewModel.sportTag == .Bad {
                let imageView = UIImageView(image: UIImage(named: "progress_ic_attention_sport"))
                imageView.origin = CGPointMake(xPoint, 10)
                
                self.attentionView.addSubview(imageView)
                xPoint += imageWidth + gapWidth
            }
            if viewModel.habitTag == .Bad {
                let imageView = UIImageView(image: UIImage(named: "progress_ic_attention_habit"))
                imageView.origin = CGPointMake(xPoint, 10)
                
                self.attentionView.addSubview(imageView)
                xPoint += imageWidth + gapWidth
            }
            
            self.attentionViewHeight.constant = (UIImage(named: "progress_ic_attention_stuffed")?.size.height ?? 0) + 20
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
