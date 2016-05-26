//
//  XKRWFatReasonAnalyzeVC.swift
//  XKRW
//
//  Created by 忘、 on 15/5/28.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWFatReasonReviewVC: XKRWBaseVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var analyzeTableView: UITableView!

    var footerView:UIView?
    var nextButton:UIButton!
    var cell:XKRWAnalyzeCell!
    var fromWhichVC:FromWhichVC?
    
    var titleArray:NSArray = NSArray()
    var imageArray:NSArray = NSArray()
    var dicData = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MobClick.event("pg_whyfat")
        
        self.addNaviBarBackButton();

        self.initHeaderViewAndFooterView()

        if(titleArray.count == 0)
        {
            self.title = "恭喜你!"
        }else{
            self.title = "注意改正以下问题"
        }
        
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.analyzeTableView.backgroundColor = UIColor.whiteColor()
        analyzeTableView.delegate = self
        analyzeTableView.dataSource = self
        analyzeTableView.tableFooterView = footerView;
        
       analyzeTableView.registerNib(UINib(nibName: "XKRWAnalyzeCell", bundle: nil), forCellReuseIdentifier: "analyzeCell")
        cell = analyzeTableView.dequeueReusableCellWithIdentifier("analyzeCell") as! XKRWAnalyzeCell
        // Do any additional setup after loading the view.
    }
    
    //初始化tableView的头视图与尾视图
    func  initHeaderViewAndFooterView(){
        
        footerView = UIView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 120))
        footerView?.backgroundColor = UIColor.whiteColor()
        nextButton = UIButton(type: UIButtonType.Custom)
        nextButton!.setBackgroundImage(UIImage(named: "buttonGreen_p"), forState: UIControlState.Highlighted)
        nextButton!.setBackgroundImage(UIImage(named: "buttonGreen"), forState: UIControlState.Normal)
        nextButton!.frame = CGRectMake(15, (120-42)/2,UI_SCREEN_WIDTH-30 , 42)
        nextButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        nextButton!.titleLabel?.font = XKDEFAULFONT
        
        self.initHabitData()
        titleArray =  dicData.allKeys
        imageArray = dicData.allValues
        
        if(fromWhichVC == FromWhichVC.FatAnalyseVC || fromWhichVC == FromWhichVC.AssessmentReport){
            nextButton!.setTitle("我知道了", forState: UIControlState.Normal)
        }
        else{
        
            if(titleArray.count == 0){
                nextButton!.setTitle("去制定瘦身计划", forState: UIControlState.Normal)
            }else{
                nextButton!.setTitle("记住了,为我制定瘦身计划吧", forState: UIControlState.Normal)
            }
        }
        nextButton!.addTarget(self, action: #selector(XKRWFatReasonReviewVC.nextAction(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        footerView?.addSubview(nextButton!)
    }
    
    func initHabitData(){
        let questionArray:NSArray = XKRWFatReasonService.sharedService().getQuestionAnswer();
        dicData.removeAllObjects()
        for i in 0  ..< questionArray.count  {
            let entity:XKRWFatReasonEntity = questionArray.objectAtIndex(i) as! XKRWFatReasonEntity
            let reason = XKRWFatReasonService.sharedService().getReasonDescriptionWithID(entity.question, andAID: entity.answer)
            
            let arrKeys : NSArray = dicData.allKeys
            switch reason{
                case 1:
                    if(!arrKeys.containsObject("饮食油腻")){
                        dicData.setObject("fatReason_food_oily", forKey: "饮食油腻")
                    }
                case 2:
                    if(!arrKeys.containsObject("吃零食")){
                        dicData.setObject("fatReason_eat_snackseat", forKey: "吃零食")
                    }
                case 3:
                    if(!arrKeys.containsObject("喝饮料")){
                        dicData.setObject("fatReason_drink", forKey: "喝饮料")
                    }
                case 4...6:
                    if(!arrKeys.containsObject("饮酒")){
                        dicData.setObject("fatReason_wine", forKey: "饮酒")
                    }
                case 7:
                    if(!arrKeys.containsObject("吃肥肉")){
                        dicData.setObject("fatReason_eat_speck", forKey: "吃肥肉")
                    }
                case 8:
                    if(!arrKeys.containsObject("吃坚果")){
                        dicData.setObject("fatReason_eat_nut", forKey: "吃坚果")
                    }
                case 9:
                    if(!arrKeys.containsObject("吃宵夜")){
                        dicData.setObject("fatReason_eatnight_snack", forKey: "吃宵夜")
                    }
                case 10:
                    if(!arrKeys.containsObject("吃饭晚")){
                        dicData.setObject("fatReason_eatLate", forKey: "吃饭晚")
                    }
                case 11:
                    if(!arrKeys.containsObject("吃饭快")){
                        dicData.setObject("fatReason_eatFast", forKey: "吃饭快")
                    }
                case 12:
                    if(!arrKeys.containsObject("饭量时多时少")){
                        dicData.setObject("fatReason_eat_indiscipline", forKey: "饭量时多时少")
                    }
                case 13:
                    if(!arrKeys.containsObject("活动量少")){
                        dicData.setObject("fatReason_sit", forKey: "活动量少")
                    }
                case 14:
                    if(!arrKeys.containsObject("缺乏锻炼")){
                        dicData.setObject("fatReason_lossSport", forKey: "缺乏锻炼")
                    }
                default:
                break
//                    println("习惯很好，不需要改善")
            }
        }
    }
    
    
    //TableView 代理方法
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(titleArray.count == 0) {
            return 300
        } else {
            
            if(cell != nil)
            {
                 return XKRWUtil.getViewSize(cell.contentView).height
            }else{
                return 0;
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(titleArray.count == 0)
        {
            return 1
        }
        else{
            return titleArray.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let identifier = "analyzeCell"
        let  cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? XKRWAnalyzeCell

        if(titleArray.count == 0){
            cell?.analyzeDescribe?.hidden = true
            cell?.imageConstraints.constant = 20;
            cell?.analyzeImageView.image = UIImage(named: "fatReason_goodHabit")
        }else{
            cell?.imageConstraints.constant = 30;
            cell!.analyzeDescribe.text = titleArray.objectAtIndex(indexPath.row) as? String
            cell!.analyzeImageView.image = UIImage(named:imageArray.objectAtIndex(indexPath.row) as! String)
        }
        return cell!
    }
    
    //执行下一步 进入制定减肥方案
    func nextAction(button:UIButton){
        
        if(fromWhichVC == FromWhichVC.AssessmentReport)
        {
            self.navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            let chooseVC:XKRWChooseSexVC =  XKRWChooseSexVC(nibName:"XKRWChooseSexVC", bundle: nil)
            self.navigationController?.pushViewController(chooseVC, animated: true)
        }
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setFromWhichVC(type:FromWhichVC){
        fromWhichVC = type
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
