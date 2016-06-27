//
//  XKRWMyNoticeDetailVC.swift
//  XKRW
//
//  Created by 忘、 on 15/9/29.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWMyNoticeDetailVC: XKRWBaseVC,UITableViewDelegate,UITableViewDataSource,XKRWFitCommentCellDelegate,XKRWTipViewDelegate,UIActionSheetDelegate,XKRWInputBoxViewDelegate {
    
    @IBOutlet weak var noticeTableView: UITableView!
    var mainCommentBottom:CGFloat = 0
    var  importView:XKRWInputBoxView = XKRWInputBoxView(placeholder: nil, style: .original)
    var  tipView:XKRWTipView?
    var reportReason = []
    var insertCommentIndex:NSIndexPath = NSIndexPath()
    var commentEntity:XKRWCommentEtity?
    var headEntity:XKRWPraiseAndCommitNoticeEntity?
//    var selectedRow:NSInteger = 0
    var commentIndexArray = [NSIndexPath]()
    var noticeTitle:String = ""
    var coverImageUrl:String = ""
    var readNum:Int = 0
    var isPresent:Bool = false
    var reportCommentId:NSInteger = 0
    var commentCount:NSInteger = 0
    var commentMutArr:NSMutableArray =  NSMutableArray()
    
    var sid = 0
    var fid = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initData()
        self.initView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //TODO:
    
    func initView(){
        self.title = "消息"
        self.addNaviBarBackButton()
        
        noticeTableView.delegate = self
        noticeTableView.dataSource = self
        noticeTableView.separatorStyle = .None
        noticeTableView.backgroundColor = UIColor.clearColor()
        noticeTableView.registerNib(UINib(nibName: "XKRWNoticeTitleCell", bundle: nil), forCellReuseIdentifier: "titleCell")
        tipView = XKRWTipView.init()
        tipView!.delegate = self
        
        importView.delegate = self
  
        importView.showIn(self.view)
    }
    
    func initData(){
        if (!XKRWUtil.isNetWorkAvailable()) {
            XKRWCui.showInformationHudWithText("没有网络，请检查网络设置")
            return;
        }
        XKHudHelper.instance().showProgressHudAnimationInView(self.view)
        self.getNoticeDetailInfo()
        self.getReportReason()
    }
    
    func getNoticeDetailInfo(){
        self.downloadWithTaskID("getNoticeComment") { () -> AnyObject! in
            return XKRWNoticeService.sharedService().getNoticeDetailDataWithBlogId(self.headEntity!.blogId, andCommentId: "\(self.headEntity!.comment_id)" ,andNoticeType:self.headEntity!.type )
        }
    }
    
    func getReportReason(){
        self.downloadWithTaskID("getReportReasons") { () -> AnyObject! in
            return XKRWUserArticleService.shareService.getReportReasonByEnabled(1)
        }
    }
    
    override func popView() {
        if(isPresent){
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
            })
        }else{
            super.popView()
        }
    }
    
    
    func showUserInfo(button:UIButton){
        let userInfoVC:XKRWUserInfoVC = XKRWUserInfoVC(nibName:"XKRWUserInfoVC",bundle:nil)
        userInfoVC.userNickname = commentEntity!.nameStr
        self.navigationController?.pushViewController(userInfoVC, animated: true)
    }
    
    //Network Deal
    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {
        if(taskID == "getNoticeComment"){
            XKHudHelper.instance().hideProgressHudAnimationInView(self.view)
         
            let blogDic:NSDictionary = result.objectForKey("data")?.objectForKey("blog") as! NSDictionary
            let comment:NSDictionary = result.objectForKey("data")?.objectForKey("comment") as! NSDictionary
            
     
            noticeTitle = blogDic.objectForKey("title") as! String
            if(self.headEntity?.type != 7){
                readNum = (blogDic.objectForKey("view")?.integerValue)!
                
                let jsonCover = blogDic["cover"] as! String
                var cover: NSDictionary
                do {
                    cover = try
                        NSJSONSerialization.JSONObjectWithData(jsonCover.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as! NSDictionary
                } catch {
                    Log.debug_println("JSON parser error")
                    return
                }
                coverImageUrl = cover.objectForKey("url") as! String
            }
            commentEntity = XKRWManagementService5_0 .sharedService().getCommentEntityFromDic(comment as [NSObject : AnyObject]) as XKRWCommentEtity
        
        }else if(taskID == "deleteComment"){
         
            if((result.objectForKey("success")?.boolValue) == true){
            XKRWCui.showInformationHudWithText("成功删除")
                if (commentIndexArray.count == 1) {
                    commentEntity = nil
                } else if (commentIndexArray.count == 2){
                    commentEntity!.sub_Array.removeObjectAtIndex(commentIndexArray[1].row)
                }
            } else {
                XKRWCui.showInformationHudWithText("删除失败")
            }

        }else if(taskID == "commitComment"){
            if (result.objectForKey("success")?.integerValue == 1){
                XKRWCui.showInformationHudWithText("评论成功");
               
                if (commentEntity!.sub_Array == nil) {
                    commentEntity!.sub_Array = NSMutableArray()
                    commentEntity!.sub_Array.addObject(result.objectForKey("comment") as! XKRWReplyEntity)
                } else {
                    if((result.objectForKey("comment") != nil)){
                        commentEntity!.sub_Array.addObject(result.objectForKey("comment") as! XKRWReplyEntity)
                    }
                }
              
            }else{
                XKRWCui.showInformationHudWithText("评论失败");
            }
            
        }else if(taskID == "getReportReasons" ){
         
            reportReason = result as! NSArray
        
        }else if(taskID == "addReport"){
            if ((result.boolValue) == true) {
                XKRWCui.showInformationHudWithText("举报成功")
                
            } else {
                XKRWCui.showInformationHudWithText("举报失败")
            }
        }
        noticeTableView.reloadData()
    }
    
    override func handleDownloadProblem(problem: AnyObject!, withTaskID taskID: String!) {
        super.handleDownloadProblem(problem, withTaskID: taskID)
    }
    
    override func shouldRespondForDefaultNotificationForDetailName(detailName: String!) -> Bool {
        return  true
    }
    
    //MARK:   Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            
            if(self.headEntity?.type == 7){
                let titleCell = UITableViewCell(style: .Default, reuseIdentifier: nil)
                titleCell.textLabel?.font = XKDefaultFontWithSize(16)
                titleCell.textLabel?.textColor = XK_TITLE_COLOR
                titleCell .textLabel?.text = noticeTitle
                XKRWUtil.addViewUpLineAndDownLine(titleCell.contentView, andUpLineHidden: true, downLineHidden: false)
                return titleCell
            }else{
                let titleCell:XKRWNoticeTitleCell = tableView.dequeueReusableCellWithIdentifier("titleCell") as! XKRWNoticeTitleCell
                titleCell.titleLabel.attributedText = XKRWUtil.createAttributeStringWithString(noticeTitle, font: XKDefaultFontWithSize(16), color: XK_TITLE_COLOR, lineSpacing: 4, alignment: .Left)
                //            titleCell.selectionStyle = .None
                if(readNum > 10000){
                    titleCell.numLabel.text = "\(readNum/10000)万+"
                }else{
                    titleCell.numLabel.text = "\(readNum)"
                    
                }
                titleCell.headImageView.setImageWithURL(NSURL(string: coverImageUrl), placeholderImage: UIImage(named: "share_photo_placeholder"),options:.RetryFailed)
                return titleCell
            }
            
        }else{
            
            if(commentEntity != nil && self.commentEntity?.commentStr.length > 0)
            {
                let commentCell = XKRWFitCommentCell.init(style: .Default, reuseIdentifier: "commentCell")
                commentCell.selectIndexPath = indexPath
                commentCell.delegate = self
                commentCell.iconBtn.addTarget(self, action:#selector(XKRWMyNoticeDetailVC.showUserInfo(_:)), forControlEvents: .TouchUpInside)
                commentCell.entity = commentEntity
                commentCell.openBlock =  { selectIndexPath , state  -> Void in
                    self.commentEntity?.isOpen = !state
                    self.noticeTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
                commentCell.line.hidden = true
                return commentCell
            }else{
                let commentCell = UITableViewCell(style:.Default, reuseIdentifier: nil)
                commentCell.textLabel?.text = "该评论已删除"
                commentCell.textLabel?.textColor = XK_TEXT_COLOR
                commentCell.textLabel?.font = XKDefaultFontWithSize(14)
                return commentCell
            }
        }
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0){
            
            
            if(self.headEntity?.type == 7){
                    return 44
            }else{
            
            if let cell = tableView.dequeueReusableCellWithIdentifier("titleCell") as? XKRWNoticeTitleCell {
                
                cell.titleLabel.preferredMaxLayoutWidth = UI_SCREEN_WIDTH-80
                cell.titleLabel.text = noticeTitle
                cell.contentView.updateConstraints()
                let height = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 1
                
                if height <= 90{
                    return 90
                }else{
                    return height
                }
            } else{
                return 0
            }
            }
        }else{
            if(commentEntity != nil && self.commentEntity?.commentStr.length > 0)
            {
                let commentCell = XKRWFitCommentCell.init(style: .Default, reuseIdentifier: "commentCell")
                commentCell.entity = commentEntity;
                return commentCell.line.bottom
            }else{
                return 44
            }
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0){
            
            if(self.headEntity?.type == 7 ){
                let postVC = XKRWPostDetailVC()
                postVC.postID = headEntity!.blogId
                self.navigationController?.pushViewController(postVC, animated: true)
            }else if(self.headEntity?.type == 2){
                let userArticleVC =   XKRWUserArticleVC()
                userArticleVC.aid = headEntity!.blogId
                self.navigationController?.pushViewController(userArticleVC, animated: true)
            }
        }
    }
    
    func fitCommentCell(fitCommentCell: XKRWFitCommentCell!, didReplyComment comment: XKRWCommentEtity!) {
        mainCommentBottom = fitCommentCell.commentLabel.frame.origin.y + fitCommentCell.commentLabel.size.height;
        var view:UIView?  = fitCommentCell.commentLabel as UIView ;
        while (view != nil) {
            
            mainCommentBottom += view!.frame.origin.y;
            if (view!.isKindOfClass(UIScrollView)) {
                mainCommentBottom -= (view as! UIScrollView).contentOffset.y
            }
            view = view!.superview;
        }
        
        insertCommentIndex = fitCommentCell.selectIndexPath;
        self.sid = 0
        self.fid = comment.comment_id.integerValue
        self.importView.beginEditWithPlaceholder("回复\(comment.nameStr)")
    }
    
    
    func fitCommentCell(fitCommentCell: XKRWFitCommentCell!, clickedComment comment: XKRWCommentEtity!) {
        mainCommentBottom = fitCommentCell.commentLabel.frame.origin.y + fitCommentCell.commentLabel.size.height;
        var view:UIView?  = fitCommentCell.commentLabel as UIView ;
        while (view != nil) {
            mainCommentBottom += view!.frame.origin.y;
            if (view!.isKindOfClass(UIScrollView)) {
                mainCommentBottom -= (view as! UIScrollView).contentOffset.y
            }
            view = view!.superview;
        }
        
        commentIndexArray.removeAll()
        commentIndexArray.append(fitCommentCell.selectIndexPath!)
        
        if (comment.nameStr == XKRWUserService.sharedService().getUserNickName()) {
            //删除Tip
            self.showIsDeleteInfoWithCommentIndex(fitCommentCell.selectIndexPath.row)
        } else {
            self.importView.beginEditWithPlaceholder("回复\(comment.nameStr)")
            insertCommentIndex = fitCommentCell.selectIndexPath;
            self.sid = 0
            self.fid = comment.comment_id.integerValue
        }
    }
    
    
    func fitCommentCell(fitCommentCell: XKRWFitCommentCell!, longPressedComment comment: XKRWCommentEtity!) {
        
        let view:UIView? = fitCommentCell.commentLabel
        
        commentIndexArray.removeAll()
        commentIndexArray.append(fitCommentCell.selectIndexPath!)
        if(comment.nameStr == XKRWUserService.sharedService().getUserNickName()){
            tipView?.showUpView(view, titles: ["删除","复制"])
           
        }else{
            tipView?.showUpView(view, titles: ["举报","复制"])
        }
        tipView!.indexArray = commentIndexArray;
        tipView!.commentId = comment.comment_id.integerValue;
        
    }
    
    func fitSubComment(replyView: XKRWReplyView!, longPressedAtIndexPath selfIndexPath: NSIndexPath!, subIndexPath subCellIndexPath: NSIndexPath!) {
        let view:UIView? = replyView.tableView.cellForRowAtIndexPath(subCellIndexPath);
        
        commentIndexArray.removeAll()
        commentIndexArray.append(selfIndexPath!)
        commentIndexArray.append(subCellIndexPath!)
        
        let replayeEntity:XKRWReplyEntity = commentEntity!.sub_Array[subCellIndexPath.row] as! XKRWReplyEntity
        
        if (replayeEntity.nickName == XKRWUserService.sharedService().getUserNickName()) {
            tipView?.showUpView(view, titles: ["删除","复制"])
            
        }else{
            tipView?.showUpView(view, titles: ["举报","复制"])
        }
        tipView!.indexArray = commentIndexArray;
        tipView!.commentId = replayeEntity.mainId;
    }
    
    func fitSubComment(replyView: XKRWReplyView!, didSelectAtIndexPath selfIndexPath: NSIndexPath!, subIndexPath subCellIndexPath: NSIndexPath!) {
        mainCommentBottom = replyView.tableView.cellForRowAtIndexPath(subCellIndexPath)!.frame.origin.y + replyView.tableView.cellForRowAtIndexPath(subCellIndexPath)!.size.height;
        var view:UIView? = replyView.tableView.cellForRowAtIndexPath(subCellIndexPath)
        while (view != nil) {
            mainCommentBottom += view!.frame.origin.y;
            if (view!.isKindOfClass(UIScrollView)) {
                mainCommentBottom -= (view as! UIScrollView).contentOffset.y;
            }
            view = view!.superview;
        }
        let replayeEntity:XKRWReplyEntity = commentEntity!.sub_Array[subCellIndexPath.row] as! XKRWReplyEntity
        if (replayeEntity.nickName == XKRWUserService.sharedService().getUserNickName()) {
            //删除Tip
            commentIndexArray.removeAll()
            commentIndexArray.append(selfIndexPath)
            commentIndexArray.append(subCellIndexPath)
            
            self.showIsDeleteInfoWithCommentIndex(subCellIndexPath.row);
        } else {
           
            self.importView.beginEditWithPlaceholder("回复\(replayeEntity.nickName)")

            insertCommentIndex = selfIndexPath;
            self.sid = replayeEntity.mainId
            self.fid = commentEntity!.comment_id.integerValue
        }
    }
    
    func showIsDeleteInfoWithCommentIndex(commentIndex:NSInteger){
        weak var  weakSelf = self;
        
        XKRWCui.showConfirmWithMessage("删除评论", okButtonTitle: "确定", cancelButtonTitle: "取消") { () -> Void in
            weakSelf?.deleteCommentWithCommentId(commentIndex)
        }
    }
    
    func deleteCommentWithCommentId(commentId:NSInteger)
    {

//        selectedRow = commentId
        
        self.downloadWithTaskID("deleteComment") { () -> AnyObject! in
            return XKRWManagementService5_0.sharedService().deleteCommentWithBlogId(self.headEntity?.blogId, andComment_id: (self.commentEntity?.sub_Array[commentId] as! XKRWReplyEntity).mainId)
        }
        
    }
    
    
    func inputBoxView(inputBoxView: XKRWInputBoxView!, sendMessage message: String!) {
        if (message!.length == 0 || message == nil) {
            XKRWCui.showInformationHudWithText("评论不能为空");
        } else {
            self.downloadWithTaskID("commitComment", outputTask: { () -> AnyObject! in
                if(self.headEntity?.type == 7){
                    return   XKRWManagementService5_0.sharedService().writeCommentWithMessage(message, blogid: self.headEntity?.blogId, sid: self.sid, fid: self.fid, type:2)
                }else{
                    return   XKRWManagementService5_0.sharedService().writeCommentWithMessage(message, blogid: self.headEntity?.blogId, sid: self.sid, fid: self.fid, type:0)
                }
                
            })
        }

    }
    

    
    func tipView(tipView: XKRWTipView!, delectCommentWithCommentId commentId: Int) {
        self.downloadWithTaskID("deleteComment") { () -> AnyObject! in
            return XKRWManagementService5_0.sharedService().deleteCommentWithBlogId(self.headEntity?.blogId, andComment_id: NSNumber(integer: commentId))
        }
    }
    
    func tipView(tipView: XKRWTipView!, copyAtIndexPath mainIndexPath: NSIndexPath!, subIndexPath: NSIndexPath!) {
        let pasteboard:UIPasteboard =  UIPasteboard.generalPasteboard()
        if (subIndexPath != nil) {
            pasteboard.string = commentEntity?.sub_Array[subIndexPath.row].replyContent
        } else {
            pasteboard.string = commentEntity?.commentStr
        }
        
        
    }
    
    func tipView(tipView: XKRWTipView!, reportCommentWithCommentId commentId: Int) {
        reportCommentId = commentId
        self.isReportComment()
    }
    
    
    
    func isReportComment(){
        XKRWCui.showConfirmWithMessage("举报评论", okButtonTitle: "确定", cancelButtonTitle: "取消"){ () -> Void in
            self.didReportComment()
        }
    }
    
    func didReportComment(){
        if(XKUtil.isNetWorkAvailable() == false){
            XKRWCui.showInformationHudWithText("没有网络，请检查网络设置")
            return
        }else{
            let   actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
            for(var  i = 0 ; i < reportReason.count ; i++){
                actionSheet.addButtonWithTitle((reportReason.objectAtIndex(i) as! NSDictionary)["name"] as? String)
            }
            actionSheet.showInView(self.view)
        }
    }
    

    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if(buttonIndex != actionSheet.cancelButtonIndex){
            let reason = "\(buttonIndex)"
            
            if(headEntity?.type == 8 ){
                self.downloadWithTaskID("addReport", outputTask: { () -> AnyObject! in
                    return XKRWUserArticleService.shareService.reportWithItem_id("\(self.reportCommentId)", type: .Post, blogId: (self.headEntity?.blogId)!, reason: reason)
                })
            }else{
                self.downloadWithTaskID("addReport", outputTask: { () -> AnyObject! in
                    return XKRWUserArticleService.shareService.reportWithItem_id("\(self.reportCommentId)", type: .Comment, blogId: (self.headEntity?.blogId)!, reason: reason)
                })
            }
        }
    }
    
    func fitSubComment(replyView: XKRWReplyView!, userNameDidClicked userName: String!) {
        let userInfoVC:XKRWUserInfoVC = XKRWUserInfoVC(nibName:"XKRWUserInfoVC",bundle:nil)
        userInfoVC.userNickname = userName
        self.navigationController?.pushViewController(userInfoVC, animated: true)
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
