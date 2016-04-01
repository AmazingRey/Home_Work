//
//  XKRWSchemeVC_5_0.swift
//  XKRW
//
//  Created by XiKang on 15/5/25.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWSchemeVC_5_0: XKRWBaseVC, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, UISearchControllerDelegate, XKRWSchemeChooseHeaderDelegate, KMSearchDisplayControllerDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, IFlyRecognizerViewDelegate, UIAlertViewDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var surfaceView: XKRWSurfaceView?

    var rightNaviButton: UIButton!
    
    var searchBar: KMSearchBar?
    var searchDisplayCtrl: KMSearchDisplayController?

    var weightView: XKRWWeightGoalView?
    var choiseHeader: XKRWSchemeChooseHeader = XKRWSchemeChooseHeader(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 44))
    var scrollCell: XKRWSchemeScrollCell = XKRWSchemeScrollCell(style: UITableViewCellStyle.Default, reuseIdentifier: "scrollCell")
    var habitCell: XKRWHabitRecordCell!
    
    let computeCell: XKRWMealSchemeCell = loadViewFromBundle("XKRWMealSchemeCell", owner: nil) as! XKRWMealSchemeCell
    var iFlyControl: IFlyRecognizerView!
    
    var ADView: XKRWADView?
    
    // MARK: - Data Properties
    
    var is_M:Int = 0
    
    var isAdOn: Bool = false
    var keyboardHeight: CGFloat = 0.0
    
    private let MAX_SEARCH_RESULT = 3
    
    var foodsCount: Int = 0
    var sportsCount: Int = 0
    
    var backFromReocrd: Bool = false
    
    var needReloadTableView: UITableView?
    var needReloadIndexPath: NSIndexPath?
    
    var isLoad: Bool = false
    var isContentLoading = true
    
    var isLoadMealFailed: Bool = false
    var isLoadSportFailed: Bool = false
    
    var recordEntity: XKRWRecordEntity4_0?
    var mealSchemes: [XKRWSchemeEntity_5_0] = []
    var sportScheme: XKRWSchemeEntity_5_0 = XKRWSchemeEntity_5_0()
    
    var mealRecords: [XKRWRecordSchemeEntity] = []
    var sportRecord: XKRWRecordSchemeEntity = XKRWRecordSchemeEntity()
    
    var foodsArray = [XKRWFoodEntity]()
    var sportsArray = [XKRWSportEntity]()
    var searchKey: String?
    
    
    // MARK: -
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - System functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        XKRWAppCommentUtil.shareAppComment().setEntryPageTimeWithPage(SCHEMEPAGE)
        
       
        
        XKRWSchemeNotificationService .shareService().registerLocalNotification();
        
        //新用户登录的时候 
        if(NSUserDefaults.standardUserDefaults().boolForKey("NewUserLogin")){
            let uid = "\(XKRWUserDefaultService.getCurrentUserId())"
            XKRWSchemeNotificationService.cancelAllLocalNotificationExcept("uid", value: uid)
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "NewUserLogin")
        }

        
        // Do any additional setup after loading the view.
        
        // load data
        self.recordEntity = XKRWRecordService4_0.sharedService().getAllRecordOfDay(NSDate())
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow", name: UIKeyboardFrameEndUserInfoKey, object: nil)
        
        self.edgesForExtendedLayout = UIRectEdge.All
        
        self.isAdOn = false
        
        // load subviews
        func initSubviews() {
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
            
            self.title = "方案"
            self.searchBar = KMSearchBar(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 44))
            
            self.searchBar?.delegate = self
            self.searchBar?.barTintColor = XKGrayDefaultColor
            self.searchBar?.layer.borderWidth = 0.5
            self.searchBar?.layer.borderColor = XK_ASSIST_LINE_COLOR.CGColor
            
            self.tableView.tableHeaderView = self.searchBar
            
            self.searchBar?.showsBookmarkButton = true
            self.searchBar?.showsScopeBar = true
            
            self.searchBar?.setImage(UIImage(named: "voice"), forSearchBarIcon: UISearchBarIcon.Bookmark, state: UIControlState.Normal)
            self.searchBar?.placeholder = "查询食物和运动"
            
            self.searchDisplayCtrl = KMSearchDisplayController(searchBar: self.searchBar, contentsController: self)
            self.searchDisplayCtrl?.delegate = self
            
            self.searchDisplayCtrl?.searchResultDelegate = self
            self.searchDisplayCtrl?.searchResultDataSource = self
            
            self.searchDisplayCtrl?.searchResultTableView.tag = 201
            self.searchDisplayCtrl?.searchResultTableView.registerNib(UINib(nibName: "XKRWSearchResultCell", bundle: nil), forCellReuseIdentifier: "searchResultCell")
            self.searchDisplayCtrl?.searchResultTableView.registerNib(UINib(nibName: "XKRWSearchResultCategoryCell", bundle: nil), forCellReuseIdentifier: "searchResultCategoryCell")
            self.searchDisplayCtrl?.searchResultTableView.registerNib(UINib(nibName: "XKRWMoreSearchResultCell", bundle: nil), forCellReuseIdentifier: "moreSearchResultCell")
            self.tableView.registerNib(UINib(nibName: "XKRWHabitRecordCell", bundle: nil), forCellReuseIdentifier: "habitCell")
            
            self.searchDisplayCtrl?.searchResultTableView.separatorStyle = .None
            
            let searchText = UILabel(frame: CGRectMake(0, 50, UI_SCREEN_WIDTH, 30))
            searchText.text = "查询"
            searchText.textColor = XK_ASSIST_TEXT_COLOR
            searchText.font = UIFont.systemFontOfSize(24)
            searchText.textAlignment = .Center
            
            let icons = UIImageView(image: UIImage(named: "search_ic_"))
            icons.center = CGPointMake(UI_SCREEN_WIDTH / 2, searchText.bottom + 10 + icons.height / 2)
            
            self.searchDisplayCtrl?.backgroundContentView.addSubview(searchText)
            self.searchDisplayCtrl?.backgroundContentView.addSubview(icons)
            
            let food = UILabel(frame: CGRectMake(icons.left, icons.bottom + 5, 50, 30))
            food.textAlignment = .Left
            food.text = "食物"
            food.font = UIFont.systemFontOfSize(14)
            food.textColor = XK_ASSIST_TEXT_COLOR
            
            self.searchDisplayCtrl?.backgroundContentView.addSubview(food)
            
            let meal = UILabel(frame: CGRectMake(UI_SCREEN_WIDTH / 2 - 25, icons.bottom + 5, 50, 30))
            meal.textAlignment = .Center
            meal.text = "菜肴"
            meal.font = UIFont.systemFontOfSize(14)
            meal.textColor = XK_ASSIST_TEXT_COLOR
            
            self.searchDisplayCtrl?.backgroundContentView.addSubview(meal)
            
            let sport = UILabel(frame: CGRectMake(icons.right - 54, icons.bottom + 5, 50, 30))
            sport.textAlignment = .Right
            sport.text = "运动"
            sport.font = UIFont.systemFontOfSize(14)
            sport.textColor = XK_ASSIST_TEXT_COLOR
            
            self.searchDisplayCtrl?.backgroundContentView.addSubview(sport)
        
            self.addNaviBarRightButtonWithText("分析", action: "rightNaviBarButtonClicked")
          
            weightView = XKRWWeightGoalView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 116.5))
            
            self.choiseHeader.delegate = self
            
            self.scrollCell.delegate = self
            
            self.tableView.registerNib(UINib(nibName: "XKRWMealSchemeCell", bundle: nil), forCellReuseIdentifier: "computeCell")
            
            self.iFlyControl = IFlyRecognizerView(center: CGPointMake((UI_SCREEN_WIDTH)/2, UI_SCREEN_HEIGHT/2))
            self.iFlyControl.setParameter("iat", forKey: IFlySpeechConstant.IFLY_DOMAIN())
            self.iFlyControl.setParameter("asrview.pcm", forKey: IFlySpeechConstant.ASR_AUDIO_PATH())
            self.iFlyControl.setParameter("20000", forKey: IFlySpeechConstant.NET_TIMEOUT())
            self.iFlyControl.setParameter("16000", forKey: IFlySpeechConstant.SAMPLE_RATE())
            self.iFlyControl.setParameter("plain", forKey: IFlySpeechConstant.RESULT_TYPE())
            self.iFlyControl.setParameter("1", forKey: IFlySpeechConstant.ASR_PTT())
            self.iFlyControl.setParameter(IFLY_AUDIO_SOURCE_MIC, forKey: "audio_source")
            self.iFlyControl.delegate = self
            self.iFlyControl.hidden = true
            self.view.addSubview(self.iFlyControl)
            
            
            self.habitCell = loadViewFromBundle("XKRWHabitRecordCell", owner: self) as! XKRWHabitRecordCell
            
            self.habitCell.setRecordEntity(self.recordEntity!)
            
            weak var weakSelf = self
            self.habitCell.saveAction = {
 
                MobClick.event("clk_habit")
                
                weakSelf?.downloadWithTaskID("saveHabit", outputTask: { () -> AnyObject! in
                    return XKRWRecordService4_0.sharedService().saveRecord(self.recordEntity!, ofType: XKRWRecordType.Habit)
                })
            }
            
            if self.isAdOn {

                self.ADView = XKRWADView(type: .Banner, adEntities: XKRWAdService.sharedService().getAdsWithPosition(.MainPage))
                
                self.ADView?.setClickAction({ (index, entity) -> Void in
                    
                    let vc = XKRWWebViewVC()
                    vc.initialTitle = entity.title
                    vc.url = entity.imgurl
                    vc.hidesBottomBarWhenPushed = true
                    
                    weakSelf?.navigationController?.pushViewController(vc, animated: true)
                    
                }, closeAction: { () -> Void in
                    
                    weakSelf?.isAdOn = false
                    XKRWAdService.sharedService().closeAdAtPosition(.MainPage)
                    
                    weakSelf?.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
                })
            }
        }
        initSubviews()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadHabit", name: "SCHEME_RELOAD_HABIT", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadSportSchemeAndRecord", name: "SCHEME_RELOAD_SPORT", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "initData", name: "SCHEME_RELOAD", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadNoticeCell", name: "SCHEME_RELOAD_NOTICE", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "initData", name: "RELOAD_DATA_WHEN_DAY_CHANGED", object: nil)
        
        XKRWNoticeService.sharedService().addNotificationInViewController(self, andKeyWindow: UIApplication.sharedApplication().keyWindow)

        scope("do fix or sync data") { () -> () in
            // do fix
            dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                
                XKRWVersionService.shareService().doSomeFixWithInfo({ (versionString: String!, currentUserNeedExecute: Bool) -> Bool in
                    
                    if currentUserNeedExecute {
                        
                        //设置默认闹钟
                        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                            XKRWAlarmService5_1().defaultAlarmSetting()
                        })
                        
                        if (versionString as NSString).floatValue >= 5.0 {
                            
                            // 方案数据处理
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                XKRWCui.showProgressHud("正在为你转换新版数据中\n请稍等...")
                            })
                            Log.debug_println (NSDate())
                            let success = XKRWRecordService4_0.sharedService().doFixV5_0()
                            Log.debug_println (NSDate())
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                self.syncData()
                                XKRWCui.hideProgressHud()
                                
                                self.surfaceView = XKRWSurfaceView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT), destination: "XKRWSchemeVC_5_0", andUserId:XKRWUserDefaultService.getCurrentUserId(), completion: { () -> Void in
                                    
                                    if XKRWUserService.sharedService().isNeedNoticeTheChangeOfInsistDays() {
                                        
                                        let alert = UIAlertView(title: "提示", message: "尊敬的瘦瘦老用户，自2015年9月1日起，瘦瘦的“坚持天数”将按照新规则计算。使用v5.0期间，若出现以下情况为正常：\n\n1.首次登录v5.0后，天数比以往增多；\n2.在v5.0重置减肥方案以后，天数比重置前增多；\n\n瘦瘦v5.0新版本以后，“坚持天数”将成为您在瘦瘦的重要数据，累积可用于特权、荣誉和优先体验资格，请加以保护您的帐号和数据。", delegate: self, cancelButtonTitle: "知道了")
                                        alert.tag = 12345
                                        
                                        alert.show()
                                    }else{
                                    
                                        if !XKRWUserService.sharedService().getUserNickNameIsEnable() {
                                            let nicknameSetVC = XKRWModifyNickNameVC()
                                            nicknameSetVC.hidesBottomBarWhenPushed = true
                                            nicknameSetVC.notShowBackButton = true
                                            self.navigationController?.pushViewController(nicknameSetVC, animated: false)
                                        }
                                        
                                    }

                                })
                                    
                            })
                            return success
                        }
                    }
                    return false
                })
            })
            // sync data
            self.syncData()
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.event("in_main")
        
        XKRWAppCommentUtil.shareAppComment().showAlertViewInVC()
        
        weak var weakView = self.weightView
        self.weightView?.reload {
            let curWeight = XKRWWeightService.shareService().getNearestWeightRecordOfDate(NSDate())
            let oriWeight = CGFloat(XKRWUserService.sharedService().getUserOrigWeight()) / 1000.0
            let destWeight = CGFloat(XKRWUserService.sharedService().getUserDestiWeight()) / 1000.0
            
            XKRWUserService.sharedService().setCurrentWeight(Int(curWeight*1000.0))
            weakView?.setOriginWeight(oriWeight, curWeight: CGFloat(curWeight), destWeight: destWeight)
        }
        //每天第一次登陆
        if( NSUserDefaults.standardUserDefaults().boolForKey("ShowImageOnWindow")){
            let imageView = UIImageView(frame: CGRectMake((UI_SCREEN_WIDTH-210)/2, (UI_SCREEN_HEIGHT-210)/2, 210, 210))
            imageView.image = UIImage(named: "pop_daily")
            imageView.addSubview(self.setShowImageViewLabel())
            if(XKRWAlgolHelper.remainDayToAchieveTarget() > -1){
                self.popUpTheTipViewOnWindowAsUserFirstTimeEntryVC((UIApplication.sharedApplication().delegate?.window)!, andImageView: imageView, andShowTipViewTime: 3, andTimeEndBlock: {(backgroundView,imageView) -> Void in
                    imageView.removeFromSuperview()
                    backgroundView.removeFromSuperview()
                   
                })
            }
            if(XKRWAlgolHelper.remainDayToAchieveTarget() == -1  && XKRWAlgolHelper.expectDayOfAchieveTarget() != nil )
            {
                if(!NSUserDefaults.standardUserDefaults().boolForKey("lateToResetScheme_\(XKRWUserService.sharedService().getUserId())")){
                self.ShowEndOfTheSchemeAlert(XKRWAlgolHelper.remainDayToAchieveTarget())
                }
            }
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "ShowImageOnWindow")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            }
        

    
        //是否显示 撒花
        if( NSUserDefaults.standardUserDefaults().boolForKey("ShowWindowFlower_\(XKRWUserService.sharedService().getUserId())")){
            self.showFlowerInWindow()
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "ShowWindowFlower_\(XKRWUserService.sharedService().getUserId())")
            NSUserDefaults.standardUserDefaults().synchronize()
        }

        
        if self.needReloadIndexPath != nil && self.needReloadTableView != nil {
            // do something
            self.needReloadTableView!.reloadData()
            // set nil when done
            self.needReloadIndexPath = nil
            self.needReloadTableView = nil
        }
        
        // 保存一下当前的体力活动值水平到 NSUserDefaults中
        
        NSUserDefaults.standardUserDefaults().setObject(XKRWAlgolHelper.dailyIntakeRecomEnergy(), forKey: DailyIntakeSize)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let userId = XKRWUserDefaultService.getCurrentUserId()
        let version = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        let key = "XKRWSchemeVC_5_0_"+"\(userId)"+"_"+"\(version)"
        
        if  NSUserDefaults.standardUserDefaults().boolForKey(key) {
            if !XKRWUserService.sharedService().getUserNickNameIsEnable() {
                let nicknameSetVC = XKRWModifyNickNameVC()
                nicknameSetVC.hidesBottomBarWhenPushed = true
                nicknameSetVC.notShowBackButton = true
                self.navigationController?.pushViewController(nicknameSetVC, animated: false)
            }
        }
    }
    
    override func checkNeedHideNaviBarWhenPoped() {
        super.checkNeedHideNaviBarWhenPoped()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * CGFloat(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
        XKRWNoticeService.sharedService().addAppCloseStateNotificationInViewController(self, andKeyWindow: UIApplication.sharedApplication().keyWindow)
//            }
        
        
        
        if !self.isLoad {
            XKRWCui.hideAdImage()
            self.isLoad = true
            self.tableView.setContentOffset(CGPointMake(0, -20), animated: false)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func syncData() -> Void {
        
        weak var weakSelf = self
        
        XKRWVersionService.shareService().checkVersion({ (currentVersion: String!, isNewUpdate: Bool, isNewSetUp: Bool) -> Bool in
            
            if isNewSetUp || isNewUpdate {
                
                
            } else {
                
                
            }
            // 同步数据
            if !XKRWSchemeService_5_0.sharedService.needFixWithUID(XKRWUserDefaultService.getCurrentUserId(), version: "5.0") {
                
                if XKRWSchemeService_5_0.sharedService.identifier != nil && XKRWSchemeService_5_0.sharedService.sportIdentifier != nil {
                    
                    self.initData()
                }
                    
                weakSelf?.downloadWithTaskID("syncData", outputTask: { () -> AnyObject! in
                    if XKRWCommHelper.syncRemoteData() {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            weakSelf?.initData()
                        })
                    }
                    return true
                })
            }
            return true
            
        }, needUpdateMark: true)
    }
    
    func initData() {
        
        if (XKRWUserService.sharedService().getSex().rawValue == eSexFemale.rawValue && XKRWRecordService4_0.sharedService().getMenstruationSituation()) {
            self.is_M = 1
        }
        self.isContentLoading = true
        
        weak var weakSelf = self
        
        self.downloadWithTaskID("cleanSchemeRecords", task: { () -> Void in
            
            XKRWRecordService4_0.sharedService().cleanWrongSchemeRecords()
        })
        
        self.downloadWithTaskID("getMealSchemeAndRecord", outputTask: { () -> AnyObject! in
            
            if weakSelf != nil {
                
                weakSelf!.mealSchemes = XKRWSchemeService_5_0.sharedService.getMealScheme()
                
                if let records = XKRWRecordService4_0.sharedService().getSchemeRecordWithSchemes(weakSelf!.mealSchemes, date: NSDate()) as? [XKRWRecordSchemeEntity] {

                    weakSelf!.mealRecords = records
                }
                return true
            }
            return false
        })
        
        self.downloadWithTaskID("getSportSchemeAndRecord", outputTask: { () -> AnyObject! in
            
            if weakSelf != nil {
               
                weakSelf!.sportScheme = XKRWSchemeService_5_0.sharedService.getSportScheme(self.is_M)
                
                if let records = XKRWRecordService4_0.sharedService().getSchemeRecordWithSchemes([weakSelf!.sportScheme], date: NSDate()) as? [XKRWRecordSchemeEntity] {
                    
                    weakSelf!.sportRecord = records.last!
                }
                return true
            }
            return false
        })
        self.recordEntity = XKRWRecordService4_0.sharedService().getAllRecordOfDay(NSDate())
        
        if let habitTable = self.scrollCell.viewWithTag(103) as? UITableView {
            habitTable.reloadData()
        }
    }
    
    func schemeInsistDayAndEntryHistoryVCCell(insistDay:String) -> UITableViewCell{
        
        var prevString = ""
        var time = insistDay
        var nextString = "天"
        let insistLabel = UILabel(frame:CGRectMake(0,0,0,0))
        let dayLabel = UILabel(frame:CGRectMake(0,0,0,0))
        let resetLabel = UILabel(frame:CGRectMake(0,0,0,0))
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "insistCell")
        
        let historyLabel = UILabel(frame:CGRectMake(UI_SCREEN_WIDTH - 36 - 120,0,120,44))
        historyLabel.text = "查看今日分析"
        historyLabel.textColor = XK_TEXT_COLOR
        historyLabel.font = XKDefaultFontWithSize(12)
        historyLabel.textAlignment = .Right
        cell.contentView.addSubview(historyLabel)
        
        if(XKRWAlgolHelper.expectDayOfAchieveTarget() == nil){
            prevString = "已坚持"
            historyLabel.hidden = false
            MobClick.event("in_Main_PlanTimeA")
        }else{
            
            let isNeed = NSUserDefaults.standardUserDefaults().boolForKey("needResetScheme_\(XKRWUserService.sharedService().getUserId())")
            print(isNeed)
            print(XKRWAlgolHelper.remainDayToAchieveTarget())
            if(XKRWAlgolHelper.remainDayToAchieveTarget() > 99 && !isNeed){
                prevString = "蜕变之旅第"
                MobClick.event("in_Main_PlanTimeB")
            }else if(XKRWAlgolHelper.remainDayToAchieveTarget() <= 99 && XKRWAlgolHelper.remainDayToAchieveTarget() > 0 && !isNeed){
                prevString = "将在"
                nextString = "天后完成蜕变"
                MobClick.event("in_Main_PlanTimeB")
                time = String(XKRWAlgolHelper.remainDayToAchieveTarget())
            }else if(XKRWAlgolHelper.remainDayToAchieveTarget() == 0  && !isNeed){
                MobClick.event("in_Main_PlanTimeB")
                prevString = "将在明天完成蜕变"
                nextString = ""
                time = ""
            }else if(XKRWAlgolHelper.remainDayToAchieveTarget() == -1 || isNeed){
                insistLabel.hidden = true
                dayLabel.hidden = true
                resetLabel.hidden = false
                time = ""
                MobClick.event("in_Main_PlanTimeC")
                resetLabel.frame = CGRectMake(15, 0, 200, 44)
                resetLabel.textColor = XK_TITLE_COLOR
                resetLabel.text = "方案已结束，请重置方案!"
                resetLabel.font = XKDefaultFontWithSize(16)
                cell.contentView.addSubview(resetLabel)
            }
            
            if(XKRWAlgolHelper.remainDayToAchieveTarget() == -1 || NSUserDefaults.standardUserDefaults().boolForKey("needResetScheme_\(XKRWUserService.sharedService().getUserId())")){
                historyLabel.hidden = true
            }else{
                historyLabel.hidden = false
            }
            
        }
        
        let title = NSAttributedString(string: prevString, attributes:[NSFontAttributeName:XKDefaultFontWithSize(16),NSForegroundColorAttributeName:XK_TITLE_COLOR] )
        
        let labelWidth = title.boundingRectWithSize(CGSizeMake(UI_SCREEN_WIDTH, 44), options: .UsesLineFragmentOrigin, context: nil).size.width


        insistLabel.frame = CGRectMake(15,0,labelWidth,44)
        insistLabel.attributedText = title
        
        cell.contentView.addSubview(insistLabel)
        
        var i = 0
        
        for character in time.characters {
            let imageView = UIImageView(frame: CGRectMake(insistLabel.right + 5 + 15 * CGFloat(i), (44-21)/2, 13, 21))
            cell.contentView.addSubview(imageView)
            imageView.image = UIImage(named: "\(character)_")
            i++
        }
        
        let nextTitle = NSAttributedString(string: nextString, attributes:[NSFontAttributeName:XKDefaultFontWithSize(16),NSForegroundColorAttributeName:XK_TITLE_COLOR] )
        
        let nextLabelWidth = nextTitle.boundingRectWithSize(CGSizeMake(UI_SCREEN_WIDTH, 44), options: .UsesLineFragmentOrigin, context: nil).size.width
        dayLabel.frame = CGRectMake(insistLabel.right + 8 + 15 * CGFloat(i),0,nextLabelWidth,44)
        dayLabel.attributedText = nextTitle
        
        cell.contentView.addSubview(dayLabel)
        
        let entryImageView = UIImageView(frame: CGRectMake(UI_SCREEN_WIDTH - 36, 0, 36, 44))
        entryImageView.image = UIImage(named: "enter")
        cell.contentView.addSubview(entryImageView)
        
        return cell
    }
    
    
    func setShowImageViewLabel() -> UILabel{
        let textLabel = UILabel(frame: CGRectMake(5,145,200,50))
        textLabel.backgroundColor = UIColor.clearColor()
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .Center
        var attributed:NSAttributedString!
        if(XKRWAlgolHelper.expectDayOfAchieveTarget() == nil){
            
             attributed = NSAttributedString(string: ("蜕变之路\n第\(XKRWUserService.sharedService().getInsisted())天"), attributes: [NSFontAttributeName:XKDefaultFontWithSize(15),NSForegroundColorAttributeName:XK_MAIN_TONE_COLOR])
            
        }else{
            if(XKRWAlgolHelper.remainDayToAchieveTarget() > 99 ){
                var day:Int!
                if(XKRWAlgolHelper.expectDayOfAchieveTarget() == nil){
                    day = XKRWUserService.sharedService().getInsisted()
                }else{
                    day = XKRWAlgolHelper.newSchemeStartDayToAchieveTarget()
                }
                
                 attributed = NSAttributedString(string: ("蜕变之路\n第\(day)天"), attributes: [NSFontAttributeName:XKDefaultFontWithSize(15),NSForegroundColorAttributeName:XK_MAIN_TONE_COLOR])
            }else if(XKRWAlgolHelper.remainDayToAchieveTarget() <= 99 && XKRWAlgolHelper.remainDayToAchieveTarget() != 0){
                
                 attributed = NSAttributedString(string: ("将在\(XKRWAlgolHelper.remainDayToAchieveTarget())天后\n完成蜕变"), attributes: [NSFontAttributeName:XKDefaultFontWithSize(15),NSForegroundColorAttributeName:XK_MAIN_TONE_COLOR])
                
            }else{
                attributed = NSAttributedString(string: ("将在明天\n完成蜕变"), attributes: [NSFontAttributeName:XKDefaultFontWithSize(15),NSForegroundColorAttributeName:XK_MAIN_TONE_COLOR])
            }
            
        }
        textLabel.attributedText = attributed
    
        return  textLabel
    }
    
    
    func showFlowerInWindow(){
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "needResetScheme_\(XKRWUserService.sharedService().getUserId())")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let window:UIWindow! = (UIApplication.sharedApplication().delegate?.window)!
        let backgroundView = UIView(frame: window.bounds)
        backgroundView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
      
        window.addSubview(backgroundView)
        
        let paragraphStyle =  NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5

        
        let attributedString = NSMutableAttributedString(string: "恭喜你达成目标体重\n继续开始新的征程吧",attributes:[NSParagraphStyleAttributeName:paragraphStyle] )
        attributedString.addAttributes([NSFontAttributeName:XKDefaultFontWithSize(16),NSForegroundColorAttributeName:XK_MAIN_TONE_COLOR], range: NSMakeRange(0, 9))
        attributedString.addAttributes([NSFontAttributeName:XKDefaultFontWithSize(14),NSForegroundColorAttributeName:UIColor.whiteColor()], range: NSMakeRange(9, 10))
        
        
        
        let showLabel = UILabel(frame: CGRectMake(0,100,UI_SCREEN_WIDTH,60))
        showLabel.attributedText = attributedString
        showLabel.numberOfLines = 0
        showLabel.textAlignment = .Center
        backgroundView.addSubview(showLabel)
        
        let flowerImageView = FLAnimatedImageView()
        let flowerImg: FLAnimatedImage = FLAnimatedImage(animatedGIFData: NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("flower", ofType: "gif")!))
        flowerImageView.animatedImage = flowerImg
        flowerImageView.frame = CGRectMake((UI_SCREEN_WIDTH-250)/2, (UI_SCREEN_HEIGHT-250)/2, 250, 250)
        backgroundView.addSubview(flowerImageView)
        
        
        let resetSchemeButton = UIButton(type: .Custom)
        resetSchemeButton.frame = CGRectMake((UI_SCREEN_WIDTH - 250)/2, flowerImageView.bottom + 30, 250, 40)
        resetSchemeButton.backgroundColor = XK_MAIN_TONE_COLOR
        resetSchemeButton.layer.masksToBounds = true
        resetSchemeButton.layer.cornerRadius = 5
        resetSchemeButton.setTitle("去定制新的方案", forState: .Normal)
        resetSchemeButton.titleLabel?.font = XKDefaultFontWithSize(16)
        resetSchemeButton.addTarget(self, action: "toResetScheme:", forControlEvents: .TouchUpInside)
        backgroundView.addSubview(resetSchemeButton)
        
       
        let lateResetSchemeButton = UIButton(type: .Custom)
        lateResetSchemeButton.frame = CGRectMake((UI_SCREEN_WIDTH - 250)/2, resetSchemeButton.bottom + 10, 250, 40)
        lateResetSchemeButton.backgroundColor = UIColor.clearColor()
        lateResetSchemeButton.setTitle("稍后定制", forState: .Normal)
        lateResetSchemeButton.titleLabel?.font = XKDefaultFontWithSize(14)
        lateResetSchemeButton.addTarget(self, action: "lateToResetScheme:", forControlEvents: .TouchUpInside)
        backgroundView.addSubview(lateResetSchemeButton)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    
    func reloadHabit() -> Void {
        
        self.recordEntity?.reloadHabitArray()
        
        if let tableView = self.scrollCell.viewWithTag(103) as? UITableView {
            tableView.reloadData()
        }
        
        self.downloadWithTaskID("saveHabit", outputTask: { () -> AnyObject! in
            XKRWRecordService4_0.sharedService().saveRecord(self.recordEntity, ofType: XKRWRecordType.Habit)
        })
    }
    
    func reloadSportSchemeAndRecord() -> Void {
        
        
        self.downloadWithTaskID("reloadSportScheme", outputTask: { () -> AnyObject! in
            
            let newScheme = XKRWSchemeService_5_0.sharedService.changeSchemeWithType(XKRWSchemeType.Sport, size: nil, dropID: self.sportScheme.schemeID, otherInfo:["is_m" : self.is_M] )
            
            self.sportRecord.record_value = 0
            self.sportRecord.sid = newScheme.schemeID
            
            self.sportScheme = newScheme
            
            return true
        })
    }
    
    func reloadNoticeCell() -> Void {
        
        var tags = [101, 102]
        
        // if there is no bad habit, then don't need to reload the cell
        if self.recordEntity?.habitArray.count > 0 {
            tags.append(103)
        }
        
        for tag in tags {
            if let tableView = self.scrollCell.viewWithTag(tag) as? UITableView {
                
                var indexPath: NSIndexPath
                if tag == 102 {
                    indexPath = NSIndexPath(forRow: 3, inSection: 0)
                } else if tag == 101 {
                    tableView.reloadData()
                    continue
                } else {
                    indexPath = NSIndexPath(forRow: 1, inSection: 0)
                }
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            }
        }
    }
    
    func keyboardWillShow() -> Void {
        
        MobClick.event("clk_Search")
    }
    
    func rightNaviBarButtonClicked() -> Void {
        
        if(XKRWAlgolHelper.remainDayToAchieveTarget() == -1 && XKRWAlgolHelper.expectDayOfAchieveTarget() != nil)
        {
            self.showToResetScheme()
        }else{
            MobClick.event("clk_TodayAnalysis")
            let vc = XKRWHistoryAndProcessVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
//        self.endOfTheUserScheme()
        
        
        
    }
    
    
    func endOfTheUserScheme(){
        let alertView = UIAlertView(title: "方案的预期天数已结束", message: "是否达到目标体重？", delegate: self, cancelButtonTitle: nil, otherButtonTitles: "完成目标\(CGFloat(XKRWUserService.sharedService().getUserDestiWeight()) / 1000.0)啦！", "没有完成，重新制定方案")
        alertView.tag = 10001
        alertView.show()
    }
    
    func ShowEndOfTheSchemeAlert(needDay:Int) {
        if(needDay <= 0){
            self.endOfTheUserScheme()
        }
    }
    
    func showToResetScheme(){
        let alertView = UIAlertView(title: "确定要重置方案吗？", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alertView.tag = 10003
        alertView.show()
    }
    
    func toResetScheme(button:UIButton){
       
        button.superview?.removeFromSuperview()
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "needResetScheme_\(XKRWUserService.sharedService().getUserId())")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.showToResetScheme()
    }
    
    func lateToResetScheme(button:UIButton){
        button.superview?.removeFromSuperview()
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "lateToResetScheme_\(XKRWUserService.sharedService().getUserId())")
        NSUserDefaults.standardUserDefaults().synchronize()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * CGFloat(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            
            self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.None)
        }

    }

    
    // MARK: - Networking
    
    override func shouldRespondForDefaultNotificationForDetailName(detailName: String!) -> Bool {
        return true
    }
    
    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {
        
        if taskID == "getMealSchemeAndRecord" {
            
            self.isContentLoading = false
            
            XKRWCui.hideProgressHud()
            
            let mealTable = self.scrollCell.viewWithTag(102)
            
            if mealTable is UITableView {
                
                (mealTable as! UITableView).reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * CGFloat(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                
                self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.None)
            }
        }
        
        if taskID == "getSportSchemeAndRecord" {
            
            self.isContentLoading = false
            
            XKRWCui.hideProgressHud()
            
            let sportTable = self.scrollCell.viewWithTag(101)
            
            if sportTable is UITableView {
                
                (sportTable as! UITableView).reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * CGFloat(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                
                self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.None)
            }
        }
        
        if taskID == "search" {
            
            XKRWCui.hideProgressHud()
            
            let temp = result as! [String: AnyObject]
            
            if let foods = temp["food"] as? [XKRWFoodEntity] {
                
                foodsArray = foods
            }
            if let sports = temp["sport"] as? [XKRWSportEntity] {
                
                sportsArray = sports
            }
            
            self.foodsCount = foodsArray.count > 3 ? 3 : foodsArray.count
            self.sportsCount = sportsArray.count > 3 ? 3 : sportsArray.count
            
            if !self.searchDisplayCtrl!.isShowSearchResultTableView {
                self.searchDisplayCtrl?.showSearchResultTableView()
            }
            self.searchDisplayCtrl?.reloadSearchResultTableView()
            
            return
        }
        
        if taskID == "saveSchemeRecord" {
            return
        }
        
        if taskID == "reloadSportScheme" {
            
            if let tableView = self.scrollCell.viewWithTag(101) as? UITableView {
                
                tableView.reloadData()
            }
            
            return
        }
        
        if taskID == "restSchene" {
            XKRWCui.hideProgressHud()
            if result != nil {
                if result.objectForKey("success")?.integerValue == 1{
                    XKRWSchemeService_5_0.sharedService.dealResetUserScheme(self)
                let fatReasonVC =  XKRWFoundFatReasonVC(nibName:"XKRWFoundFatReasonVC",bundle:nil)
                fatReasonVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(fatReasonVC, animated: true)
                }
            }else{
                XKRWCui.showInformationHudWithText("重置方案失败，请稍后尝试")
            }
        }
        
    }
    
    override func handleDownloadProblem(problem: AnyObject!, withTaskID taskID: String!) {
        
        XKRWCui.hideProgressHud()
        
        if taskID == "restSchene"{
            XKRWCui.showInformationHudWithText("重置方案失败，请稍后尝试")
            return
        }
        
        super.handleDownloadProblem(problem, withTaskID: taskID)
        
        if taskID == "getMealSchemeAndRecord" {
            
            self.isContentLoading = false
            self.isLoadMealFailed = true
        }
        
        if taskID == "getSportSchemeAndRecord" {
            
            self.isContentLoading = false
            self.isLoadSportFailed = true
        }
        
    
        
    }
    
    // MARK: - UITableView's delegate and datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if tableView.tag == 50 {
            return 3
        } else if ((tableView.tag == 101) || (tableView.tag == 102) || (tableView.tag == 103)) {
            return 1
        } else if tableView.tag == 201 {
            
            var section: Int = 0
            if self.foodsArray.count > 0 {
                section++
            }
            if self.sportsArray.count > 0 {
                section++
            }
            return section
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 50{
            
            if section == 0 {
                
                if isAdOn {
                    return 2
                } else {
                    return 1
                }
            } else {
                return 1
            }
        } else if (tableView.tag == 201) {
            
            if section == 0 {
                if foodsArray.count > 0 {
                    if foodsArray.count > 3 {
                        return 5
                    } else {
                        return foodsArray.count + 1
                    }
                } else {
                    if sportsArray.count > 3 {
                        return 5
                    } else {
                        return sportsArray.count + 1
                    }
                }
            }
            if section == 1 {
                if sportsArray.count > 3 {
                    return 5
                } else {
                    return sportsArray.count + 1
                }
            }
            
        } else {
            
            if tableView.tag == 101 {
                // Sport advise
                if XKRWUserService.sharedService().getSex().rawValue == eSexMale.rawValue {
                    return 2
                } else {
                    return 3
                }
                
            } else if tableView.tag == 102 {
                // Meal advise
                return 4
                
            } else if tableView.tag == 103 {
                // Bad Habit
                
                if self.recordEntity?.habitArray.count > 0 {
                    return 2
                } else {
                    return 1
                }
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView.tag == 50 {
            
            switch section {
            case 0:
                return UIView()
            case 1:
                return UIView()
            case 2:
                return self.choiseHeader
            default:
                return nil
            }
        }
        
        if tableView.tag == 201 {
            return UIView()
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.tag == 50 {
            
            switch section {
            case 0:
                return 0
            case 1:
                return 0
            case 2:
                return choiseHeader.height
            default:
                return 0.0
            }
        }
        if tableView.tag == 201 {
            return 10.0
        }
        return 0.0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView.tag == 50 {
            
            if section ==  0 {
                return 10.0
            }
        } else {
            
            return 10.0
        }
        return 0.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.tag == 50 {
            
            if indexPath.section == 0 {
                
                switch indexPath.row {
                case 0:
                    if let cell = tableView.dequeueReusableCellWithIdentifier("weightCell") {
                        return cell
                        
                    } else {
                        let cell: UITableViewCell = UITableViewCell(style: .Default, reuseIdentifier: "weightCell")
                        cell.contentView.addSubview(weightView!)
//                        cell.selectionStyle = .None

                        return cell
                    }

                case 1:
                    if let cell = tableView.dequeueReusableCellWithIdentifier("adCell") {
                        return cell
                    } else {
                        let cell: UITableViewCell = UITableViewCell(style: .Default, reuseIdentifier: "adCell")
                        cell.contentView.addSubview(self.ADView!)
                        
                        return cell
                    }
                default:
                    break
                }
            } else if indexPath.section == 1{
                if(XKRWAlgolHelper.expectDayOfAchieveTarget() == nil){
                   return  self.schemeInsistDayAndEntryHistoryVCCell(String(XKRWUserService.sharedService().getInsisted()))
                }else{
                    
                    return  self.schemeInsistDayAndEntryHistoryVCCell(String(XKRWAlgolHelper.newSchemeStartDayToAchieveTarget()))

                }
                
            }
            else if indexPath.section == 2 {
                
                return self.scrollCell
            }
        } else {

            if tableView.tag == 101 {
                
                if indexPath.row == 0 {
                    
                    // Sport advise
                    let cell: XKRWMealSchemeCell = tableView.dequeueReusableCellWithIdentifier("sportCell") as! XKRWMealSchemeCell
                    weak var weakCell = cell
                    weak var weakSelf = self
                    cell.setType(XKRWSchemeType.Sport, clickAction: { (index, cellType) -> () in
                        

                        if index == 2 {
                            
                            MobClick.event("clk_other2")
                            
                            let vc = XKRWRecordOthersVC(nibName: "XKRWRecordOthersVC", bundle: nil)
                            vc.type = cellType
                            if weakSelf?.recordEntity != nil {
                                vc.recordEntity = self.recordEntity!
                            }
                            vc.schemeEntity = weakSelf?.sportRecord
                            vc.hidesBottomBarWhenPushed = true
                            
                            weakSelf?.needReloadTableView = tableView
                            weakSelf?.needReloadIndexPath = indexPath
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                            return
                        }
                        
                        if weakCell != nil && weakCell?.recordEntity != nil {
                            
                            weakCell?.recordEntity?.record_value = index + 1
                            
                            weakSelf?.downloadWithTaskID("saveSchemeRecord", outputTask: { () -> AnyObject! in
                                return XKRWRecordService4_0.sharedService().saveRecord(weakCell!.recordEntity!, ofType: XKRWRecordType.Scheme)
                            })
                        }
                        
                        var y = cell.frame.origin.y
                        var v: UIView = cell as UIView
                        while v.superview != nil {
                            
                            v = v.superview!
                            y += v.frame.origin.y
                            
                            if v is UIScrollView {
                                y -= (v as! UIScrollView).contentOffset.y
                            }
                        }
                        
                        let temple = (index, cellType)
                        var image: UIImage = UIImage()
                        
                        switch temple {
                        case (1, _):
                            MobClick.event("clk_perfect2")
                            image = UIImage(named: "emblem_get")!
                        case (0, let x):
                            
                            MobClick.event("clk_NoSport")
                            
                            if x == .Breakfast {
                                image = UIImage(named: "emblem_nobf")!
                            } else if x == .Lunch {
                                image = UIImage(named: "emblem_nolunchn")!
                            } else if x == .Dinner {
                                image = UIImage(named: "emblem_nodinner")!
                            } else if x == .Sport {
                                image = UIImage(named: "emblem_lazy")!
                            }
                        default:
                            break
                        }
                        XKRWAnimateUtil.doSealAnimationWithImage(image, toPoint: CGPointMake(29, y + 29), completion: { () -> () in
                            weakCell?.sealImageView.image = image
                            weakCell?.isSealed = true
                        })
                        
                    })
                    if self.sportScheme.schemeID != 0 {
                        cell.setContent(schemeEntity: self.sportScheme, recordEntity: self.sportRecord)
                    } else {
                        cell.loading(animate: true)
                    }
                    return cell
                    
                } else if indexPath.row == 1 && XKRWUserService.sharedService().getSex().rawValue == eSexFemale.rawValue {
                    
                    var cell = tableView.dequeueReusableCellWithIdentifier("menstruationCell") as? KMSwitchCell
                    
                    if cell == nil {
                        
                        tableView.registerNib(UINib(nibName: "KMSwitchCell", bundle: nil), forCellReuseIdentifier: "menstruationCell")
                        cell = tableView.dequeueReusableCellWithIdentifier("menstruationCell") as? KMSwitchCell
                    }
                    
                    cell!.switchUnit.setOn(XKRWRecordService4_0.sharedService().getMenstruationSituation(), animated: false)
                    cell!.setTitle("大姨妈", clickSwitchAction: { (on) -> Void in
                        
                        if on {
                            self.is_M = 1
                            let alert = UIAlertView(title: "大姨妈来了！", message: "适量运动有助调节情绪，缓解生理期不适，瘦瘦为你准备了适合姨妈期的运动方案，快去看看吧！", delegate: self, cancelButtonTitle: "知道了")
                            alert.addButtonWithTitle("去换方案")
                            alert.tag = 10000
                            alert.show()
                            
                            MobClick.event("tips_mc_on")
                        }
                        else {
                            self.is_M = 0
                            let alert = UIAlertView(title: "大姨妈走了！", message: "恭喜你进入减肥黄金周，新陈代谢加速，减肥事半功倍，开启燃脂模式，努力运动吧 ！", delegate: nil, cancelButtonTitle: "知道了")
                            alert.show()
                            alert.tag = 10000
                            MobClick.event("tips_mc_off")
                        }
                        XKRWRecordService4_0.sharedService().saveMenstruation(on)
                    })
                    
//                    cell!.selectionStyle = .None
                    return cell!
                   
                } else {
                    // Sport Notice Entry
                    let cell: XKRWNoticeEntryCell = tableView.dequeueReusableCellWithIdentifier("noticeCell") as! XKRWNoticeEntryCell
                    var desc: String = "关"
                    
                    if XKRWAlarmService5_1.shareService().haveEnabledNotice(AlarmType(6)) {
                        desc = "开"
                    }
                    cell.setTitle("运动提醒", descripton: desc)
                    
                    return cell
                }
                
            } else if tableView.tag == 102 {
                
                if indexPath.row  != 3 {
                    
                    // Meal advise
                    let cell: XKRWMealSchemeCell = tableView.dequeueReusableCellWithIdentifier("mealCell", forIndexPath: indexPath) as! XKRWMealSchemeCell
                    
                    weak var weakCell = cell
                    weak var weakSelf = self
                    cell.setType(XKRWSchemeType(rawValue: indexPath.row + 1)!, clickAction: { (index, cellType) -> () in
                        
                  

                        
                        if index == 2 {
                            
                            MobClick.event("clk_other1")
                            
                            let vc = XKRWRecordOthersVC(nibName: "XKRWRecordOthersVC", bundle: nil)
                            vc.type = cellType
                            if self.recordEntity != nil {
                                vc.recordEntity = self.recordEntity!
                            }
                            vc.schemeEntity = weakCell?.recordEntity
                            vc.hidesBottomBarWhenPushed = true
                            
                            weakSelf?.needReloadTableView = tableView
                            weakSelf?.needReloadIndexPath = indexPath
                            
                            self.backFromReocrd = true
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                            return
                        }
                        
                        if weakCell != nil && weakCell?.recordEntity != nil {
                            
                            weakCell?.recordEntity?.record_value = index + 1
                            weakSelf?.downloadWithTaskID("saveSchemeRecord", outputTask: { () -> AnyObject! in
                                return XKRWRecordService4_0.sharedService().saveRecord(weakCell!.recordEntity!, ofType: XKRWRecordType.Scheme)
                            })
                        }
                        
                        var y = cell.frame.origin.y
                        var v: UIView = cell as UIView
                        while v.superview != nil {
                            
                            v = v.superview!
                            y += v.frame.origin.y
                            
                            if v is UIScrollView {
                                y -= (v as! UIScrollView).contentOffset.y
                            }
                        }
                        
                        let temple = (index, cellType)
                        var image: UIImage = UIImage()
                        
                        switch temple {
                            
                        case (1, _):
                            
                            MobClick.event("clk_perfect1")
                            
                            image = UIImage(named: "emblem_get")!
                            
                        case (0, let x):
                            
                            MobClick.event("clk_NoEat")
                            
                            if x == .Breakfast {
                                image = UIImage(named: "emblem_nobf")!
                            } else if x == .Lunch {
                                image = UIImage(named: "emblem_nolunchn")!
                            } else if x == .Dinner {
                                image = UIImage(named: "emblem_nodinner")!
                            } else if x == .Sport {
                                image = UIImage(named: "emblem_nobf")!
                            }
                        default:
                            break
                        }
                        XKRWAnimateUtil.doSealAnimationWithImage(image, toPoint: CGPointMake(29, y + 29), completion: { () -> () in
                            weakCell?.sealImageView.image = image
                            weakCell?.isSealed = true
                        })
                    })
                    
                    if self.mealSchemes.isEmpty || self.mealSchemes.count < indexPath.row {
                        cell.loading(animate: true)
                    } else {
                        cell.setContent(schemeEntity: self.mealSchemes[indexPath.row], recordEntity: self.mealRecords[indexPath.row])
                    }
                    cell.selectionStyle = .Default
                    return cell
                    
                } else {
                    
                    // Meal Notice Cell
                    let cell: XKRWNoticeEntryCell = tableView.dequeueReusableCellWithIdentifier("noticeCell") as! XKRWNoticeEntryCell
                    var desc: String = "开"
                    if (XKRWAlarmService5_1.shareService().haveEnabledNotice(AlarmType(2)) ||
                        XKRWAlarmService5_1.shareService().haveEnabledNotice(AlarmType(3)) ||
                        XKRWAlarmService5_1.shareService().haveEnabledNotice(AlarmType(4))) {
                        desc = "开"
                    } else {
                        desc = "关"
                    }
                    cell.setTitle("饮食提醒", descripton: desc)
                    
                    return cell
                }
                
            } else if tableView.tag == 103 {
                
                if indexPath.row == 0 {
                    
                    // Bad Habit
                    self.habitCell.setRecordEntity(self.recordEntity!)
                    return self.habitCell;
    
                } else if indexPath.row == 1 {
                    
                    // Habit Notice
                    let cell: XKRWNoticeEntryCell = tableView.dequeueReusableCellWithIdentifier("noticeCell") as! XKRWNoticeEntryCell
                    var desc: String = "开"
                    if XKRWAlarmService5_1.shareService().haveEnabledNotice(AlarmType(8)) {
                        desc = "开"
                    } else {
                        desc = "关"
                    }
                    cell.setTitle("习惯提醒", descripton: desc)
                    
                    return cell
                }
            } else if tableView.tag == 201 {
                
                // search result
                if indexPath.section == 0 {
                    
                    if foodsArray.count > 0 {
                        
                        if indexPath.row == 0 {
                            
                            let cell = tableView.dequeueReusableCellWithIdentifier("searchResultCategoryCell") as! XKRWSearchResultCategoryCell
                            cell.title!.text = "食物"
                            
                            return cell
                            
                        } else if indexPath.row == foodsCount + 1{
                            
                            let cell = tableView.dequeueReusableCellWithIdentifier("moreSearchResultCell") as! XKRWMoreSearchResultCell
                            cell.title.text = "查看更多食物"
                            return cell
                            
                        } else {
                            
                            let cell = tableView.dequeueReusableCellWithIdentifier("searchResultCell") as! XKRWSearchResultCell
                            
                            let entity = foodsArray[indexPath.row - 1]
                            cell.title.text = entity.foodName
                            cell.subtitle.text = "\(entity.foodEnergy)kcal/100g"
         
                            cell.logoImageView.setImageWithURL(NSURL(string: entity.foodLogo), placeholderImage: UIImage(named:"food_default"))
                            return cell
                        }
                    } else {
                        
                        if indexPath.row == 0 {
                            
                            let cell = tableView.dequeueReusableCellWithIdentifier("searchResultCategoryCell") as! XKRWSearchResultCategoryCell
                            cell.title!.text = "运动"
                            
                            return cell
                            
                        } else if indexPath.row == sportsCount + 1 {
                            
                            let cell = tableView.dequeueReusableCellWithIdentifier("moreSearchResultCell") as! XKRWMoreSearchResultCell
                            cell.title.text = "查看更多运动"
                            
                            return cell
                            
                        } else {
                            
                            let cell = tableView.dequeueReusableCellWithIdentifier("searchResultCell") as! XKRWSearchResultCell
                            
                            let entity = sportsArray[indexPath.row - 1]
                            cell.title.text = entity.sportName
                            cell.subtitle.text = "\(XKRWAlgolHelper.sportConsumeWithTime(60, mets: entity.sportMets))kcal/60分钟"

                            cell.logoImageView.setImageWithURL(NSURL(string: entity.sportActionPic), placeholderImage: UIImage(named:"food_default"))
                            
                            return cell
                        }
                    }
                } else if indexPath.section == 1 {
                    
                    if indexPath.row == 0 {
                        
                        let cell = tableView.dequeueReusableCellWithIdentifier("searchResultCategoryCell") as! XKRWSearchResultCategoryCell
                        cell.title!.text = "运动"
                        
                        return cell
                        
                    } else if indexPath.row == sportsCount + 1{
                        
                        let cell = tableView.dequeueReusableCellWithIdentifier("moreSearchResultCell") as! XKRWMoreSearchResultCell
                        cell.title.text = "查看更多运动"
                        
                        return cell
                        
                    } else {
                        
                        let cell = tableView.dequeueReusableCellWithIdentifier("searchResultCell") as! XKRWSearchResultCell
                        
                        let entity = sportsArray[indexPath.row - 1]
                        cell.title.text = entity.sportName
                        cell.subtitle.text = "\(XKRWAlgolHelper.sportConsumeWithTime(60, mets: entity.sportMets))kcal/60分钟)"
                        cell.logoImageView.setImageWithURL(NSURL(string: entity.sportActionPic), placeholderImage: UIImage(named:"food_default"))
                        
                        return cell
                    }
                }
            }
        }
        return UITableViewCell(style: .Default, reuseIdentifier: "noneCell")
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if tableView.tag == 50 {
            
            if indexPath.section == 0{
                switch indexPath.row {
                case 0:
                    if weightView != nil {
                        
                        return self.weightView!.height
                    }
                
                case 1:
                    return self.ADView?.height ?? UI_SCREEN_WIDTH / 5.0
                default:
                    break
                }
            }else if(indexPath.section == 1)
            {
                return 44
            }
            else if(indexPath.section == 2) {
                
                if self.isContentLoading {
                    self.scrollCell.setCellHeight(self.view.height)
                } else {
                    self.scrollCell.resizeSelf()
                }
                return self.scrollCell.height
            }
        } else {
            
            if tableView.tag == 101 {
                
                if indexPath.row == 0 {
                    
                    // Sport advise
                    var height: CGFloat = 114
                    if self.sportScheme.schemeID != 0 {
                        self.computeCell.setContent(schemeEntity: sportScheme, recordEntity: nil)
                        height = self.computeCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height + 1   
                    }
                    return height
                }
                
            } else if tableView.tag == 102 {
                
                if indexPath.row != 3 {
                    
                    // Meal advise
                    var height: CGFloat = 114

                    if !mealSchemes.isEmpty && mealSchemes.count >= indexPath.row {
                            
                        self.computeCell.setContent(schemeEntity: mealSchemes[indexPath.row], recordEntity: nil)
                        height = self.computeCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height + 1
                    }
                    return height
                } else {
                    return 44.0
                }
                
            } else if tableView.tag == 103 {
                
                if indexPath.row == 0 {
                    
                    // Bad Habit
                    
                    if let cell = tableView.dequeueReusableCellWithIdentifier("habitCell") as? XKRWHabitRecordCell {
                        cell.setRecordEntity(self.recordEntity!)
                        
                        return cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height + 1
                    }
                    return 44.0
                }
            } else if tableView.tag == 201 {
                
                if indexPath.section == 0 {
                    
                    if foodsArray.count > 0 {
                        
                        if indexPath.row == 0 {
                           return 38
                        } else if indexPath.row == foodsCount + 1 {
                            return 44
                        } else {
                            return 80
                        }
                    } else {
                        
                        if indexPath.row == 0 {
                            return 38
                        } else if indexPath.row == sportsCount + 1 {
                            return 44
                        } else {
                            return 80
                        }
                    }
                } else if indexPath.section == 1 {
                    
                    if indexPath.row == 0 {
                        return 38
                    } else if indexPath.row == sportsCount + 1 {
                        return 44
                    } else {
                        return 80
                    }
                }
            }
        }
        return 44.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        cell?.setSelected(false, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView.tag == 50 {
            
            if indexPath.section == 0 {
                
                if indexPath.row == 0 {
                    
                    if(NSUserDefaults.standardUserDefaults().boolForKey("needResetScheme_\(XKRWUserService.sharedService().getUserId())"))
                    {
                        XKRWCui.showInformationHudWithText("当前方案已结束，请重置方案！")
                    }else{
                        MobClick.event("clk_WeightNote")
                        
                        let vc = XKRWSurroundDegreeVC()
                        vc.dataType = DataType(1)
                        vc.hidesBottomBarWhenPushed = true
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            } else if indexPath.section == 1 {
                
                if(NSUserDefaults.standardUserDefaults().boolForKey("needResetScheme_\(XKRWUserService.sharedService().getUserId())"))
                {
                    self.showToResetScheme()
                }else{
                
                    self.rightNaviBarButtonClicked()
                }
            }
         
        } else if tableView.tag == 101 {
            
            if indexPath.row == 0 {
                
                if self.sportScheme.schemeID != 0 {
                    MobClick.event("clk_SportDetail")
                    let vc = XKRWSchemeDetailVC()
                    vc.schemeEntity = self.sportScheme
                    vc.record = self.sportRecord
                    vc.sports = XKRWSchemeService_5_0.sharedService.getCurrentSchemeSportEntities()
                    vc.is_m = self.is_M
                    self.needReloadIndexPath = indexPath
                    self.needReloadTableView = tableView
                    
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    // reload all
                    if !self.isContentLoading {
                        self.initData()
                    }
                }
                
            } else if indexPath.row == 1 && XKRWUserService.sharedService().getSex().rawValue == eSexFemale.rawValue {
                // do nothing
                
                self.needReloadIndexPath = nil
                self.needReloadTableView = nil
                return
                
            } else {
                
                MobClick.event("clk_remind2")
                
                // to sport alarm setting
                let vc = XKRWAlarmVC()
                vc.type = eAlarmExercise
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
                self.needReloadIndexPath = indexPath
                self.needReloadTableView = tableView
            }
            
        } else if tableView.tag == 102 {
            
            if indexPath.row != 3 {
                
                if self.mealSchemes.count > indexPath.row {
                    
                    MobClick.event("clk_DietDetail")
                    let vc = XKRWSchemeDetailVC()
                    vc.schemeEntity = self.mealSchemes[indexPath.row]
                    vc.record = self.mealRecords[indexPath.row]
                    
                    self.needReloadIndexPath = indexPath
                    self.needReloadTableView = tableView
                    
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    // reload all
                    
                    if !self.isContentLoading {
                        self.initData()
                    }
                }
                
            } else if indexPath.row == 3 {
                
                MobClick.event("clk_remind")
                
                // to meal alarm setting
                let vc = XKRWAlarmVC()
                vc.type = eAlarmBreakfast
                vc.hidesBottomBarWhenPushed = true
                self.needReloadIndexPath = indexPath
                self.needReloadTableView = tableView
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        } else if tableView.tag == 103 {
            
            if indexPath.row == 0 {
                
                return
            } else if indexPath.row == 1 {
                
                MobClick.event("clk_remind3")
                
                // to habit alarm setting
                let vc = XKRWAlarmVC()
                vc.type = eAlarmHabit
                vc.hidesBottomBarWhenPushed = true
                self.needReloadIndexPath = indexPath
                self.needReloadTableView = tableView
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        

        if tableView.tag == 201 {
            
            if indexPath.section == 0 {
                
                if foodsArray.count > 0 {
                    
                    if indexPath.row == 0 {
                        
                    } else if indexPath.row == foodsCount + 1 {
                        //更多页面

                        let msvc: XKRWMoreSearchResultVC = XKRWMoreSearchResultVC()
                        msvc.dataArray = foodsArray
                        msvc.searchKey = self.searchKey
                        msvc.searchType = 1

                        msvc.isNeedHideNaviBarWhenPoped = false
                        self.isNeedHideNaviBarWhenPoped = true

                        self.navigationController?.pushViewController(msvc, animated: true);
                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                    } else {
                        //跳转到食物详情
                        let vc = XKRWFoodDetailVC()
                        vc.foodId = foodsArray[indexPath.row - 1].foodId
                        vc.isNeedHideNaviBarWhenPoped =  false
                        self.isNeedHideNaviBarWhenPoped = true
                        self.navigationController?.pushViewController(vc, animated: true)
                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                    }
                } else {
                    
                    if indexPath.row == 0 {
                        
                    } else if indexPath.row == sportsCount + 1 {
                        //更多页面
                        let msvc: XKRWMoreSearchResultVC = XKRWMoreSearchResultVC()
                        msvc.dataArray = sportsArray
                        msvc.searchKey = self.searchKey
                        msvc.searchType = 0
                        msvc.isNeedHideNaviBarWhenPoped =  false
                        self.isNeedHideNaviBarWhenPoped = true
                        self.navigationController?.pushViewController(msvc, animated: true);
                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                        
                    } else {
                        //跳转到运动详情
                        
                        let vc = XKRWSportDetailVC()
                        vc.sportID = self.sportsArray[indexPath.row - 1].sportId
                        vc.sportName = self.sportsArray[indexPath.row - 1].sportName
                        vc.isNeedHideNaviBarWhenPoped =  false
                        self.isNeedHideNaviBarWhenPoped = true
                        self.navigationController?.pushViewController(vc, animated: true)
                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                    }
                }
            } else if indexPath.section == 1 {
                
                if indexPath.row == 0 {
                    
                } else if indexPath.row == sportsCount + 1 {
                    //更多页面
                    
                    let msvc: XKRWMoreSearchResultVC = XKRWMoreSearchResultVC()
                    msvc.dataArray = sportsArray
                    msvc.searchKey = self.searchKey
                    msvc.searchType = 0
                    msvc.isNeedHideNaviBarWhenPoped =  false
                    self.isNeedHideNaviBarWhenPoped = true
                    self.navigationController?.pushViewController(msvc, animated: true);
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    
                } else {
                    //跳转到运动详情
                    let vc = XKRWSportDetailVC()
                    vc.sportID = self.sportsArray[indexPath.row - 1].sportId
                    vc.isNeedHideNaviBarWhenPoped =  false
                    self.isNeedHideNaviBarWhenPoped = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                }
            }
        }
    }
    
    // MARK: - UISearchBar's delegate
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        self.searchDisplayCtrl?.showSearchResultView()
        self.isNeedHideNaviBarWhenPoped = true
        return true
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(true, animated: true)
        self.isNeedHideNaviBarWhenPoped = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: false)
        
        self.searchDisplayCtrl?.hideSearchResultView()
        self.isNeedHideNaviBarWhenPoped = false
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.isNeedHideNaviBarWhenPoped = false
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        XKRWCui.showProgressHud("")
        self.isNeedHideNaviBarWhenPoped = false
        
        if !searchBar.text!.isEmpty {
            
            self.searchKey = searchBar.text
            
            self.downloadWithTaskID("search", outputTask: { () -> AnyObject! in
                return XKRWSearchService.sharedService.searchWithKey(searchBar.text!, type: .All, page: 1, pageSize: 30)
            })
            
            if searchBar.resignFirstResponder() {
                self.searchBar!.setCancelButtonEnable(true)
            }
        }
    }
    
    func searchBarBookmarkButtonClicked(searchBar: UISearchBar) {
        
        MobClick.event("clk_VoiceSerch")
        
        self.searchDisplayCtrl?.showSearchResultView()
        self.searchBar?.setCancelButtonEnable(true)
        
        if self.iFlyControl.hidden {
            self.iFlyControl.hidden = false
            self.iFlyControl.start()
        } else {
            self.iFlyControl.hidden = true
            self.iFlyControl.cancel()
        }
    }
    
    // MARK: - iFly's delegate
    
    func onError(error: IFlySpeechError!) {
        
        if error.errorCode() != 0 {
            XKRWCui.showInformationHudWithText("搜索失败")
        }
    }
    
    func onResult(resultArray: [AnyObject]!, isLast: Bool) {
        
        if resultArray != nil && resultArray.count > 0 {
            
            if((resultArray.last as! NSDictionary).allKeys.last as! String != "。" && (resultArray.last as! NSDictionary).allKeys.last as! String != "？"
                && (resultArray.last as! NSDictionary).allKeys.last as! String != "！"
                && (resultArray.last as! NSDictionary).allKeys.last as! String != "，") {
                
                self.searchBar!.text = (resultArray.last as! NSDictionary).allKeys.last as? String
                self.searchBarSearchButtonClicked(self.searchBar!)
            }
        }
    }
    
    // MARK: - UIAlertView's delegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if alertView.tag == 12345 {
            
            if !XKRWUserService.sharedService().getUserNickNameIsEnable() {
                let nicknameSetVC = XKRWModifyNickNameVC()
                nicknameSetVC.hidesBottomBarWhenPushed = true
                nicknameSetVC.notShowBackButton = true
                self.navigationController?.pushViewController(nicknameSetVC, animated: false)
            }
  
            return
        }
        
        if alertView.tag == 10000{
            if buttonIndex == alertView.cancelButtonIndex {
                
                MobClick.event("tips_mc_on_ok")
            }
                
            else {
                MobClick.event("tips_mc_on_reload")
                
                let vc = XKRWSchemeDetailVC()
                vc.schemeEntity = self.sportScheme
                vc.is_m = self.is_M
                vc.autoChangeContent = true
                vc.record = self.sportRecord
                vc.sports = XKRWSchemeService_5_0.sharedService.getCurrentSchemeSportEntities()
                
                if let tableView = self.scrollCell.viewWithTag(101) as? UITableView {
                    self.needReloadTableView = tableView
                    self.needReloadIndexPath = NSIndexPath(forRow: 0, inSection: 0)
                }

                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        
        if alertView.tag == 10001{
            if buttonIndex == 0{
                MobClick.event("clk_finish")
                self.showFlowerInWindow()
            }else if buttonIndex == 1{
                XKRWCui.showProgressHud("重置用户减肥方案中...")
                MobClick.event("clk_unfinished")
                XKRWSchemeService_5_0.sharedService.resetUserScheme(self)
            }
            return
        }
        
        if alertView.tag == 10002{
            if buttonIndex == 0{
                XKRWCui.showProgressHud("重置用户减肥方案中...")
                XKRWSchemeService_5_0.sharedService.resetUserScheme(self)
            }
        }
        
        if alertView.tag == 10003{
            if buttonIndex == 0{
                
            }else if buttonIndex == 1{
                MobClick.event("clk_Rest1")
                XKRWCui.showProgressHud("重置用户减肥方案中...")
                XKRWSchemeService_5_0.sharedService.resetUserScheme(self)
            }
        
        }
        
        
    }
    

    //MARK: - Header's delegate
    
    func clickButtonAtIndex(index: Int) {
        
        self.scrollCell.scrollToPage(index)
        
        let adHeight: CGFloat = self.isAdOn ? 60 : 0
        
        if self.tableView.contentOffset.y > self.weightView!.height + adHeight + 20 {
            
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
    }
}
