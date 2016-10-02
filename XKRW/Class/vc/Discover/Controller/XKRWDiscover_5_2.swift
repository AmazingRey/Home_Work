//
//  XKRWDiscover_5_2.swift
//  XKRW
//
//  Created by 忘、 on 16/1/12.
//  Copyright © 2016年 XiKang. All rights reserved.
//

import UIKit

class XKRWDiscover_5_2: XKRWBaseVC,UITableViewDataSource,UITableViewDelegate, XKRWSCPopSelectorDelegate,MJRefreshBaseViewDelegate, XKRWNavigationControllerTapDelegate{

    @IBOutlet weak var discoverTable: XKRWUITableViewBase!
    
    var teamArray = [XKRWGroupItem]()
    
    var showAd = false
    var reflash = false
    var addActivitiesGroupDefualt = false
    
    var _discoverTable:XKRWUITableViewBase!
    
    var focusCell:UITableViewCell!
    var focusView:XKRWFocusView!
    var OperatingCell:XKRWDiscoverOperatingCell?
    var teamCell:XKRWDiscoverTeamCell?
    var topicCell:XKRWBlogEnterCell?
    var refreshHeaderView:MJRefreshHeaderView!
    var articleEntity:XKRWArticleListEntity =  XKRWArticleListEntity()
    var discoverADArray = []
    var articleEntityArray = []
    
