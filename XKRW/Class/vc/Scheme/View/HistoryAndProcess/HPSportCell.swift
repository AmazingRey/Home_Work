//
//  HPSportCell.swift
//  XKRW
//
//  Created by Klein Mioke on 15/7/20.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class HPSportCell: XKRWUITableViewCellbase,UITableViewDelegate {

    @IBOutlet weak var content: UIView!
    weak var model : XKRWHistoryAndProcessModel?
    
    lazy var labTitle : UILabel = {
        var tmpTitle : UILabel = UILabel()
        tmpTitle.text = "运动消耗"
        tmpTitle.textAlignment = .Center
        tmpTitle.textColor = XK_TITLE_COLOR
        return tmpTitle
    }()
    
    lazy var labCal : UILabel = {
        var tmpCal :UILabel = UILabel()
//        tmpCal.text = "\(self.model!.costCalorie)kcal"
        tmpCal.text = String(format:"%.0f",self.model!.costCalorie)
        tmpCal.font = UIFont.systemFontOfSize(27)
        tmpCal.textAlignment = .Center
        tmpCal.textColor = XK_MAIN_TONE_COLOR
        return tmpCal
    }()
    
    lazy var tableView : UITableView = {
        var tmpTable : UITableView = UITableView()
        tmpTable.delegate = self
        return tmpTable
    }()
    
    lazy var imgView : UIImageView = {
        var tmpImg : UIImageView = UIImageView()
        return tmpImg
    }()
    
    func makeContentView(viewModel:XKRWHistoryAndProcessModel) -> Void {
        self.model = viewModel
    }
    
    func setCellContent(viewModel: XKRWHistoryAndProcessModel) -> Void {
        self.makeContentView(viewModel)
        for view in self.content.subviews {
            view.removeFromSuperview()
        }
        if viewModel.sportState == .Show {
        }else{
            let label = UILabel(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 20))
            label.center = CGRectGetCenter(self.content.bounds)
            label.setX(0)
            
            label.textAlignment = .Center
            label.textColor = XK_TEXT_COLOR
            label.font = UIFont.systemFontOfSize(14)
            
            label.text = "ta今天没有运动记录哦"
            self.content.addSubview(label)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
