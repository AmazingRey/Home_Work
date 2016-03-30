//
//  XKRWAppRecommendVC.swift
//  XKRW
//
//  Created by 忘、 on 15/12/24.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWAppRecommendVC: XKRWBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    var appInfoArray:NSArray =  NSArray()

    var appShowTableView:UITableView!
    override func viewDidLoad() {                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
        super.viewDidLoad()

        self.title = "猜你喜欢"
        
        appShowTableView = UITableView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64), style: .Plain)
        appShowTableView.delegate = self
        appShowTableView.dataSource = self
        self.view.addSubview(appShowTableView)
        
        appShowTableView.registerNib(UINib(nibName: "XKRWAppRecommendCell", bundle: nil), forCellReuseIdentifier: "recommendCell")
        
        self.initData()
        
        // Do any additional setup after loading the view.
    }
    
    func initData(){
        if(XKRWUtil.isNetWorkAvailable()){
            XKHudHelper.instance().showProgressHudAnimationInView(self.view)
            self.downloadWithTaskID("getAppRecommend") { () -> AnyObject! in
                return XKRWUserService.sharedService().getAppRecommendInfo()
            }
        }else{
            self.showRequestArticleNetworkFailedWarningShow()
        }
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appInfoArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:XKRWAppRecommendCell = tableView.dequeueReusableCellWithIdentifier("recommendCell") as! XKRWAppRecommendCell
        
        cell.appName.text = (appInfoArray.objectAtIndex(indexPath.row) as! XKRWAppRecommendModel).name
        cell.appDescribe.text  = (appInfoArray.objectAtIndex(indexPath.row) as! XKRWAppRecommendModel).appDescription
        cell.headImageView.setImageWithURL(NSURL(string: (appInfoArray.objectAtIndex(indexPath.row) as! XKRWAppRecommendModel).img_path), placeholderImage: UIImage(named: "food_default"))
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        UIApplication.sharedApplication().openURL(NSURL(string: (appInfoArray.objectAtIndex(indexPath.row) as! XKRWAppRecommendModel).ios_download_url)!)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    //MARK  NetWork
    override func reLoadDataFromNetwork(button: UIButton!) {
        self.hiddenRequestArticleNetworkFailedWarningShow()
        self.initData()
    }

    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {
        XKHudHelper.instance().hideProgressHudAnimationInView(self.view)
        
        if(taskID == "getAppRecommend"){
            appInfoArray = result as! NSArray
            appShowTableView.reloadData()
        }
    }
    
    override func handleDownloadProblem(problem: AnyObject!, withTaskID taskID: String!) {
        super.handleUploadProblem(problem, withTaskID: taskID)
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
