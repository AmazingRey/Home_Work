//
//  XKRWForgetPassWordVC.swift
//  XKRW
//
//  Created by 忘、 on 15/7/2.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWForgetPassWordVC: XKRWBaseVC {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "忘记密码"
        self.addNaviBarBackButton()
        
        let url:NSURL = NSURL(string:"http://i.xikang.com/online/mobileusersystem/security/mobileresetpwd.html")!
        
        webView.loadRequest(NSURLRequest(URL: url))
        
        // Do any additional setup after loading the view.
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
