//
//  XKRWTabooFoodVC.swift
//  XKRW
//
//  Created by 忘、 on 15/7/29.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWTabooFoodVC: XKRWBaseVC,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tabooTableView: UITableView!
    
    var tabooFoodId: [Int]!
    
    var foodEntityArray: NSArray = NSArray()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "禁忌食物"
        
        self.addNaviBarBackButton()
        
        self.downloadWithTaskID("getTabooFood", outputTask: { () -> AnyObject! in
            return XKRWSchemeService_5_0.sharedService.getBanFoodsFromRemote(self.tabooFoodId!)
        })
        
        tabooTableView.delegate = self
        tabooTableView.dataSource = self
        tabooTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tabooTableView.backgroundColor = XK_BACKGROUND_COLOR

    }
    
    
    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {
        if(taskID == "getTabooFood"){
            foodEntityArray = result as! NSArray
            tabooTableView.reloadData()
        }
    }
    
    override func handleDownloadProblem(problem: AnyObject!, withTaskID taskID: String!) {

    }
    
    override func shouldRespondForDefaultNotificationForDetailName(detailName: String!) -> Bool {
        return true
    }
    
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  foodEntityArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:XKRWSearchResultCell = loadViewFromBundle("XKRWSearchResultCell", owner: self) as!  XKRWSearchResultCell
        let foodEnity:XKRWFoodEntity = foodEntityArray.objectAtIndex(indexPath.row) as! XKRWFoodEntity
        cell.logoImageView.setImageWithURL(NSURL(string: foodEnity.foodLogo))
        cell.arrowImageView.hidden = false
        
        cell.title.text = foodEnity.foodName
        cell.subtitle.text = "\(foodEnity.foodEnergy)kcal/100g"
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return  80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let foodEnity:XKRWFoodEntity = foodEntityArray.objectAtIndex(indexPath.row) as! XKRWFoodEntity
        let vc:XKRWFoodDetailVC = XKRWFoodDetailVC()
        vc.foodId = foodEnity.foodId
        self.navigationController?.pushViewController(vc, animated: true)
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
