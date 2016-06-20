//
//  XKRWUserFeedbackVC.swift
//  XKRW
//
//  Created by 忘、 on 15/9/15.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWUserFeedbackVC: XKRWBaseVC,UIWebViewDelegate {

    @IBOutlet weak var helpWebView: UIWebView!
    
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var redDotImageView: UIImageView!
    var feedbackKit:YWFeedbackKit?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "帮助与反馈";
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.addNaviBarBackButton()
        
        helpWebView.delegate = self
        
        let version:String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        
        let request:NSURLRequest = NSURLRequest(URL:NSURL(string:NSString(format: "http://ssapi.xikang.com/static/question/index.htm?ver=i%@",version) as String)!)
        helpWebView.loadRequest(request)
    
        let topLine:UIView = UIView.init(frame: CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5))
        topLine.backgroundColor = XK_ASSIST_LINE_COLOR
        feedbackButton.addSubview(topLine)
        feedbackButton.setTitleColor(XKMainSchemeColor, forState: UIControlState.Normal)
        feedbackButton.setImage(nil, forState: UIControlState.Highlighted)
        feedbackButton.setBackgroundImage(UIImage.createImageWithColor(XK_ASSIST_LINE_COLOR), forState: UIControlState.Highlighted)
        feedbackButton.showsTouchWhenHighlighted = false
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(animated: Bool) {
        if (XKRWUserDefaultService.isShowMoreredDot()) {
            redDotImageView.hidden = false;
        }else
        {
            redDotImageView.hidden = true;
        }
        
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }

    @IBAction func feedbackAction(sender: UIButton) {
        
        self.presentUMeng()
        MobClick.event("in_UserFeed")
    }
    
    func backAction() {
        self.navigationController!.popViewControllerAnimated(true)
    }

    
    func presentUMeng(){
        MobClick.event("in_feedback")
        feedbackKit = YWFeedbackKit.init(appKey: "23386781")
        feedbackKit!.hideContactInfoView = true
        feedbackKit!.environment = YWEnvironmentRelease
        feedbackKit!.extInfo = ["用户token":XKRWUserService.sharedService().getToken(),"账号":XKRWUserService.sharedService().getUserAccountName()]
        let avatarUrl = XKRWUserService.sharedService().getUserAvatar()
        
        feedbackKit!.customUIPlist = ["sendBtnText":"发送",
                                      "sendBtnTextColor":"#ffffff",
                                      "sendBtnBgColor":"#29CCB1",
                                      "hideLoginSuccess":true,
                                      "chatInputPlaceholder":"",
                                      "avatar":avatarUrl,
        ];
        weak var weakSelf = self
        feedbackKit! .makeFeedbackViewControllerWithCompletionBlock({ (viewController, error) in
            if viewController != nil {
                
                let label = UILabel.init(frame: CGRectZero)
                label.font = XKDefaultFontWithSize(17)
                label.textAlignment = .Center
                label.textColor = UIColor.blackColor()
                label.text = "意见反馈"
                label.sizeToFit()
                viewController.navigationItem.titleView = label
                
                let leftItemButton = UIButton.init(type:.Custom)
                leftItemButton .setImage(UIImage.init(named: "navigationBarback"), forState: .Normal)
                leftItemButton.setImage(UIImage.init(named: "navigationBarback_p"), forState: .Highlighted)
                let backImage = UIImage.init(named: "navigationBarback")
                leftItemButton.frame = CGRectMake(0, 0, (backImage?.size.width)!, (backImage?.size.height)!)
                leftItemButton .addTarget(self, action: #selector(XKRWUserFeedbackVC.backAction), forControlEvents: .TouchUpInside)
                
                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftItemButton)
            
                weakSelf?.navigationController?.pushViewController(viewController, animated: true)
                weak var weakNav = self.navigationController
                
                viewController.openURLBlock = {(aURLString, feedbackController)->Void in
                let webVC = UIViewController()
                    let webView = UIWebView()
                        webView.frame = webVC.view.bounds
                    webView.autoresizingMask = UIViewAutoresizing.None
                    weakNav?.pushViewController(webVC, animated: true)
                }
            } else {
                print(error.userInfo["msg"])
            }
        })
    }
    
    /**
    // MARK: - UIWebViewDelegate
    */
    
    func webViewDidFinishLoad(webView: UIWebView) {
        XKHudHelper.instance().hideProgressHudAnimationInView(helpWebView)
        let title = helpWebView.stringByEvaluatingJavaScriptFromString("document.title")
        self.title = title
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        XKHudHelper.instance().hideProgressHudAnimationInView(helpWebView)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        XKHudHelper.instance().showProgressHudAnimationInView(helpWebView)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func popView() {
        if(helpWebView.canGoBack)
        {
            helpWebView.goBack()
        }else{
            super.popView()
        }
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
