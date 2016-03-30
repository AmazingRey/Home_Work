//
//  XKRWThumpUpVC.swift
//  XKRW
//
//  Created by 忘、 on 15/9/22.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWThumpUpVC: XKRWBaseVC,UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UIScrollViewDelegate {

    var articleType:XKRWArticleType?
    var isUserSelf:Bool = true
    var nickName:String?
    var page:NSInteger = 0
    var refreshFooterView:MJRefreshFooterView!
    var refreshHeaderView:MJRefreshHeaderView!
    
    var imageView:UIImageView = UIImageView(image: UIImage(named: "feast_pic_"))
    var noNoticeLabel:UILabel = UILabel()
    
    @IBOutlet weak var thumpUpTableView: UITableView!
    
    var thunpUpArray:NSMutableArray = []
    var backToUpView:SCBackToUpView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initData()
    }
    //TODO:   ---Action
    func initView(){
        
        self.addNaviBarBackButton()
        thumpUpTableView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)
        thumpUpTableView.delegate = self;
        thumpUpTableView.dataSource = self
        thumpUpTableView.backgroundColor = UIColor.clearColor()
        thumpUpTableView.separatorStyle = .None
        thumpUpTableView.registerNib(UINib(nibName: "XKRWFitnessShareCell", bundle: nil), forCellReuseIdentifier: "topicCell")
        
        if(articleType != .ShareArticle){
            self.title = "喜欢的内容"
        }else{
            self.title = "发布的内容"
        }
        
        self.addFooterView()
        
        if(nickName != nil){
            self.addHeaderView()
        }
        
        imageView.frame = CGRectMake((UI_SCREEN_WIDTH - 197)/2, (UI_SCREEN_HEIGHT - 64 - 195)/2, 197, 195)
        noNoticeLabel.frame = CGRectMake(imageView.left, imageView.bottom, imageView.width, 40)
        
        if(articleType != .ShareArticle){
            noNoticeLabel.text = "没有喜欢的内容哦"
        }else{
            noNoticeLabel.text = "没有发布的内容哦"
        }
        noNoticeLabel.textAlignment = .Center
        noNoticeLabel.font = XKDefaultFontWithSize(16)
        noNoticeLabel.textColor = XK_TEXT_COLOR
        thumpUpTableView.addSubview(imageView)
        thumpUpTableView.addSubview(noNoticeLabel)
        
        noNoticeLabel.hidden = true
        imageView.hidden = true
        
        backToUpView = SCBackToUpView(showInSomeViewSize: thumpUpTableView.bounds.size, minitor: thumpUpTableView, withImage:"group_backtotop");
        backToUpView?.backOffsettY = UI_SCREEN_HEIGHT*2;
        self.view.addSubview(backToUpView!);
        
    }
    
    func addFooterView(){
        refreshFooterView = MJRefreshFooterView(scrollView: thumpUpTableView)
        refreshFooterView.delegate = self
    }
    
    func addHeaderView(){
        refreshHeaderView = MJRefreshHeaderView(scrollView: thumpUpTableView)
        refreshHeaderView.delegate = self
    }
    
    func initData(){
        
        self.getUserShareOrLikeInfo()
    }
    
    func iconImageAction(button:UIButton){
    
    }
    
    func dealDicToEntityAndAddToArray(dic:NSDictionary){
        let array:NSArray  = dic.objectForKey("data") as! NSArray

        for var i = 0 ; i < array.count ; i++ {
            let entity:XKRWArticleListEntity = XKRWArticleListEntity()
            let dic:NSDictionary = array.objectAtIndex(i) as! NSDictionary
          
            entity.blogId = dic.objectForKey("blogid") as! String
            
            let jsonCover = dic["cover_pic"] as! String
            var cover: NSDictionary
            do {
                cover = try NSJSONSerialization.JSONObjectWithData(jsonCover.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as! NSDictionary
            } catch {
                Log.debug_println("JSON parser error")
                return
            }
            
            entity.coverImageUrl = cover.objectForKey("url") as! String
            if(articleType != .LikeArticle){
                entity.createTime = dic.objectForKey("ctime")!.integerValue
            }else{
                entity.createTime = dic.objectForKey("good_time")!.integerValue
            }
            if(dic.objectForKey("nickname") != nil)
            {
                entity.userNickname = dic.objectForKey("nickname") as! String
            }
            if(dic.objectForKey("avatar") != nil){
                entity.headImageUrl = dic.objectForKey("avatar") as! String
            }
            
            if(dic.objectForKey("level") != nil){
                entity.userDegreeImageUrl = dic.objectForKey("level") as! String
            }
            
            if(dic.objectForKey("manifesto") != nil){
                entity.manifesto = dic.objectForKey("manifesto") as! String
            }
            
            
            entity.bePraisedNum = dic.objectForKey("goods")!.integerValue
            
            if((dic.objectForKey("del_status") != nil)&&(dic.objectForKey("del_status")!.integerValue == 2
                || dic.objectForKey("del_status")!.integerValue==3))
            {
                 entity.articleState =  XKRWUserArticleStatus(rawValue: NSString(string: dic.objectForKey("del_status") as!String).integerValue)!
            }else
            {
                entity.articleState =  XKRWUserArticleStatus(rawValue: NSString(string: dic.objectForKey("status") as!String).integerValue)!
            }
            print(entity.articleState.rawValue)
            entity.title = dic.objectForKey("title") as! String
            entity.articleViewNums = dic.objectForKey("views")!.integerValue
            
            
            if let key = dic["topic_key"] as? NSString, name = dic["topic_name"] as? String {
                
                let topicEntity = XKRWTopicEntity(id: key.integerValue, name: name, enabled: true)
                entity.topic = topicEntity;
            }
            thunpUpArray.addObject(entity)
        }
    }
    
    // 获取 其他人喜欢 或 发表的文章
    func getUserShareOrLikeInfo(){
        print(articleType)
        if(articleType != .LikeArticle && articleType != .ShareArticle)
        {
            articleType = .LikeArticle
        }
        //  你无法知道 为啥要这么写吧    因为接口 太奇葩
        page = self.thunpUpArray.count/10 + 1
        
        if(XKRWUtil.isNetWorkAvailable())
        {
            XKRWCui.showProgressHud("加载中...")
            self.downloadWithTaskID("UserShareOrLikeInfo") { () -> AnyObject! in
                XKRWUserService.sharedService().getUserShareOrLikeInfoFrom(self.nickName, andInfoType: self.articleType!, andpageTime: 0, andSize: 10,andPage:0)
            }
        }else{
            self.showRequestArticleNetworkFailedWarningShow()
        }
    }
    
    func upPullgetUserShareOrLikeInfo(){
        var entity = XKRWArticleListEntity()
        if(thunpUpArray.count > 0){
            entity = thunpUpArray.lastObject as! XKRWArticleListEntity
        }
        //  写这样的判断 真的 好痛苦   ^.^
        if(page == self.thunpUpArray.count/10 + 1)
        {
            self.downloadWithTaskID("upUserShareOrLikeInfo") { () -> AnyObject! in
                XKRWUserService.sharedService().getUserShareOrLikeInfoFrom(self.nickName, andInfoType: self.articleType!, andpageTime: (entity.createTime), andSize: 10, andPage: self.thunpUpArray.count/10 + 2)
            }
        }else{
            page = self.thunpUpArray.count/10 + 1
            self.downloadWithTaskID("upUserShareOrLikeInfo") { () -> AnyObject! in
                XKRWUserService.sharedService().getUserShareOrLikeInfoFrom(self.nickName, andInfoType: self.articleType!, andpageTime: (entity.createTime), andSize: 10, andPage: self.thunpUpArray.count/10 + 1)
            }
        }
    }
    
    func downPullgetUserShareOrLikeInfo(){
        self.downloadWithTaskID("downUserShareOrLikeInfo") { () -> AnyObject! in
           XKRWUserService.sharedService().getUserShareOrLikeInfoFrom(self.nickName, andInfoType: self.articleType!, andpageTime: 0, andSize: 10, andPage: 0)
        }
    }


    
    override func reLoadDataFromNetwork(button: UIButton!) {
        self.getUserShareOrLikeInfo()
    }
    
    //MARK:   -- Network Action
    
    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {
        XKRWCui.hideProgressHud()
        if(taskID == "UserShareOrLikeInfo")
        {
            self.hiddenRequestArticleNetworkFailedWarningShow()
            self.dealDicToEntityAndAddToArray(result as! NSDictionary)
        }else if(taskID == "upUserShareOrLikeInfo"){
            
            refreshFooterView.endRefreshing()
            
            self.dealDicToEntityAndAddToArray(result as! NSDictionary)
        }else if(taskID == "downUserShareOrLikeInfo"){
            if(nickName != nil){
                refreshHeaderView.endRefreshing()
            }
            thunpUpArray.removeAllObjects()
            self.dealDicToEntityAndAddToArray(result as! NSDictionary)
        }
        
        if(thunpUpArray.count > 0){
            thumpUpTableView.reloadData()
            imageView.hidden = true
            noNoticeLabel.hidden = true
        }else{
            imageView.hidden = false
            noNoticeLabel.hidden = false
        }

    }
    
    override func handleDownloadProblem(problem: AnyObject!, withTaskID taskID: String!) {
        XKRWCui.hideProgressHud()
        if(taskID == "UserShareOrLikeInfo"){
            self.showRequestArticleNetworkFailedWarningShow()
        }
        super.handleDownloadProblem(problem, withTaskID: taskID)
        
        if(nickName != nil){
            if refreshHeaderView.refreshing {
                refreshHeaderView.endRefreshing()
            }
        }
        if refreshFooterView.refreshing {
            refreshFooterView.endRefreshing()
        }
    }
    
    override func shouldRespondForDefaultNotificationForDetailName(detailName: String!) -> Bool {
        return true
    }
    
    
    //MARK:   ---MJRefreshBaseViewDelegate
    func refreshViewBeginRefreshing(refreshView: MJRefreshBaseView!) {
        if(nickName == nil){
            self.upPullgetUserShareOrLikeInfo()
        }else{
            if(refreshView == refreshHeaderView){
                self.downPullgetUserShareOrLikeInfo()
            }else{
                self.upPullgetUserShareOrLikeInfo()
            }
        }
    }
    
    func refreshViewEndRefreshing(refreshView: MJRefreshBaseView!) {
        
    }
    
    func refreshView(refreshView: MJRefreshBaseView!, stateChange state: MJRefreshState) {
        
    }
    
    
    //MARK:   ---tableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return thunpUpArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let topicCell:XKRWFitnessShareCell? = tableView.dequeueReusableCellWithIdentifier("topicCell") as? XKRWFitnessShareCell
        
        let entity = thunpUpArray.objectAtIndex(indexPath.section) as? XKRWArticleListEntity
        
        topicCell?.setContentWithEntity(entity, style: .FitShare, andSuperVC: self)
        topicCell?.tag = indexPath.row
        topicCell?.bgButton.addTarget(self, action: "didSelectArticle:", forControlEvents: UIControlEvents.TouchUpInside)

        return topicCell!
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let entity = thunpUpArray.objectAtIndex(indexPath.section) as! XKRWArticleListEntity
        if(entity.articleState == .DeleteByUser || entity.articleState == .DeleteByAdmin ){
            return UI_SCREEN_WIDTH * kCoverRatio
        }else{
            return (UI_SCREEN_WIDTH * kCoverRatio + 35);
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:UIView = UIView.init(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 10))
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view:UIView = UIView.init(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 10))
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    func didSelectArticle(sender:UIButton) {
        let entity = thunpUpArray.objectAtIndex(sender.tag) as? XKRWArticleListEntity
        let userArticleVC =   XKRWUserArticleVC()
        userArticleVC.aid = entity?.blogId
        if(isUserSelf){
            userArticleVC.likeArticleDeleted = {
                if(entity?.articleState == .DeleteByUser || entity?.articleState == .DeleteByAdmin)
                {
                    return true
                }else{
                    return false
                }
                }()
        }
        self.navigationController?.pushViewController(userArticleVC, animated: true)
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        let entity = thunpUpArray.objectAtIndex(indexPath.section) as? XKRWArticleListEntity
//        let userArticleVC =   XKRWUserArticleVC()
//        userArticleVC.aid = entity?.blogId
//        if(isUserSelf){
//            userArticleVC.likeArticleDeleted = {
//                if(entity?.articleState == .DeleteByUser || entity?.articleState == .DeleteByAdmin)
//                {
//                    return true
//                }else{
//                    return false
//                }
//                }()
//        }
//        self.navigationController?.pushViewController(userArticleVC, animated: true)
//    }
    
     //MARK:   ---UIScroller Delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        backToUpView?.scrollViewDidEndDecelerating(scrollView);
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        backToUpView?.scrollViewDidScroll(scrollView);
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        backToUpView?.scrollViewWillBeginDragging(scrollView);
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        backToUpView?.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        refreshFooterView?.free()
        
        if(nickName != nil){
            refreshHeaderView?.free()
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
