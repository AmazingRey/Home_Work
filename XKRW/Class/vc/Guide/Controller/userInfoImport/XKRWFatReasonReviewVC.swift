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
    
    var titleArray:NSMutableArray = NSMutableArray()
    var imageArray:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MobClick.event("in_FatReason")
        
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
        self.initData()
        
        if(fromWhichVC == FromWhichVC.FatAnalyseVC || fromWhichVC == FromWhichVC.AssessmentReport){
            nextButton!.setTitle("我知道了", forState: UIControlState.Normal)
        }
        else{
        
            if(titleArray.count == 0){
                nextButton!.setTitle("去制定减肥方案吧", forState: UIControlState.Normal)
            }else{
                nextButton!.setTitle("记住了,为我制定方案吧", forState: UIControlState.Normal)
            }
        }
        nextButton!.addTarget(self, action: "nextAction:", forControlEvents: UIControlEvents.TouchUpInside);
        footerView?.addSubview(nextButton!)
    }
    
    
    func initData(){
        let questionArray:NSArray =  XKRWFatReasonService.sharedService().getQuestionAnswer();
        for var i = 0 ;i < questionArray.count ; i++ {
            let entity:XKRWFatReasonEntity = questionArray.objectAtIndex(i) as! XKRWFatReasonEntity
            let reason = XKRWFatReasonService.sharedService().getReasonDescriptionWithID(entity.question, andAID: entity.answer)
            
            switch reason{
                case 1:
                    if(!titleArray.containsObject("饮食油腻")){
                        titleArray .addObject("饮食油腻")
                        imageArray.addObject("fatReason_food_oily")
                    }
                case 2:
                    if(!titleArray.containsObject("吃零食")){
                        titleArray .addObject("吃零食")
                        imageArray.addObject("fatReason_eat_snackseat")
                    }
                case 3:
                    if(!titleArray.containsObject("喝饮料")){
                        titleArray .addObject("喝饮料")
                        imageArray.addObject("fatReason_drink")
                    }
                case 4...6:
                    if(!titleArray.containsObject("饮酒")){
                        titleArray .addObject("饮酒")
                        imageArray.addObject("fatReason_wine")
                    }
                case 7:
                    if(!titleArray.containsObject("吃肥肉")){
                        titleArray .addObject("吃肥肉")
                        imageArray.addObject("fatReason_eat_speck")
                    }
                case 8:
                    if(!titleArray.containsObject("吃坚果")){
                        titleArray .addObject("吃坚果")
                        imageArray.addObject("fatReason_eat_nut")
                    }
                case 9:
                    if(!titleArray.containsObject("吃宵夜")){
                        titleArray .addObject("吃宵夜")
                        imageArray.addObject("fatReason_eatnight_snack")
                    }
                case 10:
                    if(!titleArray.containsObject("吃饭晚")){
                        titleArray .addObject("吃饭晚")
                        imageArray.addObject("fatReason_eatLate")
                    }
                case 11:
                    if(!titleArray.containsObject("吃饭快")){
                        titleArray .addObject("吃饭快")
                        imageArray.addObject("fatReason_eatFast")
                    }
                case 12:
                    if(!titleArray.containsObject("饭量时多时少")){
                        titleArray .addObject("饭量时多时少")
                        imageArray.addObject("fatReason_eat_indiscipline")
                    }
                case 13:
                    if(!titleArray.containsObject("活动量少")){
                        titleArray .addObject("活动量少")
                        imageArray.addObject("fatReason_sit")
                    }
                case 14:
                    if(!titleArray.containsObject("缺乏锻炼")){
                        titleArray .addObject("缺乏锻炼")
                        imageArray.addObject("fatReason_lossSport")
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
