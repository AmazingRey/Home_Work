//
//  XKRWNoticeCenterVC.swift
//  XKRW
//
//  Created by 忘、 on 15/9/18.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWNoticeCenterVC: XKRWBaseVC,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var noticeTableView: UITableView!
    
    var selectedSegmentIndex = 0
    var noticeType:NSInteger = 0
    var isPresent:Bool = false
    var dataArray = []
    var imageView:UIImageView = UIImageView(image: UIImage(named: "feast_pic_"))
    var noNoticeLabel:UILabel = UILabel()
    var chatNum = -1
    var noticeListData:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initData()
        self.systemNoticeSetHaveRead()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        noticeTableView.reloadData()
        
        self.hidesBottomBarWhenPushed = true
        
    }

    //TODO:    Action
    func initView(){
        self.addNaviBarBackButton()
        self.title = "消息中心"
        self.navigationItem.rightBarButtonItem = nil
        let segment = UISegmentedControl(items: ["通知","评论"])
        segment.frame = CGRectMake(15, 10, UI_SCREEN_WIDTH-30, 30)
        segment.tintColor = XKMainSchemeColor
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: "changeSegmentIndexAction:", forControlEvents: .ValueChanged)
        self.view.addSubview(segment)
        
        noticeTableView.separatorStyle = .None
        noticeTableView.delegate = self
        noticeTableView.dataSource = self
        noticeTableView.registerNib(UINib(nibName: "XKRWPraiseCell", bundle: nil), forCellReuseIdentifier: "notice")
        noticeTableView.backgroundColor = XK_BACKGROUND_COLOR
        
        imageView.frame = CGRectMake((UI_SCREEN_WIDTH - 197)/2, (UI_SCREEN_HEIGHT - 64 - 195)/2, 197, 195)
        noNoticeLabel.frame = CGRectMake(imageView.left, imageView.bottom, imageView.width, 40)
        noNoticeLabel.text = "还没有消息哦"
        noNoticeLabel.textAlignment = .Center
        noNoticeLabel.font = XKDefaultFontWithSize(16)
        noNoticeLabel.textColor = XK_TEXT_COLOR
        imageView.hidden = true
        noNoticeLabel.hidden = true
        
        noticeTableView.addSubview(imageView)
        noticeTableView.addSubview(noNoticeLabel)
    }
    
    func initData(){
        if(selectedSegmentIndex == 0){
            noticeListData  = XKRWNoticeService.sharedService().getNoticeListFromDatabaseAndUserId(XKRWUserService.sharedService().getUserId(), andNoticeType: "4,699,9,10")
        }else{
            noticeListData  = XKRWNoticeService.sharedService().getNoticeListFromDatabaseAndUserId(XKRWUserService.sharedService().getUserId(), andNoticeType: "2,7")
        }
        chatNum = XKRWNoticeService.sharedService().ShouShouServerChat(XKRWUserService.sharedService().getUserId())
        self.checkIsHaveMessage()
        
        noticeTableView.reloadData()
    }
    
    override func popView() {
        if(isPresent){
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
        }else{
            super.popView()
        }
    }

    func checkIsHaveMessage() -> Void{
        if(noticeListData.count > 0 ){
            imageView.hidden = true
            noNoticeLabel.hidden = true
        }else{
            imageView.hidden = false
            noNoticeLabel.hidden = false
        }
    }
    
    override func rightItemAction(button: UIButton!) {
        let success = XKRWNoticeService.sharedService().setAllNoticeHadRead(XKRWUserService.sharedService().getUserId())
        if(success){
            noticeListData.removeAllObjects()
            self.initData()
        }
    }
    
    func systemNoticeSetHaveRead(){
        XKRWNoticeService.sharedService().setSystemNoticeHadRead(XKRWUserService.sharedService().getUserId())
    }
    
    func changeSegmentIndexAction(segment:UISegmentedControl) -> Void{
        selectedSegmentIndex = segment.selectedSegmentIndex
        if(segment.selectedSegmentIndex == 0){
            MobClick.event("clk_BoxNews")
            self.navigationItem.rightBarButtonItem = nil
            noticeListData  = XKRWNoticeService.sharedService().getNoticeListFromDatabaseAndUserId(XKRWUserService.sharedService().getUserId(), andNoticeType: "4,699,9,10")
        }else{
            MobClick.event("clk_BoxComment")
            noticeListData  = XKRWNoticeService.sharedService().getNoticeListFromDatabaseAndUserId(XKRWUserService.sharedService().getUserId(), andNoticeType: "2,7")
             self.setNavifationItemWithLeftItemTitle(nil, andRightItemTitle: "全部已读", andItemColor: UIColor.whiteColor(), andShowLeftRedDot: false, andShowRightRedDot: false, andLeftRedDotShowNum: false, andRightRedDotShowNum: false,andLeftItemIcon: nil,andRightItemIcon: nil)
        }
        self.checkIsHaveMessage()
        noticeTableView.reloadData()
    }
    
    //MARK:  Delegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let noticeCell:XKRWPraiseCell = tableView.dequeueReusableCellWithIdentifier("notice") as! XKRWPraiseCell
        noticeCell.selectionStyle = .None
      
        if(noticeListData.count > 0){
            let entity:XKRWPraiseAndCommitNoticeEntity = noticeListData.objectAtIndex(indexPath.row) as!  XKRWPraiseAndCommitNoticeEntity
        
            noticeCell.praiseContentLabel.attributedText = XKRWUtil.createAttributeStringWithString(entity.content, font:XKDefaultFontWithSize(14) , color: XK_ASSIST_TEXT_COLOR, lineSpacing:3.5 , alignment: NSTextAlignment.Left)
            print(entity.userDegreeUrl)
            noticeCell.degreeImageView.setImageWithURL(NSURL(string: entity.userDegreeUrl), placeholderImage: nil)
            noticeCell.headButton.setImageWithURL(NSURL(string: entity.avater), forState: .Normal, placeholderImage: nil)
         
            noticeCell.headButton.layer.masksToBounds = true
            noticeCell.headButton.layer.cornerRadius = 20
            noticeCell.userName.text = entity.nickName
            noticeCell.praiseTimeLabel.text = entity.time
            if(entity.read == 1){
                noticeCell.contentView.backgroundColor = UIColor.whiteColor()
            }else{
                noticeCell.contentView.backgroundColor = XKGrayDefaultColor
            }
            
            if(entity.type == 699){
                if(chatNum > 0){
                    noticeCell.newChatInfoLabel.hidden = false
                    noticeCell.newChatInfoLabel.text = "\(chatNum)"
                }
                noticeCell.userName.text = "瘦瘦客服"
                noticeCell.headButton.setBackgroundImage(UIImage(named: "shoushouServer"), forState: .Normal)
            }else{
                noticeCell.newChatInfoLabel.hidden = true
            }
        }
        return noticeCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell:XKRWPraiseCell?  = tableView.dequeueReusableCellWithIdentifier("notice") as? XKRWPraiseCell
        if (cell != nil){
            if(noticeListData.count > 0){
                let entity:XKRWPraiseAndCommitNoticeEntity = noticeListData.objectAtIndex(indexPath.row) as!  XKRWPraiseAndCommitNoticeEntity
                cell?.praiseContentLabel.preferredMaxLayoutWidth = UI_SCREEN_WIDTH-80
                cell?.praiseContentLabel.text = entity.content
                cell!.praiseContentLabel.backgroundColor = UIColor.redColor()
            }
            let height = cell!.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 5
            
            if height <= 60{
                return 60
            }else{
                return height
            }
        } else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeListData.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let entity:XKRWPraiseAndCommitNoticeEntity = noticeListData.objectAtIndex(indexPath.row) as!  XKRWPraiseAndCommitNoticeEntity
        
        let success =    XKRWNoticeService.sharedService().setCurrentNoticeHadRead(XKRWUserService.sharedService().getUserId(), andNid: entity.nid)
        
        if(success){
            noticeListData.removeAllObjects()
            self.initData()
        }
        if(entity.type == 3 || entity.type == 4){
            let userArticleVC =   XKRWUserArticleVC()
            userArticleVC.aid = entity.blogId
            self.navigationController?.pushViewController(userArticleVC, animated: true)
            
        }
        else if(entity.type  == 699){
            let chatVC = XKRWShouShouServicerVC(nibName:"XKRWShouShouServicerVC",bundle: nil)
            chatVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(chatVC, animated: true)
        }else if(entity.type == 9 || entity.type == 10){
            return
        }
        else{
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            if(XKRWUtil.isNetWorkAvailable())
            {
                let vc = XKRWMyNoticeDetailVC(nibName:"XKRWMyNoticeDetailVC",bundle:nil)
                vc.headEntity = entity
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                XKRWCui.showInformationHudWithText("网络连接有问题,请稍后再试")
            }
 
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
             let entity:XKRWPraiseAndCommitNoticeEntity = noticeListData.objectAtIndex(indexPath.row) as!  XKRWPraiseAndCommitNoticeEntity
            
             let success =   XKRWNoticeService.sharedService().deleteNoticeWithNid(entity.nid)
            
            if(success){
                noticeListData.removeAllObjects()
                self.initData()
            }
        }
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
