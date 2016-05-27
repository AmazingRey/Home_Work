//
//  XKRWUserInfoVC.swift
//  XKRW
//
//  Created by 忘、 on 15/9/23.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWUserInfoVC: XKRWBaseVC,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate {

    var userNickname:String! = ""
    
    var infoTableView: UITableView = UITableView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT), style: .Plain)
    var data = []
    var predictCell: HPPredictCell?
    var mealCell: HPMealCell?
    var sportCell: HPSportCell?
    var habitCell: HPHabitCell?
    var contentCell:XKRWUserInfoContentCell?
    var dataNumCell:XKRWUserInfoDataCell?
    var headView:XKRWHeaderView!
    var sportView = XKRWNewHPSportView()

    var entity:XKRWUserInfoShowEntity = XKRWUserInfoShowEntity()
    
    var schemeReocrds: [XKRWRecordSchemeEntity] = []
    var oldRecord = XKRWRecordEntity4_0()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        self.initView()
        // Do any additional setup after loading the view.
        
        // Bad code
        MobClick.event("clk_UserImage")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let nav:XKRWNavigationController =  self.navigationController as! XKRWNavigationController
        nav.navigationBarChangeFromDefaultNavigationBarToTransparencyNavigationBar();
        Log.debug_println(self.navigationController)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let nav:XKRWNavigationController = self.navigationController as! XKRWNavigationController
        nav.navigationBarChangeFromTransparencyNavigationBarToDefaultNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO:   -- Action
    func initView(){
        self.addNaviBarBackButton()
//        self.title = "查看资料"
        self.view.backgroundColor = XK_BACKGROUND_COLOR
        self.automaticallyAdjustsScrollViewInsets = false
        XKUtil.executeCodeWhenSystemVersionAbove(7.0, blow: 0) { () -> Void in
            self.edgesForExtendedLayout = .All
            self.navigationController?.edgesForExtendedLayout = .All
        }
        infoTableView.delegate = self
        infoTableView.dataSource = self
        infoTableView.separatorStyle = .None
        infoTableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(infoTableView)
    
        headView = loadViewFromBundle("XKRWHeaderView", owner: self) as! XKRWHeaderView
        headView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 210 * UI_SCREEN_WIDTH / 320)
        headView.clipsToBounds = true
        headView.arrowButton?.hidden = true
        headView.headerArcImageView!.layer.masksToBounds = true
        headView.headerArcImageView!.layer.cornerRadius = 41

        headView.headerButton?.addTarget(self, action: #selector(XKRWUserInfoVC.showBigHeadImageView), forControlEvents: .TouchUpInside)
        infoTableView.tableHeaderView = headView
        
        infoTableView.registerNib(UINib(nibName: "HPPredictCell", bundle: nil), forCellReuseIdentifier: "predictCell")
        infoTableView.registerNib(UINib(nibName: "HPMealCell", bundle: nil), forCellReuseIdentifier: "mealCell")
        infoTableView.registerNib(UINib(nibName: "HPSportCell", bundle: nil), forCellReuseIdentifier: "sportCell")
        infoTableView.registerNib(UINib(nibName: "HPHabitCell", bundle: nil), forCellReuseIdentifier: "habitCell")
        infoTableView.registerNib(UINib(nibName: "XKRWUserInfoDataCell", bundle: nil), forCellReuseIdentifier: "XKRWUserInfoDataCell")
        infoTableView.registerNib(UINib(nibName: "XKRWUserInfoContentCell", bundle: nil), forCellReuseIdentifier: "XKRWUserInfoContentCell")
    }
    
    func initData(){
        self.downloadWithTaskID("getOtherPerpleInfo") { () -> AnyObject! in
            return XKRWUserService.sharedService().getOtherUserInfoFromUserNickname(self.userNickname)
        };
    }
    
    func setHeaderViewData(entity:XKRWUserInfoShowEntity){
        if(entity.avatar.characters.count > 0){
            headView.headerButton?.setImageWithURL(NSURL(string: entity.avatar), forState: .Normal, placeholderImage: nil ,options:.RetryFailed)
            headView.headerButton?.layer.masksToBounds = true
            headView.headerButton?.layer.cornerRadius = 39
        }
        if(entity.level.characters.count > 0){
            headView.degreeImageView?.setImageWithURL(NSURL(string: entity.level), placeholderImage: UIImage(named: "level_image") ,options:.RetryFailed)
        }
        if(entity.backgroundUrl.characters.count > 0){
            headView.backgroundImageView?.setImageWithURL(NSURL(string: entity.backgroundUrl), placeholderImage: nil ,options:.RetryFailed)
        }
    
        if(entity.sex == eSexFemale){
            headView.sexImageView?.image = UIImage(named: "me_ic_female")
        }else{
            headView.sexImageView?.image = UIImage(named: "me_ic_male")
        }
        
        
        headView.nickNamelabel?.text = entity.nickname
        headView.menifestoLabel?.text = entity.manifesto
        headView.insistLabel?.text = "已坚持了\((entity.daily))天"
        headView.insistLabel?.textColor = UIColor.whiteColor()
        
//        infoTableView.tableHeaderView!.clipsToBounds = true
    }
    
    override func popView() {
        let nav:XKRWNavigationController? =  self.navigationController as? XKRWNavigationController
        nav!.navigationBarChangeFromTransparencyNavigationBarToDefaultNavigationBar();
        super.popView()
    }
    
    
