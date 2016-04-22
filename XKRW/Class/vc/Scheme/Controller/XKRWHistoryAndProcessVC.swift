//
//  XKRWHistoryAndProcessVC.swift
//  XKRW
//
//  Created by XiKang on 15/6/2.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit


class XKRWHistoryAndProcessVC: XKRWBaseVC, UITableViewDelegate, UITableViewDataSource, XKRWCalendarDelegate, HPMealCellDelegate, HPSportCellDelegate, UIAlertViewDelegate {
    
    var tableView: XKRWUITableViewBase!
    var calendar: XKRWCalendar!
    
    var loadingView: UIView!
    
    var isCalendarShown: Bool = false
    var selectedDate: NSDate = NSDate()
    var calendarDisplayDate: NSDate?
    
    var schemeReocrds:[XKRWRecordSchemeEntity] = []
    var oldRecord = XKRWRecordEntity4_0()
    
    var viewModel = XKRWHistoryAndProcessModel()
    
    var calendarTitleCell: XKRWCalendarTitleCell?
    
    var summaryCell: HPSummaryCell?
    var predictCell: HPPredictCell?
    var mealCell: HPMealCell!
    
    var sportCell: HPSportCell!
    var habitCell: HPHabitCell!
    
    var dataCenterCell: UITableViewCell!
    
    var rightNaviButton: UIBarButtonItem!
    
    var needReload: Bool = false
    var needShowTip: Bool = false
    
    var isLoad: Bool = false
    
    var recordDates: NSMutableArray!
    
//    var count: Int = 0
    
//    var startCountVc: Int = 0
//    var endCountVc: Int = 0
//    
//    var intoSwitch: Int = 0
//    let keySwitch = "\(XKRWUserDefaultService.getCurrentUserId())_into_switch"
    
    // MARK: - Initialization and system's functions
    override func viewDidLoad() {
        super.viewDidLoad()
        var day:Int! ;
        if(XKRWAlgolHelper.expectDayOfAchieveTarget() == nil){
            day = XKRWUserService.sharedService().getInsisted()
        }else{
            day = XKRWAlgolHelper.newSchemeStartDayToAchieveTarget()
        }
        
        self.title = String(format: "第%d天", day == 0 ? 1 : day)
        
        self.addNaviBarBackButton()

        func initSubviews() {
            
            self.loadingView = UIView(frame: self.view.bounds)
            self.loadingView.backgroundColor = XK_BACKGROUND_COLOR
            
            self.addNaviBarRightButtonWithNormalImageName("share", highlightedImageName: "share_p", selector: #selector(XKRWHistoryAndProcessVC.rightNaviBarButtonClicked))
            self.rightNaviButton = self.navigationItem.rightBarButtonItem
            
            self.tableView = XKRWUITableViewBase(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationController!.navigationBar.frame.size.height - UIApplication.sharedApplication().statusBarFrame.size.height), style: UITableViewStyle.Plain)
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.separatorStyle = .None
            self.tableView.backgroundColor = XK_BACKGROUND_COLOR
            
            self.tableView.registerNib(UINib(nibName: "XKRWCalendarTitleCell", bundle: nil), forCellReuseIdentifier: "calendarCell")
            self.tableView.registerNib(UINib(nibName: "HPSummaryCell", bundle: nil), forCellReuseIdentifier: "summaryCell")
            self.tableView.registerNib(UINib(nibName: "HPPredictCell", bundle: nil), forCellReuseIdentifier: "predictCell")
            self.tableView.registerNib(UINib(nibName: "HPMealCell", bundle: nil), forCellReuseIdentifier: "mealCell")
            self.tableView.registerNib(UINib(nibName: "HPSportCell", bundle: nil), forCellReuseIdentifier: "sportCell")
            self.tableView.registerNib(UINib(nibName: "HPHabitCell", bundle: nil), forCellReuseIdentifier: "habitCell")
            self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "dataCenterCell")
            
            self.tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 40))
            
            self.view.addSubview(self.tableView)
            
            if self.selectedDate.isDayEqualToDate(NSDate()) {
                
                self.summaryCell = self.tableView.dequeueReusableCellWithIdentifier("summaryCell") as? HPSummaryCell
                self.predictCell = self.tableView.dequeueReusableCellWithIdentifier("predictCell") as? HPPredictCell
            }
            
            self.mealCell = self.tableView.dequeueReusableCellWithIdentifier("mealCell") as! HPMealCell
            self.mealCell.delegate = self
            
            self.sportCell = self.tableView.dequeueReusableCellWithIdentifier("sportCell") as! HPSportCell
            self.sportCell.delegate = self
            
            self.habitCell = self.tableView.dequeueReusableCellWithIdentifier("habitCell") as! HPHabitCell
        }
        initSubviews()
        
        // Do any additional setup after loading the view.
        
        self.view.addSubview(self.loadingView)
        
        
        XKRWAppCommentUtil.shareAppComment().setEntryPageTimeWithPage(ANALYZEPAGE)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.needReload == true {
            
            XKRWCui.showProgressHud("")
            
            self.downloadWithTaskID("dealData", outputTask: { () -> AnyObject! in
                self.viewModel.dealWithSchemeRecords(&self.schemeReocrds, oldRecord: &self.oldRecord)
                return true
            })
            
        } else {
            self.needReload = true
        }
        
