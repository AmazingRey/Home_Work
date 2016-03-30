//
//  XKRWBePraisedVC.swift
//  XKRW
//
//  Created by 忘、 on 15/9/22.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

@objc enum bePraiseDataType:Int{
    case FromNetwofk
    case FromDataBase
}


class XKRWBePraisedVC: XKRWBaseVC,UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate {

    @IBOutlet weak var praisedTableView: UITableView!
    
    var dataType:bePraiseDataType = .FromNetwofk
    
    var present = false
//    var nibsRegistered = false
    let identifier:String = "XKRWPraiseCell"
    var bePraisedArray:NSMutableArray = []
    
    var refreshHeaderView:MJRefreshHeaderView!
    
    var refreshFooterView:MJRefreshFooterView!
    
    var imageView:UIImageView = UIImageView(image: UIImage(named: "feast_pic_"))
    var noNoticeLabel:UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initData()
        
        // Do any additional setup after loading the view.
    }
    //TODO:  Action
    func initView(){
        self.addNaviBarBackButton()
        if(dataType == .FromDataBase){
            self.title = "新收到的喜欢"
        }else{
            self.title = "获得喜欢"
        }
        praisedTableView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)
        praisedTableView.delegate = self
        praisedTableView.dataSource = self
        praisedTableView.separatorStyle = .None
        praisedTableView.backgroundColor = XK_BACKGROUND_COLOR
        let nib:UINib =  UINib(nibName: identifier, bundle: nil)
        praisedTableView.registerNib(nib, forCellReuseIdentifier: identifier)
        
        imageView.frame = CGRectMake((UI_SCREEN_WIDTH - 197)/2, (UI_SCREEN_HEIGHT - 64 - 195)/2, 197, 195)
        noNoticeLabel.frame = CGRectMake(imageView.left, imageView.bottom, imageView.width, 40)
        noNoticeLabel.text = "还没有收到任何喜欢哦"
        noNoticeLabel.textAlignment = .Center
        noNoticeLabel.font = XKDefaultFontWithSize(16)
        noNoticeLabel.textColor = XK_TEXT_COLOR
        praisedTableView.addSubview(imageView)
        praisedTableView.addSubview(noNoticeLabel)
        
        noNoticeLabel.hidden = true
        imageView.hidden = true
        
        if(dataType == .FromNetwofk){
            self.addFooterView()
            self.addHeaderView()
        }
    }
    
    func initData(){
        if(dataType == .FromNetwofk){
            self.getBePraisedInfo()
        }else{
            bePraisedArray = XKRWNoticeService.sharedService().getBePraiseFromDatabaseWithUserId(XKRWUserService.sharedService().getUserId())
            XKRWNoticeService.sharedService().deleteUnreadBePraisedNotice()
        }
    }
    
    func addFooterView(){
        refreshFooterView = MJRefreshFooterView(scrollView: praisedTableView)
        refreshFooterView.delegate = self
    }
    
    func addHeaderView(){
        refreshHeaderView = MJRefreshHeaderView(scrollView: praisedTableView)
        refreshHeaderView.delegate = self
    }
    
    func showUserInfo(buttton:UIButton){
        let userinfoVC:XKRWUserInfoVC = XKRWUserInfoVC(nibName:"XKRWUserInfoVC",bundle:nil)
        let entity =  bePraisedArray.objectAtIndex(buttton.tag - 1000) as! XKRWBePraisedEntity
        userinfoVC.userNickname = entity.userNickName
        self.navigationController?.pushViewController(userinfoVC, animated: true)
    }
    
    func getBePraisedInfo(){
        if(XKRWUtil.isNetWorkAvailable()){
            XKRWCui.showProgressHud("加载中...")
            self.downloadWithTaskID("getBePraisedInfo") { () -> AnyObject! in
                return XKRWUserService.sharedService().getBePraisedInfoAndpageTime(0, andSize: 10)
            };
        }else{
            self.showRequestArticleNetworkFailedWarningShow()
        }
    }
    
    func downPullBePraisedInfo(){
        self.downloadWithTaskID("downGetBePraisedInfo") { () -> AnyObject! in
            return XKRWUserService.sharedService().getBePraisedInfoAndpageTime(0, andSize: 10)
        };
    }
    
    
    func upPullBePraisedInfo(){
        var entity:XKRWBePraisedEntity = XKRWBePraisedEntity()
        if( bePraisedArray.count > 0){
            entity = bePraisedArray.lastObject as! XKRWBePraisedEntity
        }
        self.downloadWithTaskID("upgetBePraisedInfo") { () -> AnyObject! in
            return XKRWUserService.sharedService().getBePraisedInfoAndpageTime(entity.createTime, andSize: 10)
        };
    }
    
    func dealDicToEntityAndAddToArray(dic: AnyObject! ){
    
        print(dic)
        let array = dic.objectForKey("data") as! NSArray
        for var i = 0 ;i < array.count ; i++ {
            let dic:NSDictionary = array.objectAtIndex(i) as! NSDictionary
            let entity = XKRWBePraisedEntity()
            entity.headImageUrl = dic.objectForKey("avatar") as! String
            if(dic.objectForKey("blogid") != nil){
                entity.blogId = dic.objectForKey("blogid") as! String
            }
            if(dic.objectForKey("postid") != nil){
                entity.postId = dic.objectForKey("postid") as! String
            }
            entity.createTime = dic.objectForKey("good_time")!.integerValue
            entity.userDegreeUrl = dic.objectForKey("level") as! String
            entity.userNickName = dic.objectForKey("nickname") as! String
            entity.content = dic.objectForKey("title") as! String
            bePraisedArray.addObject(entity)
        }
    }
    
    override func reLoadDataFromNetwork(button: UIButton!) {
        self.getBePraisedInfo()
    }
    
    override func popView() {
        if(present){
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
        }else{
            super.popView()
        }
    }
    
    
    //MARK:  Network Deal
    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {
        XKRWCui.hideProgressHud()
        if(taskID == "getBePraisedInfo"){
            self.hiddenRequestArticleNetworkFailedWarningShow()
            self.dealDicToEntityAndAddToArray(result)
            
        }else if(taskID == "downGetBePraisedInfo"){
            bePraisedArray.removeAllObjects()
            refreshHeaderView.endRefreshing()
             self.dealDicToEntityAndAddToArray(result)
        }else if(taskID == "upgetBePraisedInfo"){
            refreshFooterView.endRefreshing()
            self.dealDicToEntityAndAddToArray(result)
        }
       
       
        if(bePraisedArray.count > 0){
            praisedTableView.reloadData()
            imageView.hidden = true
            noNoticeLabel.hidden = true
        }else{
            imageView.hidden = false
            noNoticeLabel.hidden = false
        }

    }
    
    override func handleDownloadProblem(problem: AnyObject!, withTaskID taskID: String!) {
         XKRWCui.hideProgressHud()
        if(taskID == "getBePraisedInfo"){
            self.showRequestArticleNetworkFailedWarningShow()
        }
        super.handleDownloadProblem(problem, withTaskID: taskID)
    }
    
    override func shouldRespondForDefaultNotificationForDetailName(detailName: String!) -> Bool {
        return true
    }
    
    //MARK:   ---MJRefreshBaseViewDelegate
    func refreshViewBeginRefreshing(refreshView: MJRefreshBaseView!) {
        if(refreshView == refreshHeaderView){
            self.downPullBePraisedInfo()
        }else{
            self.upPullBePraisedInfo()
        }
    }
    
    func refreshViewEndRefreshing(refreshView: MJRefreshBaseView!) {
        
    }
    
    func refreshView(refreshView: MJRefreshBaseView!, stateChange state: MJRefreshState) {
        
    }
    
    //MARK:  TableViewDelagate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bePraisedArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var praiseCell:XKRWPraiseCell? = tableView.dequeueReusableCellWithIdentifier(identifier) as? XKRWPraiseCell
        if(praiseCell == nil){
            praiseCell!  = loadViewFromBundle(identifier, owner: nil) as! XKRWPraiseCell
        }
        praiseCell!.selectionStyle = .None
        let entity = bePraisedArray.objectAtIndex(indexPath.row) as! XKRWBePraisedEntity
        praiseCell!.headButton.tag = 1000 + indexPath.row
        praiseCell!.headButton.addTarget(self, action: "showUserInfo:", forControlEvents:.TouchUpInside)
        
        if(dataType == .FromDataBase){
            praiseCell!.praiseContentLabel.attributedText = XKRWUtil.createAttributeStringWithString( entity.content, font: XKDefaultFontWithSize(14), color: XK_TEXT_COLOR, lineSpacing: 3.5, alignment: .Left)
        }else{
        
            if(entity.blogId.length > 0){
                praiseCell!.praiseContentLabel.attributedText = XKRWUtil.createAttributeStringWithString("喜欢了你的分享 " +  "《" + entity.content + "》", font: XKDefaultFontWithSize(14), color: XK_TEXT_COLOR, lineSpacing: 3.5, alignment: .Left)
            }else{
                praiseCell!.praiseContentLabel.attributedText = XKRWUtil.createAttributeStringWithString("喜欢了你的帖子 " +  "《" + entity.content + "》", font: XKDefaultFontWithSize(14), color: XK_TEXT_COLOR, lineSpacing: 3.5, alignment: .Left)
            }
        }
        praiseCell!.degreeImageView.setImageWithURL(NSURL(string: entity.userDegreeUrl), placeholderImage: nil)
        praiseCell!.userName.text =  entity.userNickName
        praiseCell!.headButton.layer.masksToBounds = true
        praiseCell!.headButton.layer.cornerRadius = 20
        praiseCell!.praiseTimeLabel.text =  XKRWUtil.calculateTimeShowStr(Int(entity.createTime))
        praiseCell!.headButton.setImageWithURL(NSURL(string: entity.headImageUrl), forState:
        .Normal)
        return praiseCell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell:XKRWPraiseCell?  = tableView.dequeueReusableCellWithIdentifier("XKRWPraiseCell") as? XKRWPraiseCell
        let entity = bePraisedArray.objectAtIndex(indexPath.row) as! XKRWBePraisedEntity
        if (cell != nil){
            
            cell?.praiseContentLabel.preferredMaxLayoutWidth = UI_SCREEN_WIDTH - 80
            cell?.praiseContentLabel.text = entity.content
            cell?.contentView.updateConstraints()
            let height = cell!.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 1

            if height <= 60 {
                return 70
            }else{
                return height
            }
        } else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(dataType == .FromDataBase){
            let entity = bePraisedArray.objectAtIndex(indexPath.row) as! XKRWBePraisedEntity
            
            if(entity.blogId.length > 0){
                let articleVC = XKRWUserArticleVC()
                articleVC.aid = entity.blogId;
                self.navigationController?.pushViewController(articleVC, animated: true)
            
            }else{
                let postVC = XKRWPostDetailVC()
                postVC.postID = entity.postId
                self.navigationController?.pushViewController(postVC, animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        if(dataType == .FromNetwofk){
            refreshFooterView.free()
            refreshHeaderView.free()
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