//MARK Network Deal
    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {

        if(taskID == "getOtherPerpleInfo"){
            self.entity = result as! XKRWUserInfoShowEntity
            self.setHeaderViewData(entity)
            
            if self.entity.checkInfoComplete() && self.entity.isRecord{
                
                self.schemeReocrds = self.entity.schemeReocrds
                self.oldRecord = self.entity.oldRecordEntity
                
                // 由于纪录的数据bug，可能会导致一天多条相同type的记录，为了显示和计算，去掉重复的记录
                var srs = [XKRWRecordSchemeEntity]()
                for scheme in self.schemeReocrds {
                    
                    let contains = srs.contains({ (content: XKRWRecordSchemeEntity) -> Bool in
                        if content.type == scheme.type {
                            return true
                        }
                        return false
                    })
                    if !contains {
                        srs.append(scheme)
                    } else {
                        for i in 0 ..< srs.count {
                            let temp = srs[i]
                            
                            if temp.type == scheme.type {
                                // 取最新的记录
                                if temp.create_time < scheme.create_time {
                                    srs.removeAtIndex(i)
                                    srs.insert(scheme, atIndex: i)
                                }
                                break
                            }
                        }
                    }
                }
                self.schemeReocrds = srs
                
//                if(self.viewModel == nil){
//                    self.viewModel = XKRWHistoryAndProcessModel()
//                    
//                    // set view model to other's info
//                    self.viewModel!.isSelf = false
//                    self.viewModel!.BM = XKRWAlgolHelper.BM_with_weight(self.entity.weight, height: Float(self.entity.height), age: self.entity.age, sex: self.entity.sex)
//                    self.viewModel!.PAL = XKRWAlgolHelper.PAL_with_sex(self.entity.sex, physicalLabor: self.entity.labor_level)
//                    self.viewModel!.sex = self.entity.sex
//                    self.viewModel!.age = self.entity.age
//                    self.viewModel!.labor = self.entity.labor_level
//                    
//                    self.viewModel!.dealWithSchemeRecords(&self.schemeReocrds, oldRecord: &self.oldRecord)
//                    self.viewModel!.isShowPredictView = true
//                    self.viewModel!.isToday = false
//                    self.viewModel!.isShowMealAnalysis = false
//                    self.viewModel!.canModified = false
//                    
//                    self.viewModel!.lossWeight = self.entity.lossWeight
//                    self.viewModel!.lessEatCalories = self.entity.lessEatCalories
//                    self.viewModel!.sportCalories = self.entity.sportCalories
//                    self.viewModel!.sportArray = self.entity.sportArray
//                }
            }
            infoTableView.reloadData()
        }
    }
    
    override func handleDownloadProblem(problem: AnyObject!, withTaskID taskID: String!) {
        super.handleDownloadProblem(problem, withTaskID: taskID)
    }
    
    override func shouldRespondForDefaultNotificationForDetailName(detailName: String!) -> Bool {
        return  true
    }
    
//MARK:   delegate
    