//        startCountVc = self.navigationController!.viewControllers.count

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        endCountVc = self.navigationController!.viewControllers.count
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
//        if endCountVc < startCountVc{
//            self.dealAppCommentCount()
//        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.isLoad {
            self.isLoad = true
            self.reloadReocrdOfDay(NSDate())
        }
        
        if self.calendar == nil {
            
            self.recordDates = XKRWRecordService4_0.sharedService().getUserRecordDateFromDB()
            
            self.calendar = XKRWCalendar(origin: CGPointMake(0, 44), recordDateArray: self.recordDates, headerType: .Simple, andResizeBlock: { () -> Void in
                
            },andMonthType:.Default)
            
          
            self.calendar.addBackToTodayButtonInFooterView()
            self.calendar.delegate = self
            self.calendar.reloadCalendar()
            
            self.needShowTip = XKRWSchemeService_5_0.sharedService.needShowTipsInHistoryAndProgress()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadReocrdOfDay(date: NSDate) -> Void {
        XKRWCui.showProgressHud("")
        self.selectedDate = date

        if self.selectedDate.isDayEqualToDate(NSDate()) {
            self.navigationItem.rightBarButtonItem = self.rightNaviButton
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem()
        }
        self.downloadWithTaskID("getAllRecord", outputTask: { () -> AnyObject! in
            
            self.schemeReocrds = XKRWRecordService4_0.sharedService().getSchemeRecordWithDate(self.selectedDate) as!       [XKRWRecordSchemeEntity]
            self.oldRecord = XKRWRecordService4_0.sharedService().getAllRecordOfDay(self.selectedDate) as XKRWRecordEntity4_0
            return true
        })
    }
    
    //MARK: - Networking
    
    override func shouldRespondForDefaultNotificationForDetailName(detailName: String!) -> Bool {
        return true
    }
    
    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {
        
        if taskID == "getAllRecord" {
            
            self.downloadWithTaskID("dealData", outputTask: { () -> AnyObject! in
                self.viewModel.dealWithSchemeRecords(&self.schemeReocrds, oldRecord: &self.oldRecord)
                return true
            })
            
        } else if taskID == "modifyRecord" {
            
            XKRWCui.hideProgressHud()
            
            if !self.recordDates.containsObject(self.selectedDate) {
                
                self.recordDates.addObject(self.selectedDate)
                self.calendar.reloadCalendar()
            }
            self.downloadWithTaskID("dealData", outputTask: { () -> AnyObject! in
                self.viewModel.dealWithSchemeRecords(&self.schemeReocrds, oldRecord: &self.oldRecord)
                return true
            })
            
        } else if taskID == "dealData" {
            
            self.tableView.reloadData()
            XKRWCui.hideProgressHud()
            
            if self.loadingView != nil {
                
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.loadingView.alpha = 0
                    }, completion: { (finished) -> Void in
                        self.loadingView.removeFromSuperview()
//                        self.loadingView = nil;
                })
            }
        }
    }
    
    override func handleDownloadProblem(problem: AnyObject!, withTaskID taskID: String!) {
        
        XKRWCui.hideProgressHud()
        
//        XKRWCui.showInformationHudWithText("获取数据错误")
        super.handleDownloadProblem(problem, withTaskID: taskID)
    }
    
    //MARK: - UITableView's delegate & datasource
    
    //MARK: Header
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section != 0 {
            return 10
        }
        return 0.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 10))
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    //MARK: Cell
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            if self.viewModel.isToday {
                return 3
            } else {
                return 1
            }
        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                
                self.summaryCell?.setContent(self.viewModel)
                return XKRWUtil.getViewSize(self.summaryCell?.contentView).height + 1
                
            } else if indexPath.row == 2 {
                return XKRWUtil.getViewSize(self.predictCell?.contentView).height + 1
                
            }
        } else if indexPath.section == 1 {
            
            if self.mealCell != nil && self.viewModel.summaryTitle != nil {
                
                self.mealCell.setCellContent(self.viewModel)
                return XKRWUtil.getViewSize(self.mealCell.contentView).height + 1
            }
            return 198
        } else if indexPath.section == 2{
            
            if self.sportCell != nil && self.viewModel.summaryTitle != nil {
                
                self.sportCell.setCellContent(self.viewModel)
                return XKRWUtil.getViewSize(self.sportCell.contentView).height + 1
            }
            return 140
        } else if indexPath.section == 3{
            
            if self.habitCell != nil && self.viewModel.summaryTitle != nil {
                
                self.habitCell.setContent(self.viewModel)
                return XKRWUtil.getViewSize(self.habitCell.contentView).height + 1
            }
            return 192
            
        }
        
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                if self.calendarTitleCell == nil {
                    
                    self.calendarTitleCell = (tableView.dequeueReusableCellWithIdentifier("calendarCell") as! XKRWCalendarTitleCell)
                    self.calendarTitleCell!.selectionStyle = .None
                    self.calendarTitleCell!.dateLabel.text = self.selectedDate.stringWithFormat("MM.dd")
                    
                    if self.calendarTitleCell!.clickAfterAction == nil {
                        
                        self.calendarTitleCell!.setBeforeAction({ () -> () in
                            
                            let date = self.selectedDate.offsetDay(-1)
                            
                            if self.checkSelectedDate(date) {
                                
                                self.reloadReocrdOfDay(date)
                                self.calendar.outerSetSelectedDate(date, andNeedReload: true)
                                self.calendarTitleCell!.dateLabel.text = self.selectedDate.stringWithFormat("MM.dd")
                                
                                if self.needShowTip {
                                    self.showTip()
                                }
                            }
                            
                        }, afterAction: { () -> () in
                            
                            let date = self.selectedDate.offsetDay(1)
                            
                            if self.checkSelectedDate(date) {
                                
                                self.reloadReocrdOfDay(date)
                                self.calendar.outerSetSelectedDate(date, andNeedReload: true)
                                self.calendarTitleCell!.dateLabel.text = self.selectedDate.stringWithFormat("MM.dd")
                                
                                if self.needShowTip {
                                    self.showTip()
                                }
                            }
                        })
                    }
                }
                return self.calendarTitleCell!
                
            } else if indexPath.row == 1 {
                return self.summaryCell!
                
            } else if indexPath.row == 2 {
                
                self.predictCell?.setContent(self.viewModel)
                return self.predictCell!
            }
        } else if indexPath.section == 1 {
            
            return self.mealCell
            
        } else if indexPath.section == 2 {
            
            return self.sportCell
            
        } else if indexPath.section == 3 {
            
            weak var weakSelf = self
            
            self.habitCell.clickModifyAction = {
                
                let popView = KMPopAlertView(frame: CGRectMake(0, 0, 270, 100))
                let hpHabitChangeView = HPChangeHabitView()
                hpHabitChangeView.setContent(self.oldRecord)
                
                hpHabitChangeView.clickConfirmAction = {
                    
                    XKRWCui.showProgressHud("")
                    weakSelf?.downloadWithTaskID("modifyRecord", outputTask: { () -> AnyObject! in
                        return XKRWRecordService4_0.sharedService().saveRecord(weakSelf?.oldRecord, ofType: XKRWRecordType.Habit)
                    })
                    popView.hide()
                }
                
                popView.addSubview(hpHabitChangeView)
                popView.height = hpHabitChangeView.height
                popView.show()
            }
            return self.habitCell
        } else if indexPath.section == 4 {
        
            if self.dataCenterCell == nil {
                self.dataCenterCell = tableView.dequeueReusableCellWithIdentifier("dataCenterCell")
                
                let dataCenterView = NSBundle.mainBundle().loadNibNamed("XKRWMoreView", owner: self, options: nil)[0] as! XKRWMoreView
                dataCenterView.frame = CGRect(x: 0, y: 0, width: UI_SCREEN_WIDTH, height: 44)
                
                    dataCenterView.pushLabel.text = "阶段分析"
                dataCenterView.userInteractionEnabled = false
               
                self.dataCenterCell.addSubview(dataCenterView)

            }
            
         return dataCenterCell
            
        }
        return UITableViewCell()
    }
    
    // MARK: Action
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                self.showCalendar(!isCalendarShown)
            }
        } else if indexPath.section == 4 {
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
            MobClick.event("in_data2")
            let vc = XKRWDataCenterVC()
            vc.selectedIndex = 1
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Calendar's Delegate
    
    func calendarSelectedDate(date: NSDate!) {
        
        if self.checkSelectedDate(date) {
            self.reloadReocrdOfDay(date)
            
            if self.needShowTip {
                self.showTip()
            }
        }
        self.showCalendar(false)
    }
    
    func checkSelectedDate(date: NSDate) -> Bool {
        
        if date.originTimeOfADay() > NSDate().originTimeOfADay() {
            XKRWCui.showInformationHudWithText("不能查看今天以后的日期哦~")
            return false
        }
        
        // TODO: get regist date
        
        let regDateInterval = NSDate(fromString: XKRWUserService.sharedService().getREGDate(), withFormat: "yyyy-MM-dd").timeIntervalSince1970
//        let resetDateInterval = XKRWUserService.sharedService().getResetTime().integerValue
        
        if date.originTimeOfADay() < regDateInterval {
            
            self.calendar.outerSetSelectedDate(self.selectedDate, andNeedReload: false)
            XKRWCui.showInformationHudWithText("不能查看注册以前的日期哦~")
            return false
        }
        return true
    }
    
    func calendarScrollToNextMonth() {
        
        self.calendarDisplayDate = self.calendarDisplayDate?.offsetMonth(1)
        self.calendarTitleCell?.dateLabel.text = self.calendarDisplayDate?.stringWithFormat("MM月")
    }
    
    func calendarScrollToPreMonth() {
        
        self.calendarDisplayDate = self.calendarDisplayDate?.offsetMonth(-1)
        self.calendarTitleCell?.dateLabel.text = self.calendarDisplayDate?.stringWithFormat("MM月")
    }
    
    
    // MARK: - HPMealCell delegate
    
    func HPMealCellClickAction(cell: HPMealCell, clickButtonTag tag: Int) {
        
        let recordValue = tag % 100
        
        switch Int(tag / 100) {
        case 1:
            
            if recordValue == 3 {
                
                let vc = XKRWRecordOthersVC(nibName: "XKRWRecordOthersVC", bundle: nil)
                vc.recordEntity = self.oldRecord
                vc.schemeEntity = self.viewModel.breakfast
                
                vc.type = XKRWSchemeType.Breakfast
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                if self.viewModel.breakfast != nil {
                    self.viewModel.breakfast?.record_value = recordValue
                } else {
                    
                    let entity = XKRWRecordSchemeEntity()
                    entity.create_time = Int(self.selectedDate.timeIntervalSince1970)
                    entity.type = RecordType.Breakfirst
                    entity.record_value = recordValue
                    
                    self.viewModel.breakfast = entity
                }
                XKRWCui.showProgressHud("")
                self.downloadWithTaskID("modifyRecord", outputTask: { () -> AnyObject! in
                    return XKRWRecordService4_0.sharedService().saveRecord(self.viewModel.breakfast!, ofType: XKRWRecordType.Scheme)
                })
            }
            
        case 2:
            if recordValue == 3 {
                
                let vc = XKRWRecordOthersVC(nibName: "XKRWRecordOthersVC", bundle: nil)
                vc.recordEntity = self.oldRecord
                vc.schemeEntity = self.viewModel.lunch

                vc.type = XKRWSchemeType.Lunch
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                if viewModel.lunch != nil {
                    viewModel.lunch?.record_value = recordValue
                } else {
                    
                    let entity = XKRWRecordSchemeEntity()
                    entity.create_time = Int(self.selectedDate.timeIntervalSince1970)
                    entity.type = RecordType.Lanch
                    entity.record_value = recordValue
                    
                    viewModel.lunch = entity;
                }
                XKRWCui.showProgressHud("")
                self.downloadWithTaskID("modifyRecord", outputTask: { () -> AnyObject! in
                    return XKRWRecordService4_0.sharedService().saveRecord(self.viewModel.lunch!, ofType: XKRWRecordType.Scheme)
                })
            }
            
        case 3:
            if recordValue == 3 {
                
                let vc = XKRWRecordOthersVC(nibName: "XKRWRecordOthersVC", bundle: nil)
                vc.recordEntity = self.oldRecord
                vc.schemeEntity = self.viewModel.dinner

                vc.type = XKRWSchemeType.Dinner
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                
                if viewModel.dinner != nil {
                    viewModel.dinner?.record_value = recordValue
                } else {
                    
                    let entity = XKRWRecordSchemeEntity()
                    entity.create_time = Int(self.selectedDate.timeIntervalSince1970)
                    entity.type = RecordType.Dinner
                    entity.record_value = recordValue
                    
                    viewModel.dinner = entity;
                }
                XKRWCui.showProgressHud("")
                self.downloadWithTaskID("modifyRecord", outputTask: { () -> AnyObject! in
                    return XKRWRecordService4_0.sharedService().saveRecord(self.viewModel.dinner!, ofType: XKRWRecordType.Scheme)
                })
            }
        default:
            break
        }
    }
    
    func HPMealCellClickActionToRecord(cell: HPMealCell) {
        
        MobClick.event("clk_FoodMark")
        
        self.popView()
    }
    
    func HPMealCellClickAnalsisButton(cell: HPMealCell) {
        
        MobClick.event("clk_FoodAnalysis")
        
        self.needReload = false
        
        let vc = XKRWHPMealAnalysisVC(nibName: "XKRWHPMealAnalysisVC", bundle: nil)
        vc.viewModel = self.viewModel
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Sport Cell's Delegate
    
    func SportCell(cell: HPSportCell, clickModifyButtonIndex index: Int) {
        
        if self.viewModel.sport != nil {
            
            if index != 3 {
                self.viewModel.sport?.record_value = index
            } else {
                // to other record
                let vc = XKRWRecordOthersVC(nibName: "XKRWRecordOthersVC", bundle: nil)
                vc.type = .Sport
                vc.recordEntity = self.oldRecord
                vc.schemeEntity = self.viewModel.sport
                
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            
        } else {
            
            let entity = XKRWRecordSchemeEntity()
            entity.create_time = Int(self.selectedDate.timeIntervalSince1970)
            entity.type = RecordType.Sport
            
            self.viewModel.sport = entity
            
            if index != 3 {
                self.viewModel.sport?.record_value = index
            } else {
                // to other record
                
                let vc = XKRWRecordOthersVC(nibName: "XKRWRecordOthersVC", bundle: nil)
                vc.type = .Sport
                vc.recordEntity = self.oldRecord
                vc.schemeEntity = XKRWRecordService4_0.sharedService().getSchemeRecordWithDate(self.selectedDate, type: RecordType.Sport)
                
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
        }
        XKRWCui.showProgressHud("")
        self.downloadWithTaskID("modifyRecord", outputTask: { () -> AnyObject! in
            return XKRWRecordService4_0.sharedService().saveRecord(self.viewModel.sport!, ofType: XKRWRecordType.Scheme)
        })
    }
    
    func SportCellClickToRecordButton(cell: HPSportCell) {
        
        MobClick.event("clk_SportMark")
        self.popView()
    }
    
//    // MARK: - UIAlertView's delegate 
//    
//    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
//        
//        if buttonIndex != alertView.cancelButtonIndex {
//            
//            let string = "itms-apps://itunes.apple.com/app/id622478622"
//            UIApplication.sharedApplication().openURL(NSURL(string: string)!)
//            
//            self.intoSwitch = 1 // 1.永远不开启了
//            
//        }else{
//            self.intoSwitch = 2 // 2.五次出入开启
//        }
//        
//        NSUserDefaults.standardUserDefaults().setObject(self.intoSwitch, forKey: keySwitch)
//        NSUserDefaults.standardUserDefaults().synchronize()
//    }
    
    // MARK: - Other functions
    
    func showCalendar(show: Bool) -> Void {
        self.isCalendarShown = show
        
        if show {
            
            MobClick.event("clk_calendar")
            
            self.calendarDisplayDate = self.selectedDate
            
            let button = UIButton(type: UIButtonType.Custom)
            button.frame = self.view.bounds
            button.addTarget(self, action: #selector(XKRWHistoryAndProcessVC.hideCalendar(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            button.tag = 103267
            
            self.view.addSubview(button)
            
            self.tableView.scrollEnabled = false
            
            self.calendar.alpha = 0.0
            self.view.addSubview(self.calendar)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.calendarTitleCell?.dateLabel.text = self.selectedDate.stringWithFormat("MM月")
                self.calendar.alpha = 1
            })
        } else {
            
            self.tableView.scrollEnabled = true
            
            if let button = self.view.viewWithTag(103267) {
                button.removeFromSuperview()
            }
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.calendarTitleCell?.dateLabel.text = self.selectedDate.stringWithFormat("MM.dd")
                self.calendar.alpha = 0.0
            }, completion: { (finish) -> Void in
                
                self.calendar.removeFromSuperview()
            })
        }
    }
    
    func rightNaviBarButtonClicked() {
        
        if self.viewModel.predictLoseWeight != nil {
            
            MobClick.event("clk_Share")
            
            let shareVC = XKRWShareCourseVC(nibName: "XKRWShareCourseVC", bundle: nil)
            
            shareVC.registDays = XKRWUserService.sharedService().getInsisted()
            shareVC.loseWeightString = self.viewModel.predictLoseWeight!
            
            self.presentViewController(shareVC, animated: true) { () -> Void in
                
            }
        }
    }
    
    func hideCalendar(sender: UIButton) -> Void {
         
        self.showCalendar(false)
        sender.removeFromSuperview()
    }
    
    func showTip() -> Void {
        
        let tipsView = KMHeaderTips(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 64), text: "至多补记最近两天历程，\n两天以前不能补记", type: KMHeaderTipsType.Default)
        
        self.view.addSubview(tipsView)
        tipsView.startAnimationWithStartOrigin(CGPointMake(0, -tipsView.height), endOrigin: CGPointMake(0, 0))
        
        self.needShowTip = false
        XKRWSchemeService_5_0.sharedService.setNeedShowTipsInHistoryAndProgress(false)
        
        return
    }

    override func popView() {
//            self.dealAppCommentCount()
            super.popView()
    }
    
//    func dealAppCommentCount() {
//        
//        if self.intoSwitch == 0 {
//            
//            let alert = UIAlertView(title: nil, message: "妈妈说喜欢我们就会瘦,\n不信你试试啊！", delegate: self, cancelButtonTitle: "就不试，狗带吧！")
//            alert.addButtonWithTitle("我要瘦，我要瘦！")
//            alert.addButtonWithTitle("呵呵，可以吐槽吗？")
//            alert.show()
//            
//        } else if self.intoSwitch == 2 {
//            
//            if self.count%5 == 0 {
//                let alert = UIAlertView(title: nil, message: "妈妈说喜欢我们就会瘦,\n不信你试试啊！", delegate: self, cancelButtonTitle: "就不试，狗带吧！")
//                alert.addButtonWithTitle("我要瘦，我要瘦！")
//                alert.addButtonWithTitle("呵呵，可以吐槽吗？")
//                alert.show()
//            }
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
