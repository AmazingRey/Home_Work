//
//  XKRWEstimateWeightVC.swift
//  XKRW
//
//  Created by 忘、 on 15/7/21.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWEstimateWeightVC:  XKRWBaseVC,UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate {
    var titleArrays:NSArray! = NSArray()
    
    var foodNameArray:NSArray! = NSArray()
    var foodCoverImageArray:NSArray! = NSArray()
    
    var foodDetailImageArray:NSArray! = NSArray()
    
    var browserImageArray:NSArray = NSArray();

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "估算重量"
        self.view.backgroundColor = XK_BACKGROUND_COLOR
        self.initData()
        self.addNaviBarBackButton()
        let estimateTableView:UITableView = UITableView(frame: CGRectMake(0, 0,UI_SCREEN_WIDTH , UI_SCREEN_HEIGHT-64), style: UITableViewStyle.Plain)
        estimateTableView.delegate = self;
        estimateTableView.dataSource = self;
        estimateTableView.backgroundColor = XK_BACKGROUND_COLOR
        self.view.addSubview(estimateTableView)
        // Do any additional setup after loading the view.
    }
    
    
    func initData(){
        titleArrays = ["凉菜","炒菜","煮菜","沙拉","炖菜","蒸菜","汤食","主食","加工主食","粥食","饮品","其他"];
        
        foodNameArray = [["凉拌荤菜","凉拌素菜"],["炒海鲜","炒荤菜","炒素菜"],
                        ["煮海鲜","煮素菜"],
                        ["果蔬沙拉","混合沙拉"],
                        ["炖海鲜","炖荤菜","炖素菜"],
                        ["蒸海鲜","蒸荤菜","蒸素菜"],
                        ["海鲜汤","荤菜汤","素菜汤"],
                        ["米饭","面点","面条"],
                        ["加工饭类","加工面食"],
                        ["谷物粥","肉粥"],
                        ["豆类饮品","果汁","奶"],
                        ["蛋","蔬菜","水果"]]
        
        foodCoverImageArray = [["凉拌荤菜-封面图","凉拌素菜-封面图"],["炒海鲜-封面图","炒荤菜-封面图","炒素菜-封面图"],
            ["煮海鲜-封面图","煮素菜-封面图"],
            ["果蔬沙拉-封面图","混合沙拉-封面图"],
            ["炖海鲜-封面图","炖荤菜-封面图","炖素菜-封面图"],
            ["蒸海鲜-封面图","蒸荤菜-封面图","蒸素菜-封面图"],
            ["海鲜汤-封面图","荤菜汤-封面图","素菜汤-封面图"],
            ["米饭-封面图","面点-封面图","面条-封面图"],
            ["炒饭-封面图","加工面食-封面图"],
            ["谷物粥-封面图","肉粥-封面图"],
            ["豆制饮品-封面图","果汁类-封面图","奶-封面图"],
            ["蛋-封面图","蔬菜-封面图","水果-封面图"]]
        
        foodDetailImageArray = [[["凉拌荤菜-内容图"],["凉拌素菜-内容图"]],
            [["炒海鲜-内容图"],["炒荤菜-内容图"],["炒素菜-内容图"]],
            [["煮海鲜-内容图"],["煮素菜-内容图"]],
            [["果蔬沙拉-内容图"],["混合沙拉-内容图"]],
            [["炖海鲜-内容图"],["炖荤菜-内容图"],["炖素菜-内容图"]],
            [["蒸海鲜-内容图"],["蒸荤菜-内容图"],["蒸素菜-内容图"]],
            [["海鲜汤-内容图"],["荤菜汤-内容图"],["素菜汤-内容图"]],
            [["米饭1","米饭2"],["面点1","面点2"],["面条1","面条2"]],
            [["炒饭-内容图(小)","炒饭-内容图(大)"],["加工面食1","加工面食2","加工面食3","加工面食4"]],
            [["谷物粥-内容图"],["肉粥-内容图"]],
            [["豆制饮品-内容图1","豆制饮品-内容图2"],["果汁类-内容图"],["奶-内容图"]],
            [["蛋-内容图"],["蔬菜1","蔬菜2"],["水果-内容图"]]
        ]
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let foodName:NSArray = foodNameArray.objectAtIndex(indexPath.section) as! NSArray
        let foodImageName:NSArray = foodCoverImageArray.objectAtIndex(indexPath.section) as! NSArray
        let cell:XKRWEstimateWeightCell = loadViewFromBundle("XKRWEstimateWeightCell", owner: self) as!  XKRWEstimateWeightCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.logoImageView.image = UIImage(named: foodImageName.objectAtIndex(indexPath.row) as! String )
        cell.foodName.text = foodName.objectAtIndex(indexPath.row) as? String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let foodArray:NSArray = foodNameArray.objectAtIndex(section) as! NSArray
        
        return foodArray.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view:UIView = UIView(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 38))
        view.backgroundColor = XK_BACKGROUND_COLOR
        let label:UILabel =  UILabel(frame:CGRectMake(15, 0, 100, 38))
        label.text = titleArrays.objectAtIndex(section) as? String
        label.backgroundColor = UIColor.clearColor()
        XKRWUtil.addViewUpLineAndDownLine(view, andUpLineHidden: false, downLineHidden: false)
        
        view.addSubview(label)
        return view
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return titleArrays.count
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return  80
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let foodImageArray:NSArray = foodDetailImageArray.objectAtIndex(indexPath.section) as! NSArray
        
        browserImageArray = foodImageArray.objectAtIndex(indexPath.row) as! NSArray
        
        let browser:MWPhotoBrowser = MWPhotoBrowser(delegate: self)
        browser.displaySelectionButtons = false;
        browser.displayActionButton = false;
        browser.zoomPhotosToFill = false;
        browser.alwaysShowControls = true;
        browser.title = "分量参考图";
        browser.setCurrentPhotoIndex(0)
        self.navigationController?.pushViewController(browser, animated: true)
    }
    
    
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(browserImageArray.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        if index < UInt(browserImageArray.count){
            return  MWPhoto(image:UIImage(named: browserImageArray.objectAtIndex(Int(index)) as! String ))
        }
        return nil;
    }
    

    
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, titleForPhotoAtIndex index: UInt) -> String! {
        let title:NSString = NSString(format: "%ld/%ld",index+1,UInt(browserImageArray.count))
        
        return title as String
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
