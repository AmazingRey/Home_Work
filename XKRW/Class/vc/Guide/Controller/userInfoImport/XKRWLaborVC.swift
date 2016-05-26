//
//  XKRWLaborVC.swift
//  XKRW
//
//  Created by 忘、 on 15/5/29.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWLaborVC: XKRWBaseVC {

    @IBOutlet weak var backgoundView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        MobClick.event("pg_pal")
        self.title = "选择体力活动水平"
         self.view.backgroundColor = UIColor.whiteColor()
        self.addNaviBarBackButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func chooseLaborAction(sender: UIButton) {
        
        switch sender.tag{
        case 1000:
            XKRWUserService.sharedService().setUserLabor(eLight)
        case 1001:
            XKRWUserService.sharedService().setUserLabor(eMiddle)
        default:
             XKRWUserService.sharedService().setUserLabor(eHeavy)
        }
        
        let setCurrentWeight =  XKRWSetCurrentWeightVC(nibName: "XKRWSetCurrentWeightVC", bundle: nil)
        self.navigationController?.pushViewController(setCurrentWeight, animated: true)
        
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
