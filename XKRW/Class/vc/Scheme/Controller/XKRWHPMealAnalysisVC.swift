//
//  XKRWHPMealAnalysisVC.swift
//  XKRW
//
//  Created by Klein Mioke on 15/7/27.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWHPMealAnalysisVC: XKRWBaseVC {
    
//    var viewModel: XKRWHistoryAndProcessModel =  XKRWHistoryAndProcessModel()

    @IBOutlet weak var circleView: UIView!
    
//    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbLabel: UILabel!
    
    var needShowTip: Bool = false
    var isThreesperfect: Bool = false
    var needShowPie:Bool = true
    var recordDate:NSDate!
    var tipView: KMHeaderTips!
    var calorieValue: Float!
    var proteinValue: Float!
    var fatValue: Float!
    var nutriPersentage:NSDictionary!
    var recordEntity:XKRWRecordEntity4_0 = XKRWRecordEntity4_0()
    var recommendedIntakeCalorie:Float!
    var schemeReocrds:[XKRWRecordSchemeEntity] = []

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "饮食分析"
        self.addNaviBarBackButton()
        recordEntity = XKRWRecordService4_0.sharedService().getAllRecordOfDay(recordDate)

        self.nutriPersentage = XKRWRecordService4_0.sharedService().getFatProteinCarbohydrate(recordEntity.date)
    
        let fat = (self.nutriPersentage![kFat] as! NSNumber).floatValue
        let protein = (self.nutriPersentage![kProtein] as! NSNumber).floatValue
        let carbohydrate = (self.nutriPersentage![kCarbohydrate] as! NSNumber).floatValue
        self.proteinLabel.textColor = XKMainSchemeColor
        self.fatLabel.textColor = XKMainSchemeColor
        self.carbLabel.textColor = XKMainSchemeColor
        
        if fat == 0 && protein == 0 && carbohydrate == 0 {  //处理的意思是  除了没有操作、以及没吃  其他的没有实际的食物都显示推荐比例
            self.proteinLabel.text = "0"
            self.fatLabel.text = "0"
            self.carbLabel.text = "0"
            calorieValue = 60
            proteinValue = 15
            fatValue = 25
            self.needShowPie = false
        } else {
            let fatPersent = fat * 2.25 / (fat * 2.25 + protein + carbohydrate)
            let carPersent = carbohydrate / (fat * 2.25 + protein + carbohydrate)
            let proteinPersent = protein / (fat * 2.25 + protein + carbohydrate)
            
            calorieValue = carPersent
            proteinValue = proteinPersent
            fatValue = fatPersent
            
            if proteinPersent*100 > 15{
                self.proteinLabel.textColor = UIColor.redColor()
            }
            
            if fatPersent*100 > 25{
                self.fatLabel.textColor = UIColor.redColor()
            }
            
            if carPersent*100 > 60{
                self.carbLabel.textColor = UIColor.redColor()
            }
            
            self.proteinLabel.text = String(format: "%0.1f%%", proteinPersent * 100)
            self.fatLabel.text = String(format: "%0.1f%%", fatPersent * 100)
            self.carbLabel.text = String(format: "%0.1f%%", carPersent * 100)
            
            self.needShowPie = true
        }
        
        let pieChart = self.createPieChart()
        pieChart.center = CGPointMake(UI_SCREEN_WIDTH / 2, self.circleView.height / 2)
        
        if self.needShowPie == true
        {
            circleView.addSubview(pieChart)
        } else {
            pieChart.removeFromSuperview()
        }
        
        pieChart.strokeChart()
        
        let backgroundView = UIView(frame: CGRectMake(0, 0, 187, 187))
        backgroundView.center = CGPointMake(UI_SCREEN_WIDTH / 2, self.circleView.height / 2)
        
        backgroundView.layer.cornerRadius = backgroundView.height / 2
        backgroundView.layer.masksToBounds = true
        backgroundView.backgroundColor = XK_ASSIST_LINE_COLOR
        
        let innerCircle = UIView(frame: CGRectMake(0, 0, 167, 167))
        innerCircle.center = CGRectGetCenter(backgroundView.bounds)
        innerCircle.backgroundColor = UIColor.whiteColor()
        
        innerCircle.layer.cornerRadius = innerCircle.height / 2
        innerCircle.layer.masksToBounds = true
        
        backgroundView.addSubview(innerCircle)

        self.needShowTip = XKRWSchemeService_5_0.sharedService.needShowTipsInMealAnalyze()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if self.needShowTip {
            self.showTip()
            XKRWSchemeService_5_0.sharedService.setNeedShowTipsInMealAnalyze(false)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.tipView != nil {
            self.tipView.free()
            self.tipView = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createPieChart() -> PNPieChart {
        
        var items = [PNPieChartDataItem]()
        
        var colors = [UIColor(fromHexString: "#ff6b6b"), UIColor(fromHexString: "#29ccb1"), UIColor(fromHexString: "#ffc555")]
        
        items.append(PNPieChartDataItem(value:CGFloat(fatValue as NSNumber), color: colors[0], description: "脂肪"))
        items.append(PNPieChartDataItem(value: CGFloat(calorieValue as NSNumber), color: colors[1], description: "碳水化合物"))
        items.append(PNPieChartDataItem(value: CGFloat(proteinValue as NSNumber), color: colors[2], description: "蛋白质"))
        
        let pieChart = PNPieChart(frame: CGRectMake((UI_SCREEN_WIDTH - 163) / 2, 0, 163, 163), items: items)
        pieChart.shouldHighlightSectorOnTouch = false
        pieChart.innerCircleRadius = 0
        
        pieChart.hideDescription = true
        
        return pieChart
    }
    
    

    func showTip() -> Void {
        
        self.tipView = KMHeaderTips(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 64), text: "自己安排饮食易造成营养不均衡，\n建议按照方案执行", type: KMHeaderTipsType.Default)
        self.view.addSubview(self.tipView)
        
        self.tipView.startAnimationWithStartOrigin(CGPointMake(0, -tipView.height), endOrigin: CGPointMake(0, 0))
    }
    
    deinit {
        
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
