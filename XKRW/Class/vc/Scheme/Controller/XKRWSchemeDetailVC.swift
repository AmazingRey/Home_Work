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
    var recordDate:NSDate  = NSDate()
    
    weak var schemeEntity: XKRWSchemeEntity_5_0?
    weak var record: XKRWRecordSchemeEntity?
    
    var sports: [XKRWSportEntity]?
    var is_m = 0
    var autoChangeContent:Bool = false
    var mealDescriptionHeader: SDDescriptionHeaderView = SDDescriptionHeaderView.instanceView()
    
    var selectionView: KMPopSelectionView?
    
    // MARK: - System's function
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.addNaviBarBackButton()
        self.edgesForExtendedLayout = UIRectEdge.Top
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64), style: UITableViewStyle.Plain)
        self.tableView.backgroundColor = XK_BACKGROUND_COLOR
        self.tableView.separatorStyle = .None
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        
        self.addNaviBarRightButtonWithText("换一组", action: #selector(XKRWBaseVC.doClickNaviBarRightButton(_:)),withColor: XKMainSchemeColor)
    
        if self.schemeEntity?.schemeType == .Sport {
               MobClick.event("pg_fit_sug_detail")
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
              MobClick.event("pg_meal_sug_detai")
            self.title = self.schemeEntity!.schemeType.getDescription() + "方案"
            
            self.mealDescriptionHeader.setContentWithEntity(self.schemeEntity!)
            
            self.tableView.registerNib(UINib(nibName: "SDChangeSizeCell", bundle: nil), forCellReuseIdentifier: "changeCell")
            self.tableView.registerNib(UINib(nibName: "SDMealSchemeCell", bundle: nil), forCellReuseIdentifier: "mealCell")
            
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
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if self.schemeEntity?.schemeType != .Sport {
            
            if section == 0 {
                return self.mealDescriptionHeader.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.schemeEntity?.schemeType != .Sport {
            
            if section == 0 {
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
            
            if self.schemeEntity != nil {
                return self.schemeEntity!.foodCategories.count
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
            
            if let cell = self.tableView.dequeueReusableCellWithIdentifier("mealCell") as? SDMealSchemeCell {
                
                cell.calculateHeightWithEntity(self.schemeEntity!.foodCategories[indexPath.row])
                print(cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height + 1)
                return cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height + 1
            } else {
                return 366
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
        return UITableViewCell()
    }
    
    // MARK: - Actions
    
    override func doClickNaviBarRightButton(sender: AnyObject!) {
        
        MobClick.event("clk_Refresh")
        
        XKRWCui.showProgressHud("")
        
        if self.schemeEntity != nil {
            
            self.downloadWithTaskID("changeScheme", outputTask: { () -> AnyObject! in
              return  XKRWSchemeService_5_0.sharedService.changeSchemeWithType(self.schemeEntity!.schemeType, date: self.recordDate, size: self.schemeEntity!.size, dropID: self.schemeEntity!.schemeID, otherInfo: ["is_m":self.is_m])
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
        
        tipView.startAnimationWithStartOrigin(CGPointMake(0, -tipView.height + 64), endOrigin: CGPointMake(0, 0))
    }
    
    //MARK: - Networking
    
    override func shouldRespondForDefaultNotificationForDetailName(detailName: String!) -> Bool {
        return true
    }
    
    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {
        
        if taskID == "changeScheme" {
            
            if result is XKRWSchemeEntity_5_0 {
                
                let newEntity = result as! XKRWSchemeEntity_5_0
                print(newEntity)
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
                    dispatch_async(dispatch_get_main_queue(), { 
                         NSNotificationCenter.defaultCenter().postNotificationName("energyCircleDataChanged", object: "sport")
                        NSNotificationCenter.defaultCenter().postNotificationName("RecordSchemeData", object: "sport")
                    });

                } else {
                    dispatch_async(dispatch_get_main_queue(), { 
                         NSNotificationCenter.defaultCenter().postNotificationName("energyCircleDataChanged", object: "food")
                        NSNotificationCenter.defaultCenter().postNotificationName("RecordSchemeData", object: "food")
                    });
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
            return XKRWSchemeService_5_0.sharedService.changeSchemeWithType(self.schemeEntity!.schemeType, date: self.recordDate,size: sizeNum, dropID: self.schemeEntity!.schemeID, otherInfo:["is_m":self.is_m])
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
