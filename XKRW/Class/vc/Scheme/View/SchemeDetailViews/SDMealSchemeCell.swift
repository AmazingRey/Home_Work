//
//  SDMealSchemeCell.swift
//  XKRW
//
//  Created by Klein Mioke on 15/8/13.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class SDMealSchemeCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet weak var mealTitle: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var mealDescription: UILabel!
    
    @IBOutlet weak var banFoodsDescription: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageCtrl: UIPageControl!
    
    @IBOutlet weak var banFoodsEntryHeight: NSLayoutConstraint!
    
    weak var foodCategoryEntity: XKRWFoodCategoryEntity?
    
    var isNeedLoad: Bool = true
    
    var clickToBanFoodsAction: (Void -> Void)?
    var clickToDescriptionAction: (Void -> Void)?
    
    @IBAction func clickToBanFoods(sender: AnyObject) {
        self.clickToBanFoodsAction?()
    }
    @IBAction func clickToDescriptionVC(sender: AnyObject) {
        self.clickToDescriptionAction?()
    }
    
    func setContentWithEntity(entity: XKRWFoodCategoryEntity, indexPath: NSIndexPath) -> Void {
        
        self.foodCategoryEntity = entity
        
        self.isNeedLoad = false
        
        self.mealTitle.text = "食物\(indexPath.row + 1): \(entity.categoryName)"
        self.sizeLabel.text = "约\(Int(Float(entity.calorie) * 0.9))-\(Int(Float(entity.calorie) * 1.1))kcal"
        
        self.mealDescription.text = entity.detail
        self.mealDescription.preferredMaxLayoutWidth = UI_SCREEN_WIDTH - 30
        
        var xPoint: CGFloat = 0
        
        for url in entity.imgUrl {
         
            let imageView = UIImageView(frame: CGRectMake(xPoint, 0, UI_SCREEN_WIDTH, self.scrollView.height))
            imageView.contentMode = .ScaleAspectFit
            
            imageView.setImageWithURL(NSURL(string: url), placeholderImage:UIImage(named: "sportsdetails_normal"),options:.RetryFailed)
            
            self.scrollView.addSubview(imageView)
            xPoint += UI_SCREEN_WIDTH
        }
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSizeMake(xPoint, 0)
        
        self.pageCtrl.numberOfPages = entity.imgUrl.count
        
        if !entity.banFoods.isEmpty {
            self.banFoodsDescription.text = entity.banFoodsString
        } else {
            self.banFoodsEntryHeight.constant = 0
        }
    }
    
    func calculateHeightWithEntity(entity: XKRWFoodCategoryEntity) -> Void {
        
        self.mealTitle.text = "食物: \(entity.categoryName)"
        self.sizeLabel.text = "约\(Int(Float(entity.calorie) * 0.9))-\(Int(Float(entity.calorie) * 1.1))kcal"
        
        self.mealDescription.text = entity.detail
        self.mealDescription.preferredMaxLayoutWidth = UI_SCREEN_WIDTH - 30
        
        if !entity.banFoods.isEmpty {
            self.banFoodsDescription.text = entity.banFoodsString
        } else {
            self.banFoodsEntryHeight.constant = 0
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        self.pageCtrl.currentPage = Int(scrollView.contentOffset.x / UI_SCREEN_WIDTH)
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