//MARK:   UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == 4){
            return 0
        }else{
            return 10.0
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view:UIView = UIView.init(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 10))
        view.backgroundColor = UIColor.clearColor()  //XK_BACKGROUND_COLOR
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            if(indexPath.row == 0){
                dataNumCell = tableView.dequeueReusableCellWithIdentifier("XKRWUserInfoDataCell") as? XKRWUserInfoDataCell
                dataNumCell?.selectionStyle = .None
                dataNumCell!.starNumLabel.text = "\(entity.starNum)颗"
                dataNumCell!.bePraiseLabel.text = "\(entity.bePraisedNum)次"
                return dataNumCell!
            }else{
                contentCell = tableView.dequeueReusableCellWithIdentifier("XKRWUserInfoContentCell") as? XKRWUserInfoContentCell
                if(indexPath.row == 1){
                    contentCell!.titleLabel.text = "发布的内容"
                    contentCell!.contentLabel.text = "\(entity.blognum + entity.post_num)篇"
                }else if(indexPath.row == 2){
                    contentCell!.titleLabel.text = "喜欢的内容"
                    contentCell!.contentLabel.text = "\(entity.thumpUpNum + entity.post_send)篇"
                }
                return contentCell!
            }
        }
        else if(indexPath.section == 1){
            if self.entity.isRecord{
                if self.entity.checkInfoComplete() {
                    predictCell = tableView.dequeueReusableCellWithIdentifier("predictCell") as? HPPredictCell
                    self.predictCell!.setContent(self.entity)
                    return predictCell!
                }
                else {
                    
                    var cell = tableView.dequeueReusableCellWithIdentifier("noDataCell")
                    if cell == nil {
                        cell = UITableViewCell(style: .Default, reuseIdentifier: "noDataCell")
                        
                        let label = UILabel(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 64))
                        label.text = "ta的计划数据暂未生成...\n请稍后查看"
                        label.numberOfLines = 2
                        label.textAlignment = .Center
                        
                        label.textColor = XK_ASSIST_TEXT_COLOR
                        label.font = XKDefaultFontWithSize(14)
                        label.backgroundColor = UIColor.whiteColor()
                        cell?.selectionStyle = .None
                        
                        cell!.contentView.addSubview(label)
                    }
                    return cell!
                }
            }else{
                var cell = tableView.dequeueReusableCellWithIdentifier("noDataCell")
                if cell == nil {
                    cell = UITableViewCell(style: .Default, reuseIdentifier: "noDataCell")
                    
                    let label = UILabel(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 64))
                    label.text = "TA很懒，什么都没记录！"
                    label.numberOfLines = 0
                    label.textAlignment = .Center
                    label.textColor = XK_ASSIST_TEXT_COLOR
                    label.font = XKDefaultFontWithSize(14)
                    label.backgroundColor = UIColor.whiteColor()
                    cell!.selectionStyle = .None
                    
                    cell!.contentView.addSubview(label)
                }
                return cell!
            }
        }
        else if(indexPath.section == 2){//饮食栏位
            if self.mealCell == nil {
                self.mealCell = tableView.dequeueReusableCellWithIdentifier("mealCell") as? HPMealCell
            }
            self.mealCell!.setCellContent(self.entity)
            return mealCell!
        }
        else{   // if(indexPath.section == 3) 运动栏位
            var cell = tableView.dequeueReusableCellWithIdentifier("newSportCell")
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "newSportCell")
            }
            cell?.selectionStyle = .None
            sportView.frame = CGRectMake(0, 0, self.view.frame.size.width, 186)
            cell?.contentView.addSubview(self.sportView)
            sportView.setSportView(self.entity)
            return cell!
            
//            if sportCell == nil {
//                sportCell = tableView.dequeueReusableCellWithIdentifier("sportCell") as?  HPSportCell
//            }
//            if(self.viewModel != nil){
//               self.sportCell!.setCellContent(self.viewModel!)
//            }
//            return sportCell!
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 3
        }else{
            return 1
        }
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.entity.checkInfoComplete() && self.entity.isRecord {
            return 4
        }
        return 2
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0) {
            if(indexPath.row == 0) {
                return 64
            } else {
                return 44
            }
        }
        return 187
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let likeVC = XKRWLikeVC()
        likeVC.nickName = userNickname
        if(indexPath.row == 1){
            likeVC.selfType = .ShareArticle
            self.navigationController?.pushViewController(likeVC, animated: true)
            
            MobClick.event("clk_publish1")
            
        }else if(indexPath.row == 2){
            likeVC.selfType = .LikeArticle
            self.navigationController?.pushViewController(likeVC, animated: true)
            
            MobClick.event("clk_like1")
        }
        
    }
    
    // MARK:  UIScrollViewDelagate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let nav = self.navigationController as? XKRWNavigationController {
            nav.changeImageViewAlpha( 210 * UI_SCREEN_WIDTH / 320 - scrollView.contentOffset.y, andHeaderViewHeight: 120, andViewController: self, andnavigationBarTitle: "用户资料")
        }
    }
    
    func showBigHeadImageView(){
        let headImageVC: XKRWShowHeadIamgeVC = XKRWShowHeadIamgeVC(nibName:"XKRWShowHeadIamgeVC",bundle:nil)
        headImageVC.headImageUrl = self.entity.avatar_hd
        self.presentViewController(headImageVC, animated: false) { () -> Void in
            
        }
    }
}
