//
//  XKRWArticleSectionCell.swift
//  XKRW
//
//  Created by Klein Mioke on 15/9/18.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWArticleSectionCell: UITableViewCell {
    
    var isEdit: Bool = true {
        didSet {
            if !isEdit {
                yPoint = 0
                self.moreButton.removeFromSuperview()
                self.sectionTitle.removeFromSuperview()
                self.topLine.removeFromSuperview()
            }
        }
    }
    
    private var yPoint: CGFloat = 44.0
    
    var indexPath: NSIndexPath?
    
    var content: XKRWArticleSectionView!
    
    var sectionTitle: UILabel!
    var moreButton: UIButton!
    
    var topLine: UIView!
    
    var moreButtonClickAction:(Void -> Void)?
    var imageClickHandler: ((indexPath: NSIndexPath, imageIndex: Int) -> Void)?
    
    var actionEnable: Bool {
        set {
            self.content.userInteractionEnabled = newValue
        }
        get {
            return self.content.userInteractionEnabled
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        self.contentView.clipsToBounds = true
        
        self.sectionTitle = {
            
            let label = UILabel(frame: CGRectMake(15, 8, 160, 28))
            label.font = UIFont.systemFontOfSize(14)
            label.textColor = XK_ASSIST_TEXT_COLOR
            
            self.contentView.addSubview(label)
            return label
        }()
        
        self.moreButton = {
            let button = UIButton(frame: CGRectMake(UI_SCREEN_WIDTH - 50, 0, 50, 44))
            button.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
            button.backgroundColor = UIColor.clearColor()
            button.setImage(UIImage(named: "point_of_more"), forState: UIControlState.Normal)
            button.imageView?.contentMode = UIViewContentMode.Center
            
            button.addTarget(self, action: "clickMoreAction", forControlEvents: .TouchUpInside)
            
            self.contentView.addSubview(button)
            return button
        }()
        
        self.topLine = {
           
            let line = UIView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5))
            line.backgroundColor = XK_ASSIST_LINE_COLOR
            
            self.contentView.addSubview(line)
            return line
        }()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContentWithText(text: String, imageURLs: [String]?, ifHaveImages images: [UIImage]?, sectionNumber: Int) -> Void {
        
        self.sectionTitle.text = "第\(sectionNumber)段"
        
        if self.content != nil {
            self.content.removeFromSuperview()
        }
        
        self.content = XKRWArticleSectionView(frame: CGRectMake(0, self.yPoint, UI_SCREEN_WIDTH, 0))
        self.content.setContentWithText(text, imageURLs: imageURLs, ifHaveImages: images)
        
        self.content.clickHandler = { (index: Int) -> Void in
            if self.indexPath != nil {
                self.imageClickHandler?(indexPath: self.indexPath!, imageIndex: index)
            }
        }
        
        self.contentView.addSubview(self.content)
        
        self.contentView.height = self.content.bottom
        self.height = self.contentView.height + 1
    }

    func clickMoreAction() -> Void {
        self.moreButtonClickAction?()
    }
}
