//
//  XKRWGradeRuleVC.swift
//  XKRW
//
//  Created by 忘、 on 15/9/24.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWGradeRuleVC: XKRWBaseVC,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var gradeRuleTableView: UITableView!

    var handleArray = []
    var addExperienceArray = []
    var experienceLimitArray = []
    
    var gradeArray:NSMutableArray = []
    var gradeImageArray:NSMutableArray = []
    var gradeExperienceArray:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        self.initView()
        // Do any additional setup after loading the view.
    }

    //TODO:   action
    func initView(){
        self.title = "经验值和等级"
        self.addNaviBarBackButton()
        gradeRuleTableView.delegate = self
        gradeRuleTableView.separatorStyle = .None
        gradeRuleTableView.dataSource = self
        gradeRuleTableView.backgroundColor = UIColor.clearColor()
        gradeRuleTableView.rowHeight = 44
        gradeRuleTableView.registerNib(UINib(nibName: "XKRWGradeRuleDetailCell", bundle: nil), forCellReuseIdentifier: "ruleDetailCell")
    }
    
    func initData(){
        handleArray = ["操作项目","登录","连续M天登录","获得星星","发布瘦身分享","发布帖子","喜欢","被喜欢","评论","评论求助帖","沙发评论","被评论"];
        addExperienceArray = ["增加经验值","+20点","+(M-1)*5点","+5点","+50点","+20点","+5点","+10点","+5点","+10点/贴","双倍评论经验","+5点"];
        experienceLimitArray = ["每日上限","20点","一次","无上限","100点","100点","100点","无上限","20点","50点","无","100点"];
        gradeArray = ["等级"];
        gradeImageArray = ["称号"];
        gradeExperienceArray = ["所需经验值"];
        
        if(XKRWUtil.isNetWorkAvailable())
        {
            self.downloadWithTaskID("getHonorInfo") { () -> AnyObject! in
                return XKRWUserService.sharedService().getHonorSystemInfo()
            }
        }else{
            self.showRequestArticleNetworkFailedWarningShow()
        }
        
    }
    
    //MARK: Network Deal
    
    override func reLoadDataFromNetwork(button: UIButton!) {
        self.initData()
    }
    
    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {

        if(taskID == "getHonorInfo"){
            self.hiddenRequestArticleNetworkFailedWarningShow()
            let  dataArray:NSArray =  result.objectForKey("data") as! NSArray
            print(result)
            for i in 0  ..< dataArray.count  {
                let dic:NSDictionary =  dataArray.objectAtIndex(i) as! NSDictionary
                 gradeArray.addObject("\(i+1)")
                gradeImageArray.addObject(dic.objectForKey("url")!)
                gradeExperienceArray.addObject(NSString(format: "%ld", dic.objectForKey("down")!.integerValue))
            }
            
            gradeRuleTableView.reloadData()
        }
    }
    
    override func shouldRespondForDefaultNotificationForDetailName(detailName: String!) -> Bool {
        return true
    }
    
    override func handleDownloadProblem(problem: AnyObject!, withTaskID taskID: String!) {
        self.showRequestArticleNetworkFailedWarningShow()
    }
    
    
    //MARK:  Delagate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  34
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 34))
        view.backgroundColor =  XK_BACKGROUND_COLOR //UIColor.clearColor()
        let label:UILabel = UILabel(frame: CGRectMake(15, 0, UI_SCREEN_WIDTH, 34))
        label.backgroundColor = UIColor.clearColor()
        label.font = XKDefaultFontWithSize(16)
        label.textColor = XK_TEXT_COLOR
        if(section == 0){
            label.text = "通过以下方式获得经验值"
        }else{
            label.text = "等级说明"
        }
        view.addSubview(label)
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let ruleDetailCell:XKRWGradeRuleDetailCell = tableView.dequeueReusableCellWithIdentifier("ruleDetailCell") as! XKRWGradeRuleDetailCell
        ruleDetailCell.selectionStyle = .None
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                ruleDetailCell.ruleOneLabel.font = XKDefaultFontWithSize(16)
                ruleDetailCell.ruleTwoLabel.font = XKDefaultFontWithSize(16)
                ruleDetailCell.ruleThreeLabel.font = XKDefaultFontWithSize(16)
            }else{
                ruleDetailCell.ruleOneLabel.font = XKDefaultFontWithSize(14)
                ruleDetailCell.ruleTwoLabel.font = XKDefaultFontWithSize(14)
                ruleDetailCell.ruleThreeLabel.font = XKDefaultFontWithSize(14)
            }
            ruleDetailCell.superRuleImageView.hidden = true
            ruleDetailCell.ruleTwoLabel.hidden = false
            ruleDetailCell.ruleOneLabel.text = handleArray.objectAtIndex(indexPath.row) as? String
            ruleDetailCell.ruleTwoLabel.text = addExperienceArray.objectAtIndex(indexPath.row) as? String
            ruleDetailCell.ruleThreeLabel.text = experienceLimitArray.objectAtIndex(indexPath.row) as? String
        }else{
            if(indexPath.row == 0){
                ruleDetailCell.superRuleImageView.hidden = true
                ruleDetailCell.ruleTwoLabel.hidden = false
                ruleDetailCell.ruleOneLabel.font = XKDefaultFontWithSize(16)
                ruleDetailCell.ruleTwoLabel.font = XKDefaultFontWithSize(16)
                ruleDetailCell.ruleThreeLabel.font = XKDefaultFontWithSize(16)
                ruleDetailCell.ruleTwoLabel.text = gradeImageArray.objectAtIndex(indexPath.row) as? String
            }else{
                ruleDetailCell.ruleTwoLabel.hidden = true
                ruleDetailCell.superRuleImageView.hidden = false
                ruleDetailCell.ruleOneLabel.font = XKDefaultFontWithSize(14)
                ruleDetailCell.ruleThreeLabel.font = XKDefaultFontWithSize(14)
                ruleDetailCell.ruleImageView.setImageWithURL(NSURL(string:gradeImageArray.objectAtIndex(indexPath.row) as! String), placeholderImage: UIImage(named: "level_image"),options:.RetryFailed)
            }
            
            ruleDetailCell.ruleOneLabel.text = gradeArray.objectAtIndex(indexPath.row) as? String
            ruleDetailCell.ruleThreeLabel.text = gradeExperienceArray.objectAtIndex(indexPath.row) as? String
        }
        return ruleDetailCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
            return handleArray.count
        }else{
            return gradeArray.count
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
