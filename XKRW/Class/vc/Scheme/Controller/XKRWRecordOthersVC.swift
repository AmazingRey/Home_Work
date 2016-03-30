//
//  XKRWRecordOthersVC.swift
//  XKRW
//
//  Created by Klein Mioke on 15/6/25.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWRecordOthersVC: XKRWBaseVC, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, KMSearchDisplayControllerDelegate, IFlyRecognizerViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    
    var search_bar: KMSearchBar = KMSearchBar(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 44))
    var searchDisplayCtrl: KMSearchDisplayController?
    
    var needShowSearchHistories: Bool = true
    
    var isLoad: Bool = false
    
    var eatMillions: UIView?
    var eatMillionsButton: UIButton?
    
    var date: NSDate?
    var type: XKRWSchemeType?
    
    var searchType: XKRWSearchType?
    
    var searchKeys: NSMutableArray = NSMutableArray()
    var searchResults = [AnyObject]()
    
    var recordEntity: XKRWRecordEntity4_0 = XKRWRecordEntity4_0()
    var records = [AnyObject]()
    var recordsCalorie: NSInteger = 0
    
    var totalCalorie: NSInteger = 0
    
    var schemeEntity: XKRWRecordSchemeEntity?
    var originRecordValue: NSInteger?
    
    var iFlyControl: IFlyRecognizerView!
    
    //MARK: - Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //MARK: - System's Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNaviBarBackButton()
        self.hidesBottomBarWhenPushed = true
        
        self.edgesForExtendedLayout = UIRectEdge.Top
        self.view.backgroundColor = XK_BACKGROUND_COLOR

        // Do any additional setup after loading the view.
        self.search_bar.delegate = self
        
        self.search_bar.showsBookmarkButton = true
        self.search_bar.showsScopeBar = true
        self.search_bar.barTintColor = XK_BACKGROUND_COLOR
        self.search_bar.layer.borderWidth = 0.5
        self.search_bar.layer.borderColor = XK_ASSIST_LINE_COLOR.CGColor
        
        self.search_bar.setImage(UIImage(named: "voice"), forSearchBarIcon: UISearchBarIcon.Bookmark, state: UIControlState.Normal)
        
        self.searchDisplayCtrl = KMSearchDisplayController(searchBar: self.search_bar, contentsController: self)
        
        self.searchDisplayCtrl!.delegate = self
        self.searchDisplayCtrl!.searchResultDelegate = self
        self.searchDisplayCtrl!.searchResultDataSource = self
        
        self.searchDisplayCtrl!.searchResultTableView.tag = 201
        
        if self.type != nil {
            
            var placeholder = ""
            switch self.type! {
            case .Sport:
                
                placeholder = "记录运动"
                self.title = "做了别的"
                self.searchType = .Sport
                self.tableView.tableFooterView = UIView()
                
            case let x:
                placeholder = "记录食物"
                self.title = "吃了别的"
                self.searchType = .Food
                
                self.bottomSpace.constant = 75
                
                eatMillionsButton = UIButton(frame: CGRectMake(0, UI_SCREEN_HEIGHT - 75, UI_SCREEN_WIDTH, 75))
                
                eatMillionsButton!.setTitle("我吃了大餐", forState: UIControlState.Normal)
                eatMillionsButton!.titleLabel?.font = UIFont.systemFontOfSize(14)

                eatMillionsButton!.setTitleColor(XK_TITLE_COLOR, forState: UIControlState.Normal)
                eatMillionsButton!.backgroundColor = UIColor.whiteColor()
                eatMillionsButton!.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 10)
                
                eatMillionsButton?.setImage(UIImage(named: "feast_select_"), forState: UIControlState.Normal)
                eatMillionsButton?.setImage(UIImage(named: "feast_select_s_"), forState: UIControlState.Selected)
                
                eatMillionsButton?.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, UI_SCREEN_WIDTH / 2 - 70)
                
                eatMillionsButton!.addTarget(self, action: "eatALot:", forControlEvents: UIControlEvents.TouchUpInside)
                
                self.view.addSubview(eatMillionsButton!)
                
                eatMillionsButton!.mas_makeConstraints({ (maker: MASConstraintMaker!) -> Void in
                    maker.bottom.mas_equalTo()(self.view).with().offset()(0)
                    maker.leading.mas_equalTo()(self.view).with().offset()(0)
                    maker.width.mas_equalTo()(UI_SCREEN_WIDTH)
                    maker.height.mas_equalTo()(75)
                })
                
                let subtitle = UILabel(frame: CGRectMake(0, 37.5, UI_SCREEN_WIDTH, 20))
                subtitle.font = UIFont.systemFontOfSize(14)
                subtitle.textAlignment = NSTextAlignment.Center
                subtitle.text = XKRWRecordService4_0.sharedService().getEatALotTextFromLocal()
                subtitle.textColor = XK_TITLE_COLOR
                
                eatMillionsButton?.addSubview(subtitle)
                
                var line = UIView(frame: CGRectMake(0, 0, eatMillionsButton!.width, 0.5))
                line.backgroundColor = XK_ASSIST_LINE_COLOR
                eatMillionsButton!.addSubview(line)
                
                line = UIView(frame: CGRectMake(0, eatMillionsButton!.height - 0.5, eatMillionsButton!.width, 0.5))
                line.backgroundColor = XK_ASSIST_LINE_COLOR
                eatMillionsButton!.addSubview(line)
                
                self.eatMillions = UIView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, self.view.height - eatMillionsButton!.height))
                self.eatMillions?.backgroundColor = XK_BACKGROUND_COLOR
                
                let imageView = UIImageView(image: UIImage(named: "feast_pic_"))
                imageView.center = CGRectGetCenter(self.eatMillions!.bounds)
                self.eatMillions?.addSubview(imageView)
                
                if self.schemeEntity?.record_value == 5 {
                    self.showEatMillions(true, animate: false)
                    eatMillionsButton!.selected = true
                }
                
                var ratio: Float = 0
                switch x {
                case .Breakfast:
                    ratio = 0.3
                case .Dinner:
                    ratio = 0.2
                case .Lunch:
                    ratio = 0.5
                default:
                    break
                }
                self.totalCalorie = NSInteger(XKRWAlgolHelper.dailyIntakeRecomEnergy() * ratio)

            }
            self.search_bar.placeholder = placeholder
        }
        self.originRecordValue = self.schemeEntity?.record_value
        