    var postDetailVC:XKRWPostDetailVC! = XKRWPostDetailVC()
    var articleWebView:XKRWArticleWebView!
    /// 是否已参加减肥知识
    var isCompeleteJfzs = false
    /// 是否已参加运动推荐
    var isCompeleteYdtj = false
    /// 是否已参加励志
    var isCompeleteLizhi = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        self.initView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.getDiscoverADInfo()
        self.getAllNoticeInfomationFromNetWork()
        self.getIslimShareNewestArticle()
        self.getDiscoverOperationState()
        self.getUserJoinTeam()
        let nav = self.navigationController as! XKRWNavigationController
        nav.tapNavBarDelegate = self;
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let nav = self.navigationController as! XKRWNavigationController
        nav.tapNavBarDelegate = nil;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if XKUtil.isNetWorkAvailable(){
            let key = "\(XKRWUserDefaultService.getCurrentUserId())_hasAddGroup"
            let abool = NSUserDefaults.standardUserDefaults().objectForKey(key)
            if (!XKRWUserService.sharedService().currentUser.isAddGroup)&&(abool == nil){
                let vc:XKRWGroupManageViewController = XKRWGroupManageViewController()
                self.presentViewController(vc, animated: true, completion: nil)
                NSUserDefaults.standardUserDefaults().setBool(true, forKey:key)
                NSUserDefaults.standardUserDefaults().synchronize()
                XKRWUserService.sharedService().addActivitiesGroupDefualt = true
            }else{
                self.getReminderNewTeamData()
            }
        }
    }
    
    func initView(){
        self.title = "发现"
        print(discoverTable)
        discoverTable.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)
        discoverTable.forbidTouchContenDelay();
        discoverTable.delegate = self
        discoverTable.dataSource = self
        discoverTable.separatorStyle = .None
        discoverTable.backgroundColor = XK_BACKGROUND_COLOR
        self.addHeaderView()
        self.setNavifationItemWithLeftItemTitle(nil, andRightItemTitle: nil, andItemColor: UIColor.whiteColor(), andShowLeftRedDot: true, andShowRightRedDot: false, andLeftRedDotShowNum: true, andRightRedDotShowNum: false, andLeftItemIcon: "message", andRightItemIcon: nil)
        
        focusView = NSBundle.mainBundle().loadNibNamed("XKRWFocusView", owner: nil, options: nil)!.first as! XKRWFocusView
        focusView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH / 5)
        
        focusCell = UITableViewCell.init(style: .Default, reuseIdentifier: "focusCell")

        focusCell.contentView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH / 5)
        focusCell.contentView .addSubview(focusView)
        
        discoverTable.registerNib(UINib(nibName: "XKRWFocusCell", bundle: nil), forCellReuseIdentifier: "focusCell")
        discoverTable.registerNib(UINib(nibName: "XKRWDiscoverOperatingCell", bundle: nil), forCellReuseIdentifier: "OperatingCell")
        discoverTable.registerNib(UINib(nibName: "XKRWDiscoverTeamCell", bundle: nil), forCellReuseIdentifier: "TeamCell")
        discoverTable.registerNib(UINib(nibName: "XKRWBlogEnterCell", bundle: nil), forCellReuseIdentifier: "topicCell")
        
        self.hideNavigationLeftItemRedDot(true, andRightItemRedDotNeedHide: true)
    }
    
    func addHeaderView(){
        refreshHeaderView = MJRefreshHeaderView(scrollView: discoverTable)
        refreshHeaderView.delegate = self
    }
    
    func setTeamSectionHeadTableViewCell() -> UITableViewCell{

        let subView = UIView(frame: CGRectMake(0,0,UI_SCREEN_WIDTH,44))
//        XKRWUtil.addViewUpLineAndDownLine(subView, andUpLineHidden: false, downLineHidden: true)
        subView.backgroundColor = UIColor.whiteColor()

        let myTeamLabel = UILabel(frame: CGRectMake(15,0,100,44))
        myTeamLabel.text = "我的小组"
        myTeamLabel.font = XKDefaultFontWithSize(16)
        myTeamLabel.textColor = XK_TITLE_COLOR
        subView.addSubview(myTeamLabel)
        
        let myPostButton =  UIButton(type: .Custom)
        myPostButton.frame = CGRectMake(UI_SCREEN_WIDTH-36-60, 0, 96, 44)
        myPostButton.enabled = false
        
        
        let imageView = UIImageView(image: UIImage(named: "arrow_right5_3"))
        imageView.contentMode = .ScaleAspectFit;
        imageView.right = myPostButton.frame.size.width - 15;
        imageView.top = (myPostButton.frame.size.height - imageView.frame.size.height)/2;
        myPostButton.addSubview(imageView)
        
        let myPostLabel = UILabel(frame: CGRectMake(0,0,60,44))
        myPostLabel.text = "我的帖子"
        myPostLabel.font = XKDefaultFontWithSize(14)
        myPostLabel.textAlignment = .Right
        myPostLabel.right = imageView.left - 10
        myPostLabel.textColor = XK_ASSIST_TEXT_COLOR
        myPostButton.addSubview(myPostLabel)
        
        subView.addSubview(myPostButton)
        
        let tableViewCell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        tableViewCell.contentView.addSubview(subView)
        return tableViewCell
    }
    
    func setTeamSectionFooterTableViewCell()->UITableViewCell{
        let footerView = UIView()
        footerView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 44)
        
        XKRWUtil.addViewUpLineAndDownLine(footerView, andUpLineHidden: true, downLineHidden: false)
        
        footerView.backgroundColor = UIColor.whiteColor()
        let title = "加入更多小组" as NSString
        let titleWidth = title.boundingRectWithSize(CGSizeMake(UI_SCREEN_WIDTH, 1000), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:XKDefaultFontWithSize(14)], context: nil).size.width + 10
        
        let addPostImageView = UIImageView(frame: CGRectMake((UI_SCREEN_WIDTH-titleWidth-15)/2, (44-15)/2, 15, 15))
        addPostImageView.image = UIImage(named: "discover_group_add_")
        footerView.addSubview(addPostImageView)
        let myPostLabel = UILabel(frame: CGRectMake((UI_SCREEN_WIDTH-titleWidth-15)/2+15 ,0,titleWidth,44))
        myPostLabel.text = title as String
   
        myPostLabel.font = XKDefaultFontWithSize(14)
        myPostLabel.textAlignment = .Center
        myPostLabel.textColor = XK_MAIN_TONE_COLOR
        footerView.addSubview(myPostLabel)
        let tableViewCell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        tableViewCell.contentView.addSubview(footerView)
        return tableViewCell
    }
        
    func focusCellFormDequeueReusableCell(tableView:UITableView) -> UITableViewCell{
        focusView.dataSource = NSMutableArray(array: discoverADArray)
        weak var weakSelf = self
        focusView.adImageClickBlock = {(adEntity)->Void in
            weakSelf!.noticeAndFocusPush(adEntity)
        }
        return focusCell!
    }
   
    func noticeAndFocusPush(entity:XKRWShareAdverEntity) -> Void {
        if entity.type == nil {
            return
        }
        
        if entity.type == "url" {
            let vc = XKRWNewWebView()
            vc.hidesBottomBarWhenPushed = true
            vc.webTitle = entity.title
            vc.contentUrl = entity.imgUrl
            let isMall = entity.imgUrl.containsString("ssbuy.xikang.com")
            if isMall {
                let isShare = entity.imgUrl.containsString("share_url=")
                if isShare {
                    let range = entity.imgUrl.rangeOfString("share_url")
                    let shareString = entity.imgUrl.substringFromIndex((range?.endIndex)!)
                    vc.shareURL = shareString
                    
                } else {
                    vc.isHidenRightNavItem = true
                }
                
            } else {
                vc.shareURL = ""
                vc.isHidenRightNavItem = false
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if entity.type == "share" { //瘦身分享
            let vc = XKRWUserArticleVC()
            vc.hidesBottomBarWhenPushed = true
            vc.aid = entity.nid
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if entity.type == "post" { //帖子
            postDetailVC.hidesBottomBarWhenPushed = true
            postDetailVC.postID = entity.nid
            self.navigationController?.pushViewController(postDetailVC, animated: true)

            return
            
        } else {
            
            articleWebView = XKRWArticleWebView()
            articleWebView.hidesBottomBarWhenPushed = true
            
            if entity.type == "jfzs" {
                articleWebView.category = eOperationKnowledge
                articleWebView.isComplete = isCompeleteJfzs
                
            } else if entity.type == "pkinfo" {
                let pkVC = XKRWPKVC()
                pkVC.hidesBottomBarWhenPushed = true
                pkVC.nid = entity.nid
                self.navigationController?.pushViewController(pkVC, animated: true)
                return
                
            } else if entity.type == "lizhi" {
                articleWebView.category = eOperationEncourage
                articleWebView.isComplete = isCompeleteLizhi
                
            } else if entity.type == "ydtj" {
                articleWebView.category = eOperationSport
                articleWebView.isComplete = isCompeleteYdtj
            }
            articleWebView.navTitle = entity.title
            self.downloadWithTaskID("getFocusAndNoticeDetail", outputTask: { () -> AnyObject! in
                return XKRWManagementService5_0.sharedService().getArticleDetailFromServerByNid(entity.nid, andType: entity.type)
            })
            return;
        }
        
    }

    func OperatingCellFormDequeueReusableCell(tableView:UITableView) ->XKRWDiscoverOperatingCell{
        OperatingCell = tableView.dequeueReusableCellWithIdentifier("OperatingCell") as? XKRWDiscoverOperatingCell
        OperatingCell?.contentView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH * 91 / 375)
        OperatingCell!.pkButton.addTarget(self, action: #selector(XKRWDiscover_5_2.entryPKList), forControlEvents: .TouchUpInside)
        OperatingCell!.motivationalButton.addTarget(self, action: #selector(XKRWDiscover_5_2.entryMotivationList), forControlEvents: .TouchUpInside)
        OperatingCell!.sportRecommendButton.addTarget(self, action: #selector(XKRWDiscover_5_2.entrySportRecommandList), forControlEvents: .TouchUpInside)
        OperatingCell!.lossWeightOfKnowledgeButton.addTarget(self, action: #selector(XKRWDiscover_5_2.entryLossWeightKnowledgeList), forControlEvents: .TouchUpInside)
        return OperatingCell!
    }
    
    func topicCellFormDequeueReusableCell(tableView:UITableView)->XKRWBlogEnterCell{
        topicCell = tableView.dequeueReusableCellWithIdentifier("topicCell") as? XKRWBlogEnterCell
        topicCell!.setContentWithEntity(articleEntity)
        return topicCell!;
    }
    
    func teamCellFormDequeueReusableCell(tableView:UITableView)->XKRWDiscoverTeamCell{
        teamCell = tableView.dequeueReusableCellWithIdentifier("TeamCell") as? XKRWDiscoverTeamCell

        return teamCell!
    }
    
    func initData(){
        self.getUserJoinTeam()
        
        self.changeCommentNoticeNum()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(XKRWDiscover_5_2.changeCommentNoticeNum), name: "CommentAndSystemNoticeChanged", object: nil)
        
    }
    
    /**获取用户已加入的小组*/
    func getUserJoinTeam(){
        if(XKRWUtil.isNetWorkAvailable()){
        self.downloadWithTaskID("userJoinTeam") { () -> AnyObject! in
            return XKRWManagementService5_0.sharedService().getUserJoinTeamInfomation()
            }
        }else{
            XKRWCui.showInformationHudWithText("请检查网络后尝试")
        }
    }
    
        /**获取用户消息盒子 的消息*/
    func getAllNoticeInfomationFromNetWork(){
        if(XKRWUtil.isNetWorkAvailable()){
            self.downloadWithTaskID("getnotice") { () -> AnyObject! in
                return XKRWNoticeService.sharedService().getAllNoticeInfomationFromNetWorkWithTime(nil, andMessageType: "message")
        }
        }else{
            XKRWCui.showInformationHudWithText("请检查网络后尝试")
        }
    }
    
    /**获取瘦身分享的广告*/
    func getDiscoverADInfo(){
        if XKRWUtil.isNetWorkAvailable(){
            self.downloadWithTaskID("getADInfo") { () -> AnyObject! in
             return XKRWAdService.sharedService().downLoadAdWithPosition("share", andCommerce_type: "focus")
            }
        }else{
            XKRWCui.showInformationHudWithText("请检查网络后尝试")
        }
    }
    
    /**获取瘦身分享的推荐文章*/
    func getIslimShareNewestArticle(){
        if XKRWUtil.isNetWorkAvailable(){
            self.downloadWithTaskID("getNewestArticle", outputTask: { () -> AnyObject! in
                return XKRWManagementService5_0.sharedService().getBlogRecommendFromServerWithPage(NSNumber(integer: 1))
            })
        }else{
             XKRWCui.showInformationHudWithText("请检查网络后尝试")
        }
    }
    
    /**获取瘦身运营文章状态*/
    func getDiscoverOperationState(){
        if XKRWUtil.isNetWorkAvailable(){
            self.downloadWithTaskID("getOperationState", outputTask: { () -> AnyObject! in
                return XKRWManagementService5_0.sharedService().getDiscoverOperationState()
            })
        }else{
            XKRWCui.showInformationHudWithText("请检查网络后尝试")
        }
        
    }
    
    /**获取最新小组数据*/
    func getReminderNewTeamData(){
        
        if XKRWUtil.isNetWorkAvailable(){
            let key = "\(XKRWUserDefaultService.getCurrentUserId())_ActivitiesTeamServer_time"
            var ctivitiesTeamServer_time:String!
            if ((NSUserDefaults.standardUserDefaults().objectForKey(key)) != nil){
                ctivitiesTeamServer_time = NSUserDefaults.standardUserDefaults().objectForKey(key) as! String
            }else{
                ctivitiesTeamServer_time = ""
            }

            self.downloadWithTaskID("getActivitiesTeam", outputTask: { () -> AnyObject! in

 
                return XKRWGroupService.shareInstance().getActivitiesGroupsWithCtime(ctivitiesTeamServer_time)
            })
        }else{
            XKRWCui.showInformationHudWithText("请检查网络后尝试")
        }
    }

    
    // MARK: Action
    override func leftItemAction(button: UIButton!) {
        MobClick.event("clk_MessageBox")
        let noticeCenterVC = XKRWNoticeCenterVC(nibName:"XKRWNoticeCenterVC",bundle: nil)
        noticeCenterVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(noticeCenterVC, animated: true)
    }
    
    
    /**进入我的小组*/
    func entryMyTeam(){
        MobClick.event("in_MyPost")
        let mypostVC:XKRWReportViewController = XKRWReportViewController()
        mypostVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mypostVC, animated: true)
    }
    
      /**进入更多小组*/
    func addMoreTeam(){
        let addMoreteamVC:XKRWAddGroupViewController = XKRWAddGroupViewController()
        addMoreteamVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addMoreteamVC, animated: true)
    }
    
    /**进入广告展示*/
    func pushToAdverPageWithUrlStr(adUrl:String,pageTitle:String){
        MobClick.event("clk_FocusMap")
        
        let adVC = XKRWNewWebView()
        adVC.hidesBottomBarWhenPushed = true
        adVC.contentUrl = adUrl
        adVC.webTitle = pageTitle
        self.navigationController?.pushViewController(adVC, animated: true)
    }
    
//    func reFlashTeamData(){
//        reflash = true
//    }
    
      /**进入pk列表*/
    func entryPKList(){
        let vc = XKRWOperateArticleListVC(nibName:"XKRWOperateArticleListVC",bundle: nil)
        vc.operateArticleType = .PK
        vc.operateString = "pk"
        vc.adArray = discoverADArray as? [XKRWShareAdverEntity]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /**进入励志列表*/
    func entryMotivationList(){
        let vc = XKRWOperateArticleListVC(nibName:"XKRWOperateArticleListVC",bundle: nil)
        vc.operateArticleType = .Motivation
        vc.operateString = "lizhi"
        vc.adArray = discoverADArray as? [XKRWShareAdverEntity]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
     /**进入运动推荐列表*/
    func entrySportRecommandList(){
        let vc = XKRWOperateArticleListVC(nibName:"XKRWOperateArticleListVC",bundle: nil)
        vc.operateArticleType = .SportRecommend
        vc.operateString = "ydtj"
        vc.adArray = discoverADArray as? [XKRWShareAdverEntity]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /**进入减肥知识列表*/
    func entryLossWeightKnowledgeList(){
        let vc = XKRWOperateArticleListVC(nibName:"XKRWOperateArticleListVC",bundle: nil)
        vc.operateArticleType = .Knowledge
        vc.operateString = "jfzs"
        vc.adArray = discoverADArray as? [XKRWShareAdverEntity]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getTeamPostNumbers(teamID:String)->[TeamPostNumEntity]?{
        
        let objectContect:NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! XKRWAppDelegate).managedObjectContext
        let request:NSFetchRequest = NSFetchRequest(entityName: "TeamPostNumEntity")
        request.predicate = NSPredicate(format: "teamID = %@ and userID = %d", teamID,XKRWUserService.sharedService().getUserId())
        var teamNumbers:[TeamPostNumEntity]
        do{
            try  teamNumbers = objectContect.executeFetchRequest(request) as! [TeamPostNumEntity]
            return teamNumbers
            
        }catch{
            Log.debug_println("从CoreData中获取TeamPostNumEntity失败")
            return nil
        }
    }
    
    
    func showTeamNewPostNum(indexPatch:NSIndexPath,teamArray:[XKRWGroupItem])->(isNew:Bool,newPostNum:Int){

        let teamEntity = teamArray[indexPatch.row - 1]
        
        let teamPostNumEntityArray = self.getTeamPostNumbers(teamEntity.groupId)
        
        if(teamPostNumEntityArray == nil || teamPostNumEntityArray?.count == 0){
            return (true,0)
        }else{
            return (false,Int(teamEntity.postNums)! - (teamPostNumEntityArray![0] as TeamPostNumEntity).postNum!.integerValue > 0 ? Int(teamEntity.postNums)! - (teamPostNumEntityArray![0] as TeamPostNumEntity).postNum!.integerValue : 0)
        }
        
    }
    
    
    func changeCommentNoticeNum() -> Void{
        let unreadNum = XKRWNoticeService.sharedService().getUnreadCommentOrSystemNoticeNum()
        if(unreadNum > 0){
            self.setNavigationLeftRedNum("\(unreadNum)")
            self.hideNavigationLeftItemRedDot(false, andRightItemRedDotNeedHide: true)
        }else{
            self.hideNavigationLeftItemRedDot(true, andRightItemRedDotNeedHide: true)
        }
    
    }
    

    func stopReflash(){
        refreshHeaderView.endRefreshing()
    }
    


    // MARK: Delegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(showAd){
            if(indexPath.section == 0){
                return  self.focusCellFormDequeueReusableCell(tableView)
            }else if(indexPath.section == 1){
                return self.OperatingCellFormDequeueReusableCell(tableView)
            }else if(indexPath.section == 2){
                let topicCell = self.topicCellFormDequeueReusableCell(tableView)
                weak var weakSelf = self
                topicCell.islimShareActionBlock = { ()->Void in
                    let fitnessShareVC = XKRWFitnessShareVC()
                    fitnessShareVC.myType = .FitnessShareType
                    fitnessShareVC.dataMutArray = NSMutableArray(array: self.articleEntityArray)
                    fitnessShareVC.hidesBottomBarWhenPushed = true
                    weakSelf?.navigationController?.pushViewController(fitnessShareVC, animated: true)
                
                }
                return topicCell
            }else {
                
                if(indexPath.row == 0){
                    let cell = self.setTeamSectionHeadTableViewCell()
                
                    return cell
                }else if(indexPath.row == teamArray.count + 1){
                    let cell = self.setTeamSectionFooterTableViewCell()
                    return cell
                }else{
                
                    let teamCell = self.teamCellFormDequeueReusableCell(tableView)
                    teamCell.teamImageView.setImageWithURL(NSURL(string: teamArray[indexPath.row - 1].groupIcon), placeholderImage: nil ,options:.RetryFailed)
                    teamCell.teamNameLabel.text = teamArray[indexPath.row - 1].groupName
                    teamCell.teamDescribleLabel.text = teamArray[indexPath.row - 1].groupDescription
                    
                    let showState = self.showTeamNewPostNum(indexPath, teamArray: teamArray)
                    if showState.isNew == true{
                        teamCell.teamNewPostImageView.hidden = false
                        teamCell.showStatelabel.hidden = true
                    }else{
                        teamCell.teamNewPostImageView.hidden = true
                        if(showState.newPostNum == 0){
                            teamCell.showStatelabel.hidden = true
                        }else{
                            teamCell.showStatelabel.hidden = false
                            let stateLabelText:String
                            if showState.newPostNum > 99 {
                                stateLabelText = "99+"
                            } else {
                                stateLabelText = "\(showState.newPostNum)"
                            }
                            teamCell.showStatelabel.text = stateLabelText
                        }
                    }

                
                    return teamCell
                }
            }
        
        }else{
            if(indexPath.section == 0){
                return self.OperatingCellFormDequeueReusableCell(tableView)
            }else if(indexPath.section == 1){
                let topicCell = self.topicCellFormDequeueReusableCell(tableView)
                weak var weakSelf = self
                topicCell.islimShareActionBlock = { ()->Void in
                    let fitnessShareVC = XKRWFitnessShareVC()
                    fitnessShareVC.myType = .FitnessShareType
                    fitnessShareVC.dataMutArray = NSMutableArray(array: self.articleEntityArray)
                    fitnessShareVC.hidesBottomBarWhenPushed = true
                    weakSelf?.navigationController?.pushViewController(fitnessShareVC, animated: true)
                    
                }
                return topicCell

            }else {
                if(indexPath.row == 0){
                    let cell = self.setTeamSectionHeadTableViewCell()
                    
                    return cell
                }else if(indexPath.row == teamArray.count + 1){
                    let cell = self.setTeamSectionFooterTableViewCell()
                    return cell
                }else{
                    
                    let teamCell = self.teamCellFormDequeueReusableCell(tableView)
                    teamCell.teamImageView.setImageWithURL(NSURL(string: teamArray[indexPath.row - 1].groupIcon), placeholderImage: nil ,options:.RetryFailed)
                    teamCell.teamNameLabel.text = teamArray[indexPath.row - 1].groupName
                    teamCell.teamDescribleLabel.text = teamArray[indexPath.row - 1].groupDescription
                    
                    let showState = self.showTeamNewPostNum(indexPath, teamArray: teamArray)
                    if showState.isNew == true{
                        teamCell.teamNewPostImageView.hidden = false
                        teamCell.showStatelabel.hidden = true
                    }else{
                        teamCell.teamNewPostImageView.hidden = true
                        if(showState.newPostNum == 0){
                            teamCell.showStatelabel.hidden = true
                        }else{
                            teamCell.showStatelabel.hidden = false
                            teamCell.showStatelabel.text = "\(showState.newPostNum)"
                        }
                    }
                    
                    
                    return teamCell
                }
            }
        }
    
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if showAd{
            return 4
        }else{
            return 3
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showAd{
            if(section == 3){
                return teamArray.count + 2
            }else {
                return 1
            }
        }else{
            if(section == 2){
                return teamArray.count + 2
            }else {
                return 1
            }
        }

    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let sectionView = UIView(frame: CGRectMake(0,0,UI_SCREEN_WIDTH,10))
        sectionView.backgroundColor = UIColor.clearColor()
        return sectionView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(showAd){
            if indexPath.section == 0{
                return UI_SCREEN_WIDTH / 5
            }else if(indexPath.section == 1){
                return 91.0 * UI_SCREEN_WIDTH / 375.0
            }else if(indexPath.section == 2){
                return UI_SCREEN_WIDTH * 9 / 16.0 + 44
            }else if(indexPath.section == 3){
                if (indexPath.row == 0 || indexPath.row == teamArray.count + 1){
                    return 44
                }else{
                    return 60
                }
            }
        }else{
            if indexPath.section == 0{
                return  91.0 * UI_SCREEN_WIDTH / 375.0
            }else if(indexPath.section == 1){
                return UI_SCREEN_WIDTH * 9 / 16.0 + 44
            }else if(indexPath.section == 2){
                if (indexPath.row == 0 || indexPath.row == teamArray.count + 1){
                    return 44
                }else{
                    return 60
                }
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        [tableView .deselectRowAtIndexPath(indexPath, animated: false)]
        if showAd {
            if indexPath.section == 2 {
                let fitnessShareVC:XKRWFitnessShareVC = XKRWFitnessShareVC()
                fitnessShareVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(fitnessShareVC, animated: true)

            } else if indexPath.section == 3 {
                
                if(indexPath.row == 0){
                    self.entryMyTeam()
                }else if(indexPath.row == teamArray.count + 1){
                    self.addMoreTeam()
                }else{
                    let groupVC:XKRWGroupViewController = XKRWGroupViewController()
                    
                    groupVC.isCompeleteYdtj = isCompeleteYdtj
                    groupVC.isCompeleteLiZhi = isCompeleteLizhi
                    groupVC.isCompeleteJfzs = isCompeleteJfzs
                    
                    groupVC.hidesBottomBarWhenPushed = true
                    groupVC.groupAuthType = groupAuthNone
                    groupVC.groupId = (teamArray[indexPath.row - 1] ).groupId
                    self.navigationController?.pushViewController(groupVC, animated: true)
                }
            }
            
        }else{
            
            if indexPath.section == 1 {
                let fitnessShareVC:XKRWFitnessShareVC = XKRWFitnessShareVC()
                fitnessShareVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(fitnessShareVC, animated: true)
            } else if indexPath.section == 2{
                if(indexPath.row == 0){
                    self.entryMyTeam()
                }else if(indexPath.row == teamArray.count + 1){
                    self.addMoreTeam()
                }else{
                    let groupVC:XKRWGroupViewController = XKRWGroupViewController()
                    groupVC.hidesBottomBarWhenPushed = true
                    groupVC.groupAuthType = groupAuthNone
                    groupVC.groupId = (teamArray[indexPath.row - 1] ).groupId
                    self.navigationController?.pushViewController(groupVC, animated: true)
                }
            }
        }
    }
    
    //MARK:   ---MJRefreshBaseViewDelegate
    func refreshViewBeginRefreshing(refreshView: MJRefreshBaseView!) {
        self.getDiscoverADInfo()
        self.getAllNoticeInfomationFromNetWork()
        self.getIslimShareNewestArticle()
        self.getDiscoverOperationState()
        self.getUserJoinTeam()
        self.performSelector(#selector(XKRWDiscover_5_2.stopReflash), withObject: nil, afterDelay: 2)
    }
    
    func refreshViewEndRefreshing(refreshView: MJRefreshBaseView!) {
        
    }
    
    func refreshView(refreshView: MJRefreshBaseView!, stateChange state: MJRefreshState) {
        
    }

    
    // MARK:XKRWSCPopSelector Delegate
    func popSelectorData(data: [String]!) {
        
        if XKRWUtil.isNetWorkAvailable()&&data.count != 0{
            self.downloadWithTaskID("addMutilGroup", outputTask: { () -> AnyObject! in
                
                return XKRWGroupService.shareInstance().addMutilGroupbyGroupIds(data)
            })
        }else{
            XKRWCui.showInformationHudWithText("请检查网络后尝试")
        }
    }
    
    // MARK:NetWork
    
    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {
      //  print(result)

        if(taskID == "addMutilGroup"){ //批量加入活跃小组
            let success = result as! String
            if Int(success) == 1 {
                XKRWCui.showInformationHudWithText("加入成功")
                self.getUserJoinTeam()
            }else{
                XKRWCui.showInformationHudWithText("加入失败")
            }
        }
        
        if(taskID == "userJoinTeam"){
            teamArray = result as! [XKRWGroupItem]
            if showAd {
                discoverTable.reloadSections(NSIndexSet(index: 3), withRowAnimation: .None)
            }else{
                discoverTable.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)
            }
        }

        if taskID == "getnotice"{
            let array = result.objectForKey("data")

            for  var i = 0  ; i < array?.count ; i += 1 {
                let dic:[NSObject : AnyObject] = (array?.objectAtIndex(i)) as! [NSObject : AnyObject]
                if dic["type"]?.integerValue == 2 || dic["type"]?.integerValue == 7 {
                    XKRWNoticeService.sharedService().insertNoticeListToDatabase(dic , andUserId: XKRWUserService.sharedService().getUserId(), andIsRead: 0, andIspush: false)
                }else if dic["type"]?.integerValue == 4{
                    XKRWNoticeService.sharedService().insertSystemNoticeToDatabase(dic , andUserId: XKRWUserService.sharedService().getUserId(), andIsRead: 0, andIspush: false)
                }else if dic["type"]?.integerValue == 6{
                    XKRWNoticeService.sharedService().insertShouShouServicerNoticeToDatabase(dic, andUserId: XKRWUserService.sharedService().getUserId(), andIsRead: 0, andIspush: false)
                }else if  dic["type"]?.integerValue == 8 || dic["type"]?.integerValue == 3{
                  XKRWNoticeService.sharedService().insertThumpNoticeToDatabase(dic, andUserId: XKRWUserService.sharedService().getUserId(), andIsRead: 0, andIspush: false)
                }else if dic["type"]?.integerValue == 9 || dic["type"]?.integerValue == 10{
                    XKRWNoticeService.sharedService().insertDeleteNoticeToDatabase(dic, andUserId: XKRWUserService.sharedService().getUserId(), andIsRead: 0, andIspush: false)
                }
            }
            NSNotificationCenter.defaultCenter().postNotificationName("CommentAndSystemNoticeChanged", object: nil)
        }
        
        if taskID == "getNewestArticle"{
            if(result != nil){
                articleEntity = (result as! Array)[0]
                articleEntityArray = result as! NSArray
                if showAd {
                    discoverTable.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)
                }else{
                    discoverTable.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
                }
            }
        }
        
        if taskID == "getADInfo"{
            if(result != nil){
//                print(result)
                discoverADArray = result as! NSArray
                let temp = showAd
                if(discoverADArray.count > 0){
                    showAd = true
                }else{
                    showAd = false
                }
                
                if(temp != showAd){
                    discoverTable.reloadData()
                }
            }
        }
        
        if taskID == "getOperationState"{
        
            if(result != nil){
                
                let uid = XKRWUserService.sharedService().getUserId()
        
                let knowledgeDic = result.objectForKey("data")!.objectForKey("jfzs")
                print(knowledgeDic?.objectForKey("star")?.integerValue)
                if(knowledgeDic?.objectForKey("star")?.integerValue != 2){
                    OperatingCell?.lossWeightOfKnowledgeButton.setBackgroundImage(UIImage(named: "discover_lose-weight_"), forState: .Normal)
                    isCompeleteJfzs = true
                    
                }else{
                    
                    isCompeleteJfzs = false
                    let entitynid = knowledgeDic?.objectForKey("nid")?.integerValue
                    let nid = NSUserDefaults.standardUserDefaults().objectForKey( NSString(format: "KnowlegdeNId_%ld_%ld", entitynid!,uid) as String)?.integerValue
                    print(NSString(format: "KnowlegdeNId_%ld", entitynid!) as String)
                    if(entitynid == nid){
                        OperatingCell?.lossWeightOfKnowledgeButton.setBackgroundImage(UIImage(named: "discover_lose-weight_star_"), forState: .Normal)
                    }else{
                        OperatingCell?.lossWeightOfKnowledgeButton.setBackgroundImage(UIImage(named: "discover_lose-weight_star_new_"), forState: .Normal)
                    }
                }

                
                let encouragementDic = result.objectForKey("data")!.objectForKey("lizhi")
                if(encouragementDic?.objectForKey("star")?.integerValue != 2){
                    
                   isCompeleteLizhi = true
                    OperatingCell?.motivationalButton.setBackgroundImage(UIImage(named: "discover_date_"), forState: .Normal)
                    
                }else{
                    isCompeleteLizhi = false
                    let entitynid = encouragementDic?.objectForKey("nid")?.integerValue
                    
                    let nid = NSUserDefaults.standardUserDefaults().objectForKey(NSString(format: "encouragementNid_%ld_%ld", entitynid!,uid) as String)?.integerValue
                    if(entitynid == nid){
                        OperatingCell?.motivationalButton.setBackgroundImage(UIImage(named: "discover_date_star_"), forState: .Normal)
                    }else{
                        OperatingCell?.motivationalButton.setBackgroundImage(UIImage(named: "discover_date_star_new_"), forState: .Normal)
                    }
                }

                
                let sportRecommandDic = result.objectForKey("data")!.objectForKey("ydtj")
                if(sportRecommandDic?.objectForKey("star")?.integerValue != 2){
                    
                    isCompeleteYdtj = true
                    OperatingCell?.sportRecommendButton.setBackgroundImage(UIImage(named: "discover_exercise_"), forState: .Normal)
                }else{
                    
                    isCompeleteYdtj = false
                    let entitynid = sportRecommandDic?.objectForKey("nid")?.integerValue
                    let nid = NSUserDefaults.standardUserDefaults().objectForKey(NSString(format: "sportRecommendNid_%ld_%ld", entitynid!,uid) as String)?.integerValue
                    if(entitynid == nid){
                        OperatingCell?.sportRecommendButton.setBackgroundImage(UIImage(named: "discover_exercise_star_"), forState: .Normal)
                    }else{
                        OperatingCell?.sportRecommendButton.setBackgroundImage(UIImage(named: "discover_exercise_star_new_"), forState: .Normal)
                    }
                }

                
                let pkDic = result.objectForKey("data")!.objectForKey("pk")
                let entitynid = pkDic?.objectForKey("nid")?.integerValue
                let nid = NSUserDefaults.standardUserDefaults().objectForKey(NSString(format: "pkNid_%ld_%ld", entitynid!,uid) as String)?.integerValue
                if(entitynid == nid){
                    if XKRWManagementService5_0.sharedService().checkHadPKNum(pkDic?["nid"] as! String){
                        OperatingCell?.pkButton.setBackgroundImage(UIImage(named: "discover_pk_now_"), forState: .Normal)
                    }else{
                        OperatingCell?.pkButton.setBackgroundImage(UIImage(named: "discover_pk_"), forState: .Normal)
                    }
                    
                }else{
                    OperatingCell?.pkButton.setBackgroundImage(UIImage(named: "discover_pk_new_"), forState: .Normal)
                }
                
            }
        
        }
        
        if taskID == "getActivitiesTeam"{
            
            let groupWithtServerTimeItem = result as!XKRWGroupWithtServerTimeItem
            
            let key = "\(XKRWUserDefaultService.getCurrentUserId())_ActivitiesTeamServer_time"
            NSUserDefaults.standardUserDefaults().setObject(String(groupWithtServerTimeItem.server_time), forKey: key)
            NSUserDefaults.standardUserDefaults().synchronize()
            
            if(groupWithtServerTimeItem.groupItems.count == 0){
                return
            }
            
            if(XKRWUserService.sharedService().addActivitiesGroupDefualt == false){
                    let keyWindow = UIApplication.sharedApplication().keyWindow
                    let alert = XKRWSCPopSelector(frame: (keyWindow?.frame)!)
                    alert.delegate = self
                    alert.dataSource = groupWithtServerTimeItem.groupItems as Array
                    keyWindow?.addSubview(alert)
            }else{
                
                var groupids = [String]()
                for  groupItem in groupWithtServerTimeItem.groupItems{
                     groupids.append(groupItem.groupId)
                }
                
                XKRWUserService.sharedService().addActivitiesGroupDefualt = false
            }
        }
        if taskID == "getFocusAndNoticeDetail" {
            let entity = result as! XKRWOperationArticleListEntity
            articleWebView.entity = entity
            if entity.date == nil {
                entity.date = "2000-01-01"
            }
            
            print(entity.date as String)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date:NSDate = dateFormatter.dateFromString(entity.date as String)!
            
            let isToday = date.isDayEqualToDate(NSDate())
            articleWebView.requestUrl = (result as! XKRWOperationArticleListEntity).url
            if !isToday {
                articleWebView.entity.field_question_value = ""
            } else {
                articleWebView.entity.starState = 1
            }
            articleWebView.source = eFromToday
            self.navigationController?.pushViewController(articleWebView, animated: true)
            
        }
        
    }
    
    override func handleDownloadProblem(problem: AnyObject!, withTaskID taskID: String!) {
        super.handleDownloadProblem(problem, withTaskID: taskID)
    }
    
    override func shouldRespondForDefaultNotificationForDetailName(detailName: String!) -> Bool {
        return true
    }
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        refreshHeaderView?.free()
    }
  
    func tapNavigationBar() {
        self.discoverTable .scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
