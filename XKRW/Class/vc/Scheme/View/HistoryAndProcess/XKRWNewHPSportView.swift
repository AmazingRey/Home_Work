//
//  XKRWNewHPSportView.swift
//  XKRW
//
//  Created by ss on 16/5/11.
//  Copyright © 2016年 XiKang. All rights reserved.
//

import UIKit

class XKRWNewHPSportView: UIView,UITableViewDelegate,UITableViewDataSource {
    weak var model : XKRWHistoryAndProcessModel?
    
    lazy var labHead : UILabel = {
        var tmpHead : UILabel = UILabel()
        tmpHead.text = "今日运动"
        tmpHead.textAlignment = .Left
        tmpHead.font = UIFont.systemFontOfSize(17)
        tmpHead.textColor = XK_TITLE_COLOR
        self.addSubview(tmpHead)
        return tmpHead
    }()
    
    lazy var imgHead : UIImageView = {
        var tmpimgHead : UIImageView = UIImageView()
        tmpimgHead.image = UIImage(named:"progress_ic_sport.png")
        self.addSubview(tmpimgHead)
        return tmpimgHead
    }()


    lazy var labTitle : UILabel = {
        var tmpTitle : UILabel = UILabel()
        tmpTitle.text = "运动消耗"
        tmpTitle.textAlignment = .Center
        tmpTitle.textColor = XK_TITLE_COLOR
        self.addSubview(tmpTitle)
        return tmpTitle
    }()
    
    lazy var labCal : UILabel = {
        var tmpCal :UILabel = UILabel()
        //        tmpCal.text = "\(self.model!.costCalorie)kcal"
        tmpCal.text = String(format:"%.0f",self.model!.costCalorie)
        tmpCal.font = UIFont.systemFontOfSize(27)
        tmpCal.textAlignment = .Center
        tmpCal.textColor = XK_MAIN_TONE_COLOR
        self.addSubview(tmpCal)
        return tmpCal
    }()
    
    lazy var labNodata : UILabel = {
        var tmpNodata :UILabel = UILabel()
        //        tmpCal.text = "\(self.model!.costCalorie)kcal"
        tmpNodata.text = "ta今天没有运动记录哦"
        tmpNodata.font = UIFont.systemFontOfSize(14)
        tmpNodata.textAlignment = .Center
        tmpNodata.textColor = XK_TEXT_COLOR
        self.addSubview(tmpNodata)
        return tmpNodata
    }()
    
    lazy var tableView : UITableView = {
        var tmpTable : UITableView = UITableView()
        tmpTable.delegate = self
        tmpTable.dataSource = self
        tmpTable.registerNib(UINib(nibName:"XKRWDailyAnalysizeCell" ,bundle:nil), forCellReuseIdentifier: "dailyAnalysizeCell")
        tmpTable.scrollEnabled = false
        tmpTable.separatorStyle = .None
        tmpTable.backgroundColor = UIColor.clearColor()
        self.addSubview(tmpTable)
        return tmpTable
    }()
    
    lazy var imgView : UIImageView = {
        var tmpImg : UIImageView = UIImageView()
        var imgName = "";
        if (UI_SCREEN_HEIGHT == 320) {
            imgName = "date_indicator320_Big"
        }else{
            imgName = "date_indicator_Big"
        }
        tmpImg.image = UIImage(named:imgName)
        self.addSubview(tmpImg)
        return tmpImg
    }()
    
    func setSportView(model:XKRWHistoryAndProcessModel) -> Void {
        self.model = model
        self.addMasonryLayOut()
    }

    func addMasonryLayOut(){
        self.imgHead.mas_makeConstraints { (make) in
            make.left.mas_equalTo()(5)
            make.top.mas_equalTo()(self.mas_top).offset()(5)
            make.width.and().height().mas_equalTo()(31)
        }
        self.labHead.mas_makeConstraints { (make) in
            make.centerY.mas_equalTo()(self.imgHead.mas_centerY)
            make.left.mas_equalTo()(self.imgHead.mas_right).offset()(5)
            make.width.mas_equalTo()(70)
            make.height.mas_equalTo()(40)
        }
        
        if (self.model?.sportState != .Show || self.model?.costCalorie == 0) {
            self.labNodata.mas_makeConstraints { (make) in
                make.centerX.mas_equalTo()(self.mas_centerX)
                make.centerY.mas_equalTo()(self.mas_centerY)
            }
        }else{
            self.labTitle.mas_makeConstraints { (make) in
                make.centerX.mas_equalTo()(self.mas_centerX)
                make.top.mas_equalTo()(self.mas_top).offset()(25)
            }
            self.labCal.mas_makeConstraints { (make) in
                make.width.mas_equalTo()(UI_SCREEN_WIDTH)
                make.height.mas_equalTo()(40)
                make.centerX.mas_equalTo()(self.mas_centerX)
                make.top.mas_equalTo()(self.labTitle.mas_bottom);
            }
            self.tableView.mas_makeConstraints{(make) in
                make.left.mas_equalTo()(32)
                make.width.mas_equalTo()(UI_SCREEN_WIDTH - 64)
                make.height.mas_equalTo()(80)
                make.top.mas_equalTo()(self.labCal.mas_bottom).offset()(10)
            }
            self.imgView.mas_makeConstraints{(make) in
                make.left.mas_equalTo()(32)
                make.width.mas_equalTo()(UI_SCREEN_WIDTH - 64)
                make.height.mas_equalTo()(80)
                make.top.mas_equalTo()(self.labCal.mas_bottom)
                make.bottom.mas_equalTo()(self.tableView.mas_bottom);
            }
        }
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if let cell:XKRWDailyAnalysizeCell = tableView.dequeueReusableCellWithIdentifier("dailyAnalysizeCell", forIndexPath:indexPath) as? XKRWDailyAnalysizeCell{
            switch indexPath.row {
            case 0:
                cell.labLeft.text = "跑步"
            default:
                cell.labLeft.text = "扯淡"
            }
            cell.labRight.text = "45分钟"
            return cell
        }else{
            let cell: XKRWDailyAnalysizeCell = XKRWDailyAnalysizeCell(style: .Default, reuseIdentifier: "dailyAnalysizeCell")
            cell.labLeft.text = "asdadf"
            cell.labRight.text = "xcvxcvzxcv"
            return cell
        }
    }
}
