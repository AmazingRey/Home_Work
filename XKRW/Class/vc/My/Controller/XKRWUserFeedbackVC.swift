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
    }

    @IBAction func feedbackAction(sender: UIButton) {
        
        self.presentUMeng()
        MobClick.event("in_UserFeed")
    }

    
    func presentUMeng(){
        MobClick.event("in_feedback")
        let feedbackVC:FeedbackViewController = FeedbackViewController(nibName:"FeedbackViewController", bundle: nil)
        self.navigationController?.pushViewController(feedbackVC, animated: true)
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
