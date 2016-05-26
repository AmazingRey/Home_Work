//
//  XKRWChooseSexVC.swift
//  XKRW
//
//  Created by 忘、 on 15/5/29.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWChooseSexVC: XKRWBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        MobClick.event("pg_sex")
        self.addNaviBarBackButton()
        self.title = "选择性别"
         self.view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func chooseSexAction(sender: UIButton) {
        XKRWUtil.clearButtonSelectedState(self.view)
        if sender.tag == 1000{
            XKRWUserService.sharedService().setSex(eSexFemale)
        }else if sender.tag == 1001{
            XKRWUserService.sharedService().setSex(eSexMale)
        }
        let setageVC =  XKRWSetAgeVC(nibName: "XKRWSetAgeVC", bundle: nil)
        self.navigationController?.pushViewController(setageVC, animated: true)
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
