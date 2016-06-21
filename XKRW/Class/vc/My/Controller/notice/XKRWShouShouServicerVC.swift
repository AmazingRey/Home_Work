//
//  XKRWShouShouServicerVC.swift
//  XKRW
//
//  Created by 忘、 on 16/2/18.
//  Copyright © 2016年 XiKang. All rights reserved.
//

import UIKit



class XKRWShouShouServicerVC: XKRWBaseVC,UITableViewDelegate,UITableViewDataSource,XKRWInputBoxViewDelegate {
    
    let toolBarMinHeight: CGFloat = 44.0
   
    @IBOutlet weak var chatTableView: UITableView!
    var toolBarView:XKRWInputBoxView!
    var toolBarConstranit: NSLayoutConstraint!
    var redirect = ""
    var sendMessage:String?
    var messageList = [XKRWChatMessageModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()

        self.title = "瘦瘦客服"
        chatTableView.backgroundColor = UIColor.clearColor()
        chatTableView.delegate = self
        chatTableView.dataSource  = self
        chatTableView.separatorStyle = .None
        self.view.addSubview(chatTableView)
        
        chatTableView.registerNib(UINib(nibName: "XKRWServerChatCell", bundle: nil), forCellReuseIdentifier: "ChatCell")
        
        toolBarView = XKRWInputBoxView(placeholder: "", style: .footer)
        toolBarView.delegate = self
        toolBarView.showIn(self.view)
        self.performSelector(#selector(XKRWShouShouServicerVC.setTableViewContentOffset), withObject: nil, afterDelay: 0.25)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideKeyboard", name: "hideKeyboard", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        XKRWNoticeService.sharedService().setChatNoticeHadRead(XKRWUserService.sharedService().getUserId())
    }
    
    func initData() -> Void{
       messageList = XKRWNoticeService.sharedService().getAllShouShouServerAndUserReplayFromDatabaseWithUserId(XKRWUserService.sharedService().getUserId()) as! [XKRWChatMessageModel]
    }
    
    func setTableViewContentOffset() -> Void {
        let size = self.chatTableView.contentSize
        print(size)
        if(size.height > UI_SCREEN_HEIGHT - 64 - 40){
            self.chatTableView.contentOffset.y = size.height - (UI_SCREEN_HEIGHT - 64 - 40)
            
        }
    }
    
    //Mark
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell:XKRWServerChatCell = tableView.dequeueReusableCellWithIdentifier("ChatCell") as!  XKRWServerChatCell
        let model = messageList[indexPath.row]
        cell.setMessage(model)
        
        return XKRWUtil.getViewSize(cell.contentView).height + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:XKRWServerChatCell = tableView.dequeueReusableCellWithIdentifier("ChatCell") as!  XKRWServerChatCell
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        let model = messageList[indexPath.row]
        cell.setMessage(model)
        
        return cell
    }
    

    
    // MARK: - gestureRecognizer
    func tapTableView(gestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
        toolBarConstranit.constant = 0
    }
    
    
    
    // MARK: - keyBoard notification
    func keyboardChange(notification: NSNotification) {
        let userInfo = notification.userInfo as NSDictionary!
        let newFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let animationTimer = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        view.layoutIfNeeded()
        if newFrame.origin.y == UIScreen.mainScreen().bounds.size.height {
            UIView.animateWithDuration(animationTimer, animations: { () -> Void in
                self.toolBarConstranit.constant = 0
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animateWithDuration(animationTimer, animations: { () -> Void in
                self.toolBarConstranit.constant = -newFrame.size.height
                self.scrollToBottom()
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func scrollToBottom() {
        let numberOfRows = chatTableView.numberOfRowsInSection(0)
        if numberOfRows > 0 {
            chatTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: numberOfRows - 1, inSection: 0), atScrollPosition: .Bottom, animated: true)
        }
    }
    
    
    func inputBoxView(inputBoxView: XKRWInputBoxView!, sendMessage message: String!) {
        if(XKRWUtil.isNetWorkAvailable()){
            sendMessage = message
            self.downloadWithTaskID("sendMessage") { () -> AnyObject! in
                return XKRWNoticeService.sharedService().sendChatInfoToShouShouServer(message)
            }
        }else{
            XKRWCui.showInformationHudWithText("请检查网络后尝试")
        }
    }
    
//    func inputBoxView(inputBoxView: XKRWInputBoxView!, inHeight height: CGFloat, willShowDuration duration: CGFloat) {
//        UIView.animateWithDuration(NSTimeInterval(duration)) { () -> Void in
//            var frame = self.chatTableView.frame
//            frame.origin.y += -height + 40
//            self.chatTableView.frame = frame
//        }
//    }
    
//    func inputBoxView(inputBoxView: XKRWInputBoxView!, willHideDuration duration: CGFloat, inHeigh height: CGFloat) {
//        UIView.animateWithDuration(NSTimeInterval(duration)) { () -> Void in
//            var frame = self.chatTableView.frame
//            frame.origin.y -= height - 40
//            self.chatTableView.frame = frame
//        }
//    }
    
    //MARK : Network
    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {
        if(taskID == "sendMessage"){
            if(result.boolValue == true){
                XKRWNoticeService.sharedService().insertUserToShoushouServiceNoticeToDatabase(sendMessage, andUserId: XKRWUserService.sharedService().getUserId())
                messageList = XKRWNoticeService.sharedService().getAllShouShouServerAndUserReplayFromDatabaseWithUserId(XKRWUserService.sharedService().getUserId()) as! [XKRWChatMessageModel]
                chatTableView.reloadData()
                self.performSelector("setTableViewContentOffset", withObject: nil, afterDelay: 0.25)
            }
        }
    }
    
    override func handleDownloadProblem(problem: AnyObject!, withTaskID taskID: String!) {
        super.handleDownloadProblem(problem, withTaskID: taskID)
    }
    
    override func shouldRespondForDefaultNotificationForDetailName(detailName: String!) -> Bool {
        return true
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
