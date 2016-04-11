//
//  XKRWLoginVC.swift
//  XKRW
//
//  Created by 忘、 on 15/5/26.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWLoginVC: XKRWBaseVC {

    @IBOutlet weak var thirdpartyLoginLabel: UILabel!
    @IBOutlet weak var weiboLabel: UILabel!
    @IBOutlet weak var weiboButton: UIButton!
    @IBOutlet weak var qqLabel: UILabel!
    @IBOutlet weak var qqButton: UIButton!
    @IBOutlet weak var wechatLabel: UILabel!
    @IBOutlet weak var wechatButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userAcount: UITextField!
    
    var loginSuccess: (Void -> Void)?
    
    var loginFailed:(Bool ->Void)?
    
    var fromWhichVC: FromWhichVC?
    
    static var isShowLoginVC: Bool = false
    var isPresent = false
    
    class func showLoginVCWithTarget(targetVC: UIViewController, loginSuccess: ()->(), failed: Bool->(), alertMessage: String?) -> Void {
        
        // 如果已经显示LoginVC,则不弹出LoginVC
        if XKRWLoginVC.isShowLoginVC == true {
            return
        }
        let vc = XKRWLoginVC(nibName: "XKRWLoginVC", bundle: nil)
        vc.loginSuccess = loginSuccess
        vc.loginFailed = failed
        vc.isPresent = true
        XKRWLoginVC.isShowLoginVC = true
        
        let nav = XKRWNavigationController(rootViewController: vc)
        
        targetVC.navigationController?.presentViewController(nav, animated: true, completion: {
            
            if alertMessage != nil {
                XKRWWarningView.showWainingViewWithString(alertMessage!)
            }
        })
    }
    
    override func viewDidLoad() {
        
        self.forbidAutoAddPopButton = true
        super.viewDidLoad()
        
        let  account:NSString? =  NSUserDefaults.standardUserDefaults().objectForKey(kXKUserAccount) as? String
        if(account != nil && account?.length != 0){
            userAcount.text = account as? String
        }
        
        self.title = "登录"
        
        if (fromWhichVC == FromWhichVC.RegisterVC) {
            self.addNaviBarBackButton()
        }
        else {
            
            self.navigationItem.hidesBackButton = true
            let rightNaviBarButton:UIButton = UIButton(type: UIButtonType.Custom)
            rightNaviBarButton.setTitle("注册", forState: UIControlState.Normal)
            rightNaviBarButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            rightNaviBarButton.setTitleColor(XKGrayDefaultColor, forState: .Highlighted)
            rightNaviBarButton.titleLabel!.font = UIFont.systemFontOfSize(14)
            
            let width = ("注册" as NSString).boundingRectWithSize(CGSizeMake(100, 100), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(14)], context: nil).size.width
            
            rightNaviBarButton.frame = CGRectMake(0, 0, width, 44)
            rightNaviBarButton.addTarget(self, action: "doClickNaviBarRightButton", forControlEvents:UIControlEvents.TouchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNaviBarButton)
        }
        
        // Do any additional setup after loading the view.
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyBoard")
        self.view.addGestureRecognizer(tapGesture)
        
        wechatLabel.hidden = true
        wechatButton.hidden = true
        qqButton.hidden = true
        qqLabel.hidden = true
        weiboButton.hidden = true
        weiboLabel.hidden = true
        thirdpartyLoginLabel.hidden = true
        self.downloadWithTaskID("showThirdpartyLogin", outputTask: { () -> AnyObject! in
            return  NSNumber(bool: XKRWServerPageService.sharedService().isShowPurchaseEntry_uploadVersion())
        })
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        XKRWLoginVC.isShowLoginVC = false
    }

    //登录
    @IBAction func loginAction(sender: UIButton) {
         MobClick.event("clk_RgstLogin")
        
        if(userAcount.text!.characters.count==0){
            XKRWCui.showInformationHudWithText("账号不能为空");
            
        }else if(userPassword.text!.characters.count==0){
            XKRWCui.showInformationHudWithText("密码不能为空");
        }
        else if(userPassword.text!.characters.count<6){
            XKRWCui.showInformationHudWithText("密码输入错误");
        }
        else {
            self.view.endEditing(true)
            self.uploadBlockingWithTask({ () -> Void in
                XKRWAccountService.shareService().loginWithAccount(self.userAcount.text, password: self.userPassword.text, needLong: true)
                }, inView: self.navigationController?.view)
        }
    }
    
    //网络成功请求重载didUpload
    override func didUpload() {
        XKRWCui.hideProgressHud()
        XKRWUserDefaultService.setLogin(true)
        if(loginSuccess != nil)
        {
            self.loginSuccess!()
            loginSuccess = nil
        }
        
        NSUserDefaults.standardUserDefaults().setObject(userAcount.text, forKey: kXKUserAccount)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        XKRWUserDefaultService.setCurrentUserId(XKRWUserService.sharedService().getUserId());
         
        // 返回
        if !self.isPresent {
            if XKRWAlgolHelper.expectDayOfAchieveTarget() != nil {
                XKRWLocalNotificationService.shareInstance().registerMetamorphosisTourAlarms()
            }

            if (self.navigationController?.tabBarController != nil) {
                self.navigationController?.tabBarController?.navigationController?.popToRootViewControllerAnimated(false)
            } else {
                self.navigationController?.popToRootViewControllerAnimated(false);
            }
        } else {
            if(!XKRWUserService.sharedService().checkUserInfoIsComplete())
            {
                //暂时 未处理   当当前账号被挤下来  在登录一个数据不全的帐号的时候 会出现问题
                 self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
//                let fatReasonVC = XKRWFoundFatReasonVC(nibName:"XKRWFoundFatReasonVC", bundle: nil)
//                self.navigationController?.pushViewController(fatReasonVC, animated: true)
            }else{
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }

    }
    
    //网络失败请求重载handleUploadProblem
    override func handleUploadProblem(problem: AnyObject!, withTaskID taskID: String!) {
//        println(problem)
        
        if let problem = problem as? NSException {
            XKRWCui.showInformationHudWithText(problem.description);
        }
        XKRWCui.hideProgressHud()
    }
    
    //忘记密码
    @IBAction func forgetPasswordAction(sender: UIButton) {
        let forgetPasswordVC: XKRWForgetPassWordVC = XKRWForgetPassWordVC(nibName:"XKRWForgetPassWordVC", bundle: nil)
        self.navigationController?.pushViewController(forgetPasswordVC, animated: true)
    }
    
    
    func hideKeyBoard(){
        if userAcount.becomeFirstResponder(){
            userAcount.resignFirstResponder()
        }else if(userPassword.becomeFirstResponder()){
            userPassword.resignFirstResponder()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //点击注册按钮进行注册操作
    func doClickNaviBarRightButton(){
        let registerVC:XKRWRegisterVC =  XKRWRegisterVC(nibName: "XKRWRegisterVC", bundle: nil)
        registerVC .setFromWhichVC(FromWhichVC.LoginVC)
        self.navigationController?.pushViewController(registerVC, animated: true)
        
    }
    
    func setFromWhichVC(type:FromWhichVC){
        fromWhichVC = type
    }
    
    override func handleDownloadProblem(problem: AnyObject!, withTaskID taskID: String!) {
        XKRWCui.hideProgressHud()
        super.handleUploadProblem(problem, withTaskID: taskID)
        if self.loginFailed != nil {
            self.loginFailed!(true)
        }
    }
    
    override func didDownloadWithResult(result: AnyObject!, taskID: String!) {
        if(taskID == "weiboLogin" || taskID == "qqLogin" || taskID == "weixinLogin")
        {
            XKRWUserDefaultService.setCurrentUserId(XKRWUserService.sharedService().getUserId());
            XKRWUserService .sharedService().setThirdPartyLogin();
            XKRWCui.hideProgressHud()
            
            if(loginSuccess != nil)
            {
                self.loginSuccess!()
                loginSuccess = nil
            }
            // 返回
            if !self.isPresent {
                
                if XKRWAlgolHelper.expectDayOfAchieveTarget() != nil {
                    XKRWLocalNotificationService.shareInstance().registerMetamorphosisTourAlarms()
                }

                if (self.navigationController?.tabBarController != nil){
                    self.navigationController?.tabBarController?.navigationController?.popToRootViewControllerAnimated(false)
                }else{
                    self.navigationController?.popToRootViewControllerAnimated(false);
                }
            } else {
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }else if(taskID == "showThirdpartyLogin" ) {
            if(taskID == "showThirdpartyLogin"  ) {
                if(result.boolValue == true){
                    if (WXApi.isWXAppInstalled()) {
                        wechatLabel.hidden = false
                        wechatButton.hidden = false
                    }
                    qqLabel.hidden = false
                    qqButton.hidden = false
                    weiboLabel.hidden = false
                    weiboButton.hidden = false
                    thirdpartyLoginLabel.hidden = false
                }
            }
        }
    }
    
    override func shouldRespondForDefaultNotificationForDetailName(detailName: String!) -> Bool {
        return true
    }

    
    
    @IBAction func thirdpartyLoginAction(sender: UIButton) {
        
        if sender.tag == 1000 {
            
            let snsPlatform:UMSocialSnsPlatform = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToQQ)
            snsPlatform.loginClickHandler(self,UMSocialControllerService.defaultControllerService(),true,{(response :UMSocialResponseEntity!) ->Void in
                let usm = UMSResponseCodeSuccess
                let rcode = response.responseCode
                
                if rcode.rawValue == usm.rawValue{
                    var snsAccount = UMSocialAccountManager.socialAccountDictionary()
                    let qqUser:UMSocialAccountEntity =  snsAccount[UMShareToQQ] as! UMSocialAccountEntity
//                    println("QQ用户数据\(qqUser)")
                    let token = qqUser.accessToken
                    XKRWCui.showProgressHud("登录中...")
                    MobClick.event("clk_RgstQQ");
                    self.downloadWithTaskID("qqLogin", outputTask: { () -> AnyObject! in
                        XKRWAccountService.shareService().userThirdPartyLoginBytoken(token, openId: nil, thridType: "qq", needLong: true)
                    })
                } else{
                    XKRWCui.showInformationHudWithText("QQ授权失败")
                }
            });
            
        } else if sender.tag == 1001 {
            
            let snsPlatform:UMSocialSnsPlatform = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToSina)
            snsPlatform.loginClickHandler(self,UMSocialControllerService.defaultControllerService(),true,{(response :UMSocialResponseEntity!) ->Void in
                let usm = UMSResponseCodeSuccess
                let rcode = response.responseCode
    
                if rcode.rawValue == usm.rawValue{
                    var snsAccount = UMSocialAccountManager.socialAccountDictionary()
                    let sniaUser:UMSocialAccountEntity =  snsAccount[UMShareToSina] as! UMSocialAccountEntity
                    let token = sniaUser.accessToken
                    let userid = sniaUser.usid
                    XKRWCui.showProgressHud("登录中...")
                    MobClick.event("clk_RgstWb")
                    self.downloadWithTaskID("weiboLogin", outputTask: { () -> AnyObject! in
                        XKRWAccountService.shareService().userThirdPartyLoginBytoken(token, openId: userid, thridType: "wb", needLong: true)
                    })
                }else{
                    XKRWCui.showInformationHudWithText("微博授权失败")
                }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            });
        }else {
            
            let snsPlatform:UMSocialSnsPlatform? = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToWechatSession)
            if(snsPlatform != nil)
            {
                snsPlatform!.loginClickHandler(self, UMSocialControllerService.defaultControllerService(), true, {
                    (response: UMSocialResponseEntity!) -> Void in
                    
                    if response.responseCode == UMSResponseCodeSuccess {
                        
                        var wxAccount = UMSocialAccountManager.socialAccountDictionary()
                        let wxUser:UMSocialAccountEntity =  wxAccount[UMShareToWechatSession] as! UMSocialAccountEntity
                        let token = wxUser.accessToken
                        let openId = wxUser.openId
                        XKRWCui.showProgressHud("登录中...")
                        MobClick.event("clk_RgstWc")
                        
                        self.downloadWithTaskID("weixinLogin", outputTask: { () -> AnyObject! in
                            XKRWAccountService.shareService().userThirdPartyLoginBytoken(token, openId: openId, thridType: "wx", needLong: true)
                        })
                    } else {
                        XKRWCui.showInformationHudWithText("微信授权失败")
                    }
                });
            } else {
                XKRWCui.showAlertWithMessage("请先安装微信")
            }
        }
    }
}
