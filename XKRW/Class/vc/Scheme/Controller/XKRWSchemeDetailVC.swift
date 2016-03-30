//
//  XKRWSchemeDetailVC.swift
//  XKRW
//
//  Created by Klein Mioke on 15/8/14.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWSchemeDetailVC: XKRWBaseVC, UITableViewDelegate, UITableViewDataSource, KMPopSelectionViewDelegate {
    
    // MARK: - Properties
    
    var tableView: UITableView!
    
    weak var schemeEntity: XKRWSchemeEntity_5_0?
    weak var record: XKRWRecordSchemeEntity?
    
    var sports: [XKRWSportEntity]?
    var is_m = 0
    var autoChangeContent:Bool = false
    var mealDescriptionHeader: SDDescriptionHeaderView = SDDescriptionHeaderView.instanceView()
    
    var selectionView: KMPopSelectionView?
    
    // MARK: - System's function

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        MobClick.event("clk_DietDetail")
        
        self.addNaviBarBackButton()
        self.edgesForExtendedLayout = UIRectEdge.Top
        
        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        self.tableView.backgroundColor = XK_BACKGROUND_COLOR
        self.tableView.separatorStyle = .None
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.addSubview(self.tableView)
        
        
        
        let width = ("换一组" as NSString).boundingRectWithSize(CGSizeMake(CGFloat.max, CGFloat.max),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: UIFont.systemFontOfSize(15)],
            context: nil).size.width
        
        let rightNaviButton = UIButton(frame: CGRectMake(0, 0, width, 50))
        rightNaviButton.setTitle("换一组", forState: UIControlState.Normal)
        rightNaviButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        rightNaviButton.addTarget(self, action: "doClickNaviBarRightButton:", forControlEvents: .TouchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNaviButton)
        
        if self.schemeEntity?.schemeType == .Sport {
            // sport
            self.title = self.schemeEntity!.schemeName
            
            self.tableView.registerNib(UINib(nibName: "SDSportSchemeCell", bundle: nil), forCellReuseIdentifier: "sportCell")
            if self.autoChangeContent {
                self.doClickNaviBarRightButton("")
            }
            if self.sports == nil || self.sports?.count == 0 {
                
                XKRWCui.showProgressHud()
                
                self.downloadWithTaskID("downloadSport", outputTask: { () -> AnyObject! in
                    return XKRWSportService.shareService().batchDownloadSportWithIDs(self.schemeEntity!.content)
                })
            }
            
        } else {
            // meal
            
            self.title = self.schemeEntity!.schemeType.getDescription() + "方案"
            
            self.mealDescriptionHeader.setContentWithEntity(self.schemeEntity!)
            
            self.tableView.registerNib(UINib(nibName: "SDChangeSizeCell", bundle: nil), forCellReuseIdentifier: "changeCell")
            self.tableView.registerNib(UINib(nibName: "SDMealSchemeCell", bundle: nil), forCellReuseIdentifier: "mealCell")
//            self.mealComputeCell = self.tableView.dequeueReusableCellWithIdentifier("mealCell") as! SDMealSchemeCell
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // sport tip
        if XKRWUserService.sharedService().shouldShowTipsInVC(self, withFlag: 0) && self.schemeEntity!.schemeType == .Sport {
            self.showTip()
            XKRWUserService.sharedService().setShouldShowTips(false, inVC: self, withFlag: 0)
        }
        // foods tip
        if XKRWUserService.sharedService().shouldShowTipsInVC(self, withFlag: 1) && self.schemeEntity!.schemeType != .Sport {
            self.showTip()
            XKRWUserService.sharedService().setShouldShowTips(false, inVC: self, withFlag: 1)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - UITableView's delegate & datasource
    
    //MARK: Header
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if self.schemeEntity?.schemeType != .Sport {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if self.schemeEntity?.schemeType != .Sport {
            
            if section == 1 {
                return self.mealDescriptionHeader.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.schemeEntity?.schemeType != .Sport {
            
            if section == 1 {
                return self.mealDescriptionHeader
            }
        }
        return nil
    }
    
    //MARK: Cell
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.schemeEntity?.schemeType == .Sport {
            
            return self.sports?.count ?? 0
            
        } else {
            
            if section == 0 {
                return 1
            } else {
                
                if self.schemeEntity != nil {
                    return self.schemeEntity!.foodCategories.count
                }
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if self.schemeEntity?.schemeType == .Sport {
            // sport
            
            if let cell = self.tableView.dequeueReusableCellWithIdentifier("sportCell") as? SDSportSchemeCell {
                
                cell.setContentWithEntity(self.sports![indexPath.row])
                return cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height + 1
                
            } else {
                return 249
            }
            
        } else {
            // meal
            if indexPath.section == 0 {
                return 44
                
            } else {
                
                if let cell = self.tableView.dequeueReusableCellWithIdentifier("mealCell") as? SDMealSchemeCell {
                    
                    cell.calculateHeightWithEntity(self.schemeEntity!.foodCategories[indexPath.row])
                    print(cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height + 1)
                    return cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height + 1
                } else {
                    return 366
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if self.schemeEntity?.schemeType == .Sport {
            // sport
            
            if let cell = self.tableView.dequeueReusableCellWithIdentifier("sportCell") as? SDSportSchemeCell {
                
                let sport = self.sports![indexPath.row]
                cell.setContentWithEntity(sport)
                
                weak var weakSelf = self
                cell.clickToSportDetail = {
                    let vc = XKRWSportDetailVC()
                    vc.sportID = sport.sportId
                    
                    weakSelf?.navigationController?.pushViewController(vc, animated: true)
                }
                return cell
            }
        } else {
            // meal
            if indexPath.section == 0 {
                
                if let cell = tableView.dequeueReusableCellWithIdentifier("changeCell") as? SDChangeSizeCell {
                    cell.setContentWithEntity(self.schemeEntity!)
                    
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCellWithIdentifier("mealCell") as? SDMealSchemeCell {
                    
                    let foodCategoy = self.schemeEntity!.foodCategories[indexPath.row]
                    
                    cell.setContentWithEntity(foodCategoy, indexPath: indexPath)
                    
                    weak var weakSelf = self
                    
                    cell.clickToBanFoodsAction = {
                        
                        MobClick.event("clk_forbid")
                        
                        let vc = XKRWTabooFoodVC(nibName: "XKRWTabooFoodVC", bundle: nil)
                        let stringArray = foodCategoy.banFoods.componentsSeparatedByString(",")
                        
                        var ids = [Int]()
                        for temp in stringArray {
                            ids.append(Int(temp)!)
                        }
                        vc.tabooFoodId = ids
                        
                        weakSelf?.navigationController?.pushViewController(vc, animated: true)
                    }
                    cell.clickToDescriptionAction = {
                        let vc = XKRWHowToUserSchemeVC(nibName: "XKRWHowToUserSchemeVC", bundle: nil)
                        weakSelf?.navigationController?.pushViewController(vc, animated: true)
                    }
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    // MARK: Action
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if self.schemeEntity?.schemeType != .Sport {
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            if indexPath.section == 0 && indexPath.row == 0 {
                
                if self.selectionView == nil {
                    
                    var titles = [String]()
                    
                    var ratio = 0.0
                    switch self.schemeEntity!.schemeType {
                    case .Breakfast:
                        ratio = 0.3
                    case .Lunch:
                        ratio = 0.5
                    case .Dinner:
                        ratio = 0.2
                        
                    default:
                        break
                    }
                    let LMax = Int(2200 * ratio)
                    let LMin = Int(1800 * ratio)
                    let MMin = Int(1400 * ratio)
                    let SMin = Int(1200 * ratio)
                    
                    let Large = "大份（\(LMin)-\(LMax)kcal）"
                    let Middle = "中份（\(MMin)-\(LMin)kcal）"
                    let Small = "小份（\(SMin)-\(MMin)kcal）"
                    
                    switch XKRWAlgolHelper.getDailyIntakeSizeNumber() {
                    case 1:
                        titles = [Large, Middle, Small]
                    case 2:
                        titles = [Middle, Small]
                    case 3:
                        titles = [Small]
                    default:
                        titles = [Small]
                    }
                    
                    selectionView = KMPopSelectionView(frame: CGRectMake(0, 108, UI_SCREEN_WIDTH, 0), type: .Default, titles: titles, options: nil)
                    selectionView!.setCellTextAlignment(.Center)
                    selectionView!.setSelectedImage(UIImage(named: "list_select"), unselectedImage: nil)
                    
                    selectionView!.transparentButton = UIButton(frame: CGRectMake(0, 108, UI_SCREEN_WIDTH, self.view.height - 44))
                    selectionView!.transparentButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
                    
                    self.selectionView!.delegate = self
                }
                
                if self.selectionView!.isShown {
                    self.selectionView!.hide()
                } else {
                    let selectedIndex = self.schemeEntity!.size - XKRWAlgolHelper.getDailyIntakeSizeNumber()
                    self.selectionView?.setCellSelectedWithIndex(selectedIndex)
                    selectionView!.doAnimationToPoint(CGPointMake(0, 108.4), inView: self.view, fromDirection: KMDirection.Up)
                }
            }
        } else {
            
        }
    }
    
    // MARK: - Actions
    
    override func doClickNaviBarRightButton(sender: AnyObject!) {
        
        MobClick.event("clk_Refresh")
        
        XKRWCui.showProgressHud("")
        
        if self.schemeEntity != nil {
            
            self.downloadWithTaskID("changeScheme", outputTask: { () -> AnyObject! in
                return XKRWSchemeService_5_0.sharedService.changeSchemeWithType(self.schemeEntity!.schemeType,size: self.schemeEntity!.size, dropID: self.schemeEntity!.schemeID, otherInfo:["is_m":self.is_m])
            })
        }
    }
    
    func showTip() -> Void {
        
        var tipString: String
        if self.schemeEntity!.schemeType == .Sport {
            tipString = "点击换一组可更换方案。"
        } else {
            tipString = "参考图示的食物分量来吃即可。\n点击换一组可更换食谱。"
        }
        let tipView = KMHeaderTips(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 64), text: tipString, type: .Default)
        self.view.addSubview(tipView)
        
        tipView.startAnimationWithStartOrigin(CGPointMake(0, -tipView.height + 64), endOrigin: CGPointMake(0, 64))
    }
    
    //MARK: - Networking
    
    override func shouldRespondForDefaultNotificationForDetailName(detailName: String!) -> Bool {
        return true
    }
    
    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {
        
        if taskID == "changeScheme" {
            
            if result is XKRWSchemeEntity_5_0 {
                
                let newEntity = result as! XKRWSchemeEntity_5_0
                
                self.schemeEntity?.schemeID = newEntity.schemeID
                self.schemeEntity?.schemeName = newEntity.schemeName
                self.schemeEntity?.schemeType = newEntity.schemeType
                self.schemeEntity?.size = newEntity.size
                self.schemeEntity?.calorie = newEntity.calorie
                self.schemeEntity?.foodCategories = newEntity.foodCategories
                self.schemeEntity?.detail = newEntity.detail
                self.schemeEntity?.content = newEntity.content
                self.schemeEntity?.updateTime = newEntity.updateTime
                
                self.record?.sid = newEntity.schemeID
                self.record?.calorie = newEntity.calorie
                self.record?.record_value = 0
                
                if schemeEntity?.schemeType == .Sport {
                    
                    self.title = self.schemeEntity!.schemeName
                    
                    self.downloadWithTaskID("downloadSport", outputTask: { () -> AnyObject! in
                        return XKRWSportService.shareService().batchDownloadSportWithIDs(newEntity.content)
                    })
                } else {
                    
                    self.mealDescriptionHeader.setContentWithEntity(self.schemeEntity)
                    XKRWCui.hideProgressHud()
                    self.tableView.reloadData()
                }
            }
        } else if taskID == "downloadSport" {
            
            self.sports = XKRWSchemeService_5_0.sharedService.getCurrentSchemeSportEntities()
            XKRWCui.hideProgressHud()
            
            self.tableView.reloadData()
        }
    }
    
    override func handleDownloadProblem(problem: AnyObject!, withTaskID taskID: String!) {
        
        super.handleDownloadProblem(problem, withTaskID: taskID)
        
        XKRWCui.hideProgressHud()
    }
    
    // MARK: - KMPopSelection's delegate
    
    func popSelectionView(view: KMPopSelectionView!, didSelectIndex index: Int) {
        
        view.hide()
        
        let sizeNum: Int = index + XKRWAlgolHelper.getDailyIntakeSizeNumber()
        
        XKRWCui.showProgressHud("")
        
        self.downloadWithTaskID("changeScheme", outputTask: { () -> AnyObject! in
            return XKRWSchemeService_5_0.sharedService.changeSchemeWithType(self.schemeEntity!.schemeType, size: sizeNum, dropID: self.schemeEntity!.schemeID, otherInfo:["is_m":self.is_m])
        })
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
