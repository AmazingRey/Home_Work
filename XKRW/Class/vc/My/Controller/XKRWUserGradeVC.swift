//
//  XKRWUserGradeVC.swift
//  XKRW
//
//  Created by 忘、 on 15/9/24.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWUserGradeVC: XKRWBaseVC,UITableViewDataSource,UITableViewDelegate {

    var entity:XKRWUserHonorEnity?
    
    @IBOutlet weak var gradeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initData()
        self.initView()
        // Do any additional setup after loading the view.
    }
    //TODO:  action
    func initView(){
        self.addNaviBarBackButton()
        self.title = "称号"
        
        gradeTableView.delegate = self
        gradeTableView.dataSource = self
        gradeTableView.backgroundColor = UIColor.clearColor()
        gradeTableView.separatorStyle = .None
        gradeTableView.registerNib(UINib(nibName:"XKRWGradeViewCell", bundle: nil), forCellReuseIdentifier: "GradeView")
        gradeTableView.registerNib(UINib(nibName:"XKRWGradeRule", bundle: nil), forCellReuseIdentifier: "GradeRule")
    }
    
    func initData(){
        if !XKRWUtil.isNetWorkAvailable() {
            XKRWCui.showAlertWithMessage("当前网络不可用")
            return;
        }
        if(entity == nil){
            entity = XKRWUserHonorEnity()
            self.downloadWithTaskID("getHonorData", outputTask: { () -> AnyObject! in
                return XKRWUserService.sharedService().getUserHonorData()
            })
        }
    }
    
    //MARK:  Network Deal
    
    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {
        if(taskID == "getHonorData"){
            let data:NSDictionary = result.objectForKey("data") as! NSDictionary
            entity?.nowDegree = data.objectForKey("now") as! String
            entity?.nextDegree = data.objectForKey("next") as! String
            entity?.nextDegreeExperience =  data.objectForKey("up")!.integerValue
            entity?.nowDegreeProgress = data.objectForKey("rank")!.integerValue
            entity?.nowExperience = data.objectForKey("score")!.integerValue
            if(data.objectForKey("is_max")!.integerValue == 1){
                entity?.isMax = true
            }
            gradeTableView.reloadData()
        }
    }
    
    override func handleDownloadProblem(problem: AnyObject!, withTaskID taskID: String!) {
        super.handleDownloadProblem(problem, withTaskID: taskID)
    }
    
    override func shouldRespondForDefaultNotificationForDetailName(detailName: String!) -> Bool {
        return true
    }
    
    
    //MARK:  UITableViewDelegate

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:UIView = UIView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 10))
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let gradeViewCell :XKRWGradeViewCell = tableView.dequeueReusableCellWithIdentifier("GradeView") as! XKRWGradeViewCell
            gradeViewCell.selectionStyle = .None
            
            gradeViewCell.nowDegreeImageView.setImageWithURL(NSURL(string: (entity?.nowDegree)!), placeholderImage: UIImage(named: "level_image") ,options:.RetryFailed)
            gradeViewCell.nextDegreeImageView.setImageWithURL(NSURL(string: (entity?.nextDegree)!), placeholderImage: UIImage(named: "level_image") ,options:.RetryFailed)

            gradeViewCell.degreeDescribeLabel.text = NSString(format: "已有%d%%的用户拥有此称号", (entity?.nowDegreeProgress)!) as String
            gradeViewCell.degreeDescribeLabel.setFontColor(XKMainSchemeColor, string: NSString(format: "%d%%", (entity?.nowDegreeProgress)!) as String)
            
            if (entity?.isMax == true){
                gradeViewCell.degreeDescribeLabel.hidden = true
            }
            
            return gradeViewCell
        }else{
            let gradeRuleCell :XKRWGradeRule = tableView.dequeueReusableCellWithIdentifier("GradeRule") as! XKRWGradeRule
            gradeRuleCell.experienceDetailLabel.text = NSString(format: "%ld/%ld", (entity?.nowExperience)!,(entity?.nextDegreeExperience)!) as String
            gradeRuleCell.experienceDetailLabel.setFontColor(XKMainSchemeColor, string: NSString(format: "%d", (entity?.nowExperience)!) as String)
            
            return gradeRuleCell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0){
            let gradeViewCell :XKRWGradeViewCell = tableView.dequeueReusableCellWithIdentifier("GradeView") as! XKRWGradeViewCell
            return gradeViewCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 1
        }else{
            let gradeRuleCell :XKRWGradeRule = tableView.dequeueReusableCellWithIdentifier("GradeRule") as! XKRWGradeRule
            return gradeRuleCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 1
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.section == 1){
            let gradeRuleVC:XKRWGradeRuleVC =  XKRWGradeRuleVC(nibName:"XKRWGradeRuleVC", bundle: nil)
            self.navigationController?.pushViewController(gradeRuleVC, animated: true)
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
