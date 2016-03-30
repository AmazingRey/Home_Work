//
//  XKRWNicknameCheckVC.swift
//  XKRW
//
//  Created by 忘、 on 15/9/29.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWNicknameCheckVC: XKRWBaseVC {

    @IBOutlet weak var nickNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()

        // Do any additional setup after loading the view.
    }

    func initView()
    {
        self.title = "修改昵称"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func saveNickNameAction(sender: UIButton) {
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