//        self.tableView.backgroundColor = XK_BACKGROUND_COLOR
        self.tableView.tableHeaderView = self.search_bar
        self.tableView.tag = 101
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.tableView.registerNib(UINib(nibName: "XKRWRecordsCell_V5", bundle: nil), forCellReuseIdentifier: "recordCell")
        self.searchDisplayCtrl?.searchResultTableView.registerNib(UINib(nibName: "XKRWFoodRecordCell", bundle: nil), forCellReuseIdentifier: "searchResultCell")
        
        self.iFlyControl = IFlyRecognizerView(center: CGPointMake((UI_SCREEN_WIDTH)/2, UI_SCREEN_HEIGHT/2))
        self.iFlyControl.setParameter("iat", forKey: IFlySpeechConstant.IFLY_DOMAIN())
        self.iFlyControl.setParameter("asrview.pcm", forKey: IFlySpeechConstant.ASR_AUDIO_PATH())
        self.iFlyControl.setParameter("20000", forKey: IFlySpeechConstant.NET_TIMEOUT())
        self.iFlyControl.setParameter("16000", forKey: IFlySpeechConstant.SAMPLE_RATE())
        self.iFlyControl.setParameter("plain", forKey: IFlySpeechConstant.RESULT_TYPE())
        self.iFlyControl.setParameter("", forKey:IFlySpeechConstant.ASR_PTT())
        self.iFlyControl.delegate = self
        self.iFlyControl.hidden = true
        
        self.view.addSubview(self.iFlyControl)
    }
    
    internal func initData() -> Void {
        
        // TODO: do get data by type
        self.records.removeAll(keepCapacity: false)
        self.recordsCalorie = 0
        
        if self.date != nil {
            
            self.recordEntity = XKRWRecordService4_0.sharedService().getAllRecordOfDay(self.date)
            self.schemeEntity = XKRWRecordService4_0.sharedService().getSchemeRecordWithDate(self.date, type: RecordType(rawValue: self.type!.rawValue)!)
            
            if self.schemeEntity == nil {
                self.schemeEntity = XKRWRecordSchemeEntity()
                self.schemeEntity?.record_value = 0
                self.schemeEntity?.type = RecordType(rawValue: self.type!.rawValue)!
            }
            self.originRecordValue = self.schemeEntity?.record_value
        }
        
        if self.type == .Sport {
            
            for entity in self.recordEntity.SportArray {
                if entity is XKRWRecordSportEntity {
                    let sportEntity = entity as! XKRWRecordSportEntity
                    
                    if sportEntity.recordType.rawValue == self.type?.rawValue {
                        self.records.append(sportEntity)
                        self.recordsCalorie += sportEntity.calorie
                    }
                }
            }
        } else {
            
            for entity in self.recordEntity.FoodArray {
                if entity is XKRWRecordFoodEntity {
                    let foodEntity = entity as! XKRWRecordFoodEntity
                    
                    if foodEntity.recordType.rawValue == self.type?.rawValue {
                        self.records.append(foodEntity)
                        self.recordsCalorie += foodEntity.calorie
                    }
                }
            }
        }
        self.searchKeys = XKRWSearchService.sharedService.getSearchKeysByType(self.searchType!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.eatMillions?.height = self.view.height - self.bottomSpace.constant
        self.eatMillionsButton?.setY(self.view.height - self.bottomSpace.constant)
        
        self.initData()
        
        if !self.isLoad {
            self.isLoad = true
        }
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Networking
    
    override func shouldRespondForDefaultNotificationForDetailName(detailName: String!) -> Bool {
        return true
    }
    
    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {
        
        XKRWCui.hideProgressHud()
        
        if taskID == "searchTask" {
            var rst = result as! [String: AnyObject]
            
            if self.searchType == .Sport {
                self.searchResults += rst["sport"] as! [AnyObject]
            } else {
                self.searchResults += rst["food"] as! [AnyObject]
            }
            
            if !self.searchDisplayCtrl!.isShowSearchResultTableView {
                self.searchDisplayCtrl?.showSearchResultTableView()
            }
            self.needShowSearchHistories = false
            self.searchDisplayCtrl?.reloadSearchResultTableView()
        }
    }
    
    override func handleDownloadProblem(problem: AnyObject!, withTaskID taskID: String!) {
        
        super.handleDownloadProblem(problem, withTaskID: taskID)
        
        XKRWCui.hideProgressHud()
        if taskID == "searchTask" {
            XKRWCui.showInformationHudWithText("搜索失败")
        }
    }

    //MARK: - UITableView's delegate & datasource
    
    //MARK: Header
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    //MARK: Cell
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 101 {
            
            if self.type != nil {
                
                return self.records.count + 1
            } else {
                return 0;
            }
        }
        
        if tableView.tag == 201 {
            
            if self.needShowSearchHistories {
                return self.searchKeys.count + 1
            } else {
                return self.searchResults.count
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if tableView.tag == 101 {
            if indexPath.row == 0 {
                return 38
            }
            return 44
        }
        if tableView.tag == 201 {
            
            if self.needShowSearchHistories {
                return 38
            } else {
                return 82
            }
        }
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.tag == 101 {
            if indexPath.row == 0 {
                
                var cell = tableView.dequeueReusableCellWithIdentifier("categoryCell") as? XKRWSearchResultCategoryCell
                if cell == nil {
                    cell = (loadViewFromBundle("XKRWSearchResultCategoryCell", owner: self) as! XKRWSearchResultCategoryCell)
                }
                
                var isGoodJob = true
                var titleStr = "\(self.type!.getDescription())建议\(XKRWAlgolHelper.dailyConsumeSportEnergy())kcal, 当前共计"
                let normal = [NSFontAttributeName: XKDefaultNumFontWithSize(14), NSForegroundColorAttributeName: XK_ASSIST_TEXT_COLOR]
                
                if self.type == .Sport {
                    
                    if self.recordsCalorie < Int(XKRWAlgolHelper.dailyConsumeSportEnergy()) {
                    isGoodJob = false
                    }
                } else {
                    
                    titleStr = "\(self.type!.getDescription())建议摄入\(Int(CGFloat(self.totalCalorie) * 0.9))-\(self.totalCalorie)kcal, 当前共计"
                    
                    if self.recordsCalorie > self.totalCalorie {
                        isGoodJob = false

                    }
                    
                }
                let text = NSMutableAttributedString(string: titleStr)
                text.addAttributes(normal, range: NSMakeRange(0, text.length))
                
                var highlighted = [NSFontAttributeName: XKDefaultNumFontWithSize(14), NSForegroundColorAttributeName: XKMainSchemeColor]
                if isGoodJob == false {
                    highlighted = [NSFontAttributeName:XKDefaultNumFontWithSize(14),
                        NSForegroundColorAttributeName: XK_STATUS_COLOR_FEW]
                }
                let currentCalStr = NSAttributedString(string: "\(self.recordsCalorie)", attributes: highlighted)
                
                text.appendAttributedString(currentCalStr);
                
                let kcal = NSAttributedString(string: "kcal", attributes: normal)
                text.appendAttributedString(kcal)
                
                cell?.title?.attributedText = text
                cell!.selectionStyle = .None
                return cell!
                
            } else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("recordCell") as! XKRWRecordsCell_V5
                
                switch self.type! {
                case .Sport:
                    let entity = self.records[indexPath.row - 1] as! XKRWRecordSportEntity
                    
                    var sportName: NSMutableString
                    
                    if (entity.sportName as NSString).length > 10 {
                        
                        sportName = NSMutableString(string: (entity.sportName as NSString).substringToIndex(8))
                        sportName.appendString("...")
                    }
                    else {
                        sportName = NSMutableString(string: entity.sportName)
                    }
                    
                    let title = "\(sportName) / \(entity.number)分钟"
                    
                    cell.setTitle(title, detail: "\(entity.calorie)kcal")
                case .Breakfast, .Dinner, .Lunch, .Snack:
                    
                    let entity = self.records[indexPath.row - 1] as! XKRWRecordFoodEntity
                    var title: String
                    
                    var foodName: NSMutableString
                    
                    if (entity.foodName as NSString).length > 10 {
                        
                        foodName = NSMutableString(string: (entity.foodName as NSString).substringToIndex(8))
                        foodName.appendString("...")
                    }
                    else {
                        foodName = NSMutableString(string: entity.foodName)
                    }
                    
                    if entity.unit_new != nil && !entity.unit_new.isEmpty {
                        
                        title = "\(foodName) / \(entity.number_new)\(entity.unit_new)"
                    } else {
                        title = "\(foodName) / \(entity.number)\(self.getMetricUnitDescription(MetricUnit(UInt32(entity.unit))))"
                    }
                    cell.setTitle(title, detail: "\(entity.calorie)kcal")
                }
                return cell
            }
        }
        
        if tableView.tag == 201 {
            
            if self.needShowSearchHistories {
                // show search histories
                
                if indexPath.row < self.searchKeys.count {
                    
                    var cell = tableView.dequeueReusableCellWithIdentifier("searchHistoryCell")
                    if cell == nil {
                        cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "searchHistoryCell")
                        cell!.textLabel?.font = UIFont.systemFontOfSize(14)
                        cell!.textLabel?.textColor = XK_TEXT_COLOR
                    }
                    cell!.textLabel?.text = self.searchKeys[indexPath.row] as? String
                    
                    return cell!
                } else {
                    
                    var cell = tableView.dequeueReusableCellWithIdentifier("cleanHistoryCell")
                    if cell == nil {
                        cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cleanHistoryCell")
                        
                        let textLabel = UILabel(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, cell!.height))
                        textLabel.font = UIFont.systemFontOfSize(14)
                        textLabel.textColor = XK_ASSIST_TEXT_COLOR
                        textLabel.textAlignment = .Center
                        
                        textLabel.text = "清除历史数据"
                        
                        cell?.contentView.addSubview(textLabel)
                    }
                    return cell!
                }
                
            } else {
                
                // show search result
                let cell = tableView.dequeueReusableCellWithIdentifier("searchResultCell") as! XKRWFoodRecordCell
                cell.indexPath = indexPath
                if self.searchResults.count > indexPath.row {
                    
                    weak var weakSelf = self
                    if self.searchType == .Sport {
                        
                        let entity = self.searchResults[indexPath.row] as! XKRWSportEntity
                        cell.setTitle(entity.sportName, logoURL: entity.sportActionPic, clickDetail: { (indexPath) -> () in
                            
                            self.search_bar.resignFirstResponder()
                            self.search_bar.setCancelButtonEnable(true)
                            
                            let vc = XKRWSportDetailVC()
                            vc.sportEntity = entity
                            vc.sportID = entity.sportId
                            vc.isNeedHideNaviBarWhenPoped = false
                            self.isNeedHideNaviBarWhenPoped = true;
                            
                            vc.isPresent = true
                            let nav = XKRWNavigationController(rootViewController: vc)
                            weakSelf?.navigationController?.presentViewController(nav, animated: true, completion: nil)
                            
                        }, clickRecord: { (indexPath) -> () in
                            
                            self.search_bar.resignFirstResponder()
                            self.search_bar.setCancelButtonEnable(true)
                                
                            let vc = XKRWSportAddVC()
                            vc.sportEntity = entity
                            vc.recordEneity = self.recordEntity
                            vc.isNeedHideNaviBarWhenPoped = false
                            self.isNeedHideNaviBarWhenPoped = true;
                            
                            vc.passMealTypeTemp = eSport;
                            vc.needHiddenDate = true;
                            
                            vc.isPresent = true
                            let nav = XKRWNavigationController(rootViewController: vc)
                            weakSelf?.navigationController?.presentViewController(nav, animated: true, completion: nil)
                        })
                    } else {
                        let entity = self.searchResults[indexPath.row] as! XKRWFoodEntity
                        
                        cell.setTitle(entity.foodName, logoURL: entity.foodLogo, clickDetail: { (indexPath) -> () in
                            
                            self.search_bar.resignFirstResponder()
                            self.search_bar.setCancelButtonEnable(true)
                            
                            let vc = XKRWFoodDetailVC()
                            vc.foodEntity = entity
                            vc.isPresent = true
                            let nav = XKRWNavigationController(rootViewController: vc)
                            
                            vc.isNeedHideNaviBarWhenPoped = false
                            self.isNeedHideNaviBarWhenPoped = true;
                            
                            weakSelf?.navigationController?.presentViewController(nav, animated: true, completion: nil)

                        }, clickRecord: { (indexPath) -> () in
                            
                            self.search_bar.resignFirstResponder()
                            self.search_bar.setCancelButtonEnable(true)
                                
                            // new entity
                            let recordEntity = XKRWRecordFoodEntity()
                            recordEntity.recordType = RecordType(rawValue: self.type!.rawValue)!
                            recordEntity.date = self.recordEntity.date
                            
                            // set properties
                            let properties = NSDictionary(propertiesFromObject: entity)
                            properties.setPropertiesToObject(recordEntity)
                            
                            let vc = XKRWAddFoodVC4_0()
                            vc.isNeedHideNaviBarWhenPoped = false
                            vc.foodRecordEntity = recordEntity
                            vc.recordEntity = self.recordEntity
                            vc.isNeedHideNaviBarWhenPoped = false
                            self.isNeedHideNaviBarWhenPoped = true;
                            XKRWAddFoodVC4_0.presentAddFoodVC(vc, onViewController: self)
                        })
                    }
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    // MARK: Action
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setSelected(false, animated: true)
        
        if tableView.tag == 101 {
            
            if indexPath.row != 0 {
                
                switch self.type! {
                case .Sport:
                    let entity = self.records[indexPath.row - 1] as! XKRWRecordSportEntity
                    
                    let vc = XKRWSportAddVC()
                    vc.recordSportEntity = entity
                    vc.isModify = true
//                    self.navigationController?.pushViewController(vc, animated: true)
                    vc.isPresent = true
                    vc.isNeedHideNaviBarWhenPoped = false;
                    self.isNeedHideNaviBarWhenPoped = true;
                    let nav = XKRWNavigationController(rootViewController: vc)
                    self.navigationController?.presentViewController(nav, animated: true, completion: nil)
                    
                case .Breakfast, .Dinner, .Lunch, .Snack:
                    let entity = self.records[indexPath.row - 1] as! XKRWRecordFoodEntity
                    
                    let vc = XKRWAddFoodVC4_0()
                    vc.foodRecordEntity = entity

//                    self.navigationController?.pushViewController(vc, animated: true)
                    vc.isPresent = true
                    vc.isNeedHideNaviBarWhenPoped = false;
//                    self.isNeedHideNaviBarWhenPoped = true;
                    let nav = XKRWNavigationController(rootViewController: vc)
                    self.navigationController?.presentViewController(nav, animated: true, completion: nil)
                }
            }
        }
        
        if tableView.tag == 201 {
            
            if self.needShowSearchHistories {
                
                if indexPath.row < self.searchKeys.count {
                    self.search_bar.text = self.searchKeys[indexPath.row] as? String
                    self.searchBarSearchButtonClicked(self.search_bar)
                } else {
                    self.searchKeys.removeAllObjects()
                    XKRWSearchService.sharedService.cleanSearchKeysByType(self.searchType!)
                    
                    tableView.reloadData()  
                }
            }
            
            //
            if self.searchResults.count > indexPath.row {
                
                weak var weakSelf = self
                if self.searchType == .Sport {
                    
                    let entity = self.searchResults[indexPath.row] as! XKRWSportEntity
                    let vc = XKRWSportDetailVC()
                    vc.sportEntity = entity
                    vc.sportID = entity.sportId
//                    vc.isNeedHideNaviBarWhenPoped = true
                    vc.isNeedHideNaviBarWhenPoped = false;
                    self.isNeedHideNaviBarWhenPoped = true;
                    vc.isPresent = true
                    let nav = XKRWNavigationController(rootViewController: vc)
                    weakSelf?.navigationController?.presentViewController(nav, animated: true, completion: nil)
                    
                } else {
                    let entity = self.searchResults[indexPath.row] as! XKRWFoodEntity
                    
                    let vc = XKRWFoodDetailVC()
                    vc.foodEntity = entity
//                    vc.isNeedHideNaviBarWhenPoped = true
                    vc.isNeedHideNaviBarWhenPoped = false;
                    self.isNeedHideNaviBarWhenPoped = true;
                    vc.isPresent = true
                    let nav = XKRWNavigationController(rootViewController: vc)
                    weakSelf?.navigationController?.presentViewController(nav, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        if tableView.tag == 101 {
            return UITableViewCellEditingStyle.Delete
        }
        return .None
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView.tag == 101 {
            if editingStyle == .Delete {
                
                let entity: (AnyObject) = self.records.removeAtIndex(indexPath.row - 1)
                
                self.downloadWithTaskID("deleteRecord", outputTask: { () -> AnyObject! in
                    
                    return XKRWRecordService4_0.sharedService().deleteRecord(entity)
                })
                
                if self.type == .Sport {
                    self.recordEntity.SportArray.removeObject(entity)
                    self.recordsCalorie -= (entity as! XKRWRecordSportEntity).calorie
                    
                } else {
                    self.recordEntity.FoodArray.removeObject(entity)
                    self.recordsCalorie -= (entity as! XKRWRecordFoodEntity).calorie
                }
                tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.search_bar.resignFirstResponder()
        self.search_bar.setCancelButtonEnable(true)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
//        self.searchDisplayCtrl?.showSearchResultView()
        self.isNeedHideNaviBarWhenPoped = true
        return true
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchDisplayCtrl?.showSearchResultView()
        self.isNeedHideNaviBarWhenPoped = true
        if !self.searchDisplayCtrl!.isShowSearchResultTableView {
            self.searchDisplayCtrl!.showSearchResultTableView()
        }
        self.searchDisplayCtrl?.reloadSearchResultTableView()
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.isNeedHideNaviBarWhenPoped = false
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    
    func searchBarBookmarkButtonClicked(searchBar: UISearchBar) {
        self.isNeedHideNaviBarWhenPoped = false
        
        self.searchDisplayCtrl?.showSearchResultView()
        self.search_bar.setCancelButtonEnable(true)
        
        if self.iFlyControl.hidden {
            self.iFlyControl.hidden = false
            self.iFlyControl.start()
        } else {
            self.iFlyControl.hidden = true
            self.iFlyControl.cancel()
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.isNeedHideNaviBarWhenPoped = false
        self.searchDisplayCtrl?.hideSearchResultView()
        self.needShowSearchHistories = true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.isNeedHideNaviBarWhenPoped = false
        guard searchBar.text != nil else {
            return
        }
        
        if !searchBar.text!.isEmpty {
            
            self.searchResults.removeAll(keepCapacity: false)
            
            XKRWCui.showProgressHud("")
            
            if !self.searchKeys.containsObject(searchBar.text!) {
                self.searchKeys.insertObject(searchBar.text!, atIndex: 0)
            }
            
            self.downloadWithTaskID("searchTask", outputTask: { () -> AnyObject! in
                
                return XKRWSearchService.sharedService.searchWithKey(searchBar.text!, type: self.searchType!, page: 1, pageSize: 30)
            })
            if searchBar.resignFirstResponder() {
                self.search_bar.setCancelButtonEnable(true)
            }
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
                
                self.search_bar.text = (resultArray.last as! NSDictionary).allKeys.last as? String
                self.searchBarSearchButtonClicked(self.search_bar)
            }
        }
    }

    // MARK: - Other funcitons
    func getMetricUnitDescription(unit: MetricUnit) -> NSString {
    
        let i = unit.rawValue
        
        switch (i) {
        case 1:
            return "克";
        case 2:
            return "千焦";
        case 3:
            return "kcal";
        case 4:
            return "盒";
        case 5:
            return "块";
        case 6:
            return "毫升"
        case 7:
            return "分钟"
        default:
            return "";
        }
    }
    
    func eatALot(sender: UIButton) -> Void {
        
        MobClick.event("clk_EatMore")
        
        sender.selected = !sender.selected
        
        if sender.selected {
            self.showEatMillions(true, animate: true)
            
            self.schemeEntity?.record_value = 5
            
//            self.downloadWithTaskID("recordALot", outputTask: { () -> AnyObject! in
//                if self.schemeEntity != nil {
//                    return XKRWRecordService4_0.sharedService().saveRecord(self.schemeEntity!, ofType: XKRWRecordType.Scheme)
//                }
//                return nil
//            })
        } else {
            self.showEatMillions(false, animate: true)
            self.schemeEntity?.record_value = self.originRecordValue ?? 0
            
            if self.schemeEntity?.record_value == 5 {
                self.schemeEntity?.record_value = 1
            }
        }
    }
    
//    override func viewWillDisappear(animated:Bool){
//        
//        super.viewWillDisappear(animated)
//        
//        self.popView()
//        
//    }
    
    override func popView() {
        super.popView()
        
        //吃了别的  处理数据的地方  >.<
        if self.type == .Sport {
            
            if self.recordsCalorie == 0 {
                
                if self.originRecordValue != nil && self.originRecordValue < 3 {
                    return
                } else {
                    self.schemeEntity?.record_value = 1
                    self.schemeEntity?.calorie = 0
                }
            } else {
                self.schemeEntity?.record_value = 3
                self.schemeEntity?.calorie = self.recordsCalorie
            }
        } else {
            
            if self.schemeEntity?.record_value == 5 {
//                self.schemeEntity?.calorie = 0   //吃了大餐  拿实际值
                self.schemeEntity?.calorie = self.totalCalorie*6/5
                
            } else {
                // if calorie is equal to 0, means there's no record.
                if self.recordsCalorie == 0 && self.records.count == 0 {
                    
                    if self.originRecordValue == nil || self.originRecordValue == 0 || self.schemeEntity?.record_value == 2{
                        return
                    } else {
                        self.schemeEntity?.record_value = 1
                        self.schemeEntity?.calorie = 0
                    }
                    
                } else if self.recordsCalorie <= self.totalCalorie {
                    self.schemeEntity?.record_value = 3
                    self.schemeEntity?.calorie = self.recordsCalorie
                } else {
                    self.schemeEntity?.record_value = 4
                    self.schemeEntity?.calorie = self.recordsCalorie
                }
            }
            
        }
        self.downloadWithTaskID("recordScheme", outputTask: { () -> AnyObject! in
            if self.schemeEntity != nil {
                return XKRWRecordService4_0.sharedService().saveRecord(self.schemeEntity!, ofType: XKRWRecordType.Scheme)
            }
            return nil
        })
    }
    
    func showEatMillions(show: Bool, animate: Bool) -> Void {
        
        if self.eatMillions == nil {
            return
        }
        var duration: Double = 0.0
        if animate {
            duration = 0.3
        }
        
        if show {
            self.eatMillions!.alpha = 0.0
            self.view.addSubview(eatMillions!)
            
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.eatMillions!.alpha = 1
            }, completion: { (finished) -> Void in
                
            })
        } else {
            
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.eatMillions!.alpha = 0.0
            }, completion: { (finished) -> Void in
                
                self.eatMillions!.removeFromSuperview()
            })
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
