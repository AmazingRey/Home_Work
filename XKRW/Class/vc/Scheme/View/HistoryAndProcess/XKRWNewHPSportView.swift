//
//  XKRWNewHPSportView.swift
//  XKRW
//
//  Created by ss on 16/5/11.
//  Copyright © 2016年 XiKang. All rights reserved.
//

import UIKit

class XKRWNewHPSportView: UIView,UITableViewDelegate,UITableViewDataSource {
    weak var model : XKRWUserInfoShowEntity?
    
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
        tmpCal.text = "\(self.model!.sportCalories)kcal"
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
        tmpTable.rowHeight = 33
        tmpTable.backgroundColor = UIColor.clearColor()
        self.addSubview(tmpTable)
        return tmpTable
    }()
    
    lazy var imgView : UIImageView = {
        var tmpImg : UIImageView = UIImageView()
        var imgName = "";
        if self.model!.sportArray.count == 2{
            if (UI_SCREEN_HEIGHT == 320) {
                imgName = "date_indicator320_Big"
            }else{
                imgName = "date_indicator_Big"
            }
        }else if self.model!.sportArray.count <= 1{
            if (UI_SCREEN_HEIGHT == 320) {
                imgName = "date_indicator320_Small"
            }else{
                imgName = "date_indicator_Small"
            }
        }
        tmpImg.image = UIImage(named:imgName)
        self.addSubview(tmpImg)
        return tmpImg
    }()
    
    func setSportView(entity:XKRWUserInfoShowEntity) -> Void {
        self.model = entity
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
        
        if (!(self.model?.isRecord)!){
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
                make.height.mas_equalTo()(80.0 + CGFloat( self.model!.sportArray.count) * 33.0)
                make.top.mas_equalTo()(self.labCal.mas_bottom).offset()(10)
            }
            self.imgView.mas_makeConstraints{(make) in
                make.left.mas_equalTo()(32)
                make.width.mas_equalTo()(UI_SCREEN_WIDTH - 64)
                make.height.mas_equalTo()(CGFloat(self.model!.sportArray.count == 0 ? 33:self.model!.sportArray.count * 33)+15)
                make.top.mas_equalTo()(self.labCal.mas_bottom)
                make.bottom.mas_equalTo()(self.tableView.mas_bottom);
                
                var imgName = ""
                if self.model!.sportArray.count == 2{
                    if (UI_SCREEN_WIDTH == 320) {
                        imgName = "date_indicator320_Big"
                    }else{
                        imgName = "date_indicator_Big"
                    }
                }else {
                    if (UI_SCREEN_WIDTH == 320) {
                        imgName = "date_indicator320_Small"
                    }else{
                        imgName = "date_indicator_Small"
                    }
                }
                let img = UIImage(named:imgName)
                
                let stretchImg = img!.resizableImageWithCapInsets(UIEdgeInsetsMake(20, 25, 25, 25))
                self.imgView.image = stretchImg;
            }
        }
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return self.model!.sportArray.count == 0 ? 1:self.model!.sportArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if let cell:XKRWDailyAnalysizeCell = tableView.dequeueReusableCellWithIdentifier("dailyAnalysizeCell", forIndexPath:indexPath) as? XKRWDailyAnalysizeCell{
            if self.model!.sportArray.count == 0{
                cell.labLeft.text = "无记录"
                cell.labRight.text = ""
            }else{
                if let dic : NSDictionary = self.model!.sportArray.objectAtIndex(indexPath.row) as? NSDictionary{
                    cell.labLeft.text =   dic.objectForKey("text") as? String
                    cell.labRight.text =  NSString(format: "%ldkal",(dic.objectForKey("calorie")?.integerValue)!) as String
                }
            }
            return cell
        }else{
            let cell: XKRWDailyAnalysizeCell = XKRWDailyAnalysizeCell(style: .Default, reuseIdentifier: "dailyAnalysizeCell")
            cell.labLeft.text = ""
            cell.labRight.text = ""
            return cell
        }
    }
}
